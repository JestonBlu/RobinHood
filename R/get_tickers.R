#' Get tickers
#'
#' Get a dataframe of all listed companies including tickers and trade indicators.
#'
#' @param RH object of class RobinHood
#' @import curl jsonlite magrittr
#' @export
get_tickers <- function(RH) {

    if (class(RH) != "RobinHood") stop("RH must be class RobinHood, see RobinHood()")

    tickers <- api_tickers(RH)

    tickers <- tickers[, c("symbol", "rhs_tradability", "country", "name", "state", "list_date")]

    return(tickers)

}
