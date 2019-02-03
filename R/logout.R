#' Logout of RobinHood
#'
#' Send a logout call through the RobinHood API service and disable your token.
#'
#' @param RH object of class RobinHood
#' @import curl jsonlite magrittr
#' @export
#' @examples
#' \dontrun{
#' # Login in to your RobinHood account
#' RH <- RobinHood("username", "password")
#'
#' logout(RH)
#'}
logout <- function(RH) {
  if (class(RH) != "RobinHood") stop("RH must be class RobinHood, see RobinHood()")

  x <- api_logout(RH)

  if (length(x) == 0) {
    cat("Logout Sucessful")
  } else {
    cat("Failed to Logout")
  }
}
