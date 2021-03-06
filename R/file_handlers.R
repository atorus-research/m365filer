#' Cloud File Handlers
#'
#' These functions allow you to pass a SharePoint or OneDrive file path
#' directly into the destination file parameter of a function. When writing of
#' the file is done, the file will automatically be uploaded to SharePoint.
#'
#' These functions add an extra level of abstraction to a file connection
#' object. Their behavior should be exactly that of a standard file connection,
#' such as when you specify a directory path into a writer function like
#' `write.csv`. Some extra metadata has been added to provide the necessary file
#' handling to upload or download a file to or from SharePoint or OneDrive.
#'
#' When the file is closed, which is typically handled by a writer function
#' itself, the file connection is closed and the file is uploaded directly into
#' the cloud using the Microsoft365R `ms_drive` object provided (Note this only
#' happens when the mode of the file was opened to write the file. If the mode
#' was read only then no uploading is performed). Additionally, note that when
#' reading a file from OneDrive or SharePoint, the file will only be read from
#' the cloud if new updates have been made during the life of the R session.
#' This means that redundant downloading will not take place.
#'
#' To make things easier throughout your session, {m365filer} can make use of
#' the options `m365filer.onedrive` and `m365filer.spdrive`. Proper `ms_drive`
#' objects from the Microsoft365R package can be stored, and these drives will
#' automatically be recognized when calling `sharepoint_file()` or `onedrive_file()`
#'
#' For information about how the file path should be specified to properly
#' assign the destination of your file, see `?ms365_help`.
#'
#' @param path File path in SharePoint or OneDrive
#' @param drive An `ms_drive` object from the Microsoft365R package
#' @param ... Additional parameters - reserved for potential future use
#'
#' @return cloud_file object
#' @export
#' @family Microsoft 365 Cloud Paths
#' @rdname m365_cloud_files
#'
#' @examples
#' \dontrun{
#' mtcars %>%
#'   write.csv(sharepoint_file("Leadership Team/oversight/test.csv"))
#'
#' mtcars %>%
#'   write.csv(onedrive_file("Documents/test.csv"))
#'
#' mtcars %>%
#'   write.csv(
#'     cloud_file("Documents/test.csv"),
#'     drive = getOption('m365filer.onedrive')
#'   )
#' }
cloud_file <- function(path, drive, ...) {

  # Need a temp file path on disk
  src = file.path(tempdir(), basename(path))
  con = file(src)

  # Give any extra metadata
  structure(
    con,
    class = c('cloud_file', 'file', 'connection'),
    src = src,
    path = path,
    drive = drive
  )

}

#' @export
#' @family Microsoft 365 Cloud Paths
#' @rdname m365_cloud_files
sharepoint_file <- function(path, drive = getOption('m365filer.spdrive'), ...) {

  if (is.null(drive)) {
    stop('SharePoint paths will not work without a valid `drive` set', call.=FALSE)
  }

  con <- cloud_file(path, drive)

  # add an extra level to the class
  class(con) <- c('sharepoint_file', class(con))
  con
}

#' @export
#' @family Microsoft 365 Cloud Paths
#' @rdname m365_cloud_files
onedrive_file <- function(path, drive = getOption('m365filer.onedrive'), ...) {

  if (is.null(drive)) {
    stop('OneDrive paths will not work without a valid `drive` set', call.=FALSE)
  }

  con <- cloud_file(path, drive)

  # add an extra level to the class
  class(con) <- c('onedrive_file', class(con))

  con
}

#' Open or Close a Cloud File Connection
#'
#' This function does the actual closing of a cloud path object. This works by
#' closing the connection and then using the attached metadata to upload the
#' file to OneDrive or SharePoint using the attached drive.
#'
#' @param con cloud_file connection object
#' @param ... Parameters to pass forward - reserved for potential future use
#'
#' @return Nothing
#' @export
#' @family Open and Close Cloud Files
#' @rdname open_close_cloud_file
close.cloud_file <- function(con, ...) {

  # Pick out attributes needed
  src <- attr(con, 'src')
  drive <- attr(con, 'drive')
  path <- attr(con, 'path')

  if (is.null(con)) {
    stop('File connection is NULL - nothing to close')
  }

  file_mode <- summary.connection(con)$mode

  # Close the file connection
  close.connection(con)

  # Push the file up to OneDrive
  if (startsWith(file_mode, 'w')) {
    drive$upload_file(src, path)
  }
}

#' @export
#' @family Open and Close Cloud Files
#' @rdname open_close_cloud_file
open.cloud_file <- function(con, ...) {

  dots <- list(...)

  if (length(dots) > 0) {
    mode <- dots[[1]]
    if (startsWith(mode, 'r')) {
      get_cloud_file(con)
    }
  }

  open.connection(con, ...)
}

#' Summarize the Cloud File object
#'
#' Abstraction of the summary method for a connection to layer details for a
#' cloud file connection
#'
#' @param path cloud_file object
#'
#' @return Summary output of the file connection
#' @export
#'
summary.cloud_file <- function(con) {
  cat("{m365filer} M365 Cloud File\n")
  cat("Destination Path:", attr(con, 'path'), "\n")
  summary.connection(con)
}
