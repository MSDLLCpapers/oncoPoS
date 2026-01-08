#' @title Generate covariance matrix for observed treatment effect in phase 3
#' @description Generates covariance matrix for an observed treatment effect, 
#' i.e., log of hazard ratio in a phase 3 trial
#' 
#' @section Specification:
#' \if{latex}{
#'   \itemize{
#'   \item Transfer the randomization ratio to the proportion of subjects in 
#'   the control group
#'   \item Calculate the unit standard deviation based on the proportion of 
#'   subjects in the control group
#'   \item Create a covariance matrix for the observed treatment effect (log 
#'   hazard ratio)
#'   \item Update the matrix elements based on the target number of events in a
#'  phase 3 study
#'   }
#' }
#' \if{html}{
#' The contents of this section are shown in PDF user manual only.
#' }
#' 
#' @param n_events numeric vector of target number of events in phase 3
#' @param ratio randomization ratio of experimental arm compared to control
#' @return sigma_unit and covariance matrix to be used for PoS prediction
#' @examples 
#' \dontrun{gen_sigma(c(100, 150), ratio = 1)}
#' @rdname gen_sigma
#' @export 
gen_sigma <- function(n_events, ratio = 1) {
  
  p0 <- 1/(1 + ratio)
  sigma_unit <- 1/sqrt(p0)/sqrt(1-p0)
  
  J <- length(n_events)
  res <- matrix(0, J, J)
  for (i in 1:J) {
    for (j in 1:J) {
      res[i,j] <- sigma_unit/max(n_events[i], n_events[j])
    }
  }
  return(list(sigma_unit = sigma_unit, cov_matrix = res))
}
