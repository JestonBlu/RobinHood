#' RobinHood API: Option Contract Instruments
#'
#' @param RH object of class RobinHood
#' @param option_instrument_url (string) url
#' @import httr magrittr
#' @export
api_instruments_options <- function(RH, option_instrument_url) {

  # URL and token
  url <- option_instrument_url
  token <- paste("Bearer", RH$tokens.access_token)

  # GET call
  dta <- GET(url,
             add_headers("Accept" = "application/json",
                         "Content-Type" = "application/json",
                         "Authorization" = token))

  # Format return
  dta <- mod_json(dta, "fromJSON")
  dta <- as.data.frame(dta)

  dta <- dta %>%
    dplyr::mutate_at(c("strike_price"), function(x) as.numeric(as.character(x))) %>%
    dplyr::mutate_at(c("issue_date", "expiration_date"), lubridate::ymd) %>%
    dplyr::mutate_at(c("created_at", "updated_at"), lubridate::ymd_hms)
    
  return(dta)
}
