#' Create a Source File Indicator
#'
#' This object is basically just a file path, except it additionally has an
#' attribute for the file origin. This is used to then be able to infer a
#' connection object based on the `source_file` object created.
#'
#' Since file connections are eliminated and garbage collected once they're
#' closed, they're unreliable as persistent objects in your R session. To get
#' around this, {m365filer} creates the file connections on demand. To
#' preserve the automation of this, this object is created, which feeds into
#' `get_file_connection()` to return a connection object, which is then used to
#' interface with OneDrive or SharePoint as necessary
#'
#' @param path File path respective to the specified origin
#' @param origin Origin of the file - either onedrive, sharepoint, or local
#'
#' @return source_file object
#' @export
#'
#' @examples
#'
#' source_file('some/file/path.txt', 'local')
#' source_file('some/file/path.txt', 'onedrive')
#' source_file('some/file/path.txt', 'sharepoint')
#'
source_file <- function(path, origin = "local") {
  structure(
    path,
    class = c("source_file", "character"),
    origin = origin
  )
}

#' Get the origin of a source file
#'
#' Return the origin of a file path
#'
#' @param file A source_file object or character string
#'
#' @return file origin as a character string
#' @export
#'
#' @examples
#'
#' fpath <- source_file('some/file/path.txt', origin='onedrive')
#' get_file_origin(fpath)
#'
get_file_origin <- function(file) {

  if (!is.character(file)) {
    stop('Must be a source_file object or character string', call.=FALSE)
  }

  origin <- attr(file, 'origin')
  if (is.null(origin)) {
    origin <- "local"
  }
  origin
}

#' Get File Connection
#'
#' Using a source file object, this function returns the file connection object.
#' {m365filer} has file connection objects built for cloud files in the
#' cloud_file object. This object is abstracted to sharepoint files and onedrive
#' files, both of which sit on the ms_drive object from the Microsoft365R
#' package.
#'
#' These objects are built on top of file connections, which allows you to
#' interface with files much the same as a local file, by simply providing to
#' the file parameter of reader or writer functions. Files are read or written
#' directly to the cloud, and temporary files that clean up with your R sessions
#' are leveraged to minimize the amount of interface that your local device has
#' to do with the cloud
#'
#' @param file A source file object
#' @param drive An ms_drive object
#'
#' @return A cloud_file object or file path
#' @export
#'
#' @examples
#' \dontrun{
#' x <- source_file("Documents/test.csv", "onedrive")
#'
#' mtcars %>% write.csv(get_file_connection(x))
#'
#' y <- read.csv(get_file_connection(x))
#' }
get_file_connection <- function(file, drive=NULL) {
  origin <- get_file_origin(file)

  if (origin == "sharepoint") {
    if (is.null(drive)) {
      drive = getOption('m365filer.spdrive')
    }
    return(sharepoint_file(file, drive=drive))
  } else if (origin == "onedrive") {
    if (is.null(drive)) {
      drive = getOption('m365filer.onedrive')
    }
    return(onedrive_file(file, drive=drive))
  } else {
    return(as.character(file))
  }

}
