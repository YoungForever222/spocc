obis_base <- function() "http://api.iobis.org/occurrence"

obis_search <- function(scientificName = NULL, limit = 500, offset = 0, 
  obisid = NULL, aphiaid = NULL, resourceid = NULL, year = NULL,
  startdate = NULL, enddate = NULL, startdepth = NULL,
  enddepth = NULL, geometry = NULL, qc = NULL, ...) {
  
  args <- sc(list(scientificname = scientificName, limit = limit, 
      offset = offset,  obisid = obisid, aphiaid = aphiaid, 
      resourceid = resourceid, year = year, startdate = startdate, 
      enddate = enddate, startdepth = startdepth,
      enddepth = enddepth, geometry = geometry, qc = qc))
  
  cli <- crul::HttpClient$new(
    url = obis_base(),
    opts = list(...)
  )
  out <- cli$get(query = args)
  out$raise_for_status()
  jsonlite::fromJSON(out$parse("UTF-8"))
}

obis_occ_id <- function(id, ...) {
  cli <- crul::HttpClient$new(
    url = file.path(obis_base(), id),
    opts = list(...)
  )
  out <- cli$get()
  out$raise_for_status()
  jsonlite::fromJSON(out$parse("UTF-8"))
}
