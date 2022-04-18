#' RobinHood API: Option Orders
#'
#' @param RH object of class RobinHood
#' @param action (string) one of "order", "status", "cancel", "history"
#' @param status_url (string) if action = "status", status_url is required (output from place_order_options())
#' @param cancel_url (string) if action = "cancel", cancel_url is required (output from place_order_options())
#' @param quantity (int) number of contracts you want to buy
#' @param direction (string) one of "debit" or "credit"
#' @param stop_price (numeric) stop price on a limit order
#' @param type (string) one of "limit" or "market"
#' @param time_in_force (string) Good Till Canceled ("gtc"), Immediate or Cancel ("ioc"), or Opening ("opg")
#' @param side (string) one of "buy" or "sell"
#' @param option_id (string) id column returned by get_contracts()
#' @import httr magrittr
#' @export
api_orders_options <- function(RH, action, status_url = NULL, cancel_url = NULL, quantity = NULL,
                               direction = NULL, stop_price = NULL, type = NULL, time_in_force = NULL,
                               side = NULL, option_id = NULL) {

  # URL and token
  url <- RobinHood::api_endpoints("option_orders")
  token <- paste("Bearer", RH$tokens.access_token)


  if (action == "history") {
    # GET call
    dta <- GET(url,
               add_headers("Accept" = "application/json",
                           "Content-Type" = "application/json",
                           "Authorization" = token))
    httr::stop_for_status(dta)

    # format return
    dta <- RobinHood::mod_json(dta, "fromJSON")
    dta <- as.data.frame(dta$results)

    dta <- dta %>%
      dplyr::select(c("chain_symbol", "direction", "price", "premium", "processed_premium", "quantity", "processed_quantity",
                      "state", "time_in_force", "trigger", "type", "opening_strategy", "closing_strategy", "created_at",
                      "updated_at", "id")) %>%
      dplyr::mutate_at(c("price", "premium", "processed_premium", "quantity", "processed_quantity"), as.numeric) %>%
      dplyr::mutate_at(c("created_at", "updated_at"), lubridate::ymd_hms)

  }


  if (action == "order") {

    # Unique ID required for each order
    ref_id <- uuid::UUIDgenerate()

    # Option URL
    option <- paste(RobinHood::api_endpoints("option_instruments"), option_id, "/", sep = "")

    # Generate body of the put call
    detail <- data.frame(account = RH$url.account_id,
                         check.names = quantity,
                         direction = direction,
                         price = stop_price,
                         quantity = quantity,
                         type = type,
                         time_in_force = time_in_force,
                         trigger = "immediate",
                         ref_id = ref_id,
                         override_day_trade_checks = "false",
                         override_dtbp_checks = "false")

    legs <- data.frame(side = side,
                       option = option,
                       position_effect = "open",
                       ratio_quantity = 1)

    detail <- RobinHood::mod_json(detail, "toJSON")
    detail <- substr(detail, 1, nchar(detail) - 1)

    legs <- RobinHood::mod_json(legs, "toJSON")

    # Structure of the detail required special formatting
    detail <- jsonlite::prettify(paste(detail, ', "legs": [', legs, ']}'))

    # Post call to place order
    dta <- POST(url = url,
                add_headers("Accept" = "application/json",
                            "Content-Type" = "application/json",
                            "Authorization" = token),
                body = detail)
    httr::stop_for_status(dta)

    dta <- RobinHood::mod_json(dta, "fromJSON")
    dta <- as.list(dta)

    # Formatting return
    dta$canceled_quantity <- as.numeric(dta$canceled_quantity)
    dta$pending_quantity <- as.numeric(dta$pending_quantity)
    dta$premium <- as.numeric(dta$premium)
    dta$processed_premium <- as.numeric(dta$processed_premium)
    dta$price <- as.numeric(dta$price)
    dta$processed_quantity <- as.numeric(dta$processed_quantity)
    dta$quantity <- as.numeric(dta$quantity)
    dta$updated_at <- lubridate::ymd_hms(dta$updated_at)
    dta$created_at <- lubridate::ymd_hms(dta$created_at)

    # Create a staus_url to be consistent with other order functions
    dta$status_url <- gsub("cancel/", "", dta$cancel_url)

  }


  if (action == "cancel") {

    # Post call to place order
    dta <- POST(url = cancel_url,
                add_headers("Accept" = "application/json",
                            "Content-Type" = "application/json",
                            "Authorization" = token))
    httr::stop_for_status(dta)

    # Format return
    dta <- RobinHood::mod_json(dta, "fromJSON")

  }


  if (action == "status") {

    # GET call
    dta <- GET(status_url,
               add_headers("Accept" = "application/json",
                           "Content-Type" = "application/json",
                           "Authorization" = token))
    httr::stop_for_status(dta)

    # Format return
    dta <- RobinHood::mod_json(dta, "fromJSON")
    dta <- as.list(dta)

  }


  return(dta)
}
