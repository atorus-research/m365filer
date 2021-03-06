% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/file_handlers.R
\name{close.cloud_file}
\alias{close.cloud_file}
\alias{open.cloud_file}
\title{Open or Close a Cloud File Connection}
\usage{
\method{close}{cloud_file}(con, ...)

\method{open}{cloud_file}(con, ...)
}
\arguments{
\item{con}{cloud_file connection object}

\item{...}{Parameters to pass forward - reserved for potential future use}
}
\value{
Nothing
}
\description{
This function does the actual closing of a cloud path object. This works by
closing the connection and then using the attached metadata to upload the
file to OneDrive or SharePoint using the attached drive.
}
\concept{Open and Close Cloud Files}
