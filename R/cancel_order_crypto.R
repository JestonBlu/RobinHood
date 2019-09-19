#' Cancel an existing crypto order on RobinHood
#'
#' Send a cancel signal for a particular order to RobinHood. You will need to retain the buy/sell order url returned from place_order.
#'
#' @param RH object of class RobinHood
#' @param cancel_url (string) cancel url returned from place_order_crypto()
#' @import curl magrittr
#' @export
#' @examples
#' \dontrun{
#' # Login in to your RobinHood account
#' RH <- RobinHood("username", "password")
#'
#' # Place an order, should generate an email confirmation
#'x <- place_order_crypto(RH = RH,
#'                  symbol = "GE",          # Ticker symbol you want to trade
#'                  type = "market",        # Type of market order
#'                  time_in_force = "gfd",  # Time period the order is good for (gfd: good for day)
#'                  trigger = "immediate",  # Trigger or delay order
#'                  price = 8.96,           # The highest price you are willing to pay
#'                  quantity = 1,           # Number of shares you want
#'                  side = "buy")           # buy or sell
#'
#' # Cancel the order, should also generate an email confirmation
#' cancel_order_crypto(RH, x$cancel_url)
#'}
cancel_order_crypto <- function(RH, cancel_url) {

  check_rh(RH)

  order_status <- api_orders_crypto(RH, action = "cancel", cancel_url = cancel_url)

  if (length(order_status) == 0) cat("Order Canceled")

  if (length(order_status) >  0) {
    cat("You may have already canceled this order, check order_status()")
  }

}
