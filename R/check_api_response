#' RobinHood API: check_api_response
#'
#' Backend function called after GET(). Checks if API call was executed successfully.
#'
#' @param dta Data object returned by an HTTPS request to the Robinhood API
#' @export

check_api_response <- function(dta) {
  if (dta$status != 200) {
    if (dta$status == 400) {
      stop("HTTPS error 400 - Bad Request")}
    else {
      warning("HTTPS request status is not 200 - This suggests you encountered an unknown error!")
      }
    }
  }
