#' RobinHood API: Option Contract Instruments
#'
#' @param RH object of class RobinHood
#' @param option_instrument_url (string) url
#' @import curl jsonlite magrittr lubridate
#' @export
api_option_instruments <- function(RH, option_instrument_url) {

  option_instrument_url <- option_instrument_url

  option_instruments <- new_handle() %>%
    handle_setheaders("Accept" = "application/json") %>%
    handle_setheaders("Authorization" = paste("Bearer", RH$tokens.access_token)) %>%
    curl_fetch_memory(url = option_instrument_url)

  option_instruments <- fromJSON(rawToChar(option_instruments$content))
  option_instruments <- data.frame(option_instruments)

  if (option_instruments$type == "call") {

    colnames(option_instruments)[13:15] = c("cutoff_price", "below_tick", "above_tick")

    option_instruments$issue_date <- lubridate::ymd(option_instruments$issue_date)
    option_instruments$strike_price <- as.numeric(option_instruments$strike_price)
    option_instruments$expiration_date <- lubridate::ymd(option_instruments$expiration_date)
    option_instruments$created_at <- lubridate::ymd_hms(option_instruments$created_at)
    option_instruments$updated_at <- lubridate::ymd_hms(option_instruments$updated_at)

  }

  return(option_instruments)
}
