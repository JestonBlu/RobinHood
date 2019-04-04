#' Get porfolio summaries related to your RobinHood account
#'
#' @param RH object of class RobinHood
#' @import curl jsonlite magrittr
#' @export
#' @examples
#' \dontrun{
#' # Login in to your RobinHood account
#' RH <- RobinHood("username", "password")
#'
#' get_portfolios(RH)
#'}
get_portfolios <- function(RH) {

  if (class(RH) != "RobinHood") stop("RH must be class RobinHood, see RobinHood()")

  portfolios <- api_portfolios(RH)

  return(portfolios)

}
