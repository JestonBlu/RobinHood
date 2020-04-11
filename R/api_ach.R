#' RobinHood API: ACH
#'
#' Backend function for interacting and getting data on linked bank accounts.
#'
#' @param RH object of class RobinHood
#' @param action (string) one of "transfers", "relationships", "schedules"
#' @import httr magrittr
#' @export
api_ach <- function(RH, action) {

  if (action == "transfers") {

    # URL and token
    url <- api_endpoints("ach_transfers")
    token <- paste("Bearer", RH$tokens.access_token)

    # GET call
    dta <- GET(url,
               add_headers("Accept" = "application/json",
                           "Content-Type" = "application/json",
                           "Authorization" = token))

    # format return
    dta <- mod_json(dta, "fromJSON")
    dta <- as.data.frame(dta$results)

    dta <- dta %>%
      dplyr::mutate_at(c("id", "ref_id", "url", "cancel", "ach_relationship", "account", "direction", "state",
                         "status_description", "scheduled", "rhs_state", "investment_schedule_id"), as.character) %>%
      dplyr::mutate_at(c("amount", "fees", "early_access_amount"), as.numeric) %>%
      dplyr::mutate_at(c("expected_landing_date"), lubridate::ymd) %>%
      dplyr::mutate_at(c("created_at", "updated_at", "expected_sweep_at",
                         "expected_landing_datetime"), lubridate::ymd_hms)

  }

  if (action == "relationships") {

    # URL and token
    url <- api_endpoints("ach_relationships")
    token <- paste("Bearer", RH$tokens.access_token)

    # GET call
    dta <- GET(url,
               add_headers("Accept" = "application/json",
                           "Content-Type" = "application/json",
                           "Authorization" = token))

    # format return
    dta <- mod_json(dta, "fromJSON")
    dta <- as.data.frame(dta$results)

    dta <- dta %>%
      mutate_at(c("id", "url", "unlink", "verify_micro_deposits", "account", "bank_routing_number",
                  "bank_account_number", "bank_account_type", "bank_account_holder_name", "bank_account_nickname",
                  "verification_method", "verified", "unlinked_at", "state", "document_request"), as.character) %>%
      mutate_at(c("initial_deposit", "withdrawal_limit"), as.numeric) %>%
      mutate_at(c("first_created_at", "created_at"), lubridate::ymd_hms)


  }

  if (action == "schedules") {

    # URL and token
    url <- api_endpoints("ach_schedules")
    token <- paste("Bearer", RH$tokens.access_token)

    # GET call
    dta <- GET(url,
               add_headers("Accept" = "application/json",
                           "Content-Type" = "application/json",
                           "Authorization" = token))

    # format return
    dta <- mod_json(dta, "fromJSON")
    dta <- as.data.frame(dta$results)

    dta <- dta %>%
      mutate_at(c("id", "ach_relationship", "frequency", "url"), as.character) %>%
      mutate_at(c("amount"), as.numeric) %>%
      mutate_at(c("next_deposit_date", "last_attempt_date"), lubridate::ymd) %>%
      mutate_at(c("created_at", "updated_at"), lubridate::ymd_hms)

  }

  return(dta)
}
