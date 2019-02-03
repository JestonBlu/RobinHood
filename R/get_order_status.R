#' Get a current status of an order on RobinHood
#'
#' Returns a list of order information given a buy/sell order url returned from place_order().
#'
#' @param RH object of class RobinHood
#' @param order_url (string) url of order returned from place_order
#' @param limit_output (logical) return limited info on the order (default TRUE)
#' @import curl jsonlite magrittr
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
#' get_order_status(RH, x$url)
#'}
get_order_status <- function(RH, order_url, limit_output = TRUE) {

  if (class(RH) != "RobinHood") stop("RH must be class RobinHood, see RobinHood()")

  # Get Order Status
  order_status <- api_orders(RH, action = "status", order_url)

  if (limit_output == TRUE) {
    order_status <- list(updated_at = order_status$updated_at,
                        time_in_force = order_status$time_in_force,
                        state = order_status$state,
                        type = order_status$type,
                        executions = order_status$executions)
                      }

  return(order_status)
}
