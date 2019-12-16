#' @title Calculate area of strata using only raster data
#' @description The function calculates the area of strata without polygonizing the strata. Useful for checking the results of \code{\link{strataPolygons}} function.
#' @param bathy String giving the path to the bathymetry NetCDF file.
#' @param depths Numeric vector giving the cut points for depth strata (see \code{\link[base]{cut}}. Data outside the cut range will be dropped. Use limits of length two exceeding the depths of the region to avoid depth categorization (\code{c(0, 1000)} for instance).
#' @param boundary Numeric vector of length 4 giving the boundaries for the overall region. See \code{\link[raster]{extent}}. Should be given as decimal degrees. The first element defines the minimum longitude, the second element the maximum longitude, the third element the minimum latitude and the fourth element the maximum latitude of the bounding box.
#' @param geostrata A data frame defining the minimum and maximum longitude and latitude for geographically bounded strata. The data frame columns must be ordered as \code{lon.min, lon.max, lat.min, lat.max}. Column names do not matter. Each row in the data frame will be interpreted as separate geographically bounded strata. 
#' @details The function uses the \code{\link[raster]{reclassify}} and \code{\link[raster]{area}} functions to calculate the area of depth strata specified by the \code{depths} argument over a polygon specified by the \code{boundary} and \code{geostrata} arguments. 
#' @return Returns a data frame. The areas are expressed in square kilometers (km2) and nautical miles (nm2).
#' @import sp raster
#' @importFrom dplyr left_join
#' @export

# Test parameters
# bathy <- "../../GIS/GEBCO bathymetry/GEBCO_2019/GEBCO_2019.nc"; boundary <- c(0, 29, 68, 80); geostrata <- data.frame(lon.min = c(3, 10, 10, 8, 17.3), lon.max = c(16, 17.3, 17.3, 17.3, 29), lat.min = c(76, 73.5, 70.5, 68, 72.5), lat.max = c(80, 76, 73.5, 70.5, 76)); depths <- c(400, 500, 700, 1000, 1500)

# bathy = "/Users/a22357/Downloads/GEBCO_2019/GEBCO_2019.nc"; boundary = c(0, 35, 68, 80); depths = c(400, 500, 700, 1000, 1500); geostrata = data.frame(lon.min = c(0, 0, 0, 8, 17.5), lon.max = c(15, 17.5, 17.5, 17.5, 35), lat.min = c(76, 73.5, 70.5, 68, 72.5), lat.max = c(80, 76, 73.5, 70.5, 76))
strataArea <- function(bathy, depths, boundary, geostrata = NULL) {

  ## General checks ####
  
  if(!(is.vector(depths) & class(depths) %in% c("numeric", "integer"))) {
    stop("The depths parameter has to be a numeric or integer vector.")}
  
  if(!(is.vector(boundary) & class(boundary) %in% c("numeric", "integer") & length(boundary) == 4)) {
    stop("The boundary parameter has to be a numeric or integer vector of length 4 giving the decimal degree longitude and latitude limits for the strata region.")
  }
  
  if(!is.null(geostrata)) {
    if(!(is.data.frame(geostrata) & ncol(geostrata) == 4)) {
      stop("The geostrata argument has to be a data.frame with 4 columns.")
    }
  }
  
  ## Open raster
  
  ras <- raster::raster(bathy)
  
  if(is.null(proj4string(ras))) stop("bathy does not contain coordinate reference information")
  if(proj4string(ras) != "+proj=longlat +datum=WGS84 +ellps=WGS84 +towgs84=0,0,0") stop("bathy has to be in decimal degree projection. Use '+proj=longlat +datum=WGS84 +ellps=WGS84 +towgs84=0,0,0'")
  
  ras <- raster::crop(ras, raster::extent(boundary))
  
  ## Reclassify raster
  
  if(all(depths >= 0)) depths <- sort(-1 * depths)
  
  depths <- c(-Inf, depths, Inf)
  
  cut_int <- paste(abs(depths[-1]), abs(depths[-length(depths)]), sep = "-")
  cut_df <- data.frame(from = depths[-length(depths)], 
                       to = depths[-1], 
                       average = sapply(strsplit(cut_int, "-"), function(k) mean(as.numeric(k))),
                       interval = cut_int, 
                       stringsAsFactors = FALSE)
  
  cut_matrix <- as.matrix(cut_df[-ncol(cut_df)])
  
  r <- raster::reclassify(ras, rcl = cut_matrix, right = NA)
  
  ## Make the polygons
  
  if(is.null(geostrata)) {
    areas <- tapply(suppressWarnings(raster::area(r, na.rm = TRUE)), r[], sum)
    
    out <- data.frame(average = as.numeric(names(areas)), stringsAsFactors = FALSE)
    out <- dplyr::left_join(out, cut_df, by = "average")
    out$area.km2 <- unname(areas)
    out$area.nm2 <- unname(areas)/1.852^2
    
  } else {
    
    polys <- lapply(1:nrow(geostrata), function(i) {
      x <- geostrata[i,]
      sp::Polygons(list(sp::Polygon(as.matrix(data.frame(lon = c(x$lon.min, x$lon.min, x$lon.max, x$lon.max, x$lon.min), 
                 lat = c(x$lat.min, x$lat.max, x$lat.max, x$lat.min, x$lat.min))))), ID = i)
    })
    
    polys <- sp::SpatialPolygons(polys, proj4string = sp::CRS("+proj=longlat +datum=WGS84 +ellps=WGS84 +towgs84=0,0,0"))
    polys <- sp::SpatialPolygonsDataFrame(polys, geostrata)
    
    tmp <- lapply(1:length(polys), function(i) {
      r_out <- crop(r, polys[i,])
      areas <- tapply(suppressWarnings(raster::area(r_out, na.rm = TRUE)), r_out[], sum)
      
      out <- data.frame(average = as.numeric(names(areas)), geostrata.name = LETTERS[i], stringsAsFactors = FALSE)
      out <- dplyr::left_join(out, cut_df, by = "average")
      out <- suppressWarnings(cbind(out, polys@data[i,]))
      
      out$area.km2 <- unname(areas)
      out$area.nm2 <- unname(areas)/1.852^2
      
      out[order(out$average, decreasing = TRUE),]
      
    })
    
    out <- do.call(rbind, tmp)
    rownames(out) <- 1:nrow(out)
  }
  
  
  ## Output

  out
}