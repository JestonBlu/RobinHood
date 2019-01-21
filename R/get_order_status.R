#' Get order status using the RobinHood api
#'
#' Returns a list of order information given a buy/sell order url.
#'
#' @param RH object of class RobinHood
#' @param order_url (string) url of order returned from place_order
#' @param limit_output (logical) return limited info on the order (default TRUE)
#' @import curl jsonlite magrittr
#' @export
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
