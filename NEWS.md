---
title: "NEWS"
---

# RobinHood 1.6.6
  
## Bug Fixes  
  - [(GH-151)](https://github.com/JestonBlu/RobinHood/issues/151): Updated `api_login` to fix a change in the api
    - Redesigned RH object, added more transparency in API return
    - Temporarily disabled the non-MFA login method

-------------------------------------------------------------------------------
# RobinHood 1.6.5
## Bug Fixes
  - [(GH-147)](https://github.com/JestonBlu/RobinHood/issues/99): Added HTTPS validation check to make cryptic errors less likely (@JanLauGe)

-------------------------------------------------------------------------------

# RobinHood 1.6.4
## Bug Fixes
  - [(GH-99)](https://github.com/JestonBlu/RobinHood/issues/99) `RobinHood()` issues with tbl_vars 
  - [(GH-146)](https://github.com/JestonBlu/RobinHood/issues/146) `RobinHood()` issues with tbl_vars (@JanLauGe)

-------------------------------------------------------------------------------
# RobinHood 1.6.3
## Bug Fixes
  - [(GH-141)](https://github.com/JestonBlu/RobinHood/issues/141) `get_positions_options()` Column state doesn't exist #141 (@fouslim)

-------------------------------------------------------------------------------
# RobinHood 1.6.2
## Bug Fixes
  - [(GH-139)](https://github.com/JestonBlu/RobinHood/issues/139) `get_positions_options()`, `get_contracts()`: fixed api change (@fouslim, @SwingBotScripts)
-------------------------------------------------------------------------------
# RobinHood 1.6.1
## New Features
  - [(GH-123)](https://github.com/JestonBlu/RobinHood/issues/123) `api_historicals_options()`: (@jgQuantScripts)
  - [(GH-123)](https://github.com/JestonBlu/RobinHood/issues/123) `get_historicals_options()`: (@jgQuantScripts)

## Bug Fixes
## Clean up
  - [(GH-122)](https://github.com/JestonBlu/RobinHood/issues/122): `place_order()`: added default parameter value `price = NA` (@kmohammadi6)
## Documentation
  - [(GH-122)](https://github.com/JestonBlu/RobinHood/issues/122): `place_order()`: added stop loss example (@kmohammadi6)

-------------------------------------------------------------------------------
# RobinHood 1.6
## New Features
  - [(GH-74)](https://github.com/JestonBlu/RobinHood/issues/74) `get_ratings()`: returns analyst rating and comments for a particular instrument
  - [(GH-117)](https://github.com/JestonBlu/RobinHood/issues/117) `get_positions_crypto()`: added average_price field
  - [(GH-116)](https://github.com/JestonBlu/RobinHood/issues/116) New function `get_historicals_crypto()` (@jgQuantScripts)
## Bug Fixes
  - [(GH-108)](https://github.com/JestonBlu/RobinHood/issues/108) `get_tickers()`: no longer fails when call returns no info about a given equity symbol
  - [(GH-110)](https://github.com/JestonBlu/RobinHood/issues/110) `get_positions_crypto()`: no longer fails when you have a position in a single crypto only
  - [(GH-115)](https://github.com/JestonBlu/RobinHood/issues/115) `get_order_history_crypto()`: no longer limits you to the last 75 records
  - [(GH-103)](https://github.com/JestonBlu/RobinHood/issues/103) `get_positions()`: now returns a message when no positions are found
  - [(GH-111)](https://github.com/JestonBlu/RobinHood/issues/103) `api_marketdata()`: fixed dataframe conversion error (@fouslim)
  - [(GH-113)](https://github.com/JestonBlu/RobinHood/issues/113) `watchlist()`: fixed broken function due to api change
## Clean up
  - [(GH-101)](https://github.com/JestonBlu/RobinHood/issues/101) `place_order()`: no longer prevents you from trading fractional shares
  - [(GH-114)](https://github.com/JestonBlu/RobinHood/issues/114) `get_positions_crypto()` swapped out `average_price` for `mark_price`, eliminating rounding errors
  - `get_order_history_crypto()`: USD references have been stripped out of `name` and `symbol`, should look cleaner now
  - Fixed various documentation typos

## Documentation
  - Updated layout of site
  - Added network plots displaying how functions are linked within the package

-------------------------------------------------------------------------------

# RobinHood 1.5

## New Features
  - MFA is now enabled via the `RobinHood(username, password, mfa_code)` function. Use your authentication app to input your code. This is optional and only required if you have enabled MFA on your RobinHood account.

-------------------------------------------------------------------------------

# RobinHood 1.4

## New features
  - Added functions for trading options:
    - `get_positions_options()`: gets your owned options contracts
    - `get_contracts()`: get current open contracts
    - `place_order_options()`: plan a buy order on a contract
    - `get_order_status_options()`: check the status of an existing order
    - `cancel_order_options()`: cancel an existing order

## Bug Fixes
  - Fixed an issue where get fundamental returned the entire vector of symbols in every row, now its one symbol per row

## Clean up
  - `api_positions()` now only returns positions you still own

-------------------------------------------------------------------------------

# RobinHood 1.3.1

## Clean up
  - [(GH-86)](https://github.com/JestonBlu/RobinHood/issues/86) `get_market_hours()`, `get_historicals()` by default returned times in UTC. The default format has been changed to the local users timezone. The timezone column now also reflects the timezone of the actual time, not the time zone of the exchange which comes from RobinHood.

-------------------------------------------------------------------------------

# RobinHood 1.3

## New Features
  - [(GH-50)](https://github.com/JestonBlu/RobinHood/issues/50) Added `get_ach()`, `place_ach_transfer()`, `cancel_ach_transfer()` which allows transfers between linked bank accounts and RobinHood

## Clean up
  - [(GH-85)](https://github.com/JestonBlu/RobinHood/issues/85) Made cancel_url, status_url consistent across equity, crypto, and ach orders (crypto status requires an ID instead of staus_url so it has been left alone)
  - Cleaned up old comments
  - Fixed bad example code references
  - Fixed date format warning on `get_quote()`


-------------------------------------------------------------------------------

# RobinHood 1.2.5

## Bug Fixes
  - Fixed an API change that broke `get_positions()`
  - Fixed an API change that broke `get_order_history_crypto()`

-------------------------------------------------------------------------------

# RobinHood 1.2.4

## Bug Fixes
  - fixed quantity check in `place_order_crypto()` so that it allows fractional share purchases

## Clean up
  - added `page_size = 1000` as the default parameter for `get_order_history()`

-------------------------------------------------------------------------------

# RobinHood 1.2.3
  - `get_tickers()`: fixed an issue where `get_tickers(RH, fundamentals = TRUE)` would return an error when a tickers fundamental data is empty

# RobinHood 1.2.1

## Bug fixes
  - `place_orders_crypto()`: fixed a typo in the api url preventing it from working
  - `place_orders()`: fixed an issue with limit orders that would not work without a `stop_price`
  - `cancel_order_crypto()`: fixed a typo preventing it from working
  - `get_tickers()`: fixed a typo preventing function from working
  - `logout()`: fixed broken api


-------------------------------------------------------------------------------

# RobinHood 1.2

## New Features
  - Added functions for trading crypto currency:
    - `get_order_history_crypto()`
    - `place_order_crypto()`
    - `cancel_order_crypto()`
    - `cancel_order_crypto()`
    - `get_quote_crypto()`

## Clean up
  - Fixed typo in `place_order()`
  - Changed from `curl` to `httr` for backend API calls
  - Fixed bad date format in `api_accounts`
  - Improved comments in code

-------------------------------------------------------------------------------

# RobinHood 1.0.7

## Bug fixes
  - fixed a change to the upstream login api

-------------------------------------------------------------------------------

# RobinHood 1.0.6

## New Features
  - added an optional output of `get_fundamentals()` to the output of `get_tickers()`

## Clean up
  - `get_historicals()` now returns prices formatted as numeric
  - `get_fundamentals()` now returns as a data frame instead of a list

-------------------------------------------------------------------------------

# RobinHood 1.0.5

## Bug fixes
  - `get_positions()`
    - fixed an issue that throws an error when you own no shares
    - fixed an issue that throws an error when one of your investments has no "Simple Name" value in the api

## New Features
  - `get_historicals()`: added a new function for pulling historical prices
  - `get_portfolios()`: added a new function for pulling current and historical portfolio values
  - `get_order_history()`: added an additional field `created_at`

## Clean up
  - Reorganized some of the api_functions to make more calls go through `api_instruments()` when pulling instrument meta data
