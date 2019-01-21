#' Get user data
#'
#' Download a list of user data from your RobinHood account
#'
#' @param RH object class RobinHood
#' @import curl jsonlite magrittr lubridate
#' @export
get_user <- function(RH) {
  if (class(RH) != "RobinHood") stop("RH must be class RobinHood, see RobinHood()")

  user <- api_user(RH)
  user$created_at <- ymd_hms(user$created_at)

  return(user)

}
