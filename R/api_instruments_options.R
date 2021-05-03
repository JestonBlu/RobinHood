#' RobinHood API: Option Contracts
#'
#' Backend function or retrieving option contracts.
#'
#' @param RH object of class RobinHood
#' @param method (string) one of ("url", "symbol")
#' @param option_instrument_url (string) direct url for an option contract
#' @param chain_symbol (string) stock symbol
#' @param type (string) one of ("put", "call")
#' @param state (string) one of ("active", "inactive")
#' @param strike_price (numeric) strike price
#' @param tradability (string) one of ("tradable", "untradable")
#' @param expiration_date (string) expiration date ("YYYY-MM-DD")
#' @import httr magrittr
#' @export
api_instruments_options <- function(RH, method = "url", option_instrument_url = NULL,
                                    chain_symbol = NULL, type = NULL, state = NULL,
                                    strike_price = NULL, tradability = NULL,
                                    expiration_date = NULL) {

  if (method == "url") {

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

    # Format output
    dta <- dta %>%
      dplyr::rename("above_tick" = "min_ticks.above_tick",
                    "below_tick" = "min_ticks.below_tick",
                    "cutoff_price" = "min_ticks.cutoff_price") %>%
      dplyr::mutate_at(c("strike_price", "above_tick", "below_tick", "cutoff_price"), as.numeric) %>%
      dplyr::mutate_at(c("created_at", "updated_at", "sellout_datetime"), lubridate::ymd_hms) %>%
      dplyr::mutate_at(c("expiration_date", "issue_date"), lubridate::ymd)

    return(dta)
  }

  if (method == "symbol") {
    # URL and token
    url <- paste0(api_endpoints("option_instruments"), "?",
                  "chain_symbol=", chain_symbol,
                  "&type=", type,
                  "&state=", state,
                  "&tradability=", tradability,
                  "&strike_price=", strike_price)

    token <- paste("Bearer", RH$tokens.access_token)

    # GET call
    dta <- GET(url,
               add_headers("Accept" = "application/json",
                           "Content-Type" = "application/json",
                           "Authorization" = token))

    # Format return
    dta <- mod_json(dta, "fromJSON")
    output <- as.data.frame(dta$results)

    output <- cbind(output[, names(output) != "min_ticks"],
                    output[, names(output) == "min_ticks"])

    # Cycle through the pages
    while (length(dta$`next`) > 0) {

      # URL
      url <- dta$`next`

      # GET call
      dta <- GET(url,
                 add_headers("Accept" = "application/json",
                             "Content-Type" = "application/json",
                             "Authorization" = token))

      # Format return
      dta <- mod_json(dta, "fromJSON")

      dta2 <- dta$results

      # Separate embedded dataframe
      dta2 <- cbind(dta2[, names(dta2) != "min_ticks"],
                    dta2[, names(dta2) == "min_ticks"])

      output <- rbind(output, dta2)

      profvis::pause(.25)
    }

    # Filter to expiration date if provided
    if (!is.null(expiration_date)) {
      output <- subset(output, expiration_date == expiration_date)
    }

    # Format output
    output <- output %>%
      dplyr::mutate_at(c("strike_price", "above_tick", "below_tick", "cutoff_price"), as.numeric) %>%
      dplyr::mutate_at(c("created_at", "updated_at", "sellout_datetime"), lubridate::ymd_hms) %>%
      dplyr::mutate_at(c("expiration_date", "issue_date"), lubridate::ymd)


    return(output)
  }
}
