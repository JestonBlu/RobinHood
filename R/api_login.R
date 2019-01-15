#' RobinHood API Login
#'
#' Returns a list like object of class RobinHood
#' @param username RobinHood username
#' @param password RobinHood password
#' @import curl jsonlite magrittr
api_login <- function(username, password) {

  # Storage for api data
  RH <- list(
    # APIs
    api_grant_type = "password",
    api_client_id = "c82SH0WZOsabOXGP2sxqcj34FxkvfnWRZBKlBjFS"
  )

  # Get current positions
  detail <- paste("grant_type=", RH$api_grant_type,
                  "&client_id=", RH$api_client_id,
                  "&username=", username,
                  "&password=", password, sep = "")

  # Log in, get access token
  auth <- new_handle() %>%
    handle_setopt(copypostfields = detail) %>%
    handle_setheaders("Accept" = "application/json") %>%
    curl_fetch_memory(url = api_endpoints("token")) %$% content %>%
    rawToChar %>%
    fromJSON

    access_token <- auth$access_token
    refresh_token <- auth$refresh_token

  # Return object
  RH <- c(RH,
    # User tokens and ids
    tokens = list(
      access_token = access_token,
      refresh_token = refresh_token)
    )

  return(RH)
}
