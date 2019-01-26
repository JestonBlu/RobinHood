#' RobinHood API: Tickers
#'
#' Backend function called by get_ticker. Returns a data frame of all instruments listed
#' on RobinHood.
#'
#' @param RH object of class RobinHood
#' @import curl jsonlite magrittr profvis
#' @examples
#' # data returned by api call
#' # $ margin_initial_ratio
#' #  $ rhs_tradability
#' #  $ id
#' #  $ market
#' #  $ simple_name
#' #  $ min_tick_size
#' #  $ maintenance_ratio
#' #  $ tradability
#' #  $ state
#' #  $ type
#' #  $ tradeable
#' #  $ fundamentals
#' #  $ quote
#' #  $ symbol
#' #  $ day_trade_ratio
#' #  $ name
#' #  $ tradable_chain_id
#' #  $ splits
#' #  $ url
#' #  $ country
#' #  $ bloomberg_unique
#' #  $ list_date
api_tickers <- function(RH) {
  
  cat("Getting stock ticker data from RobinHood.com...")
  # Stopwatch
  start_time = proc.time()
  
  url <- api_endpoints("tickers")

  tickers <- new_handle() %>%
    handle_setheaders("Accept" = "application/json") %>%
    handle_setheaders("Authorization" = paste("Bearer", RH$tokens.access_token)) %>%
    curl_fetch_memory(url = url)

  tickers <- fromJSON(rawToChar(tickers$content))

  output <- tickers$results

  while (length(tickers$`next`) > 0) {
    tickers <- new_handle() %>%
      handle_setheaders("Accept" = "application/json") %>%
      handle_setheaders("Authorization" = paste("Bearer", RH$tokens.access_token)) %>%
      curl_fetch_memory(url = tickers$`next`)

    tickers <- fromJSON(rawToChar(tickers$content))

    x <- tickers$results

    output <- rbind(output, x)

    pause(1)
  }
  
  # Stopwatch
  end_time = proc.time() - start_time
  
  cat("..........COMPLETE (", round(end_time[3]/60, 2), "minutes)")
  
  
  return(output)
}
