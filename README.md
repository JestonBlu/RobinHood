![](https://travis-ci.org/JestonBlu/RobinHood.svg?branch=master)
![](https://img.shields.io/github/downloads/jestonblu/RobinHood/total.svg)

# RobinHood
An R Interface for the RobinHood.com no commision investing site. This project is in early development and currently has just a few features. Once I get a basic set of usuable feature created then I will stop doing development on the master branch and move development branches with releases

# Current Features
  - Log in
  - Log out
  - Get current investment positions with last known market price

# Pending Features
  - Place order
  - Cancel order
  - Get quote
  - Get research and social data for a ticker

```r
devtools::install_github("jestonblu/RobinHood")
```

# Basic Features
```r
library(RobinHood)

# Generates a list of relevant API keys for your account
RH = RobinHood(username = "username", password = "password")

# Returns a data.frame of positions
getPositions(RH)

# Logout
logout(RH)

```
