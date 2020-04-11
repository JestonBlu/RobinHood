#' Download all available crypto currency order history for your RobinHood account
#'
#' @param RH object of class RobinHood
#' @import httr jsonlite magrittr lubridate
#' @export
#' @examples
#' \dontrun{
#' # Login in to your RobinHood account
#' RH <- RobinHood("username", "password")
#'
#' get_order_history_crypto(RH)
#'}
get_order_history_crypto <- function(RH) {

    # Check if RH is valid
    check_rh(RH)

    # Get Order History
    order_history <- api_orders_crypto(RH, action = "history")

    # Get currency symbol
    currency_pairs <- api_currency_pairs(RH)

    # Adjust names for join
    colnames(currency_pairs)[1] = "currency_pair_id"

    # Force join to be character so R doesnt give a warning
    currency_pairs$currency_pair_id <- as.character(currency_pairs$currency_pair_id)
    order_history$currency_pair_id <- as.character(order_history$currency_pair_id)

    # Join currency pairs with order history to get currency symbol
    order_history <- dplyr::inner_join(currency_pairs, order_history, by = "currency_pair_id")

    # Limit output
    order_history <- order_history %>%
      dplyr::select(c("name", "symbol", "created_at", "price", "cumulative_quantity", "side", "state",
               "time_in_force", "type"))

   # Adjust factor levels it doesn't show factors not in the join
   order_history <- order_history %>%
    dplyr::mutate_at(c("name","symbol"), as.character)

  return(order_history)
}
