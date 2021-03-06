% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/read_xes.R
\name{read_xes}
\alias{read_xes}
\title{read_xes}
\usage{
read_xes(xesfile = file.choose(), validate = TRUE)
}
\arguments{
\item{xesfile}{Reference to a .xes file, conforming to the xes-standard.}

\item{validate}{When 'TRUE' some basic checks are run on the contents of the event log such as that activity instances are not connected to more than one case or activity.
Using 'FALSE' improves the performance by skipping those checks and allows to import  XES files that do not conform to bupaR requirements.}
}
\description{
Extracts eventlog from a xes-file.
}
\seealso{
\url{http://www.xes-standard.org/}
}
