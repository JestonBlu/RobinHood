#' RobinHood API: Login
#'
#' Backend function called by RobinHood(). Returns a list like object of class RobinHood which stores tokens
#' required by all other functions.
#' @param username (string) RobinHood username
#' @param password (string) RobinHood password
#' @import httr jsonlite magrittr
#' @export
api_login <- function(username, password) {

  # Storage for api data
  RH <- list(
    # APIs
    api_grant_type = "password",
    api_client_id = "c82SH0WZOsabOXGP2sxqcj34FxkvfnWRZBKlBjFS"
  )

  # Parameters
  detail <- paste("?grant_type=", RH$api_grant_type,
                  "&client_id=", RH$api_client_id,
                  "&username=", username,
                  "&password=", password, sep = "")

  url <- paste(api_endpoints("token"), detail, sep = "")

  # POST call
  dta <- POST(url) %>%
    content(type = "json") %>%
    rawToChar() %>%
    jsonlite::fromJSON() %>%
    as.list()
  
  if('detail' %in% names(dta)) {
    stop(dta$detail)
  }

  # Return object
  RH <- c(RH,
          # User tokens and ids
          tokens = list(
            access_token = dta$access_token,
            refresh_token = dta$refresh_token)
  )

  return(RH)
}
