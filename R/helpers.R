#' Microsoft 365 File Access for {m365filer}
#'
#' Accessing Microsoft 365 files is a bit tricky to do in R, as it's not as
#' simple as providing a URL path to an associated file. As such, {m365filer}
#' has some tooling built in to make the process (slightly) easier. This is all
#' built on top of the Microsoft365R package, built and maintained by the Azure
#' team.
#'
#' To set these files as OneDrive or SharePoint file, follow these steps:
#'
#' * First, you need an appropriate `ms_drive` object. Refer to the Microsoft365R
#'   documentation for instructions on setting up your connection.
#' * {m365filer} has a few different functions available to facililate file
#'   reading, which include \link{sharepoint_file}, \link{onedrive_file}, and
#'   an alternative approach using \link{source_file}. Refer to Alternative
#'   Approaches vignette for more information on using source files. As for
#'   setting your paths on OneDrive or SharePoint, note that:
#'   * On OneDrive, the file path would start right your local OneDrive file path.
#'     For example, on my system if my local copy of the file is
#'     "C:\\Users\\16105\\OneDrive\\Documents\\file.txt", the path reference to OneDrive
#'     would be 'Documents\\file.txt'.
#'   * On SharePoint, first note that you need to get the `ms_drive` object _out_ of the
#'     SharePoint site, as the SharePoint drive is a piece of the SharePoint site itself.
#'     You will then need the root directory of the SharePoint drive. This isn't always
#'     intuitive, but for the "My Microsoft Team - General" SharePoint site, the root
#'     directory is "General".
#'
#' Once these setup steps are done, everything should function as normal.
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
#' @export
is_sharepoint_file <- function(f) {
  inherits(f, 'sharepoint_file')
}

#' @family File Origin Helpers
#' @rdname file_origin_helpers
#' @export
is_onedrive_file <- function(f) {
  inherits(f, 'onedrive_file')
}

#' @family File Origin Helpers
#' @rdname file_origin_helpers
#' @export
is_cloud_file <- function(f) {
  inherits(f, 'cloud_file')
}
