#' RobinHood API: User
#'
#' Backend function called by get_user(), returns a list of user account data.
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

  # Reformat output columns
  accounts$updated_at <-  lubridate::ymd_hms(accounts$updated_at)
  accounts$margin_balances$updated_at <-  lubridate::ymd_hms(accounts$margin_balances$updated_at)
  accounts$margin_balances$gold_equity_requirement <- as.numeric(accounts$margin_balances$gold_equity_requirement)
  accounts$margin_balances$outstanding_interest <- as.numeric(accounts$margin_balances$outstanding_interest)
  accounts$margin_balances$cash_held_for_options_collateral <- as.numeric(accounts$margin_balances$cash_held_for_options_collateral)
  accounts$margin_balances$uncleared_nummus_deposits <- as.numeric(accounts$margin_balances$uncleared_nummus_deposits)
  accounts$margin_balances$overnight_ratio <- as.numeric(accounts$margin_balances$overnight_ratio)
  accounts$margin_balances$day_trade_buying_power <- as.numeric(accounts$margin_balances$day_trade_buying_power)
  accounts$margin_balances$cash_available_for_withdrawal <- as.numeric(accounts$margin_balances$cash_available_for_withdrawal)
  accounts$margin_balances$sma <- as.numeric(accounts$margin_balances$sma)
  accounts$margin_balances$cash_held_for_nummus_restrictions <- as.numeric(accounts$margin_balances$cash_held_for_nummus_restrictions)
  accounts$margin_balances$marked_pattern_day_trader_date <-  lubridate::ymd_hms(accounts$margin_balances$marked_pattern_day_trader_date)
  accounts$margin_balances$unallocated_margin_cash <- as.numeric(accounts$margin_balances$unallocated_margin_cash)
  accounts$margin_balances$start_of_day_dtbp <- as.numeric(accounts$margin_balances$start_of_day_dtbp)
  accounts$margin_balances$overnight_buying_power_held_for_orders <- as.numeric(accounts$margin_balances$overnight_buying_power_held_for_orders)
  accounts$margin_balances$day_trade_ratio <- as.numeric(accounts$margin_balances$day_trade_ratio)
  accounts$margin_balances$cash_held_for_orders <- as.numeric(accounts$margin_balances$cash_held_for_orders)
  accounts$margin_balances$unsettled_debit <- as.numeric(accounts$margin_balances$unsettled_debit)
  accounts$margin_balances$created_at <-  lubridate::ymd_hms(accounts$margin_balances$created_at)
  accounts$margin_balances$cash_held_for_dividends <- as.numeric(accounts$margin_balances$cash_held_for_dividends)
  accounts$margin_balances$cash <- as.numeric(accounts$margin_balances$cash)
  accounts$margin_balances$start_of_day_overnight_buying_power <- as.numeric(accounts$margin_balances$start_of_day_overnight_buying_power)
  accounts$margin_balances$margin_limit <- as.numeric(accounts$margin_balances$margin_limit)
  accounts$margin_balances$overnight_buying_power <- as.numeric(accounts$margin_balances$overnight_buying_power)
  accounts$margin_balances$uncleared_deposits <- as.numeric(accounts$margin_balances$uncleared_deposits)
  accounts$margin_balances$unsettled_funds <- as.numeric(accounts$margin_balances$unsettled_funds)
  accounts$margin_balances$day_trade_buying_power_held_for_orders <- as.numeric(accounts$margin_balances$day_trade_buying_power_held_for_orders)
  accounts$cash_available_for_withdrawal <- as.numeric(accounts$cash_available_for_withdrawal)
  accounts$sma <- as.numeric(accounts$sma)
  accounts$buying_power <- as.numeric(accounts$buying_power)
  accounts$max_ach_early_access_amount <- as.numeric(accounts$max_ach_early_access_amount)
  accounts$cash_held_for_orders <- as.numeric(accounts$cash_held_for_orders)
  accounts$created_at <-  lubridate::ymd_hms(accounts$created_at)
  accounts$cash <- as.numeric(accounts$cash)
  accounts$sma_held_for_orders <- as.numeric(accounts$sma_held_for_orders)
  accounts$unsettled_debit <- as.numeric(accounts$unsettled_debit)
  accounts$uncleared_deposits <- as.numeric(accounts$uncleared_deposits)
  accounts$unsettled_funds <- as.numeric(accounts$unsettled_funds)

  return(accounts)
}
