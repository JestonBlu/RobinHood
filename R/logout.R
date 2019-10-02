#' Logout of RobinHood
#'
#' Send a logout call through the RobinHood API service and disable your token.
#'
#' @param RH object of class RobinHood
#' @import httr magrittr
#' @export
#' @examples
#' \dontrun{
#' # Login in to your RobinHood account
#' RH <- RobinHood("username", "password")
#'
#' logout(RH)
#'}
logout <- function(RH) {

    # Check if RH is valid
    check_rh(RH)

    # API request to revoke token
    x <- api_logout(RH)

    if (x == "") {
      cat("Logout Sucessful")
    } else {
      cat("Failed to Logout")
    }
  }
