
## 1.4

#### New features
  - Added functions for trading options:
    - `get_positions_options()`: gets your owned options contracts
    - `get_contracts()`: get current open contracts
    - `place_order_options()`: plan a buy order on a contract
    - `get_order_status_options()`: check the status of an existing order
    - `cancel_order_options()`: cancel an existing order

#### Bug Fixes
  - Fixed an issue where get fundamental returned the entire vector of symbols in every row, now its one symbol per row

#### Clean up
  - `api_positions()` now only returns positions you still own

-----------------------------------------------------------------------------------------------------------------------------

## 1.3.1

#### Clean up
  - (GH-86) `get_market_hours()`, `get_historicals()` by default returned times in UTC. The default format has been changed to the local users timezone. The timezone column now also reflects the timezone of the actual time, not the time zone of the exchange which comes from RobinHood.

-----------------------------------------------------------------------------------------------------------------------------

## 1.3

#### New Features
  - (GH-50) Added `get_ach()`, `place_ach_transfer()`, `cancel_ach_transfer()` which allows transfers between linked bank accounts and RobinHood

#### Clean up
  - (GH-85) Made cancel_url, status_url consistent across equity, crypto, and ach orders (crypto status requires an ID instead of staus_url so it has been left alone)
  - Cleaned up old comments
  - Fixed bad example code references
  - Fixed date format warning on `get_quote()`


-----------------------------------------------------------------------------------------------------------------------------

## 1.2.5

#### Bug Fixes
  - Fixed an API change that broke `get_positions()`
  - Fixed an API change that broke `get_order_history_crypto()`

-----------------------------------------------------------------------------------------------------------------------------

## 1.2.4

#### Bug Fixes
  - fixed quantity check in `place_order_crypto()` so that it allows fractional share purchases

#### Clean up
  - added `page_size = 1000` as the default parameter for `get_order_history()`

-----------------------------------------------------------------------------------------------------------------------------

## 1.2.3
  - `get_tickers()`: fixed an issue where `get_tickers(RH, fundamentals = TRUE)` would return an error when a tickers fundamental data is empty

## 1.2.1

#### Bug fixes
  - `place_orders_crypto()`: fixed a typo in the api url preventing it from working
  - `place_orders()`: fixed an issue with limit orders that would not work without a `stop_price`
  - `cancel_order_crypto()`: fixed a typo preventing it from working
  - `get_tickers()`: fixed a typo preventing function from working
  - `logout()`: fixed broken api


-----------------------------------------------------------------------------------------------------------------------------

## 1.2

#### New Features
  - Added functions for trading crypto currency:
    - `get_order_history_crypto()`
    - `place_order_crypto()`
    - `cancel_order_crypto()`
    - `cancel_order_crypto()`
    - `get_quote_crypto()`

#### Clean up
  - Fixed typo in `place_order()`
  - Changed from `curl` to `httr` for backend API calls
  - Fixed bad date format in `api_accounts`
  - Improved comments in code

-----------------------------------------------------------------------------------------------------------------------------

## 1.0.7

#### Bug fixes
  - fixed a change to the upstream login api

-----------------------------------------------------------------------------------------------------------------------------

## 1.0.6

#### New Features
  - added an optional output of `get_fundamentals()` to the output of `get_tickers()`

#### Clean up
  - `get_historicals()` now returns prices formatted as numeric
  - `get_fundamentals()` now returns as a data frame instead of a list

-----------------------------------------------------------------------------------------------------------------------------

## 1.0.5

#### Bug fixes
  - `get_positions()`
    - fixed an issue that throws an error when you own no shares
    - fixed an issue that throws an error when one of your investments has no "Simple Name" value in the api

#### New Features
  - `get_historicals()`: added a new function for pulling historical prices
  - `get_portfolios()`: added a new function for pulling current and historical portfolio values
  - `get_order_history()`: added an additional field `created_at`

#### Clean up
  - Reorganized some of the api_functions to make more calls go through `api_instruments()` when pulling instrument meta data
