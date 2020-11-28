pacman::p_load(dplyr, raster, rgdal, rnaturalearth, ggplot2, ggthemes, ggspatial)

### Add sites and data 
sites <- data.frame(name = c("Lothagam", "Loperot", "Turkwel", "Ileret", "Koobi Fora"),
                    lat = c(2.916505253, 2.347124415, 3.140951414, 4.288297584, 3.94821913),
                    long = c(36.05927769, 35.84459854, 35.86548138, 36.26277924, 36.18644114))

### Add features
borders.africa <- ne_countries(continent='africa', returnclass="sf")
lakes <- ne_download(scale=10, type="lakes", category="physical", returnclass="sf")
lake <- lakes[!is.na(lakes$name_en) & lakes$name_en == "Lake Turkana", ]
  # Made with Natural Earth. Free vector and raster map data @ naturalearthdata.com.

setwd("~/RND/Turkana/maps/workingmaps/data/")
rivers <- readRDS("rivers.Rdata")
crop.rivers <- rivers %>% filter(long < 36.5) 
  # Africa Rivers. (2014). World Agroforestry Centre. Retrieved from http://landscapeportal.org/layers/geonode:africa_rivers_1
  # crop removes river flowing into Chew Bahir 

### Turkana region boundaries centered on lake
extN.TB <- 5
extS.TB <- 2.1
extE.TB <- 37
extW.TB <- 35.3

### Map style
theme_set(theme_classic(base_family = "Helvetica", base_size = 16))
bg.color <- "gray92"
water.color <- "cyan3"
point.size <- 3

### Regional map
map.Turkana <- ggplot() +
  geom_sf(data=borders.africa, fill=bg.color, linetype=2) +
  geom_sf(data=lake, fill=water.color) +
  geom_path(data=crop.rivers, aes(x=long, y=lat, group=group), color=water.color) +
  geom_point(data=sites, aes(x=long, y=lat), size=point.size) +
  annotation_scale() +
  annotation_north_arrow(location = "tr", which_north = "true",
                        style = north_arrow_fancy_orienteering) +
  labs(x=NULL, y=NULL) +
  coord_sf(xlim = c(extW.TB, extE.TB), ylim = c(extS.TB, extN.TB)) 
plot(map.Turkana)

  # save regional map as large tiff
    # set output dimensions to 2x axis length 
file.w <- round((2 * (extE.TB-extW.TB)), 2)
file.h <- round((2 * (extN.TB-extS.TB)), 2) - 0.6
    # export to file linked to .svg 
out.folder <- "~/RND/Turkana/maps/workingmaps/images/"
ggsave(file=paste(out.folder, "TB_regional_sites.tiff", sep=""), plot=map.Turkana, 
       device="tiff", width=file.w, height=file.h, dpi="retina")


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

  # save context map as large tiff
file.w <- 5
file.h <- 5
    # export to file linked to .svg 
ggsave(file=paste(out.folder, "EA_TBbox_capitals.tiff", sep=""), plot=map.EAfrica, 
       device="tiff", width=file.w, height=file.h, dpi="retina")
