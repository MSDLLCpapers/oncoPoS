#' @title Generate Beta Distribution Parameters for Omega
#' @description Computes the shape parameters of a Beta distribution based on 
#' the specified mean and variance. This is used to parameterize a Beta prior 
#' distribution for the benchmark probability for study success, \code{omega} 
#' in Bayesian modeling of phase III trial success.
#' 
#' @section Specification:
#' \if{latex}{
#'   \itemize{
#'     \item Accepts prior mean and variance for a Beta-distributed quantity.
#'     \item These can be obtained from predictive modeling (e.g., Benchmark
#'     probability model using random forest) or empirical prior estimates.
#'     \item Converts the mean and variance into Beta shape parameters 
#'     \eqn{\alpha} and \eqn{\beta}.
#'     \item Returns the resulting shape parameters as a named list.
#'   }
#' }
#' \if{html}{
#'   The contents of this section are shown in the PDF user manual only.
#' }
#'
#' @param mean Numeric value between 0 and 1, specifying the prior mean of the 
#' Beta distribution. This may be estimated from a Benchmark probability model 
#' such as random forest.
#' @param var Numeric value, specifying the prior variance of the Beta 
#' distribution. This may reflect uncertainty in the model-based prediction.
#'            
#' @return A named list with elements:
#' \describe{
#'   \item{\code{alpha}}{First shape parameter of the Beta distribution.}
#'   \item{\code{beta}}{Second shape parameter of the Beta distribution.}
#' }
#' 
#' @details
#' The Beta distribution is parameterized by two positive shape parameters, 
#' \eqn{\alpha} and \eqn{\beta}, 
#' which can be derived from a given mean \eqn{\mu} and variance \eqn{\sigma^2} 
#' using:
#' \deqn{
#'   \alpha = \mu \left( \frac{\mu(1 - \mu)}{\sigma^2} - 1 \right), \quad
#'   \beta = (1 - \mu) \left( \frac{\mu(1 - \mu)}{\sigma^2} - 1 \right)
#' }
#' These parameters allow for a flexible specification of prior distributions, 
#' and are particularly useful when the prior belief is derived from a 
#' predictive model in an earlier step (e.g., machine learning model 
#' estimating historical success probabilities).
#'
#' @examples
#' # Example using prior mean and variance estimated from a Benchmark 
#' # probability model
#' get_beta_params(mean = 0.52, var = 0.02)
#'
#' @rdname get_beta_params
#' @export
get_beta_params <- function(mean, var) {
  alpha <- mean * ((mean * (1 - mean)) / var - 1)
  beta <- (1 - mean) * ((mean * (1 - mean)) / var - 1)
  list(alpha = alpha, beta = beta)
}
