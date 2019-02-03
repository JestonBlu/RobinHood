#' Get account data
#'
#' Download a list of account data for your RobinHood account.
#'
#' @param RH object of class RobinHood
#' @import curl jsonlite magrittr
#' @export
#' @examples
#' \dontrun{
#' # Login in to your RobinHood account
#' RH <- RobinHood("username", "password")
#'
#' get_accounts(RH)
#'}
get_accounts <- function(RH) {

  if (class(RH) != "RobinHood") stop("RH must be class RobinHood, see RobinHood()")

  accounts <- api_accounts(RH)

  return(accounts)

}
