#' Download all available options order history for your RobinHood account
#'
#' @param RH object of class RobinHood
#' @import httr jsonlite magrittr
#' @export
#' @examples
#' \dontrun{
#' # Login in to your RobinHood account
#' RH <- RobinHood("username", "password")
#'
#' get_order_history(RH)
#'}
get_order_history_options <- function(RH) {

    # Check if RH is valid
    RobinHood::check_rh(RH)

    # Get Order History
    order_history <- RobinHood::api_orders_options(RH, action = "history")

    return(order_history)
}
