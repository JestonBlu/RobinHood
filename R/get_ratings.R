#' Get analyst raings for a given equity symbol from RobinHood
#'
#' @param RH object class RobinHood
#' @param symbol (string) Ticker symbol
#' @import httr magrittr
#' @export
#' @examples
#' \dontrun{
#' # Login in to your RobinHood account
#' RH <- RobinHood("username", "password")
#'
#' get_ratings(RH)
#'}
get_ratings <- function(RH, symbol) {

    # Check if RH is valid
    check_rh(RH)

    # Get request from user information API
    ratings <- api_ratings(RH, symbol)

    return(ratings)
}
