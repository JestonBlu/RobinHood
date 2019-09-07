#' RobinHood API: Cryptocurrency Positions
#'
#' Backend function called by get_positions(). Returns a data frame of crypto position data via the Nummus api.
#'
#' @param RH object of class RobinHood
#' @import curl magrittr
#' @export
api_positions_crypto <- function(RH) {

  positions_url <- api_endpoints("holdings_crypto", source = "crypto")

  positions <- new_handle() %>%
    handle_setheaders("Accept" = "application/json") %>%
    handle_setheaders("Authorization" = paste("Bearer", RH$tokens.access_token)) %>%
    curl_fetch_memory(url = positions_url)

  positions <- jsonlite::fromJSON(rawToChar(positions$content))
  positions <- positions$results

  positions_qty <- data.frame(
    currency_code = positions$currency$code,
    name          = positions$currency$name,
    quantity      = positions$quantity,
    type          = positions$currency$type,
    created_at    = positions$created_at
  )

  positions_qty <- positions_qty[positions_qty$type == "cryptocurrency", ]

  positions_cost <- positions$cost_bases

  cost <- c()

  for (i in 1:(length(positions_cost) - 1)) {
    x <- positions_cost[[i]]
    cost <- c(cost, x$direct_cost_basis
    )
  }

  positions_qty$cost_bases <- cost

  # Reformat columns
  positions_qty$quantity <- as.numeric(as.character(positions_qty$quantity))
  positions_qty$cost_bases <- as.numeric(as.character(positions_qty$cost_bases))
  positions_qty$created_at <- lubridate::ymd_hms(positions_qty$created_at)
  positions_qty$currency_code <- as.character(positions_qty$currency_code)

  # Rename currency_code to symbol
  colnames(positions_qty)[1] <- "symbol"

  return(positions_qty)
}
