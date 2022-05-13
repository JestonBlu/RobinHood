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
  RH <- c(
    # APIs
    api_request = list(
      grant_type = "password",
      client_id = "c82SH0WZOsabOXGP2sxqcj34FxkvfnWRZBKlBjFS",
      device_token = uuid::UUIDgenerate(),
      scope = "internal"
      ),
    api_response = list(
      access_token = "000",
      refresh_token = "000",
      expires_in = 0,
      token_type = "000",
      scope = "000",
      mfa_code = "000",
      backup_code = "000"
    )
  )

  # API call inputs
  headers <- c(
    "Accept" = "application/json",
    "Content-Type" = "application/json"
  )

  body <- data.frame(
    device_token = RH$api_request.device_token,
    client_id = RH$api_request.client_id,
    grant_type = RH$api_request.grant_type,
    scope = RH$api_request.scope,
    username = username,
    password = password,
    mfa_code = mfa_code
  )

  url <- RobinHood::api_endpoints("token")

  # POST call
  dta <- httr::POST(url,
                    body = RobinHood::mod_json(body, type = "toJSON"),
                    add_headers(headers))

  httr::stop_for_status(dta)

  # Extract from json
  dta <- dta %>%
    content(type = "json") %>%
    rawToChar() %>%
    jsonlite::fromJSON() %>%
    as.list()

  # Add response to RH object
  RH$api_response.access_token <- dta$access_token
  RH$api_response.refresh_token <- dta$refresh_token
  RH$api_response.expires_in <- dta$expires_in
  RH$api_response.token_type <- dta$token_type
  RH$api_response.scope <- dta$scope
  RH$api_response.mfa_code <- dta$mfa_code
  RH$api_response.backup_code <- dta$backup_code

  return(RH)
}
