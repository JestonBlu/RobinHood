#' Get Current Positions of your portfolio
#'
#'
#' @param RH object class RobinHood
#' @import curl jsonlite magrittr
#' @export
#' @examples
#' # Get you current positions
#' # RH <- RobinHood(username = 'your username', password = 'your password')
#' # getPositions(RH)
getPositions <- function(RH) {
  
  positions <- new_handle() %>%
    handle_setheaders("Accept" = "application/json") %>%
    handle_setheaders("Authorization" = paste("Bearer", RH$tokens.access_token)) %>%
    curl_fetch_memory(url = RH$user.url.positions) %$% content %>% 
    rawToChar %>% 
    fromJSON %$% results %>% data.frame
  
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
  
  positions = positions[, c("average_buy_price", "quantity", "updated_at")]
  
  positions = cbind(instruments, positions)
  
  return(positions)
}
