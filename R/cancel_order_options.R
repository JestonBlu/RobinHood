#' Cancel an existing options order on RobinHood
#'
#' Send a cancel signal for a particular order to RobinHood. You will need to retain the buy/sell order url returned
#' from place_order_options().
#'
#' @param RH object of class RobinHood
#' @param cancel_url (string) cancel url returned from place_order()
#' @import httr magrittr
#' @export
#' @examples
#' \dontrun{
#' # Login in to your RobinHood account
#' RH <- RobinHood("username", "password")
#'
#' # Place an order, should generate an email confirmation
#'x <- place_order_options(RH = RH,
#'                        option_id = "346e46af-380e-4052-a7c2-15748f0fc0ca",
#'                        direction = "debit",   # one of "debit" or "credit"
#'                        side = "buy",          # one of "buy" or "sell"
#'                        quantity = 1,          # number of contracts
#'                        stop_price = .01,      # Time period (gfd: good for day)
#'                        type = "limit",        # limit or market (only limit is currently supported)
#'                        time_in_force = "gtc") # "gfd", "gtc", "ioc", "opg"
#'
#' # Cancel the order, should also generate an email confirmation
#' cancel_order_options(RH, x$cancel_url)
#'}
cancel_order_options <- function(RH, cancel_url) {

  check_rh(RH)

  order_status <- api_orders_options(RH, action = "cancel", cancel_url = cancel_url)

  if (length(order_status) == 0) cat("Order Canceled")

  if (length(order_status) >  0) {
    cat("You may have already canceled this order, check get_order_status_options()")
  }

}
