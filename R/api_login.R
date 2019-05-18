#' RobinHood API: Login
#'
#' Backend function called by RobinHood(). Returns a list like object of class RobinHood which stores tokens
#' required by all other functions.
#' @param username (string) RobinHood username
#' @param password (string) RobinHood password
#' @import curl jsonlite magrittr
#' @export
api_login <- function(username, password) {

  # Storage for api data
  RH <- list(
    # APIs
    api_grant_type = "password",
    api_client_id = "c82SH0WZOsabOXGP2sxqcj34FxkvfnWRZBKlBjFS"
  )

  # Get current positions
  detail <- paste("?grant_type=", RH$api_grant_type,
                  "&client_id=", RH$api_client_id,
                  "&username=", username,
                  "&password=", password, sep = "")

  auth <- httr::POST(paste(api_endpoints("token"), detail, sep = ""))
  auth <- httr::content(auth, type = "json")
  auth <- fromJSON(rawToChar(auth))

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
