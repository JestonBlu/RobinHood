![Travis-CI](https://travis-ci.org/JestonBlu/RobinHood.svg?branch=master)
![Commit-Activity](https://img.shields.io/github/commit-activity/4w/JestonBlu/RobinHood.svg)
![CRAN Version](http://www.r-pkg.org/badges/version/RobinHood)
![CRAN Downloads](http://cranlogs.r-pkg.org/badges/RobinHood)

--------------------------------------------------------------------------------

## RobinHood
An R Interface for the RobinHood.com no commision investing site.

This project is in early development. Once I get a basic set of usuable features created then I will do a first release, submit the package to CRAN, and stop making changes to the master branch. Until then things could structurally change without notice. Please see the project page for a list of features I am working on for the initial release.

## Install with devtools
```r
devtools::install_github("jestonblu/RobinHood")
```

## Examples
```r
library(RobinHood)

# Establishes a connection with your account and generates an oauth2 token
# Returns a list style object of relevant API keys and IDs needed to interact with your account
RH = RobinHood(username = "username", password = "password")

# Returns a data.frame of positions
get_positions(RH, simple = TRUE)

#   simple_name symbol quantity average_buy_price last_trade_price cost current_value          updated_at
# 1          GE     GE        1               8.5             8.73  8.5          8.73 2019-01-10 04:19:01
# 2       Zynga   ZNGA        2               0.0             4.27  0.0          8.54 2019-01-06 16:44:03

# Get quotes
get_quote(RH, ticker = c("CAT", "GE"), simple = TRUE)

#    symbol last_trade_price last_trade_price_source
# 1    CAT       131.660000            consolidated
# 2     GE         8.980000            consolidated

# Place Order, should generate an email
x = place_order(RH = RH, symbol = "GE", type = "market", time_in_force = "gfd",
                trigger = "immediate", price = 8.96, quantity = 1, side = "buy")

# Cancel your order, should also generate an email
cancel_order(RH, x$url)

# Get market hours for a specific date
get_market_hours(RH)

#                            name     city             website   timezone acronym opens_at closes_at extended_opens_at extended_closes_at is_open       date
# 1                    IEX Market New York  www.iextrading.com US/Eastern     IEX 08:30:00  15:00:00          08:00:00           17:00:00    TRUE 2019-01-17
# 2                   Otc Markets New York  www.otcmarkets.com US/Eastern    OTCM 08:30:00  15:00:00          08:00:00           17:00:00    TRUE 2019-01-17
# 3                  NYSE Mkt Llc New York        www.nyse.com US/Eastern    AMEX 08:30:00  15:00:00          08:00:00           17:00:00    TRUE 2019-01-17
# 4                     NYSE Arca New York        www.nyse.com US/Eastern    NYSE 08:30:00  15:00:00          08:00:00           17:00:00    TRUE 2019-01-17
# 5 New York Stock Exchange, Inc. New York        www.nyse.com US/Eastern    NYSE 08:30:00  15:00:00          08:00:00           17:00:00    TRUE 2019-01-17
# 6          NASDAQ - All Markets New York      www.nasdaq.com US/Eastern  NASDAQ 08:30:00  15:00:00          08:00:00           17:00:00    TRUE 2019-01-17
# 7                 BATS Exchange New York www.batstrading.com US/Eastern    BATS 08:30:00  15:00:00          08:00:00           17:00:00    TRUE 2019-01-17

# You can identify instruments by popular tags
get_tag(RH, tag = "100-most-popular")

#       simple_name symbol
# 1           Apple   AAPL
# 2              GE     GE
# 3 Aurora Cannabis    ACB
# 4            Ford      F
# 5           Group   CRON
# 6       Microsoft   MSFT
# 7        Facebook    FB

# Get instrument fundamentals
str(get_fundamentals(RH, 'CAT'))

#'data.frame':	1 obs. of  19 variables:
# $ open                  : chr "135.020000"
# $ high                  : chr "137.710000"
# $ low                   : chr "133.660000"
# $ volume                : chr "1629664.000000"
# $ average_volume_2_weeks: chr "4372297.200000"
# $ average_volume        : chr "5479200.247000"
# $ high_52_weeks         : chr "173.100000"
# $ dividend_yield        : chr "1.967200"
# $ low_52_weeks          : chr "112.060000"
# $ market_cap            : chr "79392956900.000000"
# $ pe_ratio              : chr "21.800580"
# $ shares_outstanding    : chr "590106711.000000"
# $ ceo                   : chr "Donald James Umpleby, III"
# $ headquarters_city     : chr "Deerfield"
# $ headquarters_state    : chr "Illinois"
# $ sector                : chr "Producer Manufacturing"
# $ industry              : chr "Trucks Or Construction Or Farm Machinery"
# $ num_employees         : int 98400
# $ year_founded          : int 1925

# Watchlist commands, currently creating and removing watchlists isn't working
watchlist(RH, action = 'get')
# [1] "Default"

watchlist(RH, action = 'get', watchlist = 'Default') # get results
# [1] "AAPL" "TWTR" "TSLA" "NFLX" "FB"   "MSFT" "DIS"  "GPRO" "SBUX" "F"    "BABA" "BAC"  "FIT"  "GE"   "SNAP"

watchlist(RH, action = 'add', watchlist = 'Default', ticker = "CAT") # returns empty list
# [1] "Instrument added to watchlist"

watchlist(RH, action = 'delete', watchlist = 'Default', ticker = 'CAT')  # returns empty list
# [1] "Instrument removed from watchlist"

# Logout and revoke your oauth2 token
logout(RH)


```
