#' Get a option contracts from RobinHood
#'
#' @param RH object class RobinHood
#' @param chain_symbol (string) a single ticket symbol
#' @param type (string) one of call or put
#' @param detail (logical) if TRUE (default) return additional info on greeks, prevous day, high/low fill rate prices
#' @import httr magrittr
#' @export
#' @examples
#' \dontrun{
#' # Login in to your RobinHood account
#' RH <- RobinHood("username", "password")
#'
#' get_contracts(RH, "IR")
#'}
get_contracts <- function(RH, chain_symbol, type, detail = FALSE) {

  # Check if RH is valid
  RobinHood::check_rh(RH)

  # Get last price
  contracts <- RobinHood::api_contracts(RH, chain_symbol, type)

  # Remove conflicting updated_at
  contracts <- contracts %>% dplyr::select(-c("updated_at"))

  # Get market data on contracts, split up calls into 50 instruments at a time
  market_data <- data.frame()

  # How many calls to make
  no_calls <- ceiling(nrow(contracts) / 50)

  for (i in 1:no_calls) {

    # Get vector or urls to call
    x <- seq(i * 50 - 49, i * 50)

    # Get urls
    instruments <- as.character(stats::na.omit(contracts$url[x]))
    instruments <- paste(instruments, collapse = ",")

    intr_market_data <- RobinHood::api_marketdata(RH, instruments, type = "insturment_url")

    market_data <- rbind(market_data, intr_market_data)

  }

  # Join with contracts
  market_data <- market_data %>%
    dplyr::rename("url" = "instrument")

  contracts <- dplyr::inner_join(contracts, market_data, by = "url")

  # Select columns
  if (detail == TRUE) {

    return(contracts)

    } else {

      contracts <- contracts %>%
        dplyr::select(-c("chain_id", "id", "url", "long_strategy_code",
                         "short_strategy_code", "instrument_id"))

      }

  return(contracts)

}
