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
#' @import httr magrittr
#' @export
api_orders_crypto <- function(RH, action, order_id = NULL, cancel_url = NULL, currency_pair_id = NULL, type = NULL,
                              time_in_force = NULL, price = NULL, quantity = NULL, side = NULL) {

  if (action == "order") {

    ref_id <- uuid::UUIDgenerate()
    account_id <- RobinHood::api_accounts_crypto(RH)$id

    detail <- data.frame(account_id = account_id,
                         currency_pair_id = currency_pair_id,
                         price = price,
                         quantity = quantity,
                         ref_id = ref_id,
                         side = side,
                         time_in_force = time_in_force,
                         type = type)

    dta <- POST(url = api_endpoints("orders", "crypto"),
                add_headers("Accept" = "application/json",
                            "Content-Type" = "application/json",
                            "Authorization" = paste("Bearer", RH$tokens.access_token)),
                body = RobinHood::mod_json(detail, type = "toJSON"))
    httr::stop_for_status(dta)

    dta <- RobinHood::mod_json(dta, type = "fromJSON")

    dta$cumulative_quantity <- as.numeric(dta$cumulative_quantity)
    dta$price <- as.numeric(dta$price)
    dta$quantity <- as.numeric(dta$quantity)
    dta$rounded_executed_notional <- as.numeric(dta$rounded_executed_notional)
    dta$created_at <- lubridate::ymd_hms(dta$created_at)
    dta$updated_at <- lubridate::ymd_hms(dta$updated_at)

    return(dta)
  }

  if (action == "status") {

    # URL and token
    url <- paste(RobinHood::api_endpoints("orders", source = "crypto"), order_id, sep = "")
    token <- paste("Bearer", RH$tokens.access_token)

    # GET call
    dta <- GET(url,
        add_headers("Accept" = "application/json",
                    "Content-Type" = "application/json",
                    "Authorization" = token))
    httr::stop_for_status(dta)

    # format return
    dta <- mod_json(dta, "fromJSON")

    dta$cumulative_quantity <- as.numeric(dta$cumulative_quantity)
    dta$price <- as.numeric(dta$price)
    dta$quantity <- as.numeric(dta$quantity)
    dta$rounded_executed_notional <- as.numeric(dta$rounded_executed_notional)
    dta$created_at <- lubridate::ymd_hms(dta$created_at)
    dta$updated_at <- lubridate::ymd_hms(dta$updated_at)
    dta$last_transaction_at <- lubridate::ymd_hms(dta$last_transaction_at)

    return(dta)
  }

  if (action == "cancel") {

    # URL and token
    url <- cancel_url
    token <- paste("Bearer", RH$tokens.access_token)

    # GET call
    dta <- POST(url,
        add_headers("Accept" = "application/json",
                    "Content-Type" = "application/json",
                    "Authorization" = token))
    httr::stop_for_status(dta)

    # format return
    dta <- mod_json(dta, "fromJSON")

    return(dta)
  }

  # Get Order History
  if (action == "history") {

    # URL and token
    url <- api_endpoints("orders_crypto", source = "crypto")
    token <- paste("Bearer", RH$tokens.access_token)

    # GET call
    dta <- GET(url,
               add_headers("Accept" = "application/json",
                           "Content-Type" = "application/json",
                           "Authorization" = token))
    httr::stop_for_status(dta)

    # format return
    dta <- mod_json(dta, "fromJSON")
    output <- as.data.frame(dta$results)

    # Cycle through the pages
    while (length(dta$`next`) > 0) {

      # URL
      url <- dta$`next`

      # GET call
      dta <- GET(url,
                 add_headers("Accept" = "application/json",
                             "Content-Type" = "application/json",
                             "Authorization" = token))
      httr::stop_for_status(dta)

      # Format return
      dta <- mod_json(dta, "fromJSON")

      output <- rbind(output, dta$results)

      profvis::pause(.25)
    }

    # Reformat columns
    dta <- output %>%
      dplyr::mutate_at(c("created_at", "last_transaction_at", "updated_at"), lubridate::ymd_hms) %>%
      dplyr::mutate_at(c("cumulative_quantity", "price", "quantity", "rounded_executed_notional"), as.numeric)

    # Remove
    dta <- dta[, !names(dta) %in% "executions"]


    return(dta)

  }
}
