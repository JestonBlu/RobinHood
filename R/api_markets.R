#' RobinHood API: Markets
#'
#' Backend function called by get_market_hours(). Returns a data frame of markets data and trading hours.
#'
#' @param RH object of class RobinHood
#' @param markets_url (string) a single market url
#' @param type (string) structure of data returned, 'df' or 'list'
#' @import curl jsonlite magrittr lubridate
#' @export
api_markets <- function(RH, markets_url, type = "df") {

  markets <- new_handle() %>%
    handle_setheaders("Accept" = "application/json") %>%
    curl_fetch_memory(url = markets_url)

  markets <- fromJSON(rawToChar(markets$content))

  if (type == "df") {
    # Returns market information
    markets_df <- data.frame(markets$results)
    return(markets_df)
  }
  if (type == "list") {
    # Returns market hours
    markets$closes_at <- ymd_hms(markets$closes_at)
    markets$extended_opens_at <- ymd_hms(markets$extended_opens_at)
    markets$extended_closes_at <- ymd_hms(markets$extended_closes_at)
    markets$date <- ymd(markets$date)
    markets$opens_at <- ymd_hms(markets$opens_at)
    return(markets)
  }
}
