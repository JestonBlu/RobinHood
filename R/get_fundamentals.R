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

    fundamentals$open <- as.numeric(fundamentals$open)
    fundamentals$high <- as.numeric(fundamentals$high)
    fundamentals$low <- as.numeric(fundamentals$low)
    fundamentals$volume <- as.numeric(fundamentals$volume)
    fundamentals$average_volume_2_weeks <- as.numeric(fundamentals$average_volume_2_weeks)
    fundamentals$average_volume <- as.numeric(fundamentals$average_volume)
    fundamentals$high_52_weeks <- as.numeric(fundamentals$high_52_weeks)
    fundamentals$dividend_yield <- as.numeric(fundamentals$dividend_yield)
    fundamentals$low_52_weeks <- as.numeric(fundamentals$low_52_weeks)
    fundamentals$market_cap <- as.numeric(fundamentals$market_cap)
    fundamentals$pe_ratio <- as.numeric(fundamentals$pe_ratio)
    fundamentals$shares_outstanding <- as.numeric(fundamentals$shares_outstanding)

    return(fundamentals)

}
