#' Get data related to your RobinHood account
#'
#' @param RH object of class RobinHood
#' @import curl magrittr
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
    check_rh(RH)

    # Pull RH account data
    accounts <- api_accounts(RH)

    return(accounts)

}
