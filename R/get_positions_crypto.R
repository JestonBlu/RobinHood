#' Get the currently held crypto positions for your RobinHood account
#'
#' @param RH object class RobinHood
#' @import httr magrittr
#' @export
#' @examples
#' \dontrun{
#' # Login in to your RobinHood account
#' RH <- RobinHood("username", "password")
#'
#' get_positions_crypto(RH)
#'}
get_positions_crypto <- function(RH) {

    # Check if RH is valid
    check_rh(RH)

    # Get current positions
    positions <- api_positions_crypto(RH)

    if (nrow(positions) == 0)  {
      return(cat("You have no current positions"))
    }

    # Use the crypto currency IDs to get the current quote
    currency_codes <- positions$symbol

    crypto_quotes <- c()

    # For each instrument id, get stocker symbols and names
    for (i in currency_codes) {
      x <- get_quote_crypto(RH, symbol = i)
      x <- x[, c("symbol", "mark_price")]
      crypto_quotes <- rbind(crypto_quotes, x)
    }

    # Join positions with quotes
    positions <- dplyr::inner_join(positions, crypto_quotes, by = "symbol")

    # Calculate extended values
    positions$market_value <- round(positions$mark_price * positions$quantity, 2)
    positions$gain_loss <- round(positions$market_value - positions$cost_bases, 2)
    positions$average_price <- round(positions$market_value / positions$quantity, 2)

    # Reorder columns
    positions <- positions[, c("symbol", "name", "quantity", "market_value",
                               "average_price", "cost_bases", "gain_loss",
                               "created_at")]

    return(positions)
  }
