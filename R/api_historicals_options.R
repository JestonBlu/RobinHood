#' RobinHood API: Historicals Options
#'
#' Backend function called by get_historicals_options().
#'
#' @param RH object of class RobinHood
#' @param chain_symbol (string) stock symbol
#' @param type (string) one of ("put", "call")
#' @param strike_price (numeric) strike price
#' @param expiration_date (string) expiration date (YYYY-MM-DD)
#' @param interval (string) one of ("5minute", "10minute", "hour", "day", "week")
#' @param span (string) one of ("day", "week", "month")
#' @import httr magrittr
#' @export
api_historicals_options <- function(RH, chain_symbol, type, strike_price, expiration_date,
                                    interval = NULL, span = NULL) {

  # Call to get the option instrument id
  dta <- api_instruments_options(RH, method = "symbol",
                                 chain_symbol = chain_symbol,
                                 type = type,
                                 strike_price = strike_price,
                                 expiration_date = expiration_date)

  # url and token
  url <- paste0(api_endpoints("historicals_options"), dta$id,
                              "/?interval=", interval,
                              "&span=", span)
  token <- paste("Bearer", RH$tokens.access_token)

  # GET call
  dta <- GET(url,
             add_headers("Accept" = "application/json",
                         "Content-Type" = "application/json",
                         "Authorization" = token))
  httr::stop_for_status(df)
  
  # Format return
  dta <- mod_json(dta, "fromJSON")

  dta <- dta$data_points

  dta <- dta %>%
    dplyr::mutate_at("begins_at", lubridate::ymd_hms) %>%
    dplyr::mutate_at(c("open_price", "close_price", "high_price", "low_price", "volume"), as.numeric)

  return(dta)
  }
