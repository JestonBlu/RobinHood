#' Cancel an existing order on RobinHood
#'
#' @param RH object of class RobinHood
#' @param order_url (string) url of order returned from place_order
#' @import curl jsonlite magrittr
cancel_order <- function(RH, order_url) {

  order_status <- api_order_cancel(RH, order_url)

  return(order_status)
}
