#' Logout of RobinHood
#'
#' Send a logout call through the RobinHood API service and disable your token.
#'
#' @param RH object of class RobinHood
#' @import curl magrittr
#' @export
#' @examples
#' \dontrun{
#' # Login in to your RobinHood account
#' RH <- RobinHood("username", "password")
#'
#' logout(RH)
#'}
logout <- function(RH) {

  check_rh(RH)

  x <- api_logout(RH)

  if (length(x) == 0) {
    cat("Logout Sucessful")
  } else {
    cat("Failed to Logout")
  }
}
