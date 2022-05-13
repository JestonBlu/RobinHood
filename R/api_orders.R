#' RobinHood API: Orders
#'
#' Backend function called by place_order(), get_order_status(), cancel_order(). Issues a buy/sell order or
#' returns the status of an order. When issuing a buy order use the url column in the return data to check the
#' status or cancel the order.
#'
#' @param RH object of class RobinHood
#' @param action (string) one of "order", "status", "cancel", or "history"
#' @param status_url (string) if action = "status", status_url is required (output from place_order())
#' @param cancel_url (string) if action = "cancel", cancel_url is required (output from place_order())
#' @param instrument_id (string) URL of the instrument_id
#' @param symbol (string) Ticket symbol you are attempting to buy or sell
#' @param type (string) "market" or "limit"
#' @param time_in_force (string) Good For Day ("gfd"), Good Till Canceled ("gtc"), Immediate or Cancel ("ioc"), or Opening ("opg")
#' @param trigger (string) "immediate" or "stop"
#' @param price (number) the price you are willing to sell or buy at
#' @param stop_price (number) if trigger = stop, enter stop price, otherwise leave blank
#' @param quantity (int) number of shares you wish to transact
#' @param side (string) "buy" or "sell"
#' @param page_size (int) for get_order_history, refers to the number of historical records to return
#' @import httr magrittr
#' @export
api_orders <- function(RH, action, status_url = NULL, cancel_url = NULL, instrument_id = NULL, symbol = NULL, type = NULL,
                       time_in_force = NULL, trigger = NULL, price = NULL, stop_price = NULL, quantity = NULL,
                       side = NULL, page_size = NULL) {


  if (action == "order") {

    url <- RobinHood::api_endpoints("orders")
    token <- paste("Bearer", RH$api_response.access_token)

    detail <- data.frame(account = RH$url.account_id,
                         instrument = instrument_id,
                         symbol = symbol,
                         type = type,
                         time_in_force = time_in_force,
                         trigger = trigger,
                         price = price,
                         stop_price = stop_price,
                         quantity = quantity,
                         side = side,
                         client_id = RH$api_client_id)

    # If trigger = "stop" then stop_price must be included, otherwise it must be excluded
    if (trigger == "immediate") {
      detail <- detail[, c("account", "instrument", "symbol", "type", "time_in_force",
                          "trigger", "price", "quantity", "side", "client_id")]
    }

    dta <- POST(url = url,
                add_headers("Accept" = "application/json",
                            "Content-Type" = "application/json",
                            "Authorization" = token),
                body = mod_json(detail, type = "toJSON"))
    httr::stop_for_status(dta)

    dta <- RobinHood::mod_json(dta, "fromJSON")
    dta <- as.list(dta)

    # Rename URLs
    names(dta)[names(dta) %in% c("url", "cancel")] <- c("status_url", "cancel_url")

    dta$updated_at <-  lubridate::ymd_hms(dta$updated_at)
    dta$last_transaction_at <-  lubridate::ymd_hms(dta$last_transaction_at)
    dta$created_at <-  lubridate::ymd_hms(dta$created_at)
    dta$fees <- as.numeric(dta$fees)
    dta$cumulative_quantity <- as.numeric(dta$cumulative_quantity)
    dta$stop_price <- as.numeric(dta$stop_price)
    dta$reject_reason <- as.numeric(dta$reject_reason)
    dta$price <- as.numeric(dta$price)
    dta$average_price <- as.numeric(dta$average_price)
    dta$quantity <- as.numeric(dta$quantity)

    return(dta)

  }


  if (action == "status") {

    # Token
    token <- paste("Bearer", RH$api_response.access_token)

    # GET call
    dta <- GET(status_url,
               add_headers("Accept" = "application/json",
                          "Content-Type" = "application/json",
                          "Authorization" = token))
    httr::stop_for_status(dta)

    # format return
    dta <- RobinHood::mod_json(dta, "fromJSON")
    dta <- as.list(dta)

    # Rename urls
    names(dta)[names(dta) %in% c("url", "cancel")] <- c("status_url", "cancel_url")

  }


  if (action == "cancel") {

    # Token
    token <- paste("Bearer", RH$api_response.access_token)

    # GET call
    dta <- POST(cancel_url,
        add_headers("Accept" = "application/json",
                    "Content-Type" = "application/json",
                    "Authorization" = token))
    httr::stop_for_status(dta)

    # Format return
    dta <- RobinHood::mod_json(dta, "fromJSON")

  }


  if (action == "history") {

    url <- paste(RobinHood::api_endpoints("orders"), "?page_size=", page_size, sep = "")
    token <- paste("Bearer", RH$api_response.access_token)

    # GET call
    dta <- GET(url,
        add_headers("Accept" = "application/json",
                    "Content-Type" = "application/json",
                    "Authorization" = token))
    httr::stop_for_status(dta)

    # format return
    dta <- RobinHood::mod_json(dta, "fromJSON")
    dta <- as.data.frame(dta$results)

  }

  return(dta)


}
