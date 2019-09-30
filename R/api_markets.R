#' RobinHood API: Markets
#'
#' Backend function called by get_market_hours(). Returns a data frame of markets data and trading hours.
#'
#' @param RH object of class RobinHood
#' @param markets_url (string) a single market url
#' @param type (string) structure of data returned, 'df' or 'list'
#' @import httr magrittr

api_markets <- function(RH, markets_url, type = "df") {

  # URL and token
  token <- paste("Bearer", RH$tokens.access_token)

  # GET call
  dta <- GET(markets_url,
             add_headers("Accept" = "application/json",
                         "Content-Type" = "application/json",
                         "Authorization" = token))

  # format return
  dta <- mod_json(dta, "fromJSON")

  if (type == "df") {
    # Returns market information
    dta <- as.data.frame(dta$results)
    return(dta)
  }
  if (type == "list") {
    # Returns market hours
    dta$closes_at <- lubridate::ymd_hms(dta$closes_at)
    dta$extended_opens_at <- lubridate::ymd_hms(dta$extended_opens_at)
    dta$extended_closes_at <- lubridate::ymd_hms(dta$extended_closes_at)
    dta$date <- lubridate::ymd(dta$date)
    dta$opens_at <- lubridate::ymd_hms(dta$opens_at)

    return(dta)
  }
}
