
<!-- README.md is generated from README.Rmd. Please edit that file -->

# m365filer

<!-- badges: start -->

[<img src="https://img.shields.io/badge/License-MIT-blue.svg">](https://github.com/atorus-research/Tplyr/blob/master/LICENSE)
[![Lifecycle:
experimental](https://img.shields.io/badge/lifecycle-experimental-orange.svg)](https://lifecycle.r-lib.org/articles/stages.html#experimental-1)
<!-- badges: end -->

Welcome! If you haven’t seen Microsoft’s
[Microsoft365R](https://github.com/Azure/Microsoft365R) package, I
suggest you check it out! It provides a sleek, high level interface into
Microsoft’s Graph API leveraging the facilities provided by the
[AzureGraph](https://cran.r-project.org/package=AzureGraph) package.

The aim of m365filer is much more simple in scope. While Microsoft365R
has broad range of capabilities, m365filer focuses only on file handling
and interfacing with Microsoft drives such as OneDrive and SharePoint.
The specific goal of m365filer is to make the experience of reading and
writing files to OneDrive feel more natural and intuitive to your
typical R Programmer.

## Installation

You can install the released version of m365filer via GitHub with:

``` r
# install.packages("devtools")
devtools::install_github("atorus-research/m365filer")
```

## Setup

A prerequisite of using m365filer is setting up your connection to
OneDrive or SharePoint. Note that if you’re trying to use corporate
systems, there will likely be some coordination necessary with your
Microsoft 365 Administrators. Refer to the Microsof365R [Authenticatiing
to Microsoft
365](https://github.com/Azure/Microsoft365R/blob/master/vignettes/auth.Rmd)
vignette and the [app
registration](https://github.com/Azure/Microsoft365R/blob/master/inst/app_registration.md)
documentation for instructions on getting started. Note that the user
experience within m365filer will overall be the same if you’re using a
personal OneDrive account, which allows more user level control.

``` r
library(m365filer)

# Get ms_drive object
od <- Microsoft365R::get_personal_onedrive()
#> Loading Microsoft Graph login for tenant 'consumers'
#> Access token has expired or is no longer valid; refreshing
od
#> <Personal OneDrive of Mike Stackhouse>
#>   directory id: 3cd3250ef3665b2e 
#> ---
#>   Methods:
#>     create_folder, create_share_link, delete, delete_item,
#>     do_operation, download_file, get_item, get_item_properties,
#>     get_list_pager, list_files, list_items, list_shared_files,
#>     list_shared_items, open_item, set_item_properties,
#>     sync_fields, update, upload_file
```

Once the drive object is available, m365filer will take it the rest of
the way:

``` r
library(dplyr)
#> 
#> Attaching package: 'dplyr'
#> The following objects are masked from 'package:stats':
#> 
#>     filter, lag
#> The following objects are masked from 'package:base':
#> 
#>     intersect, setdiff, setequal, union
mtcars %>% 
  write.csv(onedrive_file('Documents/example.csv', drive=od))

read.csv(onedrive_file('Documents/example.csv', drive=od)) %>% 
  head()
#>                   X  mpg cyl disp  hp drat    wt  qsec vs am gear carb
#> 1         Mazda RX4 21.0   6  160 110 3.90 2.620 16.46  0  1    4    4
#> 2     Mazda RX4 Wag 21.0   6  160 110 3.90 2.875 17.02  0  1    4    4
#> 3        Datsun 710 22.8   4  108  93 3.85 2.320 18.61  1  1    4    1
#> 4    Hornet 4 Drive 21.4   6  258 110 3.08 3.215 19.44  1  0    3    1
#> 5 Hornet Sportabout 18.7   8  360 175 3.15 3.440 17.02  0  0    3    2
#> 6           Valiant 18.1   6  225 105 2.76 3.460 20.22  1  0    3    1
```

## An Important Note

This package is experimental! As such, I’m not heavily committed to
function APIs and this package is generally subject to change.

## Want to help?

If you want to get your hands dirty, I’d love your input! If you have
suggestions, corrections, ideas, or requests - drop an issue
[here](https://github.com/atorus-research/m365filer/issues) on GitHub.

An area in particular that I could truly use assistance is with a unit
testing framework. The interface with Microsoft 365 systems makes this a
bit complex.
