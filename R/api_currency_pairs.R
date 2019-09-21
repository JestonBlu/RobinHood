#' RobinHood API: Currency Pairs
#'
#' Returns the ID for a particular paired currency
#'
#' @param RH object of class RobinHood
#' @import curl magrittr
#' @export
api_currency_pairs <- function(RH) {

  # URL and token
  url <- api_endpoints("currency_pairs", "crypto")
  token <- paste("Bearer", RH$tokens.access_token)

  # GET call
  dta <- httr::GET(url,
    httr::add_headers("Accept" = "application/json",
                "Content-Type" = "application/json",
                "Authorization" = token))

  # Format return
  dta <- mod_json(dta, "fromJSON")
  dta <- as.list(dta$results)

  dta <- data.frame(
    id = dta$id,
    name = dta$name,
    symbol = dta$symbol,
    tradability = dta$tradability
  )

  return(dta)
}
