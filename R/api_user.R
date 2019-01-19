#' RobinHood API: User
#'
#' Backend function called by get_user() to return user data
#'
#' @param RH object of class RobinHood
#' @import curl jsonlite magrittr
#' @examples
#' # List of 14
#' # $ username
#' # $ first_name
#' # $ last_name
#' # $ id_info
#' # $ url
#' # $ email_verified
#' # $ created_at
#' # $ basic_info
#' # $ email
#' # $ investment_profile
#' # $ id
#' # $ international_info
#' # $ employment
#' # $ additional_info
api_user <- function(RH) {

  user <- new_handle() %>%
    handle_setheaders("Accept" = "application/json") %>%
    handle_setheaders("Authorization" = paste("Bearer", RH$tokens.access_token)) %>%
    curl_fetch_memory(url = api_endpoints("user")) %$% content %>%
    rawToChar %>%
    fromJSON

  return(user)
}
