#' Microsoft 365 File Access for {atorusdepot}
#'
#' Accessing Microsoft 365 files is a bit tricky to do in R, as it's not as
#' simple as providing a URL path to an associated file. As such, {atorusdepot}
#' has some tooling built in to make the process (slightly) easier. This is all
#' built on top of the Microsoft365R package, built and maintained by the Azure
#' team.
#'
#' {atorusdepot} has setup instructions to point to the location of the separate
#' department files stored in either OneDrive of SharePoint. To set these files
#' as OneDrive or SharePoint file, follow these steps:
#'
#' * For SharePoint, the option "atorusdepot.sharepoint" must be
#'   set to the appropriate SharePoint site. For pages like Microsoft Teams - the
#'   SharePoint site would be the name of the teams channel. 
#' * When setting the file path options in your .Rprofile, specify the path to 
#'   the file using the `source_file()` function available in the example below. 
#'   The first parameter of this is the file path in SharePoint or OneDrive.
#'   * On OneDrive, the file path would start at the same level
#'   * On SharePoint, you will first need the root directory of the SharePoint 
#'     drive. This isn't always intuitive, but for the "Design and Technology - 
#'     Leadership Team" SharePoint site, the root directory is "Leadership Team"
#' * The second parameter indicates whether the file is local, on SharePoint, or 
#'   on OneDrive.
#'    * For SharePoint, assign the origin as 'sharepoint'. 
#'    * For OneDrive, assign the origin as 'onedrive'.
#' #' * When you load the package, if Microsoft365R is not installed, {atorusdepot}
#'   will prompt you if you'd like to install. Select "Y" to install. 
#' * If it's the first time you're setting up this package, there will be some 
#'   setup steps necessary. This will trigger on the first load of the package. 
#'  
#' Once these setup steps are done, everything else should function as normal. 
#' You will see intermittent messages from the Microsoft365R API package when 
#' connections are initialized or reset when tokens expire.  
#' 
#' @md
#' @export
#'
ms365_help <- function() {
  help(ms365_help)
}

#' File Origin Helpers
#' 
#' These are logical checkers to centralize determination of the source of a file.
#' Local files, OneDrive files, and SharePoint files each have different access 
#' methods - so in reading these file the origin needs to first be checked.
#'
#' @param f File path of file to check
#'
#' @family File Origin Helpers
#' @rdname file_origin_helpers
#' 
#' @return Boolean
is_sharepoint_file <- function(f) {
  inherits(f, 'sharepoint_file')
}

#' @family File Origin Helpers
#' @rdname file_origin_helpers
is_onedrive_file <- function(f) {
  inherits(f, 'onedrive_file')
}

#' @family File Origin Helpers
#' @rdname file_origin_helpers
is_cloud_file <- function(f) {
  inherits(f, 'cloud_file')
}

#' Load Microsoft API
#' 
#' This isn't a CRAN package so if it's not installed, install it for the user
#'
#' @return NULL
load_microsoft_api <- function() {
  # All of this requires Microsoft 365's R API package
  tryCatch(
    require(Microsoft365R),
    warning = function(e) {
      if (grepl("there is no package", e$message)) {
        message("Using SharePoint or OneDrive files requires {Microsoft365R}")
        resp <- readline("Do you want to install now? (Y/N)")
        if (resp == "Y") {
          # The httpuv package is necessary to open your browser automatically
          # to configure Microsoft365R
          if (!('httpuv' %in% installed.packages())) {
            install.packages('httpuv')
          }
          # Bring in the package from GitHub
          devtools::install_github("Azure/Microsoft365R")
          # Run the setup for the onedrive and sharepoint connections
          Microsoft365R::get_business_onedrive()
          Microsoft365R::list_sharepoint_sites()
        } else {
          stop(paste("Cannot use SharePoint or OneDrive files without {Microsoft365R}.",
                     "Please direct to local files instead"), call. = FALSE)
        }
      }
    }
  )
  invisible()
}