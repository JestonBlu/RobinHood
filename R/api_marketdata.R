#' RobinHood API: Market Data
#'
#' Returns a dataframe of quantitative market information for a particular option instrument
#'
#' @param RH object of class RobinHood
#' @param instrument (string) a single instrument_id or multiple instrument_urls
#' @param type (string) one of instrument_id or instrument_url
#' @import httr magrittr
#' @export
api_marketdata <- function(RH, instrument, type = "instrument_id") {

  if (type == "instrument_id") {
    url <- paste(api_endpoints("marketdata_options"), instrument, "/", sep = "")
  } else {
    url <- paste(api_endpoints("marketdata_options"), "?instruments=", instrument, sep = "")
  }

  # Token
  token <- paste("Bearer", RH$tokens.access_token)

  # GET call
  dta <- GET(url,
             add_headers("Accept" = "application/json",
                         "Content-Type" = "application/json",
                         "Authorization" = token))
  httr::stop_for_status(df)
  
  # Format return
  dta <- mod_json(dta, "fromJSON")


  if (type == "instrument_id") {
    dta[sapply(dta, FUN = is.null)] <- NA
    dta <- as.data.frame(dta)
  } else {
    dta <- as.data.frame(dta$results)
  }

  # Reformat columns
  dta <- dta %>%
     dplyr::mutate_at(c("adjusted_mark_price", "adjusted_mark_price_round_down", 
                        "ask_price", "bid_price", "break_even_price", 
                        "high_price", "last_trade_price", "low_price", 
                        "mark_price", "previous_close_price", 
                        "high_fill_rate_buy_price", "high_fill_rate_sell_price",
                        "low_fill_rate_buy_price", "low_fill_rate_sell_price",
                        "chance_of_profit_long", "chance_of_profit_short",
                        "delta", "gamma", "implied_volatility", "rho", "theta",
                        "vega"),
                      function(x) as.numeric(as.character(x))) %>%
    dplyr::mutate_at(c("previous_close_date"), lubridate::ymd) %>%
    dplyr::mutate_at(c("updated_at"), lubridate::ymd_hms)
                      

  return(dta)

}
