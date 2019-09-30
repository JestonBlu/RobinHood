#' Get a current status of an crypto currency order on RobinHood
#'
#' Returns a list of order information given a buy/sell order url returned from place_order().
#'
#' @param RH object of class RobinHood
#' @param order_id (string) id field of the object returned by place_order_crypto
#' @import httr magrittr
#' @export
#' @examples
#' \dontrun{
#' # Login in to your RobinHood account
#' RH <- RobinHood("username", "password")
#'
#' # Place an order, should generate an email confirmation
#'x <- place_order_crypto(RH = RH,
#'                        symbol = "GE",          # Ticker symbol you want to trade
#'                        type = "market",        # Type of market order
#'                        time_in_force = "gfd",  # Time period (gfd: good for day)
#'                        trigger = "immediate",  # Trigger or delay order
#'                        price = 8.96,           # The highest price you are willing to pay
#'                        quantity = 1,           # Number of shares you want
#'                        side = "buy")           # buy or sell
#'
#' get_order_status_crypto(RH, order_id = x$id)
#'}
get_order_status_crypto <- function(RH, order_id) {

    # Check if RH is valid
    check_rh(RH)

    # Get Order Status
    order_status <- api_orders_crypto(RH, action = "status", order_id)

    order_status <- order_status[c("created_at", "cumulative_quantity", "executions", "last_transaction_at", "price",
                                   "quantity", "rounded_executed_notional", "side", "state", "time_in_force", "type",
                                   "updated_at")]

    return(order_status)
}
