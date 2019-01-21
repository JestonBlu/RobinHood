#' Get account data
#'
#' Download a list of account data for your RobinHood account.
#'
#' @param RH object class RobinHood
#' @import curl jsonlite magrittr lubridate
#' @export
get_accounts <- function(RH) {

  if (class(RH) != "RobinHood") stop("RH must be class RobinHood, see RobinHood()")

  accounts <- api_accounts(RH)

  return(accounts)

}
