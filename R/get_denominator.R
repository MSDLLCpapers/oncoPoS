#' @title Transform degree of heterogeneity to denominator
#' @description Helper function: transform degree of heterogeneity to 
#' denominator
#' 
#' @section Specification:
#' \if{latex}{
#' \itemize{
#' \item Determine the denominator of standard deviation for tau (standard 
#' deviation of phase 2 or 3 treatment effect) based on the level of 
#' heterogeneity 
#' }
#' }
#' \if{html}{
#' The contents of this section are shown in PDF user manual only.
#' }
#' 
#' @param input indicates the degree of heterogeneity of the study level 
#' parameter, and must be one of "large", "substantial", "moderate", "small",
#' "very small"
#' @rdname get_denominator
get_denominator <- function(input) {
  if (input == "large") {
    denom <- 1/4
  } else if (input == "substantial") {
    denom <- 1/8
  } else if (input == "moderate") {
    denom <- 1/16
  } else if (input == "small") {
    denom <- 1/32
  } else if (input == "very small"){
    denom <- 1/64
  }
  
  denom
}
