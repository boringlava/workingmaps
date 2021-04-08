pacman::p_load(here, dplyr, ggplot2, ggthemes, ggspatial, ggmap, ggsn)

### Add sites
TMPsites <- read.csv(here("data", "TMPsites.csv"))
TBIsites <- TMPsites %>%
  filter(grepl('TBI', site)) %>%
  add_row(lat = -1.227100,
          long = 36.815842,
          site = "Nairobi",
          age_Ma = NA)

extN.TB <- 7
extS.TB <- -3.5
extE.TB <- 43
extW.TB <- 31
mapbox <- c(extW.TB, extS.TB, extE.TB, extN.TB) 

TB.terrain <- get_stamenmap(mapbox, maptype= "terrain-background", zoom=7)

theme_set(theme_classic(base_family = "Helvetica", base_size = 18))

ggmap(TB.terrain) +
  geom_point(data=TBIsites, aes(x=long, y=lat), color="chocolate1", size=3) +
    scalebar(location="bottomleft", dist=100, dist_unit="km", transform=TRUE,
           x.min=extW.TB, x.max=extE.TB, y.min=extS.TB, y.max=extN.TB,
           st.dist=0.02, st.size=3, st.bottom=FALSE, anchor=c(x=40.3, y=-3.4)) +
  labs(x=NULL, y=NULL)
