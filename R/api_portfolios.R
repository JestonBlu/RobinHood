#' RobinHood API: Portfolio
#'
#' Backend function called by get_portfolio(). Returns a data frame of account summaries.
#'
#' @param RH object of class RobinHood
#' @param portfolio_url portfolio url
#' @import httr magrittr
#' @export
api_portfolios <- function(RH, portfolio_url) {

  url <- portfolio_url
  token <- paste("Bearer", RH$tokens.access_token)

  if (url == api_endpoints("portfolios")) {

    # GET call
    dta <- GET(url,
               add_headers("Accept" = "application/json",
                           "Content-Type" = "application/json",
                           "Authorization" = token))

    # format return
    dta <- mod_json(dta, "fromJSON")
    dta <- as.data.frame(dta$results)

    dta <- dta %>%
      dplyr::mutate_at(c("unwithdrawable_grants", "excess_maintenance_with_uncleared_deposits",
                         "excess_maintenance", "market_value", "withdrawable_amount",
                         "last_core_market_value", "unwithdrawable_deposits", "extended_hours_equity",
                         "excess_margin", "excess_margin_with_uncleared_deposits", "equity",
                         "last_core_equity", "adjusted_equity_previous_close", "equity_previous_close",
                         "extended_hours_market_value"), as.numeric) %>%
      dplyr::mutate_at("start_date", lubridate::ymd)

  } else {

    # GET call
    dta <- GET(url,
               add_headers("Accept" = "application/json",
                           "Content-Type" = "application/json",
                           "Authorization" = token))

    # format return
    dta <- mod_json(dta, "fromJSON")
    dta <- as.data.frame(dta$equity_historicals)

    dta <- dta %>%
      dplyr::mutate_at(c("adjusted_open_equity", "adjusted_close_equity", "open_equity", "close_equity",
                         "open_market_value", "close_market_value", "net_return"), as.numeric) %>%
      dplyr::mutate_at("begins_at", lubridate::ymd_hms)

    }

  return(dta)
}
