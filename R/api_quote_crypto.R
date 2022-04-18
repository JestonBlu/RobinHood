#' RobinHood API: Quotes for cryptocurrency
#'
#' Returns a dataframe of current quotes
#'
#' @param RH object of class RobinHood
#' @param symbols_url (string) url of query with ticker symbols
#' @import httr magrittr
#' @export
api_quote_crypto <- function(RH, symbols_url) {

  # URL and token
  url <- symbols_url
  token <- paste("Bearer", RH$tokens.access_token)

  # GET call
  dta <- GET(url,
             add_headers("Accept" = "application/json",
                         "Content-Type" = "application/json",
                         "Authorization" = token))
  httr::stop_for_status(dta)

  # format return
  dta <- RobinHood::mod_json(dta, "fromJSON")
  dta <- as.data.frame(dta)

  # Convert numeric columns from character, have to convert from factor first
  dta <- dta %>%
    dplyr::mutate_at(c("ask_price", "bid_price", "mark_price",
                       "high_price", "low_price", "open_price",
                       "volume"),
                     as.character) %>%
    dplyr::mutate_at(c("ask_price", "bid_price", "mark_price",
                       "high_price", "low_price", "open_price",
                       "volume"),
                     as.numeric)

  # Reorder columns
  dta <- dta[, c("symbol", "ask_price", "bid_price",
                       "mark_price", "high_price", "low_price",
                       "open_price", "volume")]

  # Remove the USD from the end of the symbol
  dta$symbol <- gsub(pattern = "USD$", replacement = "", x = dta$symbol)

  return(dta)
}
