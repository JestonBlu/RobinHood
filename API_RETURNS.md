
##### **api_accounts.R**

| Field                                     | Type | Description |
| ----------------------------------------- | ---- | ----------- |
| rhs_account_number                        |      |             |
| deactivated                               |      |             |
| updated_at                                |      |             |
| margin_balances                           |      |             |
| .. updated_at                             |      |             |
| .. gold_equity_requirement                |      |             |
| .. outstanding_interest                   |      |             |
| .. cash_held_for_options_collateral       |      |             |
| .. uncleared_nummus_deposits              |      |             |
| .. overnight_ratio                        |      |             |
| .. day_trade_buying_power                 |      |             |
| .. cash_available_for_withdrawal          |      |             |
| .. sma                                    |      |             |
| .. cash_held_for_nummus_restrictions      |      |             |
| .. marked_pattern_day_trader_date         |      |             |
| .. unallocated_margin_cash                |      |             |
| .. start_of_day_dtbp                      |      |             |
| .. overnight_buying_power_held_for_orders |      |             |
| .. day_trade_ratio                        |      |             |
| .. cash_held_for_orders                   |      |             |
| .. unsettled_debit                        |      |             |
| .. created_at                             |      |             |
| .. cash_held_for_dividends                |      |             |
| .. cash                                   |      |             |
| .. start_of_day_overnight_buying_power    |      |             |
| .. margin_limit                           |      |             |
| .. overnight_buying_power                 |      |             |
| .. uncleared_deposits                     |      |             |
| .. unsettled_funds                        |      |             |
| .. day_trade_buying_power_held_for_orders |      |             |
| portfolio                                 |      |             |
| cash_balances                             |      |             |
| can_downgrade_to_cash                     |      |             |
| withdrawal_halted                         |      |             |
| cash_available_for_withdrawal             |      |             |
| state                                     |      |             |
| type                                      |      |             |
| sma                                       |      |             |
| sweep_enabled                             |      |             |
| deposit_halted                            |      |             |
| buying_power                              |      |             |
| user                                      |      |             |
| max_ach_early_access_amount               |      |             |
| option_level                              |      |             |
| instant_eligibility                       |      |             |
| .. updated_at                             |      |             |
| .. reason                                 |      |             |
| .. reinstatement_date                     |      |             |
| .. reversal                               |      |             |
| .. state                                  |      |             |
| cash_held_for_orders                      |      |             |
| only_position_closing_trades              |      |             |
| url                                       |      |             |
| positions                                 |      |             |
| created_at                                |      |             |
| cash                                      |      |             |
| sma_held_for_orders                       |      |             |
| unsettled_debit                           |      |             |
| account_number                            |      |             |
| is_pinnacle_account                       |      |             |
| uncleared_deposits                        |      |             |
| unsettled_funds                           |      |             |

##### **api_fundamentals.R**

| Field                  | Type | Description |
| ---------------------- | ---- | ----------- |
| open                   |      |             |
| high                   |      |             |
| low                    |      |             |
| volume                 |      |             |
| average_volume_2_weeks |      |             |
| average_volume         |      |             |
| high_52_weeks          |      |             |
| dividend_yield         |      |             |
| low_52_weeks           |      |             |
| market_cap             |      |             |
| pe_ratio               |      |             |
| shares_outstanding     |      |             |
| description            |      |             |
| instrument             |      |             |
| ceo                    |      |             |
| headquarters_city      |      |             |
| headquarters_state     |      |             |
| sector                 |      |             |
| industry               |      |             |
| num_employees          |      |             |
| year_founded           |      |             |

##### **api_instruments.R**

| Field                | Type | Description |
| -------------------- | ---- | ----------- |
| margin_initial_ratio |      |             |
| rhs_tradability      |      |             |
| id                   |      |             |
| market               |      |             |
| simple_name          |      |             |
| min_tick_size        |      |             |
| maintenance_ratio    |      |             |
| tradability          |      |             |
| state                |      |             |
| type                 |      |             |
| tradeable            |      |             |
| fundamentals         |      |             |
| quote                |      |             |
| symbol               |      |             |
| day_trade_ratio      |      |             |
| name                 |      |             |
| tradable_chain_id    |      |             |
| splits               |      |             |
| url                  |      |             |
| country              |      |             |
| bloomberg_unique     |      |             |
| list_date            |      |             |

##### **api_login.R**
See RobinHood function

##### **api_logout**
If successful returns nothing


##### **api_markets.R**

| Field         | Type | Description |
| ------------- | ---- | ----------- |
| website       |      |             |
| city          |      |             |
| name          |      |             |
| url           |      |             |
| country       |      |             |
| todays_hours  |      |             |
| operating_mic |      |             |
| acronym       |      |             |
| timezone      |      |             |
| mic           |      |             |


##### **api_orders.R**

| Field                     | Type | Description |
| ------------------------- | ---- | ----------- |
| updated_at                |      |             |
| ref_id                    |      |             |
| time_in_force             |      |             |
| fees                      |      |             |
| cancel                    |      |             |
| response_category         |      |             |
| id                        |      |             |
| cumulative_quantity       |      |             |
| stop_price                |      |             |
| reject_reason             |      |             |
| instrument                |      |             |
| state                     |      |             |
| trigger                   |      |             |
| override_dtbp_checks      |      |             |
| type                      |      |             |
| last_transaction_at       |      |             |
| price                     |      |             |
| executions                |      |             |
| extended_hours            |      |             |
| account                   |      |             |
| url                       |      |             |
| created_at                |      |             |
| side                      |      |             |
| override_day_trade_checks |      |             |
| position                  |      |             |
| average_price             |      |             |
| quantity                  |      |             |

##### **api_positions.R**

| Field                              | Type | Description |
| ---------------------------------- | ---- | ----------- |
| shares_held_for_stock_grants       |      |             |
| account                            |      |             |
| pending_average_buy_price          |      |             |
| shares_held_for_options_events     |      |             |
| intraday_average_buy_price         |      |             |
| url                                |      |             |
| shares_held_for_options_collateral |      |             |
| created_at                         |      |             |
| updated_at                         |      |             |
| shares_held_for_buys               |      |             |
| average_buy_price                  |      |             |
| instrument                         |      |             |
| intraday_quantity                  |      |             |
| shares_held_for_sells              |      |             |
| shares_pending_from_options_events |      |             |
| quantity                           |      |             |

##### **api_quote.R**

| Field                           | Type | Description |
| ------------------------------- | ---- | ----------- |
| symbol                          |      |             |
| last_trade_price                |      |             |
| last_trade_price_source         |      |             |
| ask_price                       |      |             |
| ask_size                        |      |             |
| bid_price                       |      |             |
| bid_size                        |      |             |
| previous_close                  |      |             |
| adjusted_previous_close         |      |             |
| previous_close_date             |      |             |
| last_extended_hours_trade_price |      |             |
| trading_halted                  |      |             |
| has_traded                      |      |             |
| updated_at                      |      |             |

##### **api_tag.R**

##### **api_tickers.R**

| Field                | Type | Description |
| -------------------- | ---- | ----------- |
| margin_initial_ratio |      |             |
| rhs_tradability      |      |             |
| id                   |      |             |
| market               |      |             |
| simple_name          |      |             |
| min_tick_size        |      |             |
| maintenance_ratio    |      |             |
| tradability          |      |             |
| state                |      |             |
| type                 |      |             |
| tradeable            |      |             |
| fundamentals         |      |             |
| quote                |      |             |
| symbol               |      |             |
| day_trade_ratio      |      |             |
| name                 |      |             |
| tradable_chain_id    |      |             |
| splits               |      |             |
| url                  |      |             |
| country              |      |             |
| bloomberg_unique     |      |             |
| list_date            |      |             |

##### **api_user.R**

| Field              | Type | Description |
| ------------------ | ---- | ----------- |
| username           |      |             |
| first_name         |      |             |
| last_name          |      |             |
| id_info            |      |             |
| url                |      |             |
| email_verified     |      |             |
| created_at         |      |             |
| basic_info         |      |             |
| email              |      |             |
| investment_profile |      |             |
| id                 |      |             |
| international_info |      |             |
| employment         |      |             |
| additional_info    |      |             |

##### **api_watchlist.R**
