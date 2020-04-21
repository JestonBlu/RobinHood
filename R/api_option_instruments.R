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

  dta <- dta %>%
    mutate_at(c("issue_date", "expiration_date"), lubridate::ymd) %>%
    mutate_at(c("created_at", "updated_at"), lubridate::ymd_hms) %>%
    mutate_at("strike_price", as.numeric)

  return(dta)
}
