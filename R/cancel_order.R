#' Cancel an existing order on RobinHood
#'
#' Send a cancel buy order command to RobinHood. You will need to retain the buy/sell order url.
#'
#' @param RH object of class RobinHood
#' @param order_url (string) url of order returned from place_order()
#' @import curl jsonlite magrittr
#' @export
cancel_order <- function(RH, order_url) {

  if (class(RH) != "RobinHood") stop("RH must be class RobinHood, see RobinHood()")

  order_status <- api_orders(RH, action = "cancel", order_url)

  if (length(order_status) == 0) cat("Order Canceled")

  if (length(order_status) >  0) {
    cat("You may have already canceled this order, check order_status()")
  }

}
