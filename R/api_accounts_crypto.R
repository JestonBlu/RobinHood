#' RobinHood API: User Crypto
#'
#' Backend function which calls the Nummus API to return the account id.
#'
#' @param RH object of class RobinHood
#' @import curl magrittr
#' @export
api_accounts_crypto <- function(RH) {

  accounts <- new_handle() %>%
    handle_setheaders("Accept" = "application/json") %>%
    handle_setheaders("Authorization" = paste("Bearer", RH$tokens.access_token)) %>%
    curl_fetch_memory(url = api_endpoints("accounts", source = "crypto"))

  accounts <- jsonlite::fromJSON(rawToChar(accounts$content))
  accounts <- as.list(accounts$results)

  return(accounts)
}
