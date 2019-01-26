#' RobinHood API: Endpoints
#'
#' Backend function called by almost every function. Returns the appropriate starting URL for a given endpoint.
#'
#' @param endpoint (string) which api endpoint to look up?
api_endpoints <- function(endpoint) {

  api.endpoint <- list(
    url = "https://api.robinhood.com/",
    token = "oauth2/token/",
    revoke_token = "oauth2/revoke_token/",
    accounts = "accounts/",
    quotes = "quotes/?symbols=",
    orders = "orders/",
    markets = "markets/",
    fundamentals = "fundamentals/?symbols=",
    tags = "midlands/tags/tag/",
    watchlist = "watchlists/",
    user = "user/",
    tickers = "instruments/"
  )

  x <- which(names(api.endpoint) == endpoint)

  ep <- paste(api.endpoint$url, as.character(api.endpoint[x]), sep = "")

  return(ep)
}
