#' RobinHood API: Positions
#'
#' Returns a data frame of position data
#'
#' @param RH object of class RobinHood
#' @import curl jsonlite magrittr
api_positions <- function(RH) {

  # Get current positions
  positions <- new_handle() %>%
    handle_setheaders("Accept" = "application/json") %>%
    handle_setheaders("Authorization" = paste("Bearer", RH$tokens.access_token)) %>%
    curl_fetch_memory(url = RH$url.positions) %$% content %>%
    rawToChar %>%
    fromJSON %$% results %>% data.frame

  return(positions)
}
