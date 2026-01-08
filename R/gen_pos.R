#' @title PoS estimation
#' @description PoS estimation
#' 
#' @section Specification:
#' \if{latex}{
#'   \itemize{
#'   \item Obtain the prediction of PoS using `run_stan()`
#'   \item Create an object `fit_stan` to save the model result
#'   \item Transfer the hazard ratio bound to log-scale
#'   \item Extract simulated phase 3 trials treatment effects estimates and
#'   derive their standard errors
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
#' @return tibble of PoS estimates and the corresponding standard errors for
#' each analysis. If `plots_out` is turned on, then the MCMC chains mixing and
#' autocorrelation plots are provided as well.
#' @examples 
#' # use PFS data from a prior study
#' 
#'   gen_pos(
#'     target_hr = 0.7, 
#'     J = 2,  
#'     nevents3 = c(370, 468), 
#'     hr_bound = c(0.779, 0.8204), 
#'     omega = 0.5, 
#'     est_obs_pfs = 0.88, 
#'     low_obs_pfs = 0.74, 
#'     upp_obs_pfs = 1.05, 
#'     use_pfs = TRUE, 
#'     seed = 325,
#'     ncores = 1,
#'     nchains = 1) 
#' @seealso 
#'  \code{\link[tidybayes]{gather_draws}}
#'  \code{\link[dplyr]{mutate}}, \code{\link[dplyr]{group_by}}, \code{\link[dplyr]{summarise}}
#'  \code{\link[purrr]{map2}}, \code{\link[purrr]{reexports}}
#'  \code{\link[bayesplot]{MCMC-traces}}, \code{\link[bayesplot]{MCMC-diagnostics}}
#' @rdname gen_pos
#' @export 
#' @importFrom tidybayes spread_draws
#' @importFrom dplyr mutate group_by summarise
#' @importFrom purrr map2_dbl set_names
#' @importFrom bayesplot mcmc_trace mcmc_acf
gen_pos <- function(
    target_hr,
    J,
    nevents3,
    hr_bound, 
    omega,
    est_obs_pfs,
    low_obs_pfs,
    upp_obs_pfs,
    obs_pfs_conf_level = 0.95,
    thres = 0.01,
    n_trt2, 
    n_ctrl2,
    n_resp_trt2, 
    n_resp_ctrl2,
    use_orr = FALSE,
    use_pfs = FALSE,
    het_degree_p2 = "small",
    het_degree_p3 = "very small",
    ratio = 1, # ratio of experimental over control
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
    omega = omega,
    est_obs_pfs = est_obs_pfs,
    low_obs_pfs = low_obs_pfs,
    upp_obs_pfs = upp_obs_pfs,
    obs_pfs_conf_level = obs_pfs_conf_level,
    thres = thres,
    n_trt2 = n_trt2, 
    n_ctrl2 = n_ctrl2,
    n_resp_trt2 = n_resp_trt2, 
    n_resp_ctrl2 = n_resp_ctrl2,
    use_orr = use_orr,
    use_pfs = use_pfs,
    het_degree_p2 = het_degree_p2,
    het_degree_p3 = het_degree_p3,
    ratio = ratio, 
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
  
  # extract simulated treatment effects for phase III experiments
  out <- tidybayes::spread_draws(model = fit_rstan, theta_P3_hat[J]) |>
    dplyr::mutate(
      reject = purrr::map2_dbl(J, theta_P3_hat,  function(x, y){
        as.numeric(y < loghr_bound[[x]])
      })
    ) |>
    dplyr::group_by(J) |>
    dplyr::summarise(pos = mean(reject)) |>
    dplyr::mutate(
      pos_se = sqrt(pos * (1 - pos)/(nchains*niter/2))
    )
  
  if (plots_out) {
    suppressWarnings({
      p1 <- bayesplot::mcmc_trace(
        fit_rstan,
        pars = c("mu_P", "tau_P2", "tau_P3", "theta_P2", "theta_P3")
      )
      p2 <- bayesplot::mcmc_acf(
        fit_rstan,
        pars = c("mu_P", "tau_P2", "tau_P3", "theta_P2", "theta_P3")
      )      
    })

    out <- list(p1, p2, out) |> purrr::set_names(c("trace", "auto", "pos_est"))
  }
  return(out)
}

#' @importFrom utils globalVariables
utils::globalVariables(c('pos', 'reject', 'theta_P3_hat'))
