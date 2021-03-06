#' @examples \dontrun{
#' # Single data sources
#' (res <- occ(query = 'Accipiter striatus', from = 'gbif', limit = 5))
#' res$gbif
#' (res <- occ(query = 'Accipiter', from = 'ecoengine', limit = 50))
#' res$ecoengine
#' (res <- occ(query = 'Accipiter striatus', from = 'ebird', limit = 50))
#' res$ebird
#' (res <- occ(query = 'Danaus plexippus', from = 'inat', limit = 50))
#' res$inat
#' (res <- occ(query = 'Bison bison', from = 'bison', limit = 50))
#' res$bison
#' (res <- occ(query = 'Bison bison', from = 'vertnet', limit = 5))
#' res$vertnet
#' res$vertnet$data$Bison_bison
#' occ2df(res)
#' 
#' # Paging
#' one <- occ(query = 'Accipiter striatus', from = 'gbif', limit = 5)
#' two <- occ(query = 'Accipiter striatus', from = 'gbif', limit = 5, start = 5)
#' one$gbif
#' two$gbif
#'
#' # Restrict to records with coordinates
#' occ(query = "Acer", from = "idigbio", limit = 5, has_coords = TRUE)
#'
#' # Data from AntWeb
#' # By species
#' (by_species <- occ(query = "linepithema humile", from = "antweb", limit = 10))
#' # or by genus
#' (by_genus <- occ(query = "acanthognathus", from = "antweb"))
#'
#' occ(query = 'Setophaga caerulescens', from = 'ebird', ebirdopts = list(region='US'))
#' occ(query = 'Spinus tristis', from = 'ebird', ebirdopts =
#'    list(method = 'ebirdgeo', lat = 42, lng = -76, dist = 50))
#'
#' # idigbio data
#' ## scientific name search
#' occ(query = "Acer", from = "idigbio", limit = 5)
#' occ(query = "Acer", from = "idigbio", idigbioopts = list(offset = 5, limit  = 3))
#' ## geo search
#' bounds <- c(-120, 40, -100, 45)
#' occ(from = "idigbio", geometry = bounds, limit = 10)
#' ## just class arachnida, spiders
#' occ(idigbioopts = list(rq = list(class = 'arachnida')), from = "idigbio", limit = 10)
#' ## search certain recordsets
#' sets <- c("1ffce054-8e3e-4209-9ff4-c26fa6c24c2f",
#'     "8dc14464-57b3-423e-8cb0-950ab8f36b6f", 
#'     "26f7cbde-fbcb-4500-80a9-a99daa0ead9d")
#' occ(idigbioopts = list(rq = list(recordset = sets)), from = "idigbio", limit = 10)
#'
#' # You can pass on limit param to all sources even though its a different param in that source
#' ## ecoengine example
#' res <- occ(query = 'Accipiter striatus', from = 'ecoengine', ecoengineopts=list(limit = 5))
#' res$ecoengine
#' ## This is particularly useful when you want to set different limit for each source
#' (res <- occ(query = 'Accipiter striatus', from = c('gbif','ecoengine'),
#'    gbifopts=list(limit = 10), ecoengineopts=list(limit = 5)))
#'
#' # Many data sources
#' (out <- occ(query = 'Pinus contorta', from=c('gbif','bison','vertnet'), limit=10))
#'
#' ## Select individual elements
#' out$gbif
#' out$gbif$data
#' out$vertnet
#'
#' ## Coerce to combined data.frame, selects minimal set of
#' ## columns (name, lat, long, provider, date, occurrence key)
#' occ2df(out)
#'
#' # Pass in limit parameter to all sources. This limits the number of occurrences
#' # returned to 10, in this example, for all sources, in this case gbif and inat.
#' occ(query='Pinus contorta', from=c('gbif','inat'), limit=10)
#'
#' # Geometry
#' ## Pass in geometry parameter to all sources. This constraints the search to the
#' ## specified polygon for all sources, gbif and bison in this example.
#' ## Check out http://arthur-e.github.io/Wicket/sandbox-gmaps3.html to get a WKT string
#' occ(query='Accipiter', from='gbif',
#'    geometry='POLYGON((30.1 10.1, 10 20, 20 60, 60 60, 30.1 10.1))')
#' occ(query='Helianthus annuus', from='bison', limit=50,
#'    geometry='POLYGON((-111.06 38.84, -110.80 39.37, -110.20 39.17, -110.20 38.90,
#'                       -110.63 38.67, -111.06 38.84))')
#'
#' ## Or pass in a bounding box, which is automatically converted to WKT (required by GBIF)
#' ## via the bbox2wkt function. The format of a bounding box is
#' ## [min-longitude, min-latitude, max-longitude, max-latitude].
#' occ(query='Accipiter striatus', from='gbif', geometry=c(-125.0,38.4,-121.8,40.9))
#'
#' ## Bounding box constraint with ecoengine
#' ## Use this website: http://boundingbox.klokantech.com/ to quickly grab a bbox.
#' ## Just set the format on the bottom left to CSV.
#' occ(query='Accipiter striatus', from='ecoengine', limit=10,
#'    geometry=c(-125.0,38.4,-121.8,40.9))
#'
#' ## lots of results, can see how many by indexing to meta
#' res <- occ(query='Accipiter striatus', from='gbif',
#'    geometry='POLYGON((-69.9 49.2,-69.9 29.0,-123.3 29.0,-123.3 49.2,-69.9 49.2))')
#' res$gbif
#'
#' ## You can pass in geometry to each source separately via their opts parameter, at
#' ## least those that support it. Note that if you use rinat, you reverse the order, with
#' ## latitude first, and longitude second, but here it's the reverse for consistency across
#' ## the spocc package
#' bounds <- c(-125.0,38.4,-121.8,40.9)
#' occ(query = 'Danaus plexippus', from="inat", geometry=bounds)
#'
#' ## Passing geometry with multiple sources
#' occ(query = 'Danaus plexippus', from=c("inat","gbif","ecoengine"), geometry=bounds)
#'
#' ## Using geometry only for the query
#' ### A single bounding box
#' occ(geometry = bounds, from = "gbif", limit=50)
#' ### Many bounding boxes
#' occ(geometry = list(c(-125.0,38.4,-121.8,40.9), c(-115.0,22.4,-111.8,30.9)), from = "gbif")
#'
#' ## Many geometry and many names
#' res <- occ(query = c('Danaus plexippus', 'Accipiter striatus'),
#'    geometry = list(c(-125.0,38.4,-121.8,40.9), c(-115.0,22.4,-111.8,30.9)), from = "bison")
#' res
#'
#' ## Geometry only with WKT
#' wkt <- 'POLYGON((-98.9 44.2,-89.1 36.6,-116.7 37.5,-102.5 39.6,-98.9 44.2))'
#' occ(from = "gbif", geometry = wkt, limit = 10)
#'
#' # Specify many data sources, another example
#' ebirdopts = list(region = 'US'); gbifopts  =  list(country = 'US')
#' out <- occ(query = 'Setophaga caerulescens', from = c('gbif','inat','bison','ebird'),
#'     gbifopts = gbifopts, ebirdopts = ebirdopts, limit=20)
#' occ2df(out)
#'
#' # Pass in many species names, combine just data to a single data.frame, and
#' # first six rows
#' spnames <- c('Accipiter striatus', 'Setophaga caerulescens', 'Spinus tristis')
#' (out <- occ(query = spnames, from = 'gbif', gbifopts = list(hasCoordinate = TRUE), limit=25))
#' df <- occ2df(out)
#' head(df)
#' 
#' # no query, geometry, or ids passed
#' ## many dataset keys to gbif
#' dsets <- c("14f3151a-e95d-493c-a40d-d9938ef62954", "f934f8e2-32ca-46a7-b2f8-b032a4740454")
#' occ(limit = 20, from = "gbif", gbifopts = list(datasetKey = dsets))
#' ## class name to idigbio
#' occ(limit = 20, from = "idigbio", idigbioopts = list(rq = list(class = 'arachnida')))
#' ## limit to ecoengine
#' occ(from = "ecoengine", ecoengineopts = list(limit = 3))
#'
#' # taxize integration
#' ## You can pass in taxonomic identifiers
#' library("taxize")
#' (ids <- get_ids(names=c("Chironomus riparius","Pinus contorta"), db = c('itis','gbif')))
#' occ(ids = ids[[1]], from='bison', limit=20)
#' occ(ids = ids, from=c('bison','gbif'), limit=20)
#'
#' (ids <- get_ids(names="Chironomus riparius", db = 'gbif'))
#' occ(ids = ids, from='gbif', limit=20)
#'
#' (ids <- get_gbifid("Chironomus riparius"))
#' occ(ids = ids, from='gbif', limit=20)
#'
#' (ids <- get_tsn('Accipiter striatus'))
#' occ(ids = ids, from='bison', limit=20)
#'
#' # SpatialPolygons/SpatialPolygonsDataFrame integration
#' library("sp")
#' ## Single polygon in SpatialPolygons class
#' one <- Polygon(cbind(c(91,90,90,91), c(30,30,32,30)))
#' spone = Polygons(list(one), "s1")
#' sppoly = SpatialPolygons(list(spone), as.integer(1))
#' out <- occ(geometry = sppoly, limit=50)
#' out$gbif$data
#'
#' ## Two polygons in SpatialPolygons class
#' one <- Polygon(cbind(c(-121.0,-117.9,-121.0,-121.0), c(39.4, 37.1, 35.1, 39.4)))
#' two <- Polygon(cbind(c(-123.0,-121.2,-122.3,-124.5,-123.5,-124.1,-123.0),
#'                      c(44.8,42.9,41.9,42.6,43.3,44.3,44.8)))
#' spone = Polygons(list(one), "s1")
#' sptwo = Polygons(list(two), "s2")
#' sppoly = SpatialPolygons(list(spone, sptwo), 1:2)
#' out <- occ(geometry = sppoly, limit=50)
#' out$gbif$data
#'
#' ## Two polygons in SpatialPolygonsDataFrame class
#' sppoly_df <- SpatialPolygonsDataFrame(sppoly, data.frame(a=c(1,2), b=c("a","b"), c=c(TRUE,FALSE),
#'    row.names=row.names(sppoly)))
#' out <- occ(geometry = sppoly_df, limit=50)
#' out$gbif$data
#'
#' # curl debugging
#' library('httr')
#' occ(query = 'Accipiter striatus', from = 'gbif', limit=10, callopts=verbose())
#' # occ(query = 'Accipiter striatus', from = 'ebird', limit=10, callopts=verbose())
#' occ(query = 'Accipiter striatus', from = 'bison', limit=10, callopts=verbose())
#' occ(query = 'Accipiter striatus', from = 'ecoengine', limit=10, callopts=verbose())
#' occ(query = 'Accipiter striatus', from = c('ebird','bison'), limit=10, callopts=verbose())
#' # occ(query = 'Accipiter striatus', from = 'ebird', limit=10, callopts=timeout(seconds = 0.1))
#' occ(query = 'Accipiter striatus', from = 'inat', callopts=verbose())
#' occ(query = 'Mola mola', from = 'obis', limit = 200, callopts = verbose())
#' ## notice that callopts is ignored when from='antweb'
#' occ(query = 'linepithema humile', from = 'antweb', callopts=verbose())
#'
#' ########## More thorough data source specific examples
#' # idigbio
#' ## scientific name search
#' res <- occ(query = "Acer", from = "idigbio", limit = 5)
#' res$idigbio
#'
#' ## geo search
#' ### bounding box
#' bounds <- c(-120, 40, -100, 45)
#' occ(from = "idigbio", geometry = bounds, limit = 10)
#' ### wkt
#' # wkt <- 'POLYGON((-69.9 49.2,-69.9 29.0,-123.3 29.0,-123.3 49.2,-69.9 49.2))'
#' wkt <- 'POLYGON((-98.9 44.2,-89.1 36.6,-116.7 37.5,-102.5 39.6,-98.9 44.2))'
#' occ(from = "idigbio", geometry = wkt, limit = 10)
#'
#' ## limit fields returned
#' occ(query = "Acer", from = "idigbio", limit = 5,
#'    idigbioopts = list(fields = "scientificname"))
#'
#' ## offset and max_items
#' occ(query = "Acer", from = "idigbio", limit = 5,
#'    idigbioopts = list(offset = 10))
#'
#' ## sort
#' occ(query = "Acer", from = "idigbio", limit = 5,
#'    idigbioopts = list(sort = TRUE))$idigbio
#' occ(query = "Acer", from = "idigbio", limit = 5,
#'    idigbioopts = list(sort = FALSE))$idigbio
#'
#' ## more complex queries
#' ### parameters passed to "rq", get combined with the name queried
#' occ(query = "Acer", from = "idigbio", limit = 5,
#'    idigbioopts = list(rq = list(basisofrecord="fossilspecimen")))$idigbio
#'
#' #### NOTE: no support for multipolygons yet
#' ## WKT's are more flexible than bounding box's. You can pass in a WKT with multiple
#' ## polygons like so (you can use POLYGON or MULTIPOLYGON) when specifying more than one
#' ## polygon. Note how each polygon is in it's own set of parentheses.
#' # occ(query='Accipiter striatus', from='gbif',
#' #    geometry='MULTIPOLYGON((30 10, 10 20, 20 60, 60 60, 30 10),
#' #                           (30 10, 10 20, 20 60, 60 60, 30 10))')
#' 
#' # OBIS examples
#' ## basic query
#' (res <- occ(query = 'Mola mola', from = 'obis', limit = 200))
#' ## get to obis data
#' res$obis
#' ## get obis + gbif data
#' (res <- occ(query = 'Mola mola', from = c('obis', 'gbif'), limit = 200))
#' res$gbif
#' res$obis
#' ## no match found
#' (res <- occ(query = 'Linguimaera thomsonia', from = 'obis'))
#' ## geometry query
#' geometry <- "POLYGON((8.98 48.05,15.66 48.05,15.66 45.40,8.98 45.40,8.98 48.05))"
#' (res <- occ(from = 'obis', geometry = geometry, limit = 50))
#' res$obis
#' ## Pass in spatial classes
#' library("sp")
#' one <- Polygon(cbind(c(45,30,30,45), c(35,35,30,30)))
#' spone = Polygons(list(one), "s1")
#' sppoly = SpatialPolygons(list(spone), as.integer(1))
#' (res <- occ(from = 'obis', geometry = sppoly, limit = 50))
#' ## Do paging
#' (res1 <- occ(query = 'Mola mola', from = 'obis', limit = 10))
#' (res2 <- occ(query = 'Mola mola', from = 'obis', limit = 10, start = 20))
#' res1$obis
#' res2$obis
#' ## Pass in any occurrence route parameters to obisopts as a list
#' (res <- occ(query = 'Mola mola', from = 'obis', 
#'    obisopts = list(year = 2005)))
#' unique(res$obis$data$Mola_mola$yearcollected)
#' 
#' 
#' # ALA examples
#' ## basic query
#' (res <- occ(query = 'Alaba vibex', from = 'ala', limit = 200))
#' ## get to ala data
#' res$ala
#' occ2df(res)
#' 
#' # geometry search
#' (x <- occ(query = "Macropus", from = 'ala',
#'   geometry = "POLYGON((145 -37,150 -37,150 -30,145 -30,145 -37))"))
#' x$ala
#' occ2df(x)
#' }
