#' Get a option contracts from RobinHood
#'
#' @param RH object class RobinHood
#' @param chain_symbol (string) a single ticket symbol
#' @param type (string) one of call or put
#' @param detail (logical) if TRUE (default) return additional info on greeks, prevous day, high/low fill rate prices
#' @import httr magrittr
#' @export
#' @examples
#' \dontrun{
#' # Login in to your RobinHood account
#' RH <- RobinHood("username", "password")
#'
#' get_contracts(RH, "IR")
#'}
get_contracts <- function(RH, chain_symbol, type, detail = FALSE) {

  # Check if RH is valid
  check_rh(RH)

  # Get last price
  contracts <- api_contracts(RH, chain_symbol, type)

  # Trim output
  contracts <- contracts[, !names(contracts) %in% c("instrument")]

  # Get market data on contracts
  x <- paste(contracts$url, collapse = ",")
  market_data <- api_marketdata(RH, x, type = "insturment_url")

  # Join with contracts
  market_data <- market_data %>%
    dplyr::rename("url" = "instrument")

  contracts <- dplyr::inner_join(contracts, market_data, by = "url")

  # Select columns
  if (detail == TRUE) {

    contracts <- contracts %>%
      dplyr::select(c("expiration_date", "type", "strike_price", "last_trade_price", "last_trade_size",
                      "break_even_price", "chance_of_profit_short", "chance_of_profit_long", "ask_price",
                      "ask_size", "bid_price", "bid_size", "low_price", "high_price", "mark_price",
                      "adjusted_mark_price",  "below_tick", "above_tick", "cutoff_price", "rhs_tradability",
                      "tradability", "created_at", "updated_at", "previous_close_date", "previous_close_price",
                      "volume", "delta", "gamma", "implied_volatility", "rho", "theta", "vega", "high_fill_rate_buy_price",
                      "high_fill_rate_sell_price", "low_fill_rate_buy_price", "low_fill_rate_sell_price"))

    } else {

      contracts <- contracts %>%
        dplyr::select(c("expiration_date", "type", "strike_price", "last_trade_price", "last_trade_size",
                        "break_even_price", "chance_of_profit_short", "chance_of_profit_long", "ask_price",
                        "ask_size", "bid_price", "bid_size", "low_price", "high_price", "mark_price",
                        "adjusted_mark_price", "below_tick", "above_tick", "cutoff_price",
                        "rhs_tradability", "tradability", "created_at", "updated_at"))

      }

  return(contracts)

}
