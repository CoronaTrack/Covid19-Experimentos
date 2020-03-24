library(brmap)
library(maptools)
library(rgdal) # ensure rgdal is loaded
library(readxl)
library(tidyverse)
library(colorRamps)
library(leaflet)
library(htmlwidgets)
library(colorRamps)
library(lubridate)
library(stringi)
library(stringr)
library(htmltools)
library(brazilmaps)

workdir <- "/home/cdesantana/Covid19-Experimentos/charles_20200323"
setwd(workdir)
data <- read.csv("data/covid19-75f80f882b00403685356fe46b4f0019.csv")

brmap <- get_brmap("State")
codigos <- c("RO","AC","AM","RR","PA","AP","TO","MA","PI","CE","RN","PB","PE","AL","SE","BA","MG","ES","RJ","SP","PR","SC","MS","MT","GO","DF","RS")
brmap$cod <- codigos

mymap <- brmap %>% left_join(data %>% filter(place_type == "state") %>% mutate(state = toupper(state)) %>% filter(is_last == "True"), c("cod" = "state"))
factpal <- colorFactor(topo.colors(5), mymap$confirmed)
m <- leaflet() %>% addPolygons(data = mymap,stroke = FALSE, smoothFactor = 0.2, fillOpacity = 1, color = ~factpal(mymap$confirmed), opacity = 1.0, popup = paste(mymap$nome," - ",mymap$confirmed, " casos ",sep="")) 
saveWidget(m, paste("mapas/mapa_casos_estados.html",sep=""), selfcontained = TRUE) 
