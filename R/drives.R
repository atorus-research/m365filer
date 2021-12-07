#' Set SharePoint or OneDrive drive object to Option
#'
#' This function uses a specified SharePoint site name and uses the
#' Microsoft365R package to insert the API object into an option. Since this
#' object will be handed around different functions, the option eases the
#' hand-off across the package.
#'
#' @param sp_sitename SharePoint site name necessary to set up the API object
#'
#' @family Micrsoft API object funcs
#' @rdname microsoft_api_funs
#' 
#' @return NULL
#'
get_sp_object <- function(sp_sitename) {
  if (!is.null(sp_sitename)) {
    # Make sure the necessary package is installed
    load_microsoft_api()
    # Load the site
    message("Connecting to SharePoint...")
    sp_site <- get_sharepoint_site(sp_sitename)
    # To download files we need the associated drive
    sp_site$get_drive()
  }
}

#' @family Micrsoft API object funcs
#' @rdname microsoft_api_funs
get_od_object <- function() {
  # Make sure the necessary package is installed
  load_microsoft_api()
  message("Connecting to OneDrive...")
  get_business_onedrive()
}

#' Get OneDrive of SharePoint Drive Object
#' 
#' Both SharePoint and OneDrive have the same methods, so this can be abstracted
#' down to getting the drive object necessary to interface with the file. This
#' function uses the file path object to determine which drive object
#' should be returned
#'
#' @param file File Path as a sharepoint_file or onedrive_file
#' @param ... Reserved for potential future use
#'
#' @return ms_drive object
#' @export
#' @family Drive Retrievers
#' @rdname drive_retrievers
#'
#' @examples
#' \dontrun{
#' sp_file <- sharepoint_file('/some/sharepoint/file.txt')
#' get_drive(sp_file)
#' }
get_drive <- function(file, ...) {
  UseMethod('get_drive', file)
}

get_drive.sharepoint_file <- function(file, ...) {
  getOption('atorusdepot.spdrive')
}

get_drive.onedrive_file <- function(file, ...) {
  getOption('atorusdepot.onedrive')
}

get_drive.default <- function(file, ...) {
  stop('Object is not a cloud file', call. = FALSE)
}