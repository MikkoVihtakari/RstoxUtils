% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/readFdirCodes.R
\name{readFdirCodes}
\alias{readFdirCodes}
\title{Retrieve the Norwegian Directorate of Fisheries codes from a code list}
\usage{
readFdirCodes(
  path,
  speciesSheet = "B-Fiskeslag",
  speciesStartRow = 19,
  speciesHeaderRow = 17,
  gearSheet = "A7-Redskap",
  gearStartRow = 8
)
}
\arguments{
\item{path}{Character string specifying the path to the Excel file downloaded from the \href{https://www.fiskeridir.no/Yrkesfiske/Rapportering-ved-landing/Kodeliste}{Directorate of Fisheries webpage}.}

\item{speciesSheet}{Character string specifying the name of the tab containing species codes.}

\item{speciesStartRow}{Integer specifying the \code{skip} argument for \code{\link[readxl]{read_xlsx}} in the species code tab.}

\item{speciesHeaderRow}{Integer specifying row number of header in the species code tab.}

\item{gearSheet}{Character string specifying the name of the tab containing species codes.}

\item{gearStartRow}{Integer specifying the \code{skip} argument for \code{\link[readxl]{read_xlsx}} in the gear code tab.}
}
\description{
This function retrieves codes used in the electronic logbook data from an Excel sheet published by the Directorate of Fisheries. This list is already supplied in the package and the function is only required to update the codes.
}
\details{
The function has been written for \href{https://www.fiskeridir.no/Yrkesfiske/Rapportering-ved-landing/Kodeliste}{the code list Excel sheet} published on 2020-10-30. You may have to adjust the function depending on changes in newer versions of the file.
}
\author{
Mikko Vihtakari
}
