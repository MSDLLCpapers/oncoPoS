#' @title Estimate Log Odds Ratio Using Observed Response Data and Prior on 
#' Control Arm
#' 
#' @description
#' Estimates the log odds ratio (log OR) between treatment and control arms 
#' in a single-arm trial by combining observed responses in treatment arm with 
#' prior knowledge of the control response rate. The prior distribution on the 
#' control arm's response rate is specified through a credible interval.
#' 
#' @section Specification:
#' \if{latex}{
#'   \itemize{
#'     \item Compute the observed response rate in the treatment arm.
#'     \item Translate the control response rate bounds into a normal prior on 
#'     the logit scale.
#'     \item Fit a Bayesian model to estimate the posterior distribution of the 
#'     log OR.
#'     \item Return the posterior mean and standard deviation of the log OR.
#'   }
#' }
#' \if{html}{
#'   The contents of this section are shown in the PDF user manual only.
#' }
#'
#' @param n_resp_trt number of responses in the treatment arm
#' @param n_trt sample size in the treatment arm
#' @param low_soc_rr lower bound of the control arm's response rate
#' @param upp_soc_rr upper bound of the control arm's response rate
#' @param ci_rr confidence level (e.g., 0.80) for the control arm response rate
#' interval.
#' @param niter number of iterations to be used in stan run, Default: 1000
#' @param nchains number of chains to be used in stan run, Default: 4
#' @param ncores number of cores to be used in stan run, Default: 4
#' @param seed seed to be used in stan run
#' @param refresh integer, progress indicator, Default: 0 (turned off)
#' @param ... params to pass to stan run
#' @return A list containing:
#' \describe{
#'   \item{\code{est}}{Posterior mean of the log odds ratio.}
#'   \item{\code{se}}{Posterior standard deviation (i.e., standard error) of the
#'    log odds ratio.}
#' }
#' 
#' @details
#' This function is useful in single-arm trials where the control arm is not 
#' directly observed. A prior on the control arm's response rate provided as a 
#' credible interval, is transformed into a normal prior on the logit scale. 
#' The posterior distribution of the log odds ratio is then estimated using 
#' Bayesian inference via Stan.
#'
#' The Stan model (`estimate_ctrl.stan`) must be available in the working directory.
#'
#' @examples
#' \dontrun{
#' resp2oddsratio_estimate_ctrl(
#'   n_resp_trt = 40,
#'   n_trt = 100,
#'   low_soc_rr = 0.05,
#'   upp_soc_rr = 0.30,
#'   ci_rr = 0.80
#' )
#' }
#'
#' @rdname resp2oddsratio_estimate_ctrl
#' @export
resp2oddsratio_estimate_ctrl <- function(
    n_resp_trt, 
    n_trt, 
    low_soc_rr, 
    upp_soc_rr, 
    ci_rr = 0.8,
    niter = 1000,
    nchains = 4,
    seed = 123,
    refresh = 0,
    ...
    ) {
  
  # Compute observed treatment ORR
  p_resp_trt <- n_resp_trt / n_trt
  
  # Compute prior on logit(p_ctrl)
  logit_low <- log(low_soc_rr / (1 - low_soc_rr))
  logit_upp <- log(upp_soc_rr / (1 - upp_soc_rr))
  mu_logit_ctrl <- (logit_low + logit_upp) / 2
  sigma_logit_ctrl <- (logit_upp - logit_low) / (2 * qnorm(1 - (1 - ci_rr)/2))
  
  # Prepare data list for Stan
  stan_data <- list(
    n_resp_trt = n_resp_trt,
    n_trt = n_trt,
    mu_logit_ctrl = mu_logit_ctrl,
    sigma_logit_ctrl = sigma_logit_ctrl
  )

  rstan::rstan_options(auto_write = TRUE)
  
  stan_file <- "estimate_ctrl.stan"
  package_path <- find.package('oncoPoS',lib.loc = .libPaths())
  file_path <- file.path(package_path,'bin', 'stan', stan_file)
  
  # Run Stan model
  fit <- rstan::stan(
    file = file_path,
    data = stan_data,
    iter = niter,
    chains = nchains,
    seed = seed,
    refresh = refresh,
    ...)
  
  # Extract log(OR) samples
  posterior <- rstan::extract(fit)
  log_or_samples <- posterior$log_or
  
  # Return posterior mean and sd
  return(list(est = mean(log_or_samples),
              se = sd(log_or_samples)))
}
