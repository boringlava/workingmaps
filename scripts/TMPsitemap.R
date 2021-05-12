# A script to create a Miocene site map for inclusion in dissertation proposal

pacman::p_load(here, dplyr, raster, rgdal, rnaturalearth, ggplot2, ggthemes, ggspatial)

### Add sites
TMPsites <- read.csv(here("data", "TMPsites.csv"))

### Add features
borders.africa <- ne_countries(continent='africa', returnclass="sf")
lakes <- ne_download(scale=10, type="lakes", category="physical", returnclass="sf")
lake <- lakes[!is.na(lakes$name_en) & lakes$name_en == "Lake Turkana", ]
# Made with Natural Earth. Free vector and raster map data @ naturalearthdata.com.

rivers <- readRDS(here("data", "rivers.Rdata"))
crop.rivers <- rivers %>% filter(long < 36.5) 
# Africa Rivers. (2014). World Agroforestry Centre. Retrieved from http://landscapeportal.org/layers/geonode:africa_rivers_1
# crop removes river flowing into Chew Bahir 

Kerio <- readRDS(here("data", "KerioRiver.Rdata"))
# Google Earth trace 

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
  geom_sf(data=Kerio, color=water.color) +
  geom_path(data=crop.rivers, aes(x=long, y=lat, group=group), color=water.color) +
  geom_point(data=TMPsites, aes(x=long, y=lat), size=point.size) +
  # geom_text(data=TMPsites, aes(x=long, y=lat, label=site))+ # site labels in ggplot 
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
# export to file linked to svg 
out.folder <- "~/RND/Turkana/maps/workingmaps/images/"
ggsave(file=paste(out.folder, "TB_TMP_sites.tiff", sep=""), plot=map.Turkana, 
       device="tiff", width=file.w, height=file.h, dpi="retina")

