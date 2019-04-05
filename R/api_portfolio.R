#' RobinHood API: Portfolio
#'
#' Backend function called by get_portfolio(). Returns a data frame of account summaries.
#'
#' @param RH object of class RobinHood
#' @param portfolio_url portfolio url
#' @export
#' @import curl jsonlite magrittr lubridate
api_portfolios <- function(RH, portfolio_url) {

  if (portfolio_url == api_endpoints("portfolios")) {

    portfolios <- new_handle() %>%
      handle_setheaders("Accept" = "application/json") %>%
      handle_setheaders("Authorization" = paste("Bearer", RH$tokens.access_token)) %>%
      curl_fetch_memory(url = portfolio_url)

    portfolios <- fromJSON(rawToChar(portfolios$content))
    portfolios <- data.frame(portfolios$results)

    portfolios$unwithdrawable_grants <- as.numeric(portfolios$unwithdrawable_grants)
    portfolios$excess_maintenance_with_uncleared_deposits <- as.numeric(portfolios$excess_maintenance_with_uncleared_deposits)
    portfolios$excess_maintenance <- as.numeric(portfolios$excess_maintenance)
    portfolios$market_value <- as.numeric(portfolios$market_value)
    portfolios$withdrawable_amount <- as.numeric(portfolios$withdrawable_amount)
    portfolios$last_core_market_value <- as.numeric(portfolios$last_core_market_value)
    portfolios$unwithdrawable_deposits <- as.numeric(portfolios$unwithdrawable_deposits)
    portfolios$extended_hours_equity <- as.numeric(portfolios$extended_hours_equity)
    portfolios$excess_margin <- as.numeric(portfolios$excess_margin)
    portfolios$excess_margin_with_uncleared_deposits <- as.numeric(portfolios$excess_margin_with_uncleared_deposits)
    portfolios$equity <- as.numeric(portfolios$equity)
    portfolios$last_core_equity <- as.numeric(portfolios$last_core_equity)
    portfolios$adjusted_equity_previous_close <- as.numeric(portfolios$adjusted_equity_previous_close)
    portfolios$equity_previous_close <- as.numeric(portfolios$equity_previous_close)
    portfolios$extended_hours_market_value <- as.numeric(portfolios$extended_hours_market_value)
    portfolios$start_date <- lubridate::ymd(portfolios$start_date)

  } else {
    portfolios <- new_handle() %>%
      handle_setheaders("Accept" = "application/json") %>%
      handle_setheaders("Authorization" = paste("Bearer", RH$tokens.access_token)) %>%
      curl_fetch_memory(url = portfolio_url)

    portfolios <- fromJSON(rawToChar(portfolios$content))
    portfolios <- data.frame(portfolios$equity_historicals)

    portfolios$begins_at <- lubridate::ymd_hms(portfolios$begins_at)
    portfolios$adjusted_open_equity <- as.numeric(portfolios$adjusted_open_equity)
    portfolios$adjusted_close_equity <- as.numeric(portfolios$adjusted_close_equity)
    portfolios$open_equity <- as.numeric(portfolios$open_equity)
    portfolios$close_equity <- as.numeric(portfolios$close_equity)
    portfolios$open_market_value <- as.numeric(portfolios$open_market_value)
    portfolios$close_market_value <- as.numeric(portfolios$close_market_value)
    portfolios$net_return <- as.numeric(portfolios$net_return)
  }

  return(portfolios)
}
