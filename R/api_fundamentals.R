#' RobinHood API: Fundamentals
#'
#' Backend function called by get_fundamentals(), watchlist(). Returns a data frame of descriptive data for a
#' given ticker symbol.
#'
#' @param RH object of class RobinHood
#' @param ticker (string) vector of ticker symbols
#' @import httr magrittr
#' @export
api_fundamentals <- function(RH, ticker) {

  # URL and token
  url <- paste(api_endpoints("fundamentals"), ticker, collapse = ",", sep = "")
  token <- paste("Bearer", RH$tokens.access_token)

  # GET call
  dta <- GET(url,
             add_headers("Accept" = "application/json",
                         "Content-Type" = "application/json",
                         "Authorization" = token))
  httr::stop_for_status(dta)
  
  # Format return
  dta <- mod_json(dta, "fromJSON")
  dta <- as.data.frame(dta$results)

  return(dta)
}
