#' RobinHood API: Fundamentals
#'
#' Backend function called by get_fundamentals(), watchlist(). Returns a data frame of descriptive data for a
#' given ticker symbol.
#'
#' @param RH object of class RobinHood
#' @param ticker (string) vector of ticker symbols
#' @import curl magrittr
#' @export
api_fundamentals <- function(RH, ticker) {

  # URL and token
  url <- paste(api_endpoints("fundamentals"), ticker, collapse = ",", sep = "")
  token <- paste("Bearer", RH$tokens.access_token)

  # GET call
  dta <- httr::GET(url,
    httr::add_headers("Accept" = "application/json",
                "Content-Type" = "application/json",
                "Authorization" = token))

  # Format return
  dta <- mod_json(dta, "fromJSON")
  dta <- as.list(dta$results)

  dta <- dta %>%
    dplyr::mutate_at(c("open", "high", "low", "volume", "average_volume_2_weeks", "average_volume", "high_52_weeks",
                       "dividend_yield", "low_52_weeks", "market_cap", "pe_ratio", "shares_outstanding"),
                     as.numeric)

  return(dta)
}
