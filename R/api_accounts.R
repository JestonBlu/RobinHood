#' RobinHood API: User
#'
#' Backend function called by get_user(), returns a list of user account data.
#'
#'
#' @param RH object of class RobinHood
#' @import curl jsonlite magrittr
#' @examples
#' # data returned by api call
#' # $ rhs_account_number
#' # $ deactivated
#' # $ updated_at
#' # $ margin_balances
#' #  ..$ updated_at
#' #  ..$ gold_equity_requirement
#' #  ..$ outstanding_interest
#' #  ..$ cash_held_for_options_collateral
#' #  ..$ uncleared_nummus_deposits
#' #  ..$ overnight_ratio
#' #  ..$ day_trade_buying_power
#' #  ..$ cash_available_for_withdrawal
#' #  ..$ sma
#' #  ..$ cash_held_for_nummus_restrictions
#' #  ..$ marked_pattern_day_trader_date
#' #  ..$ unallocated_margin_cash
#' #  ..$ start_of_day_dtbp
#' #  ..$ overnight_buying_power_held_for_orders
#' #  ..$ day_trade_ratio
#' #  ..$ cash_held_for_orders
#' #  ..$ unsettled_debit
#' #  ..$ created_at
#' #  ..$ cash_held_for_dividends
#' #  ..$ cash
#' #  ..$ start_of_day_overnight_buying_power
#' #  ..$ margin_limit
#' #  ..$ overnight_buying_power
#' #  ..$ uncleared_deposits
#' #  ..$ unsettled_funds
#' #  ..$ day_trade_buying_power_held_for_orders
#' # $ portfolio
#' # $ cash_balances
#' # $ can_downgrade_to_cash
#' # $ withdrawal_halted
#' # $ cash_available_for_withdrawal
#' # $ state
#' # $ type
#' # $ sma
#' # $ sweep_enabled
#' # $ deposit_halted
#' # $ buying_power
#' # $ user
#' # $ max_ach_early_access_amount
#' # $ option_level
#' # $ instant_eligibility
#' #  ..$ updated_at
#' #  ..$ reason
#' #  ..$ reinstatement_date
#' #  ..$ reversal
#' #  ..$ state
#' # $ cash_held_for_orders
#' # $ only_position_closing_trades
#' # $ url
#' # $ positions
#' # $ created_at
#' # $ cash
#' # $ sma_held_for_orders
#' # $ unsettled_debit
#' # $ account_number
#' # $ is_pinnacle_account
#' # $ uncleared_deposits
#' # $ unsettled_funds
api_accounts <- function(RH) {

  accounts <- new_handle() %>%
    handle_setheaders("Accept" = "application/json") %>%
    handle_setheaders("Authorization" = paste("Bearer", RH$tokens.access_token)) %>%
    curl_fetch_memory(url = api_endpoints("accounts")) %$% content %>%
    rawToChar %>%
    fromJSON

  return(accounts)
}
