#' Logout of RobinHood
#'
#' Send a logout call through the RobinHood API service, this disables your token
#'
#' @param RH object of class RobinHood
#' @import curl jsonlite magrittr
#' @seealso \code{\link{logout}}
api_logout <- function(RH) {
  detail <- paste("client_id=", RH$api_client_id,
                  "&token=", RH$tokens.refresh_token, sep = "")

  # Log in, get access token
  logout <- new_handle() %>%
    handle_setopt(copypostfields = detail) %>%
    handle_setheaders("Accept" = "application/json") %>%
    curl_fetch_memory(url = api_endpoints("revoke_token")) %$% content
}
