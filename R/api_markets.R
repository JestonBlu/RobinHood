#' RobinHood API: Markets
#'
#' Get a list of markets
#'
#' @param RH object of class RobinHood
#' @param markets_url (string) url of the market api
#' @param type (string) 'df' or 'list'
#' @import curl jsonlite magrittr
api_markets <- function(RH, markets_url, type = 'df') {

  # Log in, get access token
  markets <- new_handle() %>%
    handle_setheaders("Accept" = "application/json") %>%
    curl_fetch_memory(url = markets_url) %$% content %>%
    rawToChar %>%
    fromJSON

  if (type == 'df') {
    markets_df <- markets %$% results %>% data.frame
    return(markets_df)
  }
  if (type == 'list') {
    return(markets)
  }
}
