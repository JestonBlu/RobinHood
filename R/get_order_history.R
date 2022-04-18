#' Download all available order history for your RobinHood account
#'
#' @param RH object of class RobinHood
#' @param page_size (int) number of historical records to fetch
#' @import httr jsonlite magrittr lubridate
#' @export
#' @examples
#' \dontrun{
#' # Login in to your RobinHood account
#' RH <- RobinHood("username", "password")
#'
#' get_order_history(RH)
#'}
get_order_history <- function(RH, page_size = 1000) {

    # Check if RH is valid
    RobinHood::check_rh(RH)

    # Get Order History
    order_history <- RobinHood::api_orders(RH, action = "history", page_size = page_size)

    # Get symbol to attach to output
    symbol <- as.character()

    for (i in order_history$instrument) {
      x <- RobinHood::api_instruments(RH, instrument_url = i)
      x <- x$symbol
      symbol <- c(symbol, x)
    }

    # Combine symbol with order history
    order_history$symbol <- symbol
    order_history <- order_history[, c("created_at",
                                       "symbol",
                                       "side",
                                       "price",
                                       "quantity",
                                       "fees",
                                       "state",
                                       "average_price",
                                       "type",
                                       "trigger",
                                       "time_in_force",
                                       "updated_at")]

  # Format timestamp
  order_history$created_at <- lubridate::ymd_hms(order_history$created_at)
  order_history$updated_at <- lubridate::ymd_hms(order_history$updated_at)
  order_history$fees <- as.numeric(order_history$fees)
  order_history$price <- as.numeric(order_history$price)
  order_history$average_price <- as.numeric(order_history$average_price)
  order_history$quantity <- as.numeric(order_history$quantity)

  return(order_history)
}
