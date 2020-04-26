#' Get the currently held positions for your RobinHood account
#'
#' @param RH object class RobinHood
#' @param trim_pending (logical) if FALSE, then return pending and intraday columns
#' @import httr magrittr
#' @export
#' @examples
#' \dontrun{
#' # Login in to your RobinHood account
#' RH <- RobinHood("username", "password")
#'
#' get_positions_options(RH)
#'}
get_positions_options <- function(RH, trim_pending = TRUE) {

  # Check if RH is valid
  check_rh(RH)

  # Options postions
  options <- api_positions_options(RH)

  # Get option type, loop through URL
  x <- unique(options$option)

  options_instruments <- data.frame()

  # Loop through option instruments to pull additional columns
  for (i in x) {
    y <- api_instruments_options(RH, i)

    y <- y %>%
      dplyr::select(c("url", "type", "state", "strike_price", "rhs_tradability", "tradability")) %>%
      dplyr::rename(c("option_type" = "type", "option" = "url"))

    options_instruments <- rbind(options_instruments, y)
  }


  # Join with option positions
  options$option <- as.character(options$option)
  options_instruments$option <- as.character(options_instruments$option)
  options <- dplyr::inner_join(options, options_instruments, by = "option")



  ####################################################
  # Loop through option instruments to pull market data

  x <- gsub("https://api.robinhood.com/options/instruments/", "", options$option)
  x <- gsub("/", "", x)

  option_market_data <- data.frame()

  for (i in x) {
    y <- api_marketdata(RH, i)

    option_market_data <- rbind(option_market_data, y)

  }

  option_market_data <- option_market_data %>%
    dplyr::rename("option" = "instrument") %>%
    dplyr::mutate_at("option", as.character)

  # Join with options
  options <- dplyr::inner_join(options, option_market_data, by = "option")

  # Create market value
  options$current_value <- options$trade_value_multiplier * options$last_trade_price

  ###################################################

  # Trim columns
  if (trim_pending == TRUE) {

    options <- options %>%
      dplyr::select(c("chain_symbol", "option_type", "state", "strike_price", "average_price", "quantity",
                      "trade_value_multiplier", "last_trade_price", "current_value", "rhs_tradability",
                      "tradability", "type", "created_at", "updated_at"))

  } else {

    options <- options %>%
      dplyr::select(c("chain_symbol", "option_type", "state", "strike_price", "average_price", "quantity",
                      "trade_value_multiplier", "last_trade_price", "current_value", "pending_buy_quantity",
                      "pending_expired_quantity", "pending_expiration_quantity", "pending_exercise_quantity",
                      "pending_assignment_quantity", "pending_sell_quantity", "intraday_quantity",
                      "intraday_average_open_price", "rhs_tradability", "tradability", "type",
                      "created_at", "updated_at"))
  }

  return(options)

}
