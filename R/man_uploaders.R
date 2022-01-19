#' Upload cloud files
#'
#' _*NOTE: If a function allows you to pass file connections, using a cloud_file
#' will be a better option for uploading files to OneDrive or SharePoint. See
#' `?cloud_file` for details.*_
#'
#' These functions handle the necessary process to take a file and place it on
#' either SharePoint or OneDrive without leaving a local artifact. This is done
#' by leveraging the automatically created OneDrive and SharePoint `ms_drive`
#' objects stored within the {m365filer} package, but the user may provide
#' their own `ms_drive` object by using upload_cloud_file.
#'
#' This function works by taking a writer object as a function. For example, if
#' you want to upload a CSV file to SharePoint, you would provide the data you'd
#' like to write, then `write.csv` into the writer parameter. Note you must pass
#' the function object itself by not passing in the parentheses. This function
#' then uses the writer to write out a temporary file, uploads that file to
#' SharePoint or OneDrive at the path specified in the `file` parameter, and
#' then cleans up after itself.
#'
#' Note that this function makes a weak assumption about the syntax of the
#' writer function. It's assumed that the first parameter will be the object
#' write, and the second object will be the file path for which the file should
#' be written. This is convention of most writer functions in R, like
#' `write_csv`, `write.csv`, `writexl::write_xlsx`, and more, but it's not
#' guaranteed.
#'
#' For information about how the file path should be specified to properly
#' assign the destination of your file, see `?ms365_help`.
#'
#' @param x Data object to be written
#' @param writer A function used to the provided data to disk
#' @param file Destination filepath appropriate for SharePoint or OneDrive
#' @param drive ms_drive object properly connected to OneDrive or SharePoint
#' @param ... Additional parameters to pass to writer
#'
#' @return Nothing
#' @export
#'
#' @family Micrsoft 365 Drive Uploaders
#' @rdname ms365_drive_uploaders
#'
#' @examples
#' \dontrun{
#' mtcars %>%
#'   upload_cloud_file(
#'     write.csv,
#'     "Leadership Team/oversight/test.csv",
#'     drive = getOption('m365filer.spdrive')
#'   )
#'
#' mtcars %>%
#'   upload_sharepoint_file(
#'     write.csv,
#'     "Leadership Team/oversight/test.csv"
#' )
#'
#' mtcars %>%
#'   upload_onedrive_file(
#'     write.csv,
#'     "Documents/test.csv"
#'  )
#'  }
upload_cloud_file <- function(x, writer, file, drive, ...) {

  if (!inherits(drive, 'ms_drive')) {
    stop('Drive object must be an ms_drive object from the Microsoft365R package',
         call. = FALSE)
  }

  # Create a tempfile and use the writer to write it out
  tmp <- tempfile()

  # This makes a weak assumption that the destination filepath is the
  # second parameter.
  writer(x, tmp, ...)

  # Use the drive object to upload the file
  drive$upload_file(tmp, dest = file)

  # Delete the temp file
  file.remove(tmp)
  invisible()
}

#' @export
#' @family Micrsoft 365 Drive Uploaders
#' @rdname ms365_drive_uploaders
upload_sharepoint_file <- function(x, writer, file,  ...) {
  upload_cloud_file(x, writer, file, drive=getOption('m365filer.spdrive'), ...)
}

#' @export
#' @family Micrsoft 365 Drive Uploaders
#' @rdname ms365_drive_uploaders
upload_onedrive_file <- function(x, writer, file,  ...) {
  upload_cloud_file(x, writer, file, drive=getOption('m365filer.onedrive'), ...)
}
