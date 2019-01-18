#' RobinHood API Cancel Order
#'
#' Send a cancel signal to robinhood
#'
#' @param RH object of class RobinHood
#' @param order_url url of order returned from place_order
#' @import curl jsonlite magrittr
api_order_cancel <- function(RH, order_url) {

  # Adjust order url to cancel
  order_url = paste(order_url, "cancel/", sep = "")

  # Get Order Status
  order_status <- new_handle() %>%
    handle_setheaders("Accept" = "application/json") %>%
    handle_setheaders("Authorization" = paste("Bearer", RH$tokens.access_token)) %>%
    handle_setopt(copypostfields = "") %>%
    curl_fetch_memory(url = order_url) %$% content %>%
    rawToChar %>%
    fromJSON

  return(order_status)
}
