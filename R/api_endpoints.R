#' RobinHood API: Endpoints
#'
#' Backend function called by almost every function. Returns the appropriate starting URL for a given endpoint.
#'
#' @export
#' @param endpoint (string) which api endpoint to look up?
api_endpoints <- function(endpoint) {

  api.endpoint <- list(
    url                = "https://api.robinhood.com/",
    accounts           = "accounts/",
    fundamentals       = "fundamentals/?symbols=",
    historicals        = "quotes/historicals/",
    markets            = "markets/",
    options            = "options",
    option_positions   = "options/positions/",
    option_history     = "options/orders/",
    option_instruments = "options/instruments",
    orders             = "orders/",
    portfolios         = "portfolios/",
    quotes             = "quotes/?symbols=",
    tags               = "midlands/tags/tag/",
    instruments        = "instruments/",
    token              = "oauth2/token/",
    revoke_token       = "oauth2/revoke_token/",
    user               = "user/",
    watchlist          = "watchlists/"
  )

  x <- which(names(api.endpoint) == endpoint)

  endpoint <- paste(api.endpoint$url, as.character(api.endpoint[x]), sep = "")

  return(endpoint)
}
