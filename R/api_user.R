#' RobinHood API: User
#'
#' @param RH object of class RobinHood
#' @import curl jsonlite magrittr
api_user <- function(RH) {

  user <- new_handle() %>%
    handle_setheaders("Accept" = "application/json") %>%
    handle_setheaders("Authorization" = paste("Bearer", RH$tokens.access_token)) %>%
    curl_fetch_memory(url = api_endpoints("user")) %$% content %>%
    rawToChar %>%
    fromJSON

  return(user)
}
