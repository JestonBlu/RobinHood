#' RobinHood API: Login
#'
#' Backend function called by RobinHood(). Returns a list like object of class RobinHood which stores tokens
#' required by all other functions.
#' @param username (string) RobinHood username
#' @param password (string) RobinHood password
#' @param mfa_code (string) Provided by your authentication app
#' @import httr jsonlite magrittr
#' @export
api_login <- function(username, password, mfa_code) {

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
  dta <- POST(url)
  httr::stop_for_status(dta)
  
  dta <- dta %>%
    content(type = "json") %>%
    rawToChar() %>%
    jsonlite::fromJSON() %>%
    as.list()

  # Return object
  RH <- c(RH,
          # User tokens and ids
          tokens = list(
            access_token = dta$access_token,
            refresh_token = dta$refresh_token,
            mfa_required = dta$mfa_required,
            mfa_type = dta$mfa_type)
  )

  # If MFA is enabled ask for a code to be submitted from the auth app
  if (length(dta) == 2 & mfa_code != "000000") {

    # POST call
    dta <- POST(url, body = list(mfa_code = mfa_code))
    httr::stop_for_status(dta)
    
    dta <- dta %>%
      content(type = "json") %>%
      rawToChar() %>%
      jsonlite::fromJSON() %>%
      as.list()

    RH$tokens.access_token = dta$access_token
    RH$tokens.refresh_token = dta$refresh_token
  }

  return(RH)
}
