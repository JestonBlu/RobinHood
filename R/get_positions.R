#' Get Current Positions of your portfolio
#'
#'
#' @param RH object class RobinHood
#' @import curl jsonlite magrittr lubridate
#' @export
#' @examples
#' # Get you current positions
#' # RH <- RobinHood(username = 'your username', password = 'your password')
#' # get_positions(RH)
get_positions <- function(RH) {

  ##############################################################################
  # Get current positions
  positions <- api_positions(RH)

  ##############################################################################
  # Use instrument IDs to get the ticker symbol and name
  instrument_id <- positions$instrument
  instruments <- c()

  for (i in 1:length(instrument_id)) {
    instrument <- api_instruments(instrument_id[i])

    x <- data.frame(simple_name = instrument$simple_name,
                    symbol = instrument$symbol)

    instruments <- rbind(instruments, x)
  }

  ##############################################################################
  # Combine positions with instruments
  positions <- positions[, c("average_buy_price", "quantity", "updated_at")]
  positions <- cbind(instruments, positions)

  ##############################################################################
  # Get latest quote
  symbols <- paste(as.character(positions$symbol), collapse = ",")

  # Quotes URL
  symbols_url <- paste(api_endpoints(endpoint = "quotes"), symbols, sep = "")

  # Get last price
  quotes <- api_quote(RH, symbols_url)
  quotes <- quotes[, c("last_trade_price", "symbol")]

  ##############################################################################
  # Combine quotes with positions
  positions <- merge(positions, quotes)

  # Convert timestamp
  positions$updated_at <- ymd_hms(positions$updated_at)

  # Adjust data types
  positions$average_buy_price <- as.numeric(positions$average_buy_price)
  positions$quantity <- as.numeric(positions$quantity)
  positions$last_trade_price <- as.numeric(positions$last_trade_price)

  # Calculate extended cost and value
  positions$cost <- with(positions, average_buy_price * quantity)
  positions$current_value <- with(positions, last_trade_price * quantity)

  # Reorder dataframe
  positions <- positions[, c("simple_name",
                             "symbol",
                             "quantity",
                             "average_buy_price",
                             "last_trade_price",
                             "cost",
                             "current_value",
                             "updated_at")]

  colnames(positions) <- c("name",
                           "symbol",
                           "qty",
                           "buy_price",
                           "last_price",
                           "cost",
                           "current_value",
                           "updated_at")

  return(positions)
}
