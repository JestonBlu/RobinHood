#' Get order status using the RobinHood api
#'
#' Returns a list of order information
#'
#' @param RH object of class RobinHood
#' @param order_url (string) url of order returned from place_order
#' @param simple (logical) return limited info on the order (default TRUE)
#' @import curl jsonlite magrittr
get_order_status <- function(RH, order_url, simple = TRUE) {

  # Get Order Status
  order_status <- api_order_status(RH, order_url)

  if (simple == TRUE) {
    order_status = list(updated_at = order_status$updated_at,
                        time_in_force = order_status$time_in_force,
                        state = order_status$state,
                        type = order_status$type,
                        executions = order_status$executions)
                      }

  return(order_status)
}
