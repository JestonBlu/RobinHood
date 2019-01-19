#' RobinHood API: Orders
#'
#' Issues a buy or sell order and returns a list of order information
#'
#' @param RH object of class RobinHood
#' @param action (string) one of "order", "status", or "cancel"
#' @param order_url (string) action is "status" or "cancel", only order_url is required
#' @param instrument_id (string) URL of the instrument_id
#' @param symbol (string) Ticket symbol you are attempting to buy or sell
#' @param type (string) "market" or "limit"
#' @param time_in_force (string) Good For Day ("gfd"), Good Till Canceled ("gtc"), Immediate or Cancel ("ioc"), or Opening ("opg")
#' @param trigger (string) "immediate" or "stop"
#' @param price (number) the price you are willing to sell or buy at
#' @param stop_price (number) if trigger = stop, enter stop price, otherwise leave blank
#' @param quantity (int) number of shares you wish to transact
#' @param side (string) "buy" or "sell"
#' @import curl jsonlite magrittr
api_orders <- function(RH, action, order_url = NULL, instrument_id = NULL, symbol = NULL, type = NULL,
                       time_in_force = NULL, trigger = NULL, price = NULL, stop_price = NULL, quantity,
                       side = NULL) {

  if (action == "order") {
    # Place an order to buy or sell
    detail <- paste("account=", RH$url.account_id,
                    "&instrument=", instrument_id,
                    "&symbol=", symbol,
                    "&type=", type,
                    "&time_in_force=", time_in_force,
                    "&trigger=", trigger,
                    "&price=", price,
                    "&stop_price=", stop_price,
                    "&quantity=", quantity,
                    "&side=", side,
                    "&client_id=", RH$api_client_id,
                    sep = "")

    orders <- new_handle() %>%
      handle_setheaders("Accept" = "application/json") %>%
      handle_setheaders("Authorization" = paste("Bearer", RH$tokens.access_token)) %>%
      handle_setopt(copypostfields = detail) %>%
      curl_fetch_memory(url = api_endpoints("orders")) %$% content %>%
      rawToChar %>%
      fromJSON

    return(orders)

  }

  if (action == "status") {
    # Get Order Status
    order_status <- new_handle() %>%
      handle_setheaders("Accept" = "application/json") %>%
      handle_setheaders("Authorization" = paste("Bearer", RH$tokens.access_token)) %>%
      curl_fetch_memory(url = order_url) %$% content %>%
      rawToChar %>%
      fromJSON

    return(order_status)
  }

  if (action == 'cancel') {
    # Adjust order url to cancel
    order_url <- paste(order_url, "cancel/", sep = "")

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

}
