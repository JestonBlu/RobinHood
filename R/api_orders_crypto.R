#' RobinHood API: Orders Crypto
#'
#' Backend function called by place_order(), get_order_status(), cancel_order(). Issues a buy/sell order or
#' returns the status of an order. When issuing a buy order use the url column in the return data to check the
#' status or cancel the order.
#'
#' @param RH object of class RobinHood
#' @param action (string) one of "order", "status", "cancel", or "history"
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
#' @import curl magrittr
#' @export
api_orders_crypto <- function(RH, action, order_url = NULL, instrument_id = NULL, symbol = NULL, type = NULL,
                       time_in_force = NULL, trigger = NULL, price = NULL, stop_price = NULL, quantity = NULL,
                       side = NULL) {

  if (action == "order") {
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



[{"key":"type","value":"market","description":"","type":"text","enabled":true},
{"key":"side","value":"buy","description":"","type":"text","enabled":true},
{"key":"quantity","value":"400","description":"","type":"text","enabled":true},
{"key":"account_id","value":"5f45e61b-9afa-4e75-a00d-76593342f13f","description":"","type":"text","enabled":true},
{"key":"currency_pair_id","value":"1ef78e1b-049b-4f12-90e5-555dcf2fe204","description":"","type":"text","enabled":true},
{"key":"price","value":".003","description":"","type":"text","enabled":true},
{"key":"time_in_force","value":"gfd","description":"","type":"text","enabled":true},
{"key":"ref_id","value":"aaaa","description":"","type":"text","enabled":true}]

    orders <- new_handle() %>%
      handle_setheaders("Accept" = "application/json") %>%
      handle_setheaders("Authorization" = paste("Bearer", RH$tokens.access_token)) %>%
      handle_setopt(copypostfields = detail) %>%
      curl_fetch_memory(url = api_endpoints("orders", source = "crypto"))

    orders <- jsonlite::fromJSON(rawToChar(orders$content))

    orders$updated_at <-  lubridate::ymd_hms(orders$updated_at)
    orders$last_transaction_at <-  lubridate::ymd_hms(orders$last_transaction_at)
    orders$created_at <-  lubridate::ymd_hms(orders$created_at)
    orders$fees <- as.numeric(orders$fees)
    orders$cumulative_quantity <- as.numeric(orders$cumulative_quantity)
    orders$stop_price <- as.numeric(orders$stop_price)
    orders$reject_reason <- as.numeric(orders$reject_reason)
    orders$price <- as.numeric(orders$price)
    orders$average_price <- as.numeric(orders$average_price)
    orders$quantity <- as.numeric(orders$quantity)

    return(orders)

  }

  if (action == "status") {
    order_status <- new_handle() %>%
      handle_setheaders("Accept" = "application/json") %>%
      handle_setheaders("Authorization" = paste("Bearer", RH$tokens.access_token)) %>%
      curl_fetch_memory(url = order_url)

    order_status <- jsonlite::fromJSON(rawToChar(order_status$content))

    return(order_status)
  }

  if (action == "cancel") {
    order_status <- new_handle() %>%
      handle_setheaders("Accept" = "application/json") %>%
      handle_setheaders("Authorization" = paste("Bearer", RH$tokens.access_token)) %>%
      handle_setopt(copypostfields = "") %>%
      curl_fetch_memory(url = order_url)

    order_status <- jsonlite::fromJSON(rawToChar(order_status$content))

    return(order_status)
  }

  # Get Order History
  if (action == "history") {
    order_history <- new_handle() %>%
      handle_setheaders("Accept" = "application/json") %>%
      handle_setheaders("Authorization" = paste("Bearer", RH$tokens.access_token)) %>%
      curl_fetch_memory(url = api_endpoints("orders_crypto", source = "crypto"))

    order_history <- jsonlite::fromJSON(rawToChar(order_history$content))
    order_history <- order_history$results


    # Extract executions and combine with main extraction
    executions = data.frame()

    # Loop through executions
    for (i in 1:length(order_history$executions)) {
      x = data.frame(order_history$executions[i])
      executions = rbind(executions, x)
    }

    # Rename Columns
    colnames(executions) = c("exec_effective_price", "exec_id", "exec_quantity", "exec_timestamp")

    # Combine executions with the rest of order history
    order_history = cbind(order_history, executions)

    # Reformat columns
    order_history = order_history %>%
      mutate_at(c("created_at", "last_transaction_at", "updated_at", "exec_timestamp"), lubridate::ymd_hms) %>%
      mutate_at(c("cumulative_quantity", "price", "quantity", "rounded_executed_notional", "exec_effective_price",
                  "exec_quantity"), as.numeric)

    # Remove
    order_history = order_history[, !names(order_history) %in% "executions"]


  }

}
