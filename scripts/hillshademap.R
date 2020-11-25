# A script for compiling hillshade data from SRTM into ggplot with sf objects 

### Libraries and  directory
pacman::p_load(dplyr, raster, rgdal, rnaturalearth, ggplot2, ggthemes, ggspatial)
setwd("~/RND/Turkana/maps/workingmaps/") #edit as required; .Rdata is stored here


### Small Turkana map centered on lake
extN.TB <- 5
extS.TB <- 2.2
extE.TB <- 37
extW.TB <- 35.3

### Download and process SRTM (do this once)
dem.02035 <- getData("SRTM", lon=35, lat=2)
dem.02036 <- getData("SRTM", lon=36, lat=2)
dem.02037 <- getData("SRTM", lon=37, lat=2)
dem.03035 <- getData("SRTM", lon=35, lat=3)
dem.03036 <- getData("SRTM", lon=36, lat=3)
dem.03037 <- getData("SRTM", lon=37, lat=3)
dem.04035 <- getData("SRTM", lon=35, lat=4)
dem.04036 <- getData("SRTM", lon=36, lat=4)
dem.04037 <- getData("SRTM", lon=37, lat=4)
dem.05035 <- getData("SRTM", lon=35, lat=5)
dem.05036 <- getData("SRTM", lon=36, lat=5)
dem.05037 <- getData("SRTM", lon=37, lat=5)
dem.grid <- mosaic(dem.02035, dem.02036, dem.02037, dem.03035, dem.03036, dem.03037, dem.04035, dem.04036, dem.04037, dem.05035, dem.05036, dem.05037, fun=mean)
crop.dem <- crop(dem.grid, extent(extW.TB, extE.TB, extS.TB, extN.TB))

### Generate hillshade layer
slope <- terrain(crop.dem, opt="slope")
aspect <- terrain(crop.dem, opt="aspect")
hill <- hillShade(slope, aspect, angle = 45, direction = 300)

color.grayscale <- colorRampPalette(c("white", "black"))
plot(hill, col=rev(color.grayscale(100)))
# quick plot of hillshade to test angles 

### Compress and convert 
hill.shrink <- aggregate(hill, fact=4)
hill.raster <- rasterToPoints(hill.shrink)
hill.raster.df <- as.data.frame(hill.raster)

### Import features 
srtm.grid <- readRDS("data/SRTMgrid.Rdata")
  # replaces downloading and stitching SRTM tiles wihout processing hillshade layer 
hill.raster.df <- readRDS("data/SRTMhillshade_45x300.Rdata")
  # replaces all steps above for downloading and processing SRTM 

rivers <- readRDS("data/rivers.Rdata")
crop.rivers <- rivers %>% filter(long < 36.5) 
  # Africa Rivers. (2014). World Agroforestry Centre. Retrieved from http://landscapeportal.org/layers/geonode:africa_rivers_1
  # crop removes river flowing into Chew Bahir 
Kerio <- readRDS("data/KerioRiver.Rdata")
  # Freehand .kml from Google Earth traced path 

borders.africa <- ne_countries(continent='africa', returnclass="sf")
lakes <- ne_download(scale=10, type="lakes", category="physical", returnclass="sf")
lake <- lakes[!is.na(lakes$name_en) & lakes$name_en == "Lake Turkana", ]
  # Made with Natural Earth. Free vector and raster map data @ naturalearthdata.com.

### Map style
theme_set(theme_classic(base_family = "Helvetica", base_size = 16))
bg.color <- "gray95"
water.color <- "cyan3"
point.size <- 3

### Regional map
map.Turkana <- ggplot() +
  #geom_tile(data=hill.raster.df, aes(x=x, y=y, fill=layer)) +
  #scale_fill_distiller(palette="Greys", direction=-1) +
  geom_sf(data=borders.africa, fill=NA, linetype=2) +
  geom_sf(data=lake, fill=water.color) +
  geom_sf(data=Kerio, color=water.color) +
  geom_path(data=crop.rivers, aes(x=long, y=lat, group=group), color=water.color) +
  annotation_scale() +
  annotation_north_arrow(location="tr", which_north="true",
                         style=north_arrow_fancy_orienteering) +
  labs(x=NULL, y=NULL) +
  coord_sf(xlim=c(extW.TB, extE.TB), ylim=c(extS.TB, extN.TB)) 
plot(map.Turkana)

### East Africa map extent and data
extN.EA <- 14
extS.EA <- -5
extE.EA <- 52
extW.EA <- 31.6

capitals <- data.frame(name=c("Nairobi", "Addis Ababa", "Mogadishu", "Kampala", "Juba", "Djibouti", "Asmara", "Khartoum", "Kigali", "Bujumbura", "Hargeisa"),
                       lat=c(1.227100, 9.095224, 1.993963, 0.42301291113399797, 4.857947971528862, 11.454152705708236, 15.420424899204724, 15.404307044921767, -1.7858219313913646, -3.3615853433518352, 9.607390908324566),
                       long=c(36.815842, 38.743306, 45.334426, 32.559768845193695, 31.57100812907596, 43.19653343132157, 38.90648857423801, 32.550435900518, 30.04438571691374, 29.36055868622438, 44.067797107891145))

### Context map
map.EAfrica <- ggplot() +
  geom_sf(data=borders.africa, fill=bg.color) +
  geom_sf(data=lake, fill=water.color) +
  geom_rect(aes(xmin=extW.TB, xmax=extE.TB, ymin=extS.TB, ymax=extN.TB), color="chocolate1", fill=NA, size=2) +
  geom_point(data=capitals, aes(x=long, y=lat), size=2) +
  annotation_scale() +
  annotation_north_arrow(location="lr", which_north="true",
                         style=north_arrow_fancy_orienteering) +
  labs(x=NULL, y=NULL) +
  coord_sf(xlim=c(extW.EA, extE.EA), ylim=c(extS.EA, extN.EA)) 
plot(map.EAfrica)



