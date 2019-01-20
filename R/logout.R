#' Logout of RobinHood
#'
#' Send a logout call through the RobinHood API service and disable your token.
#'
#' @param RH object of class RobinHood
#' @import curl jsonlite magrittr
#' @export
#' @examples
#' # Logout
#' # RH <- RobinHood(username = 'your username', password = 'your password')
#' # logout(RH)
logout <- function(RH) {

  x <- api_logout(RH)

  if (length(x) == 0) {
    cat("Logout Sucessful")
  } else {
    cat("Failed to Logout")
  }
}
