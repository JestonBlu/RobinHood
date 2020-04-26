#' RobinHood API: Fundamentals
#'
#' Returns a dataframe of quantitative market information for a particular option instrument
#'
#' @param RH object of class RobinHood
#' @param instrument_id (string) a single instrument_id
#' @import httr magrittr
#' @export
api_marketdata <- function(RH, instrument_id) {

  url <- paste(api_endpoints("marketdata_options"), instrument_id, "/", sep = "")

  # Token
  token <- paste("Bearer", RH$tokens.access_token)

  # GET call
  dta <- GET(url,
             add_headers("Accept" = "application/json",
                         "Content-Type" = "application/json",
                         "Authorization" = token))

  # Format return
  dta <- mod_json(dta, "fromJSON")
  dta <- as.data.frame(dta)

  # Reformat columns
  dta <- dta %>%
    dplyr::mutate_at(c("adjusted_mark_price", "ask_price", "bid_price", "break_even_price", "high_price", "last_trade_price",
                       "low_price", "mark_price", "high_fill_rate_buy_price", "high_fill_rate_sell_price",
                       "low_fill_rate_buy_price", "low_fill_rate_sell_price", "chance_of_profit_long",
                       "chance_of_profit_short", "delta", "gamma", "implied_volatility", "rho", "theta", "vega"),
                       function(x) as.numeric(as.character(x)))

  return(dta)
}
