#' Get user data
#'
#' Download a list of user data from your RobinHood account
#'
#' @param RH object class RobinHood
#' @import curl jsonlite magrittr lubridate
#' @export
get_user <- function(RH, ticker, limit_output = TRUE) {

  user <- api_user(RH)

  return(user)

}
