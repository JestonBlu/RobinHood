#' RobinHood API Quote
#'
#' Returns a list of instrument data
#'
#' @param RH object of class RobinHood
#' @param symbols_url (string) url of query with ticker symbols
#' @import curl jsonlite magrittr
api_quote <- function(RH, symbols_url) {

  quotes <- new_handle() %>%
    handle_setheaders("Accept" = "application/json") %>%
    handle_setheaders("Authorization" = paste("Bearer", RH$tokens.access_token)) %>%
    curl_fetch_memory(url = symbols_url) %$% content %>%
    rawToChar %>%
    fromJSON %$% results %>% data.frame

  return(quotes)
}
