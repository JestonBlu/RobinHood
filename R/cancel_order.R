#' Cancel an existing order on RobinHood
#'
#' Send a cancel signal for a particular order to RobinHood. You will need to retain the buy/sell order url returned from place_order.
#'
#' @param RH object of class RobinHood
#' @param order_url (string) cancel url returned from place_order()
#' @import curl magrittr
#' @export
#' @examples
#' \dontrun{
#' # Login in to your RobinHood account
#' RH <- RobinHood("username", "password")
#'
#' # Place an order, should generate an email confirmation
#'x <- place_order(RH = RH,
#'                  symbol = "GE",          # Ticker symbol you want to trade
#'                  type = "market",        # Type of market order
#'                  time_in_force = "gfd",  # Time period the order is good for (gfd: good for day)
#'                  trigger = "immediate",  # Trigger or delay order
#'                  price = 8.96,           # The highest price you are willing to pay
#'                  quantity = 1,           # Number of shares you want
#'                  side = "buy")           # buy or sell
#'
#' # Cancel the order, should also generate an email confirmation
#' cancel_order(RH, x$cancel)
#'}
cancel_order <- function(RH, order_url) {

  if (class(RH) != "RobinHood") stop("RH must be class RobinHood, see RobinHood()")

  order_status <- api_orders(RH, action = "cancel", order_url)

  if (length(order_status) == 0) cat("Order Canceled")

  if (length(order_status) >  0) {
    cat("You may have already canceled this order, check order_status()")
  }

}
