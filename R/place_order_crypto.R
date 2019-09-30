#' Place a crypto currency buy or sell order against your RobinHood account
#'
#' @param RH object of class RobinHood
#' @param symbol (string) Ticket symbol you are attempting to buy or sell
#' @param type (string) "market" or "limit"
#' @param time_in_force (string) Good For Day ("gfd"), Good Till Canceled ("gtc"), Immediate or Cancel ("ioc"), or Opening ("opg")
#' @param price (number) the price you are willing to sell or buy at
#' @param quantity (int) number of shares you wish to transact
#' @param side (string) "buy" or "sell"
#' @import httr magrittr
#' @export
#' @examples
#' \dontrun{
#' # Login in to your RobinHood account
#' RH <- RobinHood("username", "password")
#'
#' # Place an order, should generate an email confirmation
#'x <- place_order_crypto(RH = RH,
#'                        symbol = "DOGE",        # Ticker symbol
#'                        type = "market",        # Type of market order (market, limit)
#'                        time_in_force = "gfd",  # Time period (gfd: good for day)
#'                        price = .003,           # The highest price you are willing to pay
#'                        quantity = 500,         # Number of shares you want
#'                        side = "buy")           # buy or sell
#'}
place_order_crypto <- function(RH, symbol, type, time_in_force, price, quantity, side) {

    # Check if RH is valid
    check_rh(RH)

    # Set up error checks
    if (!type %in% c("market", "limit")) stop("type must be 'market' or 'limit'")
    if (!time_in_force %in% c("gfd", "gtc", "ioc", "opg")) stop(" time_in_fore must be one of 'gfd', 'gtc', 'ioc', 'opg'")
    if (quantity < 1) stop("quantity must be > 0")
    if (!side %in% c("buy", "sell")) stop("side must be 'buy' or 'sell'")

    # Convert NAs to NULL and numeric to character
    quantity <- as.character(quantity)
    price <- as.character(price)

    # Given a symbol, return the crypto id
    currency_pair_id <- api_currency_pairs(RH)

    # Clean up currency symbol
    currency_pair_id$symbol <- gsub(x = currency_pair_id$symbol, pattern = "-.*", replacement = "")
    currency_pair_id <- currency_pair_id[currency_pair_id$symbol == symbol, ]
    currency_pair_id <- as.character(currency_pair_id$id)

    # Place an order
    orders <- api_orders_crypto(RH = RH,
                                action = "order",
                                currency_pair_id = currency_pair_id,
                                price = price,
                                quantity = quantity,
                                side = side,
                                time_in_force = time_in_force,
                                type = type)

    return(orders)
}
