#' RobinHood Account Authentication
#'
#' This function returns an object of S3 class RobinHood and establishes a connection to a RobinHood account.
#' It is a required input for every other function in the package.
#'
#' @param username (string) account email address
#' @param password (string) password
#' @param mfa_code (string) mfa_code provided by your authentication app (required if mfa is enabled)
#' @import httr magrittr
#' @export
#' @examples
#' \dontrun{
#' RH <- RobinHood("username", "password")
#'}
RobinHood <- function(username, password, mfa_code = NULL) {

    # Dealing with nulls inside functions
    mfa_code <- ifelse(is.null(mfa_code), "000000", mfa_code)

    # Login to RobinHood, returns RobinHood object with access tokens
    RH <- api_login(username, password, mfa_code)

    # Get account data for the main purpose of returning the position url
    accounts <- api_accounts(RH)
    url_account_id <- accounts$url

    # Return object
    RH <- c(RH, url = list(account_id = url_account_id))

    # Check to see if connection was successful
    if (is.null(RH$tokens.access_token)) {
        cat("Login not successful, check username and password.")
    }

    class(RH) <- "RobinHood"
    return(RH)
}
