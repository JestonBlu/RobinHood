#' Place a options buy or sell order against your RobinHood account
#'
#' Place an order on an option contract. Currently only limit orders are supported so you must supply a price
#'
#' @param RH object of class RobinHood
#' @param option_id (string) id returned from get_contracts()
#' @param direction (string) one of "debit" or "credit"
#' @param side (string) one of "buy" or "sell"
#' @param quantity (integer) number of contracts to buy
#' @param stop_price (numeric) stop price for a limit order
#' @param type (string) "limit" or "market" (only limit is currently supported)
#' @param time_in_force (string) Good Till Canceled ("gtc"), Immediate or Cancel ("ioc"), or Opening ("opg")
#' @import httr magrittr
#' @export
#' @examples
#' \dontrun{
#' # Login in to your RobinHood account
#' RH <- RobinHood("username", "password")
#'
#' # Place an options order, should generate an email confirmation
#'x <- place_order_options(RH = RH,
#'                        option_id = "346e46af-380e-4052-a7c2-15748f0fc0ca",
#'                        direction = "debit",   # one of "debit" or "credit"
#'                        side = "buy",          # one of "buy" or "sell"
#'                        quantity = 1,          # number of contracts
#'                        stop_price = .01,      # Time period (gfd: good for day)
#'                        type = "limit",        # limit or market (only limit is currently supported)
#'                        time_in_force = "gtc") # "gfd", "gtc", "ioc", "opg"
#'}
place_order_options <- function(RH, option_id, direction, side, quantity, stop_price = NULL, type = "limit", time_in_force) {

    # Check if RH is valid
    RobinHood::check_rh(RH)

    # Check inputs
    # Limit orders should contain a price
    if (type != "limit") stop("Only limit orders are supported")
    if (type == "limit" & is.null(stop_price)) stop("Limit orders must contain a price")
    if (!direction %in% c("debit", "credit")) stop("direction must be 'debit' or 'credit'")

    # Place an order
    orders <- RobinHood::api_orders_options(RH = RH,
                                            option_id = option_id,
                                            direction = direction,
                                            side = side,
                                            quantity = quantity,
                                            stop_price = stop_price,
                                            type = type,
                                            time_in_force = time_in_force,
                                            action = "order")

    return(orders)
}
