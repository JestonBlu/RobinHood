#' Get Current Positions of your portfolio
#'
#'
#' @param RH object class RobinHood
#' @import curl jsonlite magrittr lubridate
#' @export
#' @examples
#' # Get you current positions
#' # RH <- RobinHood(username = 'your username', password = 'your password')
#' # getPositions(RH)
getPositions <- function(RH) {
  
  # Get current positions
  positions <- new_handle() %>%
    handle_setheaders("Accept" = "application/json") %>%
    handle_setheaders("Authorization" = paste("Bearer", RH$tokens.access_token)) %>%
    curl_fetch_memory(url = RH$user.url.positions) %$% content %>% 
    rawToChar %>% 
    fromJSON %$% results %>% data.frame
  
  # Use instrument IDs to get the ticker symbol and name
  instrument_id = positions$instrument
  instruments = c()
  
  for (i in 1:length(instrument_id)) {
    instrument <- new_handle() %>%
      handle_setheaders("Accept" = "application/json") %>%
      handle_setheaders("Authorization" = paste("Bearer", RH$tokens.access_token)) %>%
      curl_fetch_memory(url = instrument_id[i]) %$% content %>% 
      rawToChar %>% fromJSON
    
    x = data.frame(simple_name = instrument$simple_name, 
                   symbol = instrument$symbol)
    
    instruments = rbind(instruments, x)
  }
  
  # Combine positions with instruments
  positions = positions[, c("average_buy_price", "quantity", "updated_at")]
  positions = cbind(instruments, positions)
  
  # Get latest quote
  symbols = paste(as.character(positions$symbol), collapse = ",")
  
  # Quotes URL
  symbols_url = paste(getURL(endpoint = "quotes"), symbols, sep = "")
  
  quotes <- new_handle() %>%
    handle_setheaders("Accept" = "application/json") %>%
    handle_setheaders("Authorization" = paste("Bearer", RH$tokens.access_token)) %>%
    curl_fetch_memory(url = symbols_url) %$% content %>% 
    rawToChar %>% 
    fromJSON %$% results %>% data.frame
  
  quotes = quotes[, c("last_trade_price", "symbol")]
  
  # Combine quotes with positions
  positions = merge(positions, quotes)
  
  # Convert timestamp
  positions$updated_at = ymd_hms(positions$updated_at)
  
  # Adjust data types
  positions$average_buy_price = as.numeric(positions$average_buy_price)
  positions$quantity = as.numeric(positions$quantity)
  positions$last_trade_price = as.numeric(positions$last_trade_price)
  
  # Calculate extended cost and value
  positions$cost = with(positions, average_buy_price * quantity)
  positions$current_value = with(positions, last_trade_price * quantity)
  
  # Reorder dataframe
  positions = positions[, c("simple_name", "symbol", "quantity", "average_buy_price",
                            "last_trade_price", "cost", "current_value", "updated_at")]
  colnames(positions) = c("name", "symbol", "qty", "buy_price", "last_price", "cost",
                          "current_value", "updated_at")
  
  return(positions)
}
