#' Logout of RobinHood
#' 
#' Send a logout call through the RobinHood API service, this disables your token
#' 
#' @param RH object of class RobinHood
#' @import curl jsonlite magrittr
#' @export
#' @examples
#' # Logout
#' # RH <- RobinHood(username = 'your username', password = 'your password')
#' # logout(RH)
logout <- function(RH) {

  detail <- paste("client_id=", RH$api.clientID,
                  "&token=", RH$tokens.refresh_token, sep = "")
  
  # Log in, get access token
  logout <- new_handle() %>%
    handle_setopt(copypostfields = detail) %>%
    handle_setheaders("Accept" = "application/json") %>%
    curl_fetch_memory(url = getURL("revoke_token")) %$% content

  if (length(logout) == 0) {
    cat("Logout Sucessful")
  } else {
    cat("Failed to Logout")
  }
  }
