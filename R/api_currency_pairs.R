#' RobinHood API: Currency Pairs
#'
#' Returns the ID for a particular paired currency
#'
#' @param RH object of class RobinHood
#' @import curl magrittr
#' @export
api_currency_pairs <- function(RH) {

  currency_pairs <- new_handle() %>%
    handle_setheaders("Accept" = "application/json") %>%
    handle_setheaders("Authorization" = paste("Bearer", RH$tokens.access_token)) %>%
    curl_fetch_memory(url = api_endpoints("currency_pairs", source = "crypto"))

  currency_pairs <- jsonlite::fromJSON(rawToChar(currency_pairs$content))
  currency_pairs <- as.list(currency_pairs$results)

  currency_pairs <- data.frame(
    id = currency_pairs$id,
    name = currency_pairs$name,
    symbol = currency_pairs$symbol,
    tradability = currency_pairs$tradability
  )

  return(currency_pairs)
}
