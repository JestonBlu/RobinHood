#' Get a current status of an option order on RobinHood
#'
#' Returns a list of order information given a buy/sell order url returned from place_order_options().
#'
#' @param RH object of class RobinHood
#' @param status_url (string) url of order returned from place_order
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
#' get_order_status_options(RH, x$status_url)
#'}
get_order_status_options <- function(RH, status_url) {

    # Check if RH is valid
    RobinHood::check_rh(RH)

    # Get Order Status
    order_status <- RobinHood::api_orders(RH, action = "status", status_url = status_url)

    return(order_status)
}
