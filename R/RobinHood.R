#' Connect to your RobinHood Account
#'
#' This function returns an object of S3 class RobinHood and establishes a
#' connection to a RobinHood account.
#'
#' @param username user name or email
#' @param password password
#' @import curl jsonlite magrittr
#' @export
#' @examples
#' # Connect to your robinhood account
#' # RH <- RobinHood(username = 'your username', password = 'your password')
RobinHood <- function(username, password) {

  # Storage for api data
  RH = list(
    # APIs
    api.grantType = "password",
    api.clientID = "c82SH0WZOsabOXGP2sxqcj34FxkvfnWRZBKlBjFS"
  )

  ##############################################################################

  detail <- paste("grant_type=", RH$api.grantType,
                  "&client_id=", RH$api.clientID,
                  "&username=", username,
                  "&password=", password, sep = "")

  # Log in, get access token
  auth <- new_handle() %>%
    handle_setopt(copypostfields = detail) %>%
    handle_setheaders("Accept" = "application/json") %>%
    curl_fetch_memory(url = getURL("token")) %$% content %>%
    rawToChar %>%
    fromJSON


  access_token <- auth$access_token
  refresh_token <- auth$refresh_token

  # Get account id
  user <- new_handle() %>%
    handle_setheaders("Accept" = "application/json") %>%
    handle_setheaders("Authorization" = paste("Bearer", access_token)) %>%
    curl_fetch_memory(url = getURL("accounts")) %$% content %>%
    rawToChar %>%
    fromJSON

  url_positions <- user$results$positions


  # Return object
   RH = c(RH,

         # User tokens and ids
         tokens = list(
           access_token = access_token,
           refresh_token = refresh_token),

         # User url
         user.url = list(
           positions = url_positions
         )
   )

   class(RH) <- "RobinHood"

   return(RH)
}
