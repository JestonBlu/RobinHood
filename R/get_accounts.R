#' Get account data
#'
#' Download a list of account data for your RobinHood account.
#'
#' @param RH object class RobinHood
#' @import curl jsonlite magrittr lubridate
#' @export
get_accounts <- function(RH) {

  accounts <- api_accounts(RH)

  return(accounts)

}
