#' Get a crypto currency quote from RobinHood
#'
#' @param RH object class RobinHood
#' @param symbol (string) cryto currency symbol such as BTC, ETH, DOGE
#' @import curl magrittr
#' @export
#' @examples
#' \dontrun{
#' # Login in to your RobinHood account
#' RH <- RobinHood("username", "password")
#'
#' get_quote_crypto(RH, "BTC")
#'}
get_quote_crypto <- function(RH, symbol) {

    # Check if RH is valid
    check_rh(RH)

    # Get IDs for cryptocurrency
    currency_pairs <- api_currency_pairs(RH)

    # Adjust symbol to require only the crypto symbol rather than the -USD addition
    symbol <- paste(symbol, "-USD", sep = "")

    # If symbol not in return the list of crypto quotes
    if (!(symbol %in% currency_pairs$symbol))  {
        return(cat("No quote found for given symbol"))
    }

    # Filter to requested currency pair
    currency <- as.character(currency_pairs[currency_pairs$symbol == symbol, "id"])

    # Quotes URL
    quote_url <- paste(api_endpoints(endpoint = "forex"), currency, "/", sep = "")

    # Get last price
    quotes <- api_quote_crypto(RH, quote_url)

    return(quotes)

}
