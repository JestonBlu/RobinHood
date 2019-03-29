#' RobinHood API: Endpoints
#'
#' Backend function called by almost every function. Returns the appropriate starting URL for a given endpoint.
#'
#' @export
#' @param endpoint (string) which api endpoint to look up?
api_endpoints <- function(endpoint) {

  api.endpoint <- list(
    url          = "https://api.robinhood.com/",
    accounts     = "accounts/",
    fundamentals = "fundamentals/?symbols=",
    historicals  = "quotes/historicals/",
    markets      = "markets/",
    orders       = "orders/",
    quotes       = "quotes/?symbols=",
    tags         = "midlands/tags/tag/",
    tickers      = "instruments/",
    token        = "oauth2/token/",
    revoke_token = "oauth2/revoke_token/",
    user         = "user/",
    watchlist    = "watchlists/"
  )

  x <- which(names(api.endpoint) == endpoint)

  ep <- paste(api.endpoint$url, as.character(api.endpoint[x]), sep = "")

  return(ep)
}
