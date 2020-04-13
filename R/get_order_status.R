#' Get a current status of an order on RobinHood
#'
#' Returns a list of order information given a buy/sell order url returned from place_order().
#'
#' @param RH object of class RobinHood
#' @param status_url (string) url of order returned from place_order
#' @param limit_output (logical) return limited info on the order (default TRUE)
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
#'                  type = "market",        # Type of market order
#'                  time_in_force = "gfd",  # Time period the order is good for (gfd: good for day)
#'                  trigger = "immediate",  # Trigger or delay order
#'                  price = 8.96,           # The highest price you are willing to pay
#'                  quantity = 1,           # Number of shares you want
#'                  side = "buy")           # buy or sell
#'
#' get_order_status(RH, x$status_url)
#'}
get_order_status <- function(RH, status_url, limit_output = TRUE) {

    # Check if RH is valid
    check_rh(RH)

    # Get Order Status
    order_status <- api_orders(RH, action = "status", status_url = status_url)

    # Give addition order details if requested
    if (limit_output == TRUE) {
      order_status <- list(updated_at = order_status$updated_at,
                           time_in_force = order_status$time_in_force,
                           state = order_status$state,
                           type = order_status$type,
                           executions = order_status$executions,
                           status_url = order_status$status_url,
                           cancel_url = order_status$cancel_url)
                        }

     return(order_status)
}
