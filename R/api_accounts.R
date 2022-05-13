#' RobinHood API: User
#'
#' Backend function called by get_user(),'returns a list of user account data.
#'
#' @param RH object of class RobinHood
#' @import httr magrittr
#' @export
api_accounts <- function(RH) {

  # URL and token
  url <- RobinHood::api_endpoints("accounts")
  token <- paste("Bearer", RH$api_response.access_token)

  # GET call
  dta <- GET(url,
             add_headers("Accept" = "application/json",
                         "Content-Type" = "application/json",
                         "Authorization" = token))
  httr::stop_for_status(dta)

  # Format return
  dta <- RobinHood::mod_json(dta, "fromJSON")
  dta <- as.list(dta$results)

  # Reformat margin balances
  if (length(dta$margin_balances) > 1) {
    dta$margin_balances <- dta$margin_balances %>%
      dplyr::mutate_at(
        c("gold_equity_requirement", "outstanding_interest", "cash_held_for_options_collateral",
          "uncleared_nummus_deposits", "overnight_ratio", "day_trade_buying_power",
          "portfolio_cash", "funding_hold_balance", "cash_available_for_withdrawal",
          "unallocated_margin_cash", "sma", "cash_held_for_nummus_restrictions",
          "start_of_day_dtbp", "day_trade_ratio", "overnight_buying_power_held_for_orders",
          "cash_held_for_orders", "unsettled_debit", "cash_held_for_dividends",
          "cash", "margin_limit", "start_of_day_overnight_buying_power",
          "overnight_buying_power", "uncleared_deposits", "day_trade_buying_power_held_for_orders",
          "unsettled_funds", "pending_deposit", "cash_available_for_withdrawal",
          "cash_held_for_restrictions", "crypto_buying_power", "cash_pending_from_options_events",
          "settled_amount_borrowed"), as.numeric) %>%
      dplyr::mutate_at(c("updated_at", "created_at"), lubridate::ymd_hms) %>%
      dplyr::mutate_at(c("marked_pattern_day_trader_date"), lubridate::ymd)
  }

  # Reformat instant eligibility
  dta$instant_eligibility <- dta$instant_eligibility %>%
    dplyr::mutate_at(c("additional_deposit_needed"), as.numeric) %>%
    dplyr::mutate_at(c("reinstatement_date", "created_at", "updated_at"), lubridate::ymd_hms)

  # Reformat remaining list items
  dta$sma <- as.numeric(dta$sma)
  dta$buying_power <- as.numeric(dta$buying_power)
  dta$max_ach_early_access_amount <- as.numeric(dta$max_ach_early_access_amount)
  dta$cash_held_for_orders <- as.numeric(dta$cash_held_for_orders)
  dta$cash <- as.numeric(dta$cash)
  dta$sma_held_for_orders <- as.numeric(dta$sma_held_for_orders)
  dta$unsettled_debit <- as.numeric(dta$unsettled_debit)
  dta$uncleared_deposits <- as.numeric(dta$uncleared_deposits)
  dta$unsettled_funds <- as.numeric(dta$unsettled_funds)
  dta$crypto_buying_power <- as.numeric(dta$crypto_buying_power)
  dta$cash_available_for_withdrawal <- as.numeric(dta$cash_available_for_withdrawal)
  dta$portfolio_cash <- as.numeric(dta$portfolio_cash)
  dta$updated_at <- lubridate::ymd_hms(dta$updated_at)
  dta$created_at <- lubridate::ymd_hms(dta$created_at)

  return(dta)
}
