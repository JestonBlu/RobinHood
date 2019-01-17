![Travis-CI](https://travis-ci.org/JestonBlu/RobinHood.svg?branch=master)

![Commit-Activity](https://img.shields.io/github/commit-activity/4w/JestonBlu/RobinHood.svg)
![CRAN Version](http://www.r-pkg.org/badges/version/RobinHood)
![CRAN Downloads](http://cranlogs.r-pkg.org/badges/RobinHood)


## RobinHood
An R Interface for the RobinHood.com no commision investing site.

This project is in early development and currently has just a few features. Once I get a basic set of usuable features created then I will do a first release and stop making changes to the master branch. Until then things could structurally change without notice. For a list of the features I am working on see the project page.

## Install with devtools
```r
devtools::install_github("jestonblu/RobinHood")
```


## Current Features
```r
library(RobinHood)

# Establishes a connection with your account and generates an oauth2 token
# Returns a list style object of relevant API keys and IDs needed to interact with your account
RH = RobinHood(username = "username", password = "password")

# Returns a data.frame of positions
get_positions(RH)

#  simple_name symbol quantity average_buy_price last_trade_price cost current_value          updated_at
#1          GE     GE        1               8.5             8.73  8.5          8.73 2019-01-10 04:19:01
#2       Zynga   ZNGA        2               0.0             4.27  0.0          8.54 2019-01-06 16:44:03

# Get quotes
get_quote(RH, c("CAT", "GE"))

# Logout and revoke your oauth2 token
logout(RH)

```
