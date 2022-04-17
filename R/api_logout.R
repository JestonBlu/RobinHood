#' RobinHood API: Logout
#'
#' Backend function called by logout(). Sends a logout call and disables your oauth2 token.
#'
#' @param RH object of class RobinHood
#' @import httr magrittr
#' @export
api_logout <- function(RH) {

  detail <- paste("?client_id=",
                  RH$api_client_id,
                  "&token=",
                  RH$tokens.refresh_token,
                  sep = "")

  # URL
  url <- paste(api_endpoints("revoke_token"), detail, sep = "")

  dta <- POST(url)
  httr::stop_for_status(dta)
  
  dta <- dta %>%
    content(type = "json") %>%
    rawToChar()

  return(dta)

}
