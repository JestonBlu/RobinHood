#' Get order history using the RobinHood api
#'
#' Returns recent order history.
#'
#' @param RH object of class RobinHood
#' @import curl jsonlite magrittr lubridate
#' @export
get_order_history <- function(RH) {

  if (class(RH) != "RobinHood") stop("RH must be class RobinHood, see RobinHood()")

  # Get Order History
  order_history <- api_orders(RH, action = "history")

  order_status <- fromJSON(rawToChar(order_history$content))
  order_status <- order_status$results

  order_status <- order_status[, c("updated_at", "time_in_force", "fees", "state",
                                   "trigger", "type", "price", "side", "quantity")]

  order_status$updated_at <- ymd_hms(order_status$updated_at)

  return(order_status)
}
