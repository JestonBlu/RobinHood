#' Place a buy or sell order against your RobinHood account
#'
#' **Note**: Price cannot extend beyond 2 decimals
#' **Note**: Quantity must be a whole number
#' **Note**: Price * Quantity > $0.01
#'
#' @param RH object of class RobinHood
#' @param symbol (string) Ticket symbol you are attempting to buy or sell
#' @param type (string) "market" or "limit"
#' @param time_in_force (string) Good For Day ("gfd"), Good Till Canceled ("gtc"), Immediate or Cancel ("ioc"), or Opening ("opg")
#' @param trigger (string) "immediate" or "stop"
#' @param price (number) the price you are willing to sell or buy at
#' @param stop_price (number) if trigger = stop, enter stop price, otherwise leave blank
#' @param quantity (int) number of shares you wish to transact, must be a whole number
#' @param side (string) "buy" or "sell"
#' @import httr magrittr
#' @export
#' @examples
#' \dontrun{
#' # Login in to your RobinHood account
#' RH <- RobinHood("username", "password")
#'
#' # Place an order, should generate an email confirmation
#'x <- place_order(RH = RH,
#'                  symbol = "GE",          # Ticker symbol you want to trade
#'                  type = "market",        # Type of market order (market, limit)
#'                  time_in_force = "gfd",  # Time period the order is good for (gfd: good for day)
#'                  trigger = "immediate",  # Trigger or delay order
#'                  price = 8.96,           # The highest price you are willing to pay
#'                  quantity = 1,           # Number of shares you want
#'                  side = "buy")           # buy or sell
#'}
place_order <- function(RH, symbol, type, time_in_force, trigger, price, stop_price = NA, quantity, side) {

    # Check if RH is valid
    check_rh(RH)

    # Set up error checks
    if (!type %in% c("market", "limit")) stop("type must be 'market' or 'limit'")
    if (!time_in_force %in% c("gfd", "gtc", "ioc", "opg")) stop(" time_in_fore must be one of 'gfd', 'gtc', 'ioc', 'opg'")
    if (!trigger %in% c("immediate", "stop")) stop("trigger must be 'immediate' or 'stop'")
    if (trigger == "stop" & is.na(stop_price) == TRUE) stop("stop price cant be null if trigger == 'stop'")
    if (quantity < 1) stop("quantity must be > 0")
    if (!side %in% c("buy", "sell")) stop("side must be 'buy' or 'sell'")

    # Convert NAs to NULL and numeric to character
    if (is.na(stop_price) == TRUE) stop_price <- ""
    quantity <- as.character(quantity)
    price <- as.character(price)

    # Given a symbol, return the instrument_id
    instrument_url <- paste(api_endpoints(endpoint = "quotes"), symbol, sep = "")
    instrument <- api_quote(RH, instrument_url)
    instrument_id <- instrument$instrument


    # Place an order
    orders <- api_orders(RH = RH,
                         action = "order",
                         instrument_id = instrument_id,
                         symbol = symbol,
                         type = type,
                         time_in_force = time_in_force,
                         trigger = trigger,
                         price = price,
                         stop_price = stop_price,
                         quantity = quantity,
                         side = side)

    return(orders)
}
