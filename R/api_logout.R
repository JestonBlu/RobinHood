#' RobinHood API: Logout
#'
#' Backend function called by logout(). Sends a logout call and disables your oauth2 token.
#'
#' @param RH object of class RobinHood
#' @export
#' @import curl jsonlite magrittr
api_logout <- function(RH) {

  detail <- paste("client_id=",
                  RH$api_client_id,
                  "&token=",
                  RH$tokens.refresh_token,
                  sep = "")

  logout <- new_handle() %>%
    handle_setopt(copypostfields = detail) %>%
    handle_setheaders("Accept" = "application/json") %>%
    curl_fetch_memory(url = api_endpoints("revoke_token"))

  logout <- logout$content
}
