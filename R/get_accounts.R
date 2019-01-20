#' Get account data
#'
#' Download a list of account data for your RobinHood account.
#'
#' @param RH object class RobinHood
#' @import curl jsonlite magrittr lubridate
#' @export
get_accounts <- function(RH, ticker, limit_output = TRUE) {

  accounts <- api_accounts(RH)
  accounts <- accounts  %$% results %>% as.list

  return(accounts)

}