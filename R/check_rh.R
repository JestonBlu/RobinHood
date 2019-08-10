#' Checks to see if you have a valid RobihHood object
#'
#' @param RH object of class RobinHood
#' @export
check_rh <- function(RH) {

    # Check if RH is the correct class
    if (class(RH) != "RobinHood") stop("RH must be class RobinHood, see RobinHood()")

}
