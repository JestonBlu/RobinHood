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

  # Reformat margin balances
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

  # Reformat instant eligibility
  accounts$instant_eligibility <- accounts$instant_eligibility %>%
    dplyr::mutate_at(c(additional_deposit_needed), as.numeric) %>%
    dplyr::mutate_at(c(reinstatement_date, created_at, updated_at), lubridate::ymd_hms)

  # Reformat remaining list items
  accounts$sma <- as.numeric(accounts$sma)
  accounts$buying_power <- as.numeric(accounts$buying_power)
  accounts$max_ach_early_access_amount <- as.numeric(accounts$max_ach_early_access_amount)
  accounts$cash_held_for_orders <- as.numeric(accounts$cash_held_for_orders)
  accounts$cash <- as.numeric(accounts$cash)
  accounts$sma_held_for_orders <- as.numeric(accounts$sma_held_for_orders)
  accounts$unsettled_debit <- as.numeric(accounts$unsettled_debit)
  accounts$uncleared_deposits <- as.numeric(accounts$uncleared_deposits)
  accounts$unsettled_funds <- as.numeric(accounts$unsettled_funds)
  accounts$crypto_buying_power <- as.numeric(accounts$crypto_buying_power)
  accounts$cash_available_for_withdrawal <- as.numeric(accounts$cash_available_for_withdrawal)
  accounts$portfolio_cash <- as.numeric(accounts$portfolio_cash)
  accounts$updated_at <- lubridate::ymd_hms(accounts$updated_at)
  accounts$created_at <- lubridate::ymd_hms(accounts$created_at)
  
  return(accounts)
}
