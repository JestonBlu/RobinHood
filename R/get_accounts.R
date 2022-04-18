#' Get data related to your RobinHood account
#'
#' @param RH object of class RobinHood
#' @import httr magrittr
#' @export
#' @examples
#' \dontrun{
#' # Login in to your RobinHood account
#' RH <- RobinHood("username", "password")
#'
#' get_accounts(RH)
#'}
get_accounts <- function(RH) {

    # Check if RH is valid
    RobinHood::check_rh(RH)

    # Pull RH account data
    accounts <- RobinHood::api_accounts(RH)

    return(accounts)

}
