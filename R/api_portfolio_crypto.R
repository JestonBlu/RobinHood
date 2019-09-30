#' RobinHood API: Portfolio Crypto
#'
#' Backend function called by get_portfolio(..., source = "crypto"). Returns a data frame of the current crypto portolio summary.
#'
#' @param RH object of class RobinHood
#' @import httr magrittr

api_portfolios_crypto <- function(RH) {

  # URL and token
  url <- paste(api_endpoints("portfolios", source = "crypto"),
               api_accounts_crypto(RH)$id, "/",
               sep = "")
  token <- paste("Bearer", RH$tokens.access_token)

  # GET call
  dta <- GET(url,
             add_headers("Accept" = "application/json",
                         "Content-Type" = "application/json",
                         "Authorization" = token))

  # format return
  dta <- mod_json(dta, "fromJSON")
  dta <- as.list(dta)

  dta$equity <- as.numeric(dta$equity)
  dta$extended_hours_equity <- as.numeric(dta$extended_hours_equity)
  dta$market_value <- as.numeric(dta$market_value)
  dta$extended_hours_market_value <- as.numeric(dta$extended_hours_market_value)
  dta$previous_close <- as.numeric(dta$previous_close)
  dta$updated_at <- lubridate::ymd_hms(dta$updated_at)

  return(dta)
}
