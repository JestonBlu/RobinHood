#' RobinHood API: Historicals
#'
#' Backend function called by get_historicals(). Returns a data frame of historical price data.
#'
#' @param RH object of class RobinHood
#' @param historicals_url (string) api url
#' @param body (string) api body
#' @import curl jsonlite magrittr lubridate
#' @export
api_historicals <- function(RH, historicals_url, body) {

  historicals_url = paste(historicals_url, "?", body, sep = "")

  historicals <- new_handle() %>%
    handle_setheaders("Accept" = "application/json") %>%
    handle_setheaders("Authorization" = paste("Bearer", RH$tokens.access_token)) %>%
    curl_fetch_memory(url = historicals_url)

  historicals <- fromJSON(rawToChar(historicals$content))
  historicals <- data.frame(historicals$results$historicals)

  historicals$begins_at = lubridate::ymd_hms(historicals$begins_at)
  return(historicals)
  }
