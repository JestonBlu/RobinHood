#' RobinHood API: Quotes for cryptocurrency
#'
#' Returns a dataframe of current quotes
#'
#' @param RH object of class RobinHood
#' @param symbols_url (string) url of query with ticker symbols
#' @import curl magrittr
#' @export
api_quote_crypto <- function(RH, symbols_url) {

  quotes <- new_handle() %>%
    handle_setheaders("Accept" = "application/json") %>%
    handle_setheaders("Authorization" = paste("Bearer", RH$tokens.access_token)) %>%
    curl_fetch_memory(url = symbols_url)

  quotes <- jsonlite::fromJSON(rawToChar(quotes$content))
  quotes <- as.data.frame(quotes)

  # Convert numeric columns from character
  quotes <- quotes %>%
      dplyr::mutate_at(c("ask_price", "bid_price", "mark_price",
                         "high_price", "low_price", "open_price",
                         "volume", "symbol"),
                       as.character) %>%
      dplyr::mutate_at(c("ask_price", "bid_price", "mark_price",
                        "high_price", "low_price", "open_price",
                        "volume"),
                      as.numeric)

  # Reorder columns
  quotes <- quotes[, c("symbol", "ask_price", "bid_price",
                       "mark_price", "high_price", "low_price",
                       "open_price", "volume")]

  # Remove the USD from the end of the symbol
  quotes$symbol <- gsub(pattern = "USD$", replacement = "", x = quotes$symbol)

  return(quotes)
}
