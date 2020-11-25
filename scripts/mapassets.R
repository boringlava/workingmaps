# A script used to convert large shapefiles to data frames
  # requires: unzipped shapefile folders, downloaded from the sources listed below

### Setup
setwd("~/RND/Turkana/maps/")

pacman::p_load(sf, maptools, raster, rgdal, rgeos)

### Turkana region boundaries centered on lake
extN.TB <- 5
extS.TB <- 2.1
extE.TB <- 37
extW.TB <- 35.3

### East Africa map extent and data
extN.EA <- 14
extS.EA <- -5
extE.EA <- 52
extW.EA <- 31.6

### Map data I/O
out.folder <- "~/RND/Turkana/maps/workingmaps/data/"

## Freehand .kml from Google Earth traced path 
Kerio <- st_read("KerioRiver.kml")
file.name <- "KerioRiver"
saveRDS(Kerio, file=paste(out.folder, file.name, ".Rdata", sep = ""))

## [Major rivers download](http://landscapeportal.org/layers/geonode:africa_rivers_1)
rivers.maj <- readOGR(dsn="africa_rivers/africa_rivers_1.shp")
rivers.crop <- crop(rivers.maj, EAfrica)
rivers.fortify <- fortify(rivers.crop)
file.name <- "rivers_maj"
saveRDS(rivers.fortify, file = paste(out.folder, file.name, ".Rdata", sep = ""))

#### Unused basemaps ####

# ## 10m basic shaded relief [Natural Earth](https://www.naturalearthdata.com/downloads/10m-raster-data/10m-shaded-relief/)
# shaded.relief<-raster("SR_HR/SR_HR.tif")
# sr.crop <- crop(shaded.relief, EAfrica)
# sr.fortify <- as.data.frame(sr.crop, xy = TRUE)
# 
# file.name <- "sr10m"
# saveRDS(sr.fortify, file = paste(out.folder, file.name, ".Rdata", sep = ""))
# 
# ## 1 arc-minute topo [NOAA ETOPO1](https://www.ngdc.noaa.gov/mgg/global/) 
# etopo <-raster("NOAA_ETOPO/exportImage.tiff")
# topo.crop <- crop(etopo, EAfrica)
# topo.fortify <- as.data.frame(topo.crop, xy = TRUE)
# file.name <- "NOAAtopo"
# saveRDS(topo.fortify, file = paste(out.folder, file.name, ".Rdata", sep = ""))
# 
# ## [World Bank water bodies download](https://datacatalog.worldbank.org/dataset/africa-water-bodies-2015)
# waterbodies <- readOGR("africawaterbody/Africa_waterbody.shp")
# waterbodies.crop <- crop(waterbodies, extent(extW.TB, extE.TB, extS.TB, extN.TB))
# 
# ## [HydroRIVERS download](https://www.hydrosheds.org/page/hydrorivers)
# rivers.hydro <- readOGR(dsn="HydroRIVERS_v10_af_shp/HydroRIVERS_v10_af_shp/HydroRIVERS_v10_af.shp")
# rivers.crop <- crop(rivers.hydro, EAfrica)
# rivers.fortify <- fortify(rivers.crop)
# file.name <- "rivers_all"
# saveRDS(rivers.fortify, file = paste(out.folder, file.name, ".Rdata", sep = ""))
# 
# ### river orders
# order.break <- 7
# rivers.major <- filter(rivers.fortify, rivers.fortify$order < order.break)
# rivers.minor <- filter(rivers.fortify, rivers.fortify$order >= order.break)


## Gray Earth shaded relief [Natural Earth download](https://www.naturalearthdata.com/downloads/50m-raster-data/50m-gray-earth/)
### unlikely to use

# shaded.relief<-raster("gray_earth/GRAY_HR_SR.tif")
# sr.crop <- crop(shaded.relief, big.extent)
# sr.fortify <- as.data.frame(sr.crop, xy = TRUE)
# 
# file.name <- "gray50m"
# saveRDS(sr.fortify, file = paste(out.folder, file.name, ".Rdata", sep = ""))

## [HydroLAKES download](https://www.hydrosheds.org/page/hydrolakes)
### not working 
# lakes.hydro <- readOGR(dsn = "HydroLAKES_polys_v10_shp/HydroLAKES_polys_v10_shp/HydroLAKES_polys_v10.shp")
# lakes.crop <- crop(lakes.hydro, EAfrica)
# lakes.fortify <- fortify(lakes.crop)
# 
# file.name <- "lakes"
# saveRDS(lakes.fortify, file = paste(out.folder, file.name, ".Rdata", sep = ""))

## 30 sec Rivers 
### unlikely to use; based on SRTM, innacurate for Turkana

# rivers.30s <- readOGR(dsn = "af_riv_30s/af_riv_30s.shp")
# rivers.fortify <- fortify(rivers.30s)
# rivers.extent <- filter(rivers.fortify, (rivers.fortify$long > extW) & (rivers.fortify$long < extE) &
#                           (rivers.fortify$lat > extS) & (rivers.fortify$lat < extN))
# 
# file.name <- "rivers30s"
# saveRDS(rivers.extent, file = paste(out.folder, file.name, ".Rdata", sep = ""))

## 10m Rivers [Natural Earth](https://www.naturalearthdata.com/downloads/10m-physical-vectors/)
### unlikely to use; this only shows the Omo River

# ne.rivers<-readOGR("ne_10m_rivers_lake_centerlines_scale_rank/ne_10m_rivers_lake_centerlines_scale_rank.shp")
# rivers.crop <- crop(ne.rivers, big.extent)
# rivers.fortify <- fortify(rivers.crop)
# 
# file.name <- "rivers10m"
# saveRDS(rivers.fortify, file = paste(out.folder, file.name, ".Rdata", sep = ""))

## 10m Lakes [Natural Earth](https://www.naturalearthdata.com/downloads/10m-physical-vectors/)

# ne.lakes<-readOGR("ne_10m_lakes/ne_10m_lakes.shp")
# lakes.crop <- crop(ne.lakes, big.extent)
# lakes.fortify <- fortify(lakes.crop)
# 
# file.name <- "lakes10m"
# saveRDS(lakes.fortify, file = paste(out.folder, file.name, ".Rdata", sep = ""))

## Minor islands [Natural Earth](https://www.naturalearthdata.com/downloads/10m-physical-vectors/)
###  unlikely to use; doesn't include Lake Turkana islands

# islands <- readOGR(dsn = "ne_10m_minor_islands/ne_10m_minor_islands.shp")
# islands.fortify <- fortify(islands)
# 
# file.name <- "islands"
# saveRDS(islands, file = paste(out.folder, file.name, ".Rdata", sep = ""))

## [HydroBASINS download](https://www.hydrosheds.org/page/hydrobasins) 
### unlikely to use 
