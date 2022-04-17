#' RobinHood API: ACH
#'
#' Backend function for interacting and getting data on linked bank accounts.
#'
#' @param RH object of class RobinHood
#' @param action (string) one of "transfers", "relationships", "schedules", "status", "cancel", "deposit", "withdraw"
#' @param amount (numeric) amount in dollars you want to deposit or withdraw (NULL if not one of those actions)
#' @param status_url (string) URL returned by place_ach_transfer()
#' @param cancel_url (string) URL returned by place_ach_transfer()
#' @param transfer_url (string) url of your linked account, output of get_ach(RH, "relationships")
#' @import httr magrittr
#' @export
api_ach <- function(RH, action, amount = NULL, status_url = NULL, cancel_url = NULL, transfer_url = NULL) {

  if (action == "transfers") {

    # URL and token
    url <- RobinHood::api_endpoints("ach_transfers")
    token <- paste("Bearer", RH$tokens.access_token)

    # GET call
    dta <- GET(url,
               add_headers("Accept" = "application/json",
                           "Content-Type" = "application/json",
                           "Authorization" = token))
    httr::stop_for_status(dta)
    
    # format return
    dta <- RobinHood::mod_json(dta, "fromJSON")
    dta <- as.data.frame(dta$results)

    dta <- dta %>%
      dplyr::mutate_at(c("id", "ref_id", "url", "cancel", "ach_relationship", "account", "direction", "state",
                         "status_description", "scheduled", "rhs_state", "investment_schedule_id"), as.character) %>%
      dplyr::mutate_at(c("amount", "fees", "early_access_amount"), as.numeric) %>%
      dplyr::mutate_at(c("expected_landing_date"), lubridate::ymd) %>%
      dplyr::mutate_at(c("created_at", "updated_at", "expected_sweep_at", "expected_landing_datetime"), lubridate::ymd_hms)

  }


  if (action == "relationships") {

    # URL and token
    url <- RobinHood::api_endpoints("ach_relationships")
    token <- paste("Bearer", RH$tokens.access_token)

    # GET call
    dta <- GET(url,
               add_headers("Accept" = "application/json",
                           "Content-Type" = "application/json",
                           "Authorization" = token))
    httr::stop_for_status(dta)
    
    # format return
    dta <- RobinHood::mod_json(dta, "fromJSON")
    dta <- as.data.frame(dta$results)

    dta <- dta %>%
      dplyr::mutate_at(c("id", "url", "unlink", "verify_micro_deposits", "account", "bank_routing_number",
                  "bank_account_number", "bank_account_type", "bank_account_holder_name", "bank_account_nickname",
                  "verification_method", "verified", "unlinked_at", "state", "document_request"), as.character) %>%
      dplyr::mutate_at(c("initial_deposit", "withdrawal_limit"), as.numeric) %>%
      dplyr::mutate_at(c("first_created_at", "created_at"), lubridate::ymd_hms)


  }


  if (action == "schedules") {

    # URL and token
    url <- RobinHood::api_endpoints("ach_schedules")
    token <- paste("Bearer", RH$tokens.access_token)

    # GET call
    dta <- GET(url,
               add_headers("Accept" = "application/json",
                           "Content-Type" = "application/json",
                           "Authorization" = token))
    httr::stop_for_status(dta)
    
    # format return
    dta <- RobinHood::mod_json(dta, "fromJSON")
    dta <- as.data.frame(dta$results)

    # if no schedules found
    if (length(dta) == 0) {
      stop("No schedules returned")
    }

    dta <- dta %>%
      dplyr::mutate_at(c("id", "ach_relationship", "frequency", "url"), as.character) %>%
      dplyr::mutate_at(c("amount"), as.numeric) %>%
      dplyr::mutate_at(c("next_deposit_date", "last_attempt_date"), lubridate::ymd) %>%
      dplyr::mutate_at(c("created_at", "updated_at"), lubridate::ymd_hms)

  }


  if (action == "status") {

    # Token
    token <- paste("Bearer", RH$tokens.access_token)

    # GET call
    dta <- GET(status_url,
               add_headers("Accept" = "application/json",
                           "Content-Type" = "application/json",
                           "Authorization" = token)) %>%
                 content(type = "json") %>%
                 rawToChar() %>%
                 jsonlite::fromJSON() %>%
                 as.list()
    httr::stop_for_status(dta)
    
    # Select elements
    dta <- list(
      status_url = dta$url,
      cancel_url = dta$cancel,
      amount = dta$amount,
      direction = dta$direction,
      state = dta$state,
      fees = dta$fees,
      scheduled = dta$scheduled,
      early_access_amount = dta$early_access_amount,
      rhs_state = dta$rhs_state,
      created_at = dta$created_at,
      updated_at = dta$updated_at,
      expected_sweep_at = dta$expected_sweep_at,
      expected_landing_date = dta$expected_landing_datetime
    )

    # Format return
    dta$amount <- as.numeric(dta$amount)
    dta$fees <- as.numeric(dta$fees)
    dta$early_access_amount <- as.numeric(dta$early_access_amount)
    dta$created_at <- lubridate::ymd_hms(dta$created_at)
    dta$updated_at <- lubridate::ymd_hms(dta$updated_at)
    dta$expected_sweep_at <- lubridate::ymd_hms(dta$expected_sweep_at)
    dta$expected_landing_date <- lubridate::ymd_hms(dta$expected_landing_date)

  }


  if (action == "cancel") {

    # Token
    token <- paste("Bearer", RH$tokens.access_token)

    dta <- POST(cancel_url,
                add_headers("Accept" = "application/json",
                            "Content-Type" = "application/json",
                            "Authorization" = token)) %>%
                mod_json("fromJSON")
    httr::stop_for_status(dta)
    
  }


  if (action %in% c("deposit", "withdraw")) {
    # URL and token
    url <- RobinHood::api_endpoints("ach_transfers")
    token <- paste("Bearer", RH$tokens.access_token)

    # Body of call
    detail <- data.frame(ach_relationship = transfer_url,
                         amount = amount,
                         direction = action)

    # Post call
    dta <- POST(url,
                add_headers("Accept" = "application/json",
                            "Content-Type" = "application/json",
                            "Authorization" = token),
                body = mod_json(detail, "toJSON"))
    httr::stop_for_status(dta)
    
    dta <- dta %>%
      content(type = "json") %>%
      rawToChar() %>%
      jsonlite::fromJSON() %>%
      as.list()

    # Select elements
    dta <- list(
      status_url = dta$url,
      cancel_url = dta$cancel,
      amount = dta$amount,
      direction = dta$direction,
      state = dta$state,
      fees = dta$fees,
      scheduled = dta$scheduled,
      early_access_amount = dta$early_access_amount,
      rhs_state = dta$rhs_state,
      created_at = dta$created_at,
      updated_at = dta$updated_at,
      expected_sweep_at = dta$expected_sweep_at,
      expected_landing_date = dta$expected_landing_datetime
    )

    # Format return
    dta$amount <- as.numeric(dta$amount)
    dta$fees <- as.numeric(dta$fees)
    dta$scheduled <- as.logical(dta$scheduled)
    dta$early_access_amount <- as.numeric(dta$early_access_amount)
    dta$created_at <- lubridate::ymd_hms(dta$created_at)
    dta$updated_at <- lubridate::ymd_hms(dta$updated_at)
    dta$expected_sweep_at <- lubridate::ymd_hms(dta$expected_sweep_at)
    dta$expected_landing_date <- lubridate::ymd_hms(dta$expected_landing_date)

  }



  return(dta)
}
