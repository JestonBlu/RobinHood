#' RobinHood API: User Crypto
#'
#' Backend function which calls the Nummus API to return the account id.
#'
#' @param RH object of class RobinHood
#' @import curl magrittr
#' @export
api_accounts_crypto <- function(RH) {

  # URL and token
  url <- api_endpoints("accounts", "crypto")
  token <- paste("Bearer", RH$tokens.access_token)

  # GET call
  accounts <- httr::GET(url,
      add_headers("Accept" = "application/json",
                  "Content-Type" = "application/json",
                  "Authorization" = token))

  # format return
  accounts <- mod_json(accounts, "fromJSON")
  accounts <- as.list(accounts$results)

  accounts$updated_at <- lubridate::ymd_hms(accounts$updated_at)

  return(accounts)
}
