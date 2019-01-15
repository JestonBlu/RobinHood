#' RobinHood API Instruments
#'
#' Returns a list of instrument data
#'
#' @param instrument_id (string) instrument_id returned from api_positions
#' @import curl jsonlite magrittr
api_instruments <- function(instrument_id) {

  instrument <- new_handle() %>%
    handle_setheaders("Accept" = "application/json") %>%
    handle_setheaders("Authorization" = paste("Bearer", RH$tokens.access_token)) %>%
    curl_fetch_memory(url = instrument_id) %$% content %>%
    rawToChar %>% fromJSON

  return(instrument)
}
