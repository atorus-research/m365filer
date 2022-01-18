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

get_drive.cloud_file <- function(file, ...) {
  attr(file, 'drive')
}

get_drive.default <- function(file, ...) {
  stop('Object is not a cloud file', call. = FALSE)
}
