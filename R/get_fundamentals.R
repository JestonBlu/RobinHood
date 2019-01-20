#' Get ticker fundamentals
#'
#' Get ticker fundamentals for a particular symbol or list of symbols.
#'
#' @param RH object of class RobinHood
#' @param ticker (string) vector of ticker symbols
#' @param include_description (logical) include a long description of the company (default: FALSE)
#' @import curl jsonlite magrittr
#' @export
get_fundamentals <- function(RH, ticker, include_description = FALSE) {

    ticker <- paste(ticker, collapse = ",")

    fundamentals <- api_fundamentals(RH, ticker)

    if (include_description == FALSE) {
        fundamentals <- subset(fundamentals, select = -c(description, instrument))
    }

    fundamentals <- fundamentals %>% as.list

    return(fundamentals)

}
