#' RobinHood API Order Status
#'
#' Returns the status of an order
#'
#' @param RH object of class RobinHood
#' @param order_url url of order returned from place_order
#' @import curl jsonlite magrittr
api_order_status <- function(RH, order_url) {

  # Get Order Status
  order_status <- new_handle() %>%
    handle_setheaders("Accept" = "application/json") %>%
    handle_setheaders("Authorization" = paste("Bearer", RH$tokens.access_token)) %>%
    curl_fetch_memory(url = order_url) %$% content %>%
    rawToChar %>%
    fromJSON

  return(order_status)
}
