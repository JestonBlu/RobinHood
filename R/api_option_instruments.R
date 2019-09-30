#' RobinHood API: Option Contract Instruments
#'
#' @param RH object of class RobinHood
#' @param option_instrument_url (string) url
#' @import httr magrittr
#' @export
api_option_instruments <- function(RH, option_instrument_url) {

  # URL and token
  url <- option_instrument_url
  token <- paste("Bearer", RH$tokens.access_token)

  # GET call
  dta <- GET(url,
             add_headers("Accept" = "application/json",
                         "Content-Type" = "application/json",
                         "Authorization" = token))

  # format return
  dta <- mod_json(dta, "fromJSON")
  dta <- as.data.frame(dta)

  if (dta$type == "call") {

    colnames(dta)[13:15] = c("cutoff_price", "below_tick", "above_tick")

    dta$issue_date <- lubridate::ymd(dta$issue_date)
    dta$strike_price <- as.numeric(dta$strike_price)
    dta$expiration_date <- lubridate::ymd(dta$expiration_date)
    dta$created_at <- lubridate::ymd_hms(dta$created_at)
    dta$updated_at <- lubridate::ymd_hms(dta$updated_at)

  }

  return(dta)
}
