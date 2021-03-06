% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/as.gbif.R
\name{as.gbif}
\alias{as.gbif}
\title{Coerce occurrence keys to gbifkey/occkey objects}
\usage{
as.gbif(x, ...)
}
\arguments{
\item{x}{Various inputs, including the output from a call to
\code{\link[=occ]{occ()}} (class occdat), \code{\link[=occ2df]{occ2df()}} (class data.frame),
or a list, numeric, character, gbifkey, or occkey.}

\item{...}{curl options; named parameters passed on to \code{\link[crul:HttpClient]{crul::HttpClient()}}}
}
\value{
One or more in a list of both class gbifkey and occkey
}
\description{
Coerce occurrence keys to gbifkey/occkey objects
}
\details{
Internally, we use \code{\link[rgbif:occ_get]{rgbif::occ_get()}}, whereas
\code{\link[=occ]{occ()}} uses \code{\link[rgbif:occ_data]{rgbif::occ_data()}}. We can use
\code{\link[rgbif:occ_get]{rgbif::occ_get()}} here because we have the occurrence key to
go directly to the occurrence record.
}
\examples{
\dontrun{
spnames <- c('Accipiter striatus', 'Setophaga caerulescens', 
  'Spinus tristis')
out <- occ(query=spnames, from=c('gbif','ebird'), 
  gbifopts=list(hasCoordinate=TRUE), limit=2)
res <- occ2df(out)
(tt <- as.gbif(out))
(uu <- as.gbif(res))
as.gbif(as.numeric(res$key[1]))
as.gbif(res$key[1])
as.gbif(as.list(res$key[1:2]))
as.gbif(tt[[1]])
as.gbif(uu[[1]])
as.gbif(tt[1:2])
}
}
