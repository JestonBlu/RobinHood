#' Download all financial instruments available on RobinHood
#'
#' Get a dataframe of all listed companies including ticker symbols and tradeability indicators.
#'
#' @param RH object of class RobinHood
#' @import curl jsonlite magrittr
#' @export
#' @examples
#' \dontrun{
#' # Login in to your RobinHood account
#' RH <- RobinHood("username", "password")
#'
#' get_tickers(RH)
#'}
get_tickers <- function(RH) {

    if (class(RH) != "RobinHood") stop("RH must be class RobinHood, see RobinHood()")

    tickers <- api_tickers(RH)

    tickers <- tickers[, c("symbol", "rhs_tradability", "country", "name", "state", "list_date")]

    return(tickers)

}
