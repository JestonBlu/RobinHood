#' RobinHood API: Endpoints
#'
#' Backend function called by almost every function. Returns the appropriate starting URL for a given endpoint.
#'
#' @param endpoint (string) which api endpoint to look up?
#' @param source (string) directs api to api.robinhood.com (equity) vs nummus.robinhood.com (crypto)
#' @export
api_endpoints <- function(endpoint, source = "equity") {

  api.endpoint <- list(
    # RobinHood endpoints
    url                = "https://api.robinhood.com/",
    accounts           = "accounts/",
    ach_transfers      = "ach/transfers/",
    ach_relationships  = "ach/relationships/",
    ach_schedules      = "ach/deposit_schedules/",
    forex              = "marketdata/forex/quotes/",
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
    watchlist          = "watchlists/",
    # Nummus endpoints
    url_nummus         = "https://nummus.robinhood.com/",
    accounts_crypto    = "accounts/",
    currency_pairs     = "currency_pairs/",
    holdings_crypto    = "holdings/",
    orders_crypto      = "orders/",
    portfolios_crypto  = "portfolios/"
  )

  x <- which(names(api.endpoint) == endpoint)

  if (source == "equity") {
    endpoint <- paste(api.endpoint$url, as.character(api.endpoint[x]), sep = "")
  }

  if (source == "crypto") {
    endpoint <- paste(api.endpoint$url_nummus, as.character(api.endpoint[x]), sep = "")
  }


  return(endpoint)
}
