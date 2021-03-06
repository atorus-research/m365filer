% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/helpers.R
\name{is_sharepoint_file}
\alias{is_sharepoint_file}
\alias{is_onedrive_file}
\alias{is_cloud_file}
\title{File Origin Helpers}
\usage{
is_sharepoint_file(f)

is_onedrive_file(f)

is_cloud_file(f)
}
\arguments{
\item{f}{File path of file to check}
}
\value{
Boolean
}
\description{
These are logical checkers to centralize determination of the source of a file.
Local files, OneDrive files, and SharePoint files each have different access
methods - so in reading these file the origin needs to first be checked.
}
\concept{File Origin Helpers}
