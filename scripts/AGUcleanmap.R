pacman::p_load(dplyr, raster, rgdal, rnaturalearth, ggplot2, ggthemes, ggspatial)

### Add points and labels
sites <- data.frame(name = c("Lothagam", "Loperot", "Turkwel", "Ileret", "Koobi Fora"),
                    lat = c(2.916505253, 2.347124415, 3.140951414, 4.288297584, 3.94821913),
                    long = c(36.05927769, 35.84459854, 35.86548138, 36.26277924, 36.18644114))

labels <- data.frame(name = c("Lake Turkana", "Omo River", "Turkwel River", "Kenya", "Ethiopia"),
                     lat = c(3.489998, 4.7, 2.521256, 4.9, 4.5),
                     long = c(36.038134,36.1, 35.4, 35.5, 36.5))


### Add features
borders.africa <- ne_countries(continent = 'africa', returnclass = "sf")
border.ke <- borders.africa[borders.africa$name == "Kenya", ]
lakes <- ne_download(scale = 10, type = "lakes", category = "physical", returnclass = "sf")
lake <- lakes[!is.na(lakes$name_en) & lakes$name_en == "Lake Turkana", ]
  # Made with Natural Earth. Free vector and raster map data @ naturalearthdata.com.

setwd("~/RND/Turkana/maps/workingmaps/data/")
rivers <- readRDS("rivers.Rdata")
  # Africa Rivers. (2014). World Agroforestry Centre. Retrieved from http://landscapeportal.org/layers/geonode:africa_rivers_1


### Turkana region boundaries centered on lake
extN.TB <- 5
extS.TB <- 2.1
extE.TB <- 37
extW.TB <- 35.3

### Base map
theme_set(theme_classic(base_family = "serif"))
theme(rect = element_rect(fill = "transparent"))
water.color <- "cyan"
crop.rivers <- rivers %>% filter(long < 36.5) 
  #removes river flowing into Chew Bahir (also not shown)

text.small <- 3

map.Turkana <- ggplot(family="serif") +
  geom_sf(data = borders.africa, linetype = 2) +
  geom_polygon(data =  lake, aes(x=long, y=lat, group=group), fill = water.color) +
  geom_path(data = crop.rivers, aes(x=long, y=lat, group=group), color = water.color) +
  geom_point(data = sites, aes(x=long, y=lat)) +
  # geom_text(data = sites, aes(x=long, y=lat, label = name), nudge_y = -0.1) +
  # geom_text(data=NULL, aes(x=36.1, y=3.5, label="Lake Turkana"), size = text.small, angle = 295) +
  # geom_text(data=NULL, aes(x=35.45, y=2.5, label="Turkwel River"), size = text.small, angle = 275) +
  # geom_text(data=NULL, aes(x=35.95, y=4.9, label="Omo River"), size = text.small, angle = 85) +
  # geom_text(data=NULL, aes(x=36.6, y=4.4, label="Kenya"), size = text.small) +
  # geom_text(data=NULL, aes(x=36.6, y=4.53, label="Ethiopia"), size = text.small) +
  annotation_scale() +
  annotation_north_arrow(location = "tr", which_north = "true",
                        style = north_arrow_fancy_orienteering) +
  labs(x=NULL, y=NULL) +
  coord_sf(xlim = c(extW.TB, extE.TB), ylim = c(extS.TB, extN.TB)) 
plot(map.Turkana)
ggsave("TB_sites_nolabel.tiff", plot = map.Turkana, device = "tiff", width = 4, height = 7, dpi = "retina")

### Highlights
highlight.color <- "gold2"
highlight.size <- 5

sites.other <- sites %>% filter(name != "Lothagam")
site.highlight <- sites %>% filter(name == "Lothagam")
map.highlight.Lothagam <- ggplot() +
  geom_sf(data = borders.africa, linetype = 2) +
  geom_polygon(data =  lake, aes(x=long, y=lat, group=group), fill = lake.color) +
  geom_path(data = crop.rivers, aes(x=long, y=lat, group=group), color = water.color) +
  geom_point(data = sites.other, aes(x=long, y=lat)) +
  geom_text(data = sites, aes(x=long, y=lat, label = name), nudge_y = -0.1) +
  geom_point(data = site.highlight, aes(x=long, y=lat), color=highlight.color, size=highlight.size) +
  geom_text(data=NULL, aes(x=36.1, y=3.5, label="Lake Turkana"), size = text.small, angle = 295) +
  geom_text(data=NULL, aes(x=35.45, y=2.5, label="Turkwel River"), size = text.small, angle = 275) +
  geom_text(data=NULL, aes(x=35.95, y=4.9, label="Omo River"), size = text.small, angle = 85) +
  geom_text(data=NULL, aes(x=36.6, y=4.4, label="Kenya"), size = text.small) +
  geom_text(data=NULL, aes(x=36.6, y=4.53, label="Ethiopia"), size = text.small) +
  annotation_scale() +
  annotation_north_arrow(location = "tr", which_north = "true",
                         style = north_arrow_fancy_orienteering) +
  labs(x=NULL, y=NULL) +
  coord_sf(xlim = c(extW.TB, extE.TB), ylim = c(extS.TB, extN.TB)) 
plot(map.highlight.Lothagam)

text.fig.l <- 10
text.fig.s <- 7
  
sites.other <- sites %>% filter(name != "Loperot")
site.highlight <- sites %>% filter(name == "Loperot")
map.highlight.Loperot <- ggplot() +
  geom_sf(data = borders.africa, alpha=0.5, linetype = 2) +
  geom_polygon(data =  lake, aes(x=long, y=lat, group=group), fill = lake.color) +
  geom_path(data = crop.rivers, aes(x=long, y=lat, group=group), color = water.color) +
  geom_point(data = sites.other, aes(x=long, y=lat)) +
  geom_text(data = sites, aes(x=long, y=lat, label = name), nudge_y = -0.1, size = text.fig.l) +
  geom_point(data = site.highlight, aes(x=long, y=lat), color=highlight.color, size=highlight.size) +
  geom_text(data=NULL, aes(x=36.1, y=3.5, label="Lake Turkana"), size = text.fig.s, angle = 295) +
  geom_text(data=NULL, aes(x=35.45, y=2.5, label="Turkwel River"), size = text.fig.s, angle = 275) +
  geom_text(data=NULL, aes(x=35.95, y=4.9, label="Omo River"), size = text.fig.s, angle = 85) +
  geom_text(data=NULL, aes(x=36.6, y=4.4, label="Kenya"), size = text.fig.s) +
  geom_text(data=NULL, aes(x=36.6, y=4.53, label="Ethiopia"), size = text.fig.s) +
  annotation_scale() +
  annotation_north_arrow(location = "tr", which_north = "true",
                         style = north_arrow_fancy_orienteering) +
  labs(x=NULL, y=NULL) +
  coord_sf(xlim = c(extW.TB, extE.TB), ylim = c(extS.TB, extN.TB)) 
plot(map.highlight.Loperot)

### Context map

coastline <- ne_download(type = "land", category = "physical", returnclass = "sf")

extN.EA <- 15
extS.EA <- -5
extE.EA <- 52
extW.EA <- 29

# East Africa map extent

capitals <- data.frame(name=c("Nairobi", "Addis Ababa", "Mogadishu", "Kampala", "Juba", "Djibouti", "Asmara", "Khartoum", "Kigali", "Bujumbura", "Hargeisa"),
                       lat=c(1.227100, 9.095224, 1.993963, 0.42301291113399797, 4.857947971528862, 11.454152705708236, 15.420424899204724, 15.404307044921767, -1.7858219313913646, -3.3615853433518352, 9.607390908324566),
                       long=c(36.815842, 38.743306, 45.334426, 32.559768845193695, 31.57100812907596, 43.19653343132157, 38.90648857423801, 32.550435900518, 30.04438571691374, 29.36055868622438, 44.067797107891145))

EAfrica.map <- ggplot() +
  geom_sf(data = borders.africa, alpha=0.5) +
 #geom_sf_text(data=borders.africa, aes(label=name), size=5) +
  geom_polygon(data =  lake, aes(x=long, y=lat, group=group), fill = water.color) +
  geom_rect(aes(xmin = extW.TB, xmax = extE.TB, ymin = extS.TB, ymax = extN.TB), color = "chocolate1", fill = NA, size = 3) +
  geom_point(data = capitals, aes(x=long, y=lat), size = 1) +
 # geom_text(data = capitals, aes(x=long, y=lat, label = name), vjust = "top", hjust = "left", nudge_x = 0.2, size = text.small) +
  annotation_scale() +
  annotation_north_arrow(location = "tr", which_north = "true",
                         style = north_arrow_fancy_orienteering) +
  labs(x=NULL, y=NULL) +
  coord_sf(xlim = c(extW.EA, extE.EA), ylim = c(extS.EA, extN.EA)) 
plot(EAfrica.map)
ggsave("EAfrica_TBbox_nolabel.tiff", plot = EAfrica.map, device = "tiff", width = 7, height = 6, dpi = "retina")
