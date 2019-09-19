#' RobinHood API: Orders Crypto
#'
#' Backend function called by place_order(), get_order_status(), cancel_order(). Issues a buy/sell order or
#' returns the status of an order. When issuing a buy order use the url column in the return data to check the
#' status or cancel the order.
#'
#' @param RH object of class RobinHood
#' @param action (string) one of "order", "status", "cancel", or "history"
#' @param order_id (string) action is "status" or "cancel", only order_id is required
#' @param cancel_url (string) url for posting a cancel order
#' @param currency_pair_id (string) currency pair id
#' @param type (string) "market" or "limit"
#' @param time_in_force (string) Good For Day ("gfd"), Good Till Canceled ("gtc"), Immediate or Cancel ("ioc"), or Opening ("opg")
#' @param price (number) the price you are willing to sell or buy at
#' @param quantity (int) number of shares you wish to transact
#' @param side (string) "buy" or "sell"
#' @import curl magrittr
#' @export
api_orders_crypto <- function(RH, action, order_id = NULL, cancel_url = NULL, currency_pair_id = NULL, type = NULL,
                              time_in_force = NULL, price = NULL, quantity = NULL, side = NULL) {

  if (action == "order") {

    ref_id <- uuid::UUIDgenerate()
    account_id <- api_accounts_crypto(RH)$id

    detail <- data.frame(account_id = account_id,
                         currency_pair_id = currency_pair_id,
                         price = price,
                         quantity = quantity,
                         ref_id = ref_id,
                         side = side,
                         time_in_force = time_in_force,
                         type = type)

    orders <- httr::POST(url = api_endpoints("orders", "crypto"),
                         httr::add_headers("Accept" = "application/json",
                                           "Content-Type" = "application/json",
                                           "Authorization" = paste("Bearer", RH$tokens.access_token)),
                         body = mod_json(detail, type = "toJSON"))

    orders <- mod_json(orders, type = "fromJSON")

    orders$cumulative_quantity <- as.numeric(orders$cumulative_quantity)
    orders$price <- as.numeric(orders$price)
    orders$quantity <- as.numeric(orders$quantity)
    orders$rounded_executed_notional<- as.numeric(orders$rounded_executed_notional)
    orders$created_at <- lubridate::ymd_hms(orders$created_at)
    orders$updated_at <- lubridate::ymd_hms(orders$updated_at)

    return(orders)
  }

  if (action == "status") {
    order_status <- new_handle() %>%
      handle_setheaders("Accept" = "application/json") %>%
      handle_setheaders("Authorization" = paste("Bearer", RH$tokens.access_token)) %>%
      curl_fetch_memory(url = paste(api_endpoints("orders", source = "crypto"), order_id, sep = ""))

    order_status <- jsonlite::fromJSON(rawToChar(order_status$content))

    order_status$cumulative_quantity <- as.numeric(order_status$cumulative_quantity)
    order_status$price <- as.numeric(order_status$price)
    order_status$quantity <- as.numeric(order_status$quantity)
    order_status$rounded_executed_notional<- as.numeric(order_status$rounded_executed_notional)
    order_status$created_at <- lubridate::ymd_hms(order_status$created_at)
    order_status$updated_at <- lubridate::ymd_hms(order_status$updated_at)
    order_status$updated_at <- lubridate::ymd_hms(order_status$last_transaction_at)

    return(order_status)
  }

  if (action == "cancel") {
    order_cancel <- new_handle() %>%
      handle_setheaders("Accept" = "application/json") %>%
      handle_setheaders("Authorization" = paste("Bearer", RH$tokens.access_token)) %>%
      handle_setopt(copypostfields = "") %>%
      curl_fetch_memory(url = cancel_url)

    order_cancel <- jsonlite::fromJSON(rawToChar(order_cancel$content))

    return(order_cancel)
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

      if (nrow(x) == 0) {
        x = data.frame(effective_price = NA, id = NA, quantity = NA, timestamp = NA)
      }

      executions = rbind(executions, x)
    }

    # Rename Columns
    colnames(executions) = c("exec_effective_price", "exec_id", "exec_quantity", "exec_timestamp")

    # Combine executions with the rest of order history
    order_history = cbind(order_history, executions)

    # Reformat columns
    order_history = order_history %>%
      dplyr::mutate_at(c("created_at", "last_transaction_at", "updated_at", "exec_timestamp"), lubridate::ymd_hms) %>%
      dplyr::mutate_at(c("cumulative_quantity", "price", "quantity", "rounded_executed_notional", "exec_effective_price",
                  "exec_quantity"), as.numeric)

    # Remove
    order_history = order_history[, !names(order_history) %in% "executions"]


  }

}
