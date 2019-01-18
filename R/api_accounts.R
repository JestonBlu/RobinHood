#' RobinHood API User
#'
#' Returns a list like object of class RobinHood
#' @param RH object of class RobinHood
#' @import curl jsonlite magrittr
api_accounts <- function(RH) {

  # Get account id
  user <- new_handle() %>%
    handle_setheaders("Accept" = "application/json") %>%
    handle_setheaders("Authorization" = paste("Bearer", RH$tokens.access_token)) %>%
    curl_fetch_memory(url = api_endpoints("accounts")) %$% content %>%
    rawToChar %>%
    fromJSON

  return(user)
}
