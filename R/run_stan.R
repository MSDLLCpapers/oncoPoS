#' @title Run stan to generate a PoS prediction
#' @description A wrapper function to run stan in order to generate a PoS 
#' prediction
#' 
#' @section Specification:
#' \if{latex}{
#'   \itemize{
#'   \item Transfer target hazard ratio and hazard ratio bound to log-scale
#'   \item When `use_PFS` is TRUE, calculate log hazard ratio PFS estimate and  
#'   its standard error from a phase 2 study
#'   \item When `use_ORR` is TRUE, calculate log odds ratio for ORR estimate 
#'   and its standard error estimate from a phase 2 study
#'   \item Derive sigma_P1 and sigma_P2, i.e., the standard deviations in the 
#'   mixture prior, based on the input threshold value
#'   \item Calculate the unit standard deviation and the covariance matrix of 
#'   the observed treatment effect using `gen_sigma()`
#'   \item Derive the hyperparameter for the half normal distribution
#'   \item Create a list for `rstan::stan()` input
#'   \item Update the list based on `use_PFS` and `use_ORR`
#'   \item Run `rstan::stan()` to obtain the PoS prediction
#'   }
#' }
#' \if{html}{
#' The contents of this section are shown in PDF user manual only.
#' }
#' 
#' @param target_hr target hazard ration in phase 3 study (i.e., under 
#' alternative hypothesis)
#' @param J number of planned analyses in phase 3 study
#' @param nevents3 numeric vector of target number of events in phase 3 study
#' @param hr_bound numeric vector of hazard ratio bounds for analyses in phase
#' 3 study
#' @param omega probability that a treatment effect comes from a enthusiastic 
#' prior component, i.e., initial benchmarking probability for the study success
#' @param est_obs_pfs estimated PFS hazard ratio based on prior/earlier study
#' @param low_obs_pfs lower bound of estimated PFS hazard ratio based on 
#' prior/earlier study
#' @param upp_obs_pfs upper bound of estimated PFS hazard ratio based on 
#' prior/earlier study
#' @param obs_pfs_conf_level confidence level for the estimated PFS hazard ratio
#' bounds, Default: 0.95
#' @param thres probability of either lack treatment effect under the 
#' enthusiastic prior or substantial treatment effect under the pessimistic 
#' prior. Should be set to a small value, close to 0, Default: 0.01
#' @param n_resp_trt2 number of responses in treatment arm from a prior/earlier 
#' study
#' @param n_resp_ctrl2 number of responses in control arm from a prior/earlier 
#' study
#' @param n_trt2 sample size in treatment arm from a prior/earlier study
#' @param n_ctrl2 sample size in control arm from a prior/earlier study
#' @param use_orr whether response data from a prior/earlier study should be 
#' used, Default: FALSE
#' @param use_pfs whether PFS data from a prior/earlier study should be used, 
#' Default: FALSE
#' @param het_degree_p2 indicates the degree of heterogeneity of a study level 
#' parameter for a prior/earlier study and must be one of "large", 
#' "substantial", "moderate", "small", "very small", Default: 'small'.
#' @param het_degree_p3 indicates the degree of heterogeneity of a study level 
#' parameter for a phase 3 study and must be one of "large", 
#' "substantial", "moderate", "small", "very small", Default: 'very small'
#' @param m_0 intercept for linear regression of log treatment effect of PFS on 
#' log treatment effect on response. A value is expected only when `use_orr = TRUE`
#' and `use_pfs = TRUE`, Default: NA
#' @param m_1 slope for linear regression of log treatment effect of PFS on 
#' log treatment effect on response. A value is expected only when `use_orr = TRUE`
#' and `use_pfs = TRUE`, Default: NA
#' @param nu_0 standard error of `m_0`. A value is expected only when 
#' `use_orr = TRUE` and `use_pfs = TRUE`, Default: NA
#' @param nu_1 standard error of `m_1`. A value is expected only when 
#' `use_orr = TRUE` and `use_pfs = TRUE`, Default: NA
#' @param lm_sd linear regression residual variance of log treatment effect of 
#' PFS on log treatment effect on response. A value is expected only when 
#' `use_orr = TRUE` and `use_pfs = TRUE`, Default: NA
#' @param niter number of iterations to be used in stan run, Default: 1000
#' @param nchains number of chains to be used in stan run, Default: 4
#' @param ncores number of cores to be used in stan run, Default: 4
#' @param seed seed to be used in stan run
#' @param ... params to pass to stan run
#' @inheritParams gen_sigma
#' @return list which includes the generated stan object, list of data that
#' was supplied to `rstan::stan()`, and the name of the stan file which was run
#' @examples
#' # use PFS data from a prior study
#'   run_stan(
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
#'  \code{\link[stats]{Normal}}
#'  \code{\link[pracma]{erf}}
#'  \code{\link[rstan]{stan}}
#' @rdname run_stan
#' @export 
#' @importFrom stats qnorm
#' @importFrom pracma erfinv
#' @importFrom rstan stan
run_stan <- function(
    target_hr,
    J,
    nevents3,
    hr_bound, omega,
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
    ...
    ) {
  # check the 'three dots' input
  #add an error if the length of the nevenet s, hr_bound equal to J
  
  delta_P <- log(target_hr)
  loghr_bound <- log(hr_bound)
  
  #log HR PFS estimate and its SE from phase II:
  if (use_pfs) {
    lest_obs_pfs<- log(est_obs_pfs) 
    lse_obs_pfs <- (log(upp_obs_pfs) - log(low_obs_pfs))/2/stats::qnorm(1 - (1 - obs_pfs_conf_level)/2)
  }
  
  #log Odds Ratio for ORR estimate and its SE from phase II:
  if (use_orr) {
    #orr % estimates in each arm:
    log_odds_est <- resp2oddsratio(
      n_resp_trt = n_resp_trt2, 
      n_resp_ctrl = n_resp_ctrl2, 
      n_trt = n_trt2, 
      n_ctrl = n_ctrl2)
   }
  
  sigma_P1 <- sigma_P2 <- delta_P/stats::qnorm(thres)
  
  sigma_gen <- gen_sigma(nevents3, ratio)
  Sigma <- sigma_gen$cov_matrix
  sigma_unit <- sigma_gen$sigma_unit
  
  # hyperparameter for the half normal distribution
  z2 <- sigma_unit*get_denominator(het_degree_p2)/pracma::erfinv(0.5)/sqrt(2)
  z3 <- sigma_unit*get_denominator(het_degree_p3)/pracma::erfinv(0.5)/sqrt(2) # (very small degree of heterogeneity for phase 3)
  
  #define the data list for the stan model based on the available phase II data
  stan_list <- list(
    omega = omega,
    delta_P = delta_P,
    sigma_P1 = sigma_P1,
    sigma_P2 = sigma_P2,
    tau_sd2 = z2,
    tau_sd3 = z3,
    J = J,
    Sigma = Sigma
  )
  stan_file <- "phase23_interim_none.stan"
  
  if (use_pfs){
    stan_list <- append(
      stan_list,
      list(
        theta_hat = lest_obs_pfs,
        theta_hat_sd = lse_obs_pfs
        )
    )
    stan_file <- "phase23_interim_pfs.stan"
  }
  
  if (use_orr){   
    stan_list <- append(
      stan_list,
      list(
        orr_hat = log_odds_est$est,
        orr_hat_sd = log_odds_est$se,
        m_0 = m_0, m_1 = m_1, nu_0 = nu_0, nu_1 = nu_1,
        wls_sd = lm_sd/sqrt(n_trt2 + n_ctrl2)
           )
    )
    
    stan_file <- "phase23_interim_orr.stan"
    
  }
  #the below removes the duplicate tau_sd2 if both PFS and ORR are used - need to find a better solution
  if (use_pfs & use_orr){
    stan_file <- "phase23_interim_both.stan"
  }
  
  rstan::rstan_options(auto_write = TRUE)
  
  package_path <- find.package('oncoPoS',lib.loc = .libPaths())
  file_path <- file.path(package_path,'bin', 'stan', stan_file)
  
  fit_rstan <- rstan::stan(
    file = file_path,
    data = stan_list,
    iter = niter,
    chains = nchains,
    cores = ncores,
    seed = seed,
    ...
    )
  
  return(list(fit_rstan = fit_rstan, stan_list = stan_list, stan_file = stan_file))
}
