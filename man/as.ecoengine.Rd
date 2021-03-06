% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/as.ecoengine.R
\name{as.ecoengine}
\alias{as.ecoengine}
\title{Coerce occurrence keys to ecoenginekey/occkey objects}
\usage{
as.ecoengine(x, ...)
}
\arguments{
\item{x}{Various inputs, including the output from a call to
\code{\link[=occ]{occ()}} (class occdat), \code{\link[=occ2df]{occ2df()}} (class data.frame),
or a list, numeric, character, or ecoenginekey, or occkey.}

\item{...}{curl options; named parameters passed on to \code{\link[crul:HttpClient]{crul::HttpClient()}}}
}
\value{
One or more in a list of both class ecoenginekey and occkey
}
\description{
Coerce occurrence keys to ecoenginekey/occkey objects
}
\examples{
\dontrun{
spnames <- c('Accipiter striatus', 'Spinus tristis')
out <- occ(query=spnames, from='ecoengine', limit=2)
res <- occ2df(out)
(tt <- as.ecoengine(out))
(uu <- as.ecoengine(res))
as.ecoengine(res$key[1])
as.ecoengine(as.list(res$key[1:2]))
as.ecoengine(tt[[1]])
as.ecoengine(uu[[1]])
as.ecoengine(tt[1:2])
}
}
