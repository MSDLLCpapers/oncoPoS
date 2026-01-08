#' @title Estimate log odds ratio given response
#' @description Estimates log odds ratio for treatment vs control based on 
#' number of responses and samples size in each arm
#' 
#' @section Specification:
#' \if{latex}{
#'   \itemize{
#'   \item Calculate proportion of responders in treatment and control groups
#'  respectively
#'   \item Derive ORR odds in each arm
#'   \item Calculate observed ORR odds ratio and the corresponding standard error 
#'   }
#' }
#' \if{html}{
#' The contents of this section are shown in PDF user manual only.
#' }
#' 
#' @param n_resp_trt number of responses in treatment arm
#' @param n_resp_ctrl number of responses in control arm
#' @param n_trt sample size in treatment arm
#' @param n_ctrl sample size in control arm
#' @return log odds ratio point estimate and a corresponding standard error 
#' @examples 
#' resp2oddsratio(n_resp_trt = 20, n_resp_ctrl = 10, n_trt = 40, n_ctrl = 45)
#' @rdname resp2oddsratio
#' @export 
resp2oddsratio <- function(
    n_resp_trt, n_resp_ctrl, n_trt, n_ctrl
) {
  p_resp_trt <- n_resp_trt/n_trt 
  p_resp_ctrl <- n_resp_ctrl/n_ctrl 
  
  #orr odds in each arm:
  or_orr_trt <- p_resp_trt/(1 - p_resp_trt)
  or_orr_ctrl <- p_resp_ctrl/(1 - p_resp_ctrl)
  
  lest_obs_orr <- log(or_orr_ctrl/or_orr_trt)
  lse_obs_orr <- sqrt(1/n_resp_trt + 1/(n_trt - n_resp_trt) + 1/n_resp_ctrl + 1/(n_ctrl - n_resp_ctrl))
  
  return(list(est = lest_obs_orr, se = lse_obs_orr))
}
