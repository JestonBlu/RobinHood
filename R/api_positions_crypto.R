#' RobinHood API: Cryptocurrency Positions
#'
#' Backend function called by get_positions(). Returns a data frame of crypto position data via the Nummus api.
#'
#' @param RH object of class RobinHood
#' @import httr magrittr
#' @export
api_positions_crypto <- function(RH) {

  # URL and token
  url <- api_endpoints("holdings_crypto", source = "crypto")
  token <- paste("Bearer", RH$tokens.access_token)

  # GET call
  dta <- GET(url,
             add_headers("Accept" = "application/json",
                         "Content-Type" = "application/json",
                         "Authorization" = token))

  # format return
  dta <- mod_json(dta, "fromJSON")
  dta <- as.list(dta$results)

  # Create data.frame with output
  dta_qty <- data.frame(
    currency_code = dta$currency$code,
    name          = dta$currency$name,
    quantity      = dta$quantity,
    type          = dta$currency$type,
    created_at    = dta$created_at
  )

  # API works with all forex, only return cryto currency
  dta_qty <- dta_qty[dta_qty$type == "cryptocurrency", ]

  # Extract cost basis and combine with return
  dta_cost <- dta$cost_bases
  cost <- c()

  for (i in 1:(length(dta_cost) - 1)) {
    x <- dta_cost[[i]]
    cost <- c(cost, x$direct_cost_basis
    )
  }

  dta_qty$cost_bases <- cost

  # Reformat columns
  dta_qty <- dta_qty %>%
    dplyr::mutate_at(c("quantity", "cost_bases"), as.numeric) %>%
    dplyr::mutate_at("currency_code", as.character) %>%
    dplyr::mutate_at("created_at", lubridate::ymd_hms)

  # Rename currency_code to symbol
  colnames(dta_qty)[1] <- "symbol"

  return(dta_qty)
}
