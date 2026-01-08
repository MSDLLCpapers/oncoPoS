#' @title PoS estimation
#' @description
#' Computes the predicted probability of success (PoS) for a phase III clinical 
#' trial by integrating early-phase efficacy data—objective response rate (ORR) 
#' and/or progression-free survival (PFS)—with prior beliefs about study 
#' success. The prior distribution for the benchmark PoS is specified as a Beta 
#' distribution, parameterized by its mean and variance. Treatment effect 
#' estimation for ORR supports both two-arm and single-arm designs, with the 
#' latter incorporating historical control information.
#' 
#' @section Specification:
#' \if{latex}{
#'   \itemize{
#'   \item Obtain the prediction of PoS using `run_stan()`
#'   \item Create an object `fit_stan` to save the model result
#'   \item Transfer the hazard ratio bound to log-scale
#'   \item Extract simulated phase 3 trials treatment effects estimates and
#'   derive their standard errors
#'   \item Calculates posterior mean and variance of \code{omega}.
#'   \item If `plots_out` is TRUE, generate plots for MCMC chains and 
#'   autocorrelation
#'   }
#' }
#' \if{html}{
#' The contents of this section are shown in PDF user manual only.
#' }
#' 
#' @param plots_out whether plots for MCMC chains and autocorrelation should be 
#' printed, Default: FALSE
#' @inheritParams run_stan
#' @return tibble of PoS estimates, the corresponding standard errors for
#' each analysis, and the posterior mean and variance for omega. 
#' If `plots_out` is turned on, then the MCMC chains mixing and
#' autocorrelation plots are provided as well.
#' @examples 
#' # Using both ORR and PFS from a prior single-arm study with a Beta prior on 
#' # omega
#' 
#' gen_pos(
#'   target_hr = 0.70,
#'   J = 2,
#'   nevents3 = c(370, 468),
#'   hr_bound = c(0.7790, 0.8204),
#'   thres = 0.01,
#'   omega_mean = 0.3,
#'   omega_var = 0.03,
#'   est_obs_pfs = 0.73,
#'   low_obs_pfs = 0.61,
#'   upp_obs_pfs = 0.91,
#'   use_pfs = TRUE,
#'   n_trt2 = 100,
#'   n_resp_trt2 = 40,
#'   low_soc_rr = 0.05,
#'   upp_soc_rr = 0.2,
#'   use_orr = TRUE,
#'   single_arm = TRUE,
#'   seed = 222
#' )
#' @seealso 
#'  \code{\link[tidybayes]{gather_draws}}
#'  \code{\link[dplyr]{mutate}}, \code{\link[dplyr]{summarise}},
#'  \code{\link[dplyr]{group_by}}
#'  \code{\link[purrr]{map2}}, \code{\link[purrr]{reexports}}
#'  \code{\link[bayesplot]{MCMC-traces}}, 
#'  \code{\link[bayesplot]{MCMC-diagnostics}}
#' @rdname gen_pos
#' @export 
#' @importFrom tidybayes spread_draws
#' @importFrom dplyr mutate summarise group_by
#' @importFrom purrr map2_dbl set_names
#' @importFrom bayesplot mcmc_trace mcmc_acf
#' @importFrom stats var
gen_pos <- function(
    target_hr,
    J,
    nevents3,
    hr_bound, 
    omega_mean = 0.52, omega_var = 0.02,
    est_obs_pfs,
    low_obs_pfs,
    upp_obs_pfs,
    obs_pfs_conf_level = 0.95,
    thres = 0.01,
    n_trt2, 
    n_ctrl2,
    n_resp_trt2, 
    n_resp_ctrl2,
    low_soc_rr,
    upp_soc_rr,
    ci_rr = 0.8,
    use_orr = FALSE,
    single_arm = FALSE,
    use_pfs = FALSE,
    het_degree_p2 = "small",
    het_degree_p3 = "very small",
    ratio = 1, # ratio of experimental over control
    indication = 6,
    m_0 = NA,
    m_1 = NA,
    nu_0 = NA,
    nu_1 = NA,
    lm_sd = NA,
    niter = 1000,
    nchains = 4,
    ncores = 4,
    seed,
    plots_out = FALSE,
    ...
) {
  
  run_stan_res <- run_stan(
    target_hr = target_hr,
    J = J,
    nevents3 = nevents3,
    hr_bound = hr_bound, 
    omega_mean = omega_mean, omega_var = omega_var,   
    est_obs_pfs = est_obs_pfs,
    low_obs_pfs = low_obs_pfs,
    upp_obs_pfs = upp_obs_pfs,
    obs_pfs_conf_level = obs_pfs_conf_level,
    thres = thres,
    n_trt2 = n_trt2, 
    n_ctrl2 = n_ctrl2,
    n_resp_trt2 = n_resp_trt2, 
    n_resp_ctrl2 = n_resp_ctrl2,
    low_soc_rr = low_soc_rr, upp_soc_rr = upp_soc_rr, ci_rr = ci_rr,
    use_orr = use_orr, single_arm = single_arm,
    use_pfs = use_pfs,
    het_degree_p2 = het_degree_p2,
    het_degree_p3 = het_degree_p3,
    ratio = ratio, 
    indication = indication,
    m_0 = m_0,
    m_1 = m_1,
    nu_0 = nu_0,
    nu_1 = nu_1,
    lm_sd = lm_sd,
    niter = niter,
    nchains = nchains,
    ncores = ncores,
    seed = seed,
    ...
  )
  
  fit_rstan <- run_stan_res$fit_rstan
  
  loghr_bound <- log(hr_bound) # transform hr bound to log scale
  
  omega_summary <- fit_rstan |>
    tidybayes::spread_draws(omega) |>
    dplyr::summarise(
      omega_mean = mean(omega),
      omega_var = stats::var(omega)
      )
  
  # extract simulated treatment effects for phase III experiments
  out <- fit_rstan |>
    tidybayes::spread_draws(theta_P3_hat[J]) |>
    dplyr::mutate(
      reject = purrr::map2_dbl(J, theta_P3_hat, function(x, y) {
        as.numeric(y < loghr_bound[[x]])
      })
    ) |>
    dplyr::group_by(J) |>
    dplyr::summarise(pos = mean(reject)) |>
    dplyr::mutate(
      pos_se = sqrt(pos * (1 - pos)/(nchains * niter / 2)),
      omega_mean = omega_summary$omega_mean,
      omega_var = omega_summary$omega_var
    )
  
  if (plots_out) {
    suppressWarnings({
      p1 <- bayesplot::mcmc_trace(
        fit_rstan,
        pars = c("mu_P", "tau_P2", "tau_P3", "theta_P2", "theta_P3", "omega")
      )
      p2 <- bayesplot::mcmc_acf(
        fit_rstan,
        pars = c("mu_P", "tau_P2", "tau_P3", "theta_P2", "theta_P3", "omega")
      )      
    })
    
    out <- list(p1, p2, out) |> purrr::set_names(c("trace", "auto", "pos_est"))
  }
  return(out)
}

#' @importFrom utils globalVariables
utils::globalVariables(c('pos', 'reject', 'theta_P3_hat'))
