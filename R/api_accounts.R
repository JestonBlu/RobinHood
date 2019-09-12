#' RobinHood API: User
#'
#' Backend function called by get_user(),'returns a list of user account data.
#'
#' @param RH object of class RobinHood
#' @import curl magrittr
#' @export
api_accounts <- function(RH) {

  accounts <- new_handle() %>%
    handle_setheaders("Accept" = "application/json") %>%
    handle_setheaders("Authorization" = paste("Bearer", RH$tokens.access_token)) %>%
    curl_fetch_memory(url = api_endpoints("accounts"))

  accounts <- jsonlite::fromJSON(rawToChar(accounts$content))
  accounts <- as.list(accounts$results)

  # Reformat columns as numeric
  accounts$margin_balances <- accounts$margin_balances %>%
    dplyr::mutate_at(c("gold_equity_requirement", "outstanding_interest", "cash_held_for_options_collateral",
                       "uncleared_nummus_deposits", "overnight_ratio", "day_trade_buying_power",
                       "cash_available_for_withdrawal", "sma", "cash_held_for_nummus_restrictions",
                       "unallocated_margin_cash", "start_of_day_dtbp", "overnight_buying_power_held_for_orders",
                       "day_trade_ratio", "cash_held_for_orders", "unsettled_debit", "cash_held_for_dividends", "cash",
                       "start_of_day_overnight_buying_power", "margin_limit", "overnight_buying_power", "uncleared_deposits",
                       "unsettled_funds", "day_trade_buying_power_held_for_orders", "cash_available_for_withdrawal",
                       "pending_deposit", "cash_held_for_restrictions", "crypto_buying_power",
                       "cash_pending_from_options_events", "settled_amount_borrowed"),
                      as.numeric) %>%
    dplyr::mutate_at(c("updated_at", "marked_pattern_day_trader_date", "created_at"), lubridate::ymd_hms)

  return(accounts)
}
