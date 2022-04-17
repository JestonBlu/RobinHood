#' RobinHood API: Currency Pairs
#'
#' Returns the ID for a particular paired currency
#'
#' @param RH object of class RobinHood
#' @import httr magrittr
#' @export
api_currency_pairs <- function(RH) {

  # URL and token
  url <- api_endpoints("currency_pairs", "crypto")
  token <- paste("Bearer", RH$tokens.access_token)

  # GET call
  dta <- GET(url,
             add_headers("Accept" = "application/json",
                         "Content-Type" = "application/json",
                         "Authorization" = token))
  httr::stop_for_status(dta)
  
  # Format return
  dta <- mod_json(dta, "fromJSON")
  dta <- as.list(dta$results)
  
  # ID is used for quotes and orders
  # Asset ID is used for historicals
  dta <- data.frame(
    id = dta$id,
    name = dta$name,
    symbol = dta$symbol,
    tradability = dta$tradability,
    asset_code = dta$asset_currency$code,
    asset_name = dta$asset_currency$name,
    max_order_size = dta$max_order_size,
    min_order_size = dta$min_order_size,
    min_order_price_increment = dta$min_order_price_increment,
    min_order_quantity_increment = dta$min_order_quantity_increment
    
  )

  return(dta)
}
