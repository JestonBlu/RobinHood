#' RobinHood API: Portfolio Crypto
#'
#' Backend function called by get_portfolio(..., source = "crypto"). Returns a data frame of the current crypto portolio summary.
#'
#' @param RH object of class RobinHood
#' @import curl magrittr
#' @export
api_portfolios_crypto <- function(RH) {

  account_id <- api_accounts_crypto(RH)
  account_id <- account_id$id

  portfolio_url <- paste(api_endpoints("portfolios", source = "crypto"),
                         account_id, "/",
                         sep = "")

  portfolios <- new_handle() %>%
    handle_setheaders("Accept" = "application/json") %>%
    handle_setheaders("Authorization" = paste("Bearer", RH$tokens.access_token)) %>%
    curl_fetch_memory(url = portfolio_url)

  portfolios <- jsonlite::fromJSON(rawToChar(portfolios$content))

  portfolios$equity <- as.numeric(portfolios$equity)
  portfolios$extended_hours_equity <- as.numeric(portfolios$extended_hours_equity)
  portfolios$market_value <- as.numeric(portfolios$market_value)
  portfolios$extended_hours_market_value <- as.numeric(portfolios$extended_hours_market_value)
  portfolios$previous_close <- as.numeric(portfolios$previous_close)
  portfolios$updated_at <- lubridate::ymd_hms(portfolios$updated_at)

  return(portfolios)
}
