#' Get Filepaths for Cloud File or Local Version
#'
#' OneDrive files must be downloaded before they can be accessed. This function
#' gives the filename back as the local directory path where the file is synced
#' locally or the path necessary for pulling the file from the cloud
#'
#' @param file SharePoint file path or OneDrive file path
#'
#' @return File name
#'
#' @family File Paths
#' @rdname file_paths
#'
#' @examples
#'
#' sp_file <- sharepoint_file('/some/sharepoint/file.txt')
#' get_local_filename(sp_file)
#' 
get_local_filename <- function(file) {
  attr(file, 'src')
}

#' @family File Paths
#' @rdname file_paths
get_cloud_filename <- function(file) {
  attr(file, 'path')
}

#' Get the timestamp of a file as a datetime
#'
#' This function gets the timestamp of a file as a datetime object so that the
#' file timestamps may be compared properly. Different S3 dispatches are
#' available for handling local files vs. SharePoint
#'
#' @param file File path
#' @param sp_drive SharePoint drive API object
#' @param ...
#'
#' @return Datetime object
#'
#' @examples
#' get_file_timestamp('/some/local/file.txt')
#'
#' sp_file <- sharepoint_file('/some/sharepoint/file.txt')
#' get_file_timestamp(sp_file, sp_drive = getOption('atorusdepot.spdrive'))
#' 
get_file_timestamp <-function(file, ...) {
  UseMethod("get_file_timestamp", file)
}

get_file_timestamp.cloud_file <- function(file, ...) {
  drive <- get_drive(file)
  path <- attr(file, 'path')
  as_datetime(drive$get_item_properties(path)$fileSystemInfo$lastModifiedDateTime)
}

get_file_timestamp.default <- function(file, ...) {
  file.info(file)$mtime
}

#' Check if the local version of a SharePoint or OneDrive file is current
#'
#' OneDrive files must be downloaded before they can be accessed. This function
#' takes the OneDrive or SharePoint file path and compares against a file stored 
#' in the temporary directory. If there is no local copy of the file, FALSE
#' will be returned
#' 
#' @param file OneDrive or SharePoint file path (to be passed to API)
#'
#' @return Boolean
#'
#' @examples
#' sp_file <- sharepoint_file('/some/sharepoint/file.txt')
#' file_is_current(sp_file)
#' 
file_is_current <- function(file) {
  cloud_file_date <- get_file_timestamp(file)
  local_file_date <- get_file_timestamp(get_local_filename(file))
  
  # Check that the cloud file is older than the local file (with a bit of a buffer)
  isTRUE(cloud_file_date <= (local_file_date + 10))
}

#' Update local copy of a cloud file
#' 
#' OneDrive files must be downloaded before they can be accessed. This function
#' updates the local version of the file by extracting the respective drive 
#' object and downloading the file using the Microsoft 365 API through
#' Microsoft365R
#'
#' @param file A cloud_file object
#'
#' @return
#' @export
#'
#' @examples
#' sp_file <- sharepoint_file('some/file/path.txt')
#' update_local_file(sp_file)
#' 
update_local_file <- function(file) {
  drive <- get_drive(file)
  local_path <- get_local_filename(file)
  cloud_path <- get_cloud_filename(file)
  
  drive$download_file(cloud_path, dest = local_path, overwrite=TRUE)
}

#' Get a file from SharePoint or OneDrive
#'
#' OneDrive files must be downloaded before they can be accessed. This function
#' takes a number of steps to extract a file from the respective cloud location
#' and returns the local path to access the file as necessary. To avoid
#' redundancy, files are stored in the current temporary R directory which is
#' cleaned when the session is ended. The time stamp of the local copy of the
#' file is always checked before any reading is done to minimize downloads as
#' necessary.
#'
#' @param con A cloud_file connection object
#' @param .close Boolean - whether or not to close the input file connection
#'
#' @return Local filename of the desired file in the R temporary directory
#'
#' @examples
#' sp_file <- sharepoint_file('/some/sharepoint/file.txt')
#' get_cloud_file(sp_file)
#' 
get_cloud_file <- function(con, .close=FALSE) {
  
  if (!is_cloud_file(con)) {
    stop("File is not a proper cloud file for {atorusdepot}", call.=FALSE)
  }
  
  # First check if the file is up to date
  if (!file_is_current(con)) {
    update_local_file(con)
  }
  
  fname <- get_local_filename(con)
  
  # Close the connection if triggered
  if (.close) {close(con)}
  
  fname
}
