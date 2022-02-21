![Project Status](https://www.repostatus.org/badges/latest/active.svg) &nbsp;
![Travis-CI](https://travis-ci.org/JestonBlu/RobinHood.svg?branch=master) &nbsp;
![pkgdown](https://github.com/JestonBlu/RobinHood/workflows/pkgdown/badge.svg?branch=master) &nbsp;
![Dev Version](https://img.shields.io/badge/github-1.6.4-blue.svg) &nbsp;
![CRAN Version](http://www.r-pkg.org/badges/version/RobinHood?color=blue) &nbsp;
![CRAN Downloads](http://cranlogs.r-pkg.org/badges/grand-total/RobinHood) &nbsp;


## RobinHood
This is package is designed to help you execute trading programs in R.

**[RobinHood](https://robinhood.com)** is a no commission trading platform intended to bring investing to the masses. It is a great place to experiment with different trading strategies on a minimal investment because your trades will not be eaten up by commission fees.

Haven't signed up for a RobinHood account yet? Use my **[referral link](https://share.robinhood.com/josephb5278)**. We both get a free share of stock!


## Account Features
- [x] Account data
- [x] Add and remove investments on your watchlist
- [x] Execute ACH transfers
- [x] MFA enabled

## Equity Features
- [x] Get current holdings
- [x] Access investment statistics and quotes
- [x] Place and cancel orders
- [x] Get order status
- [x] Get price history
- [x] Get order history
- [x] Get market open/close hours
- [x] Search investments by popular tag
- [x] Calculate historical account balance
- [x] Get options market data
- [x] Get options positions
- [x] Get analyst ratings

## Crypto Features
- [x] Get current holdings
- [x] Get order history
- [x] Get quotes
- [x] Place and cancel orders
- [x] Get order status

**Note:** A key difference between the CRAN version and the Github version is that the API functions are exported and available to call directly. This is intended primarily to help with development and bug fixes. In the CRAN version, all API functions are not exported and instead are called behind the scenes.


## Installation
```r
# CRAN version
install.packages("RobinHood")

# Development version
devtools::install_github("jestonblu/RobinHood")
```
