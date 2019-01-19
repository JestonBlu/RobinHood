#' Connect to your RobinHood Account
#'
#' This function returns an object of S3 class RobinHood and establishes a
#' connection to a RobinHood account.
#'
#' @param username user name or email
#' @param password password
#' @import curl jsonlite magrittr
#' @export
#' @examples
#' # Connect to your robinhood account
#' # RH <- RobinHood(username = 'your username', password = 'your password')
RobinHood <- function(username, password) {

  # Login to RobinHood, returns RobinHood object with access tokens
  RH <- api_login(username, password)

  # Get user data for the main purpose of returning the position url
  user <- api_accounts(RH)
  url_positions <- user$results$positions
  url_account_id <- user$results$url

  # Return object
  RH <- c(RH, url = list(positions = url_positions,
                         account_id = url_account_id))

  # Check to see if connection was successful
  if (is.null(RH$tokens.access_token)) {
    cat("Login not successful, check username and password.")
  }

  # Set Class and return object
  class(RH) <- "RobinHood"
  return(RH)
}
