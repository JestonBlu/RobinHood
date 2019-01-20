#' RobinHood API: Markets
#'
#' Backend function called by get_market_hours(). Returns a data frame of markets data and trading hours.
#'
#' @param RH object of class RobinHood
#' @param markets_url (string) a single market url
#' @param type (string) structure of data returned, 'df' or 'list'
#' @import curl jsonlite magrittr
#' @examples
#' # data returned by api call
#' # $ website
#' # $ city
#' # $ name
#' # $ url
#' # $ country
#' # $ todays_hours
#' # $ operating_mic
#' # $ acronym
#' # $ timezone
#' # $ mic
api_markets <- function(RH, markets_url, type = "df") {

  markets <- new_handle() %>%
    handle_setheaders("Accept" = "application/json") %>%
    curl_fetch_memory(url = markets_url) %$% content %>%
    rawToChar %>%
    fromJSON

  if (type == "df") {
    # Returns market information
    markets_df <- markets %$% results %>% data.frame
    return(markets_df)
  }
  if (type == "list") {
    # Returns market hours
    return(markets)
  }
}
