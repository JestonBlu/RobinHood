#' Get personal user data related to your RobinHood account
#'
#' @param RH object class RobinHood
#' @import curl magrittr
#' @export
#' @examples
#' \dontrun{
#' # Login in to your RobinHood account
#' RH <- RobinHood("username", "password")
#'
#' get_user(RH)
#'}
get_user <- function(RH) {
  if (class(RH) != "RobinHood") stop("RH must be class RobinHood, see RobinHood()")

  user <- api_user(RH)
  user$created_at <-  lubridate::ymd_hms(user$created_at)

  return(user)

}
