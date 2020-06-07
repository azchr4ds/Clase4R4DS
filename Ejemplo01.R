#### Ejemplos : Series economicas ####

rm(list = ls())
setwd("C:/Users/AZCH/Desktop/Clase4R4DS/")
getwd()
dir()
# Precios de un articulo : Oro

#### cargamos la data ####
Oro <- read.csv("GOLDAMGBD228NLBM.csv.txt", na.strings = ".")

#  Modifiquemos los nombres de las variables :
colnames(Oro) <- c("Fecha", "Precio")

# Estrucctura del data frame 
str(Oro)


#### limpiar el data frame ####
# Veamos la existencia de elementos NA en la columna Precio
sum(is.na(Oro$Precio))

# Limpiamos loa NA 
Oro <- na.omit(Oro)

# Convertimos la variable Fecha en un dato de tipo Date
Oro$Fecha <- as.Date(Oro$Fecha)
str(Oro)

#### Agregamos columnas con informacion secundaria ####
# "pensando en lo que haremos mas adelante"
View(Oro$Fecha)

# agreguemos una columna con el dia de la semana 
Oro$dia <- weekdays(Oro$Fecha)


# Agregamos una columna con el nombre del mes 
Oro$mes <- months(Oro$Fecha)

# Agreguemos una columna con el año de cada observacion 
library(lubridate)
library(help = "lubridate")

Oro$año <- year(Oro$Fecha)

# Agreguemos una columna con el dia (numero)
Oro$NumDia <- day(Oro$Fecha)

# Agreguemos una columna con la decada a la cual pertenece la data: Usaremos dplyr
library(dplyr)
floor_decade <- function(value){
  return(value - value%%10)
}
Oro <- mutate(.data = Oro, decada = floor_decade(Oro$año))


# Veamos finalmente la estructura del dataframe Oro
str(Oro)


#### Graficos de dispersion ####

# Diagrama de dispersion del data frame en toda la linea del tiempo
head(Oro, n = 1)$Fecha # primer dia de la data 
tail(Oro, n =1)$Fecha # ultimo dia de la data 

# Empecemos usando la libreria graphics
# Escribamos en la etiqueta del eje X la ventana de tiempo
x11()

jpeg("PrecioOro.jpeg")
plot(x = Oro$Fecha, y= Oro$Precio,type ="l",
     xlab = paste("Fecha [" , head(Oro, n = 1)$Fecha , "-", tail(Oro, n =1)$Fecha,"]"),
     ylab = "Precio [USD]",
     main = "Precio del Oro [GOLDAMGBD228NLBM]",
     sub = "Fuente ; https://fred.stlouisfed.org")
dev.off()

# Hagamos un grafico de dispersion en ggplot2
library(ggplot2)
ggplot(data = Oro, mapping = aes(x = Fecha, y = Precio))+
  geom_line()+
  xlab(paste("Fecha [" , head(Oro, n = 1)$Fecha , "-", tail(Oro, n =1)$Fecha,"]"))+
  ylab("Precio [USD]")+
  ggtitle("Precio del Oro [GOLDAMGBD228NLBM]")+
  labs(subtitle = "Fuente ; https://fred.stlouisfed.org",
       caption = "Clase 4:CTIC-UNI")

# Luego de instalar los paquetes hrbrthemes y viridis, podemos ver su documentacion 
library(hrbrthemes)
library(viridis)

library(help = "hrbrthemes")
library(help = "viridis")

# Practiquemos el uso del operador %>% (pipe/tuberia)
x11()
Oro %>%
  ggplot(aes(x = Fecha, y = Precio, colour = año))+
  geom_line() + # capa geometrica
  scale_color_viridis()+ 
  theme_ipsum()+
  xlab(paste("Fecha [" , head(Oro, n = 1)$Fecha , "-", tail(Oro, n =1)$Fecha,"]"))+
  ylab("Precio [USD]")+
  ggtitle("Precio del Oro [GOLDAMGBD228NLBM]")+
  labs(subtitle = "Fuente ; https://fred.stlouisfed.org",
       caption = "Clase 4:CTIC-UNI")+
  theme( # https://github.com/azchr4ds/Clase3R4DS/blob/master/script02.R
    legend.position = c(0.05, 0.85),
    plot.title = element_text(size = 18, hjust = 1),
    plot.subtitle = element_text(size = 9, hjust = 1)
  )


# Convirtamos la variable año en una variable categorica (factor)
x11()
Oro <- Oro %>%
  mutate(año= as.factor(año))

str(Oro)

Oro %>%  
  ggplot(aes(x = Fecha, y = Precio, colour = año))+
  geom_line() + # capa geometrica
  # scale_color_viridis()+ 
  # theme_ipsum()+
  xlab(paste("Fecha [" , head(Oro, n = 1)$Fecha , "-", tail(Oro, n =1)$Fecha,"]"))+
  ylab("Precio [USD]")+
  ggtitle("Precio del Oro [GOLDAMGBD228NLBM]")+
  labs(subtitle = "Fuente ; https://fred.stlouisfed.org",
       caption = "Clase 4:CTIC-UNI")+
  theme( # https://github.com/azchr4ds/Clase3R4DS/blob/master/script02.R
    legend.position = c(0.1, 0.5),
    plot.title = element_text(size = 18, hjust = 1),
    plot.subtitle = element_text(size = 9, hjust = 1)
  )
ggsave("Oro1.png", width = 16, height = 9, dpi = 72)

#### Calculos y graficos de resumen ####
Oro2015 <- Oro %>% filter(año == 2015)
Oro2016 <- filter(.data = Oro, Fecha > "2015-12-31" & Oro$Fecha<= "2016-12-31")

# Creamos un data frame para los promedios anuales 
PromedioAnual <- Oro %>%
  group_by(año)%>%
  summarise(Numero = n(), Promedio = mean(Precio, na.rm = TRUE))

# Mostremos el comportamiento promedio por año
PromedioAnual <- PromedioAnual %>%
  mutate(año = 1968:2020)

PromedioAnual %>%
  ggplot(mapping = aes(x = año , y = Promedio))+
  geom_point()+
  labs(title = "Promedio Anual de los precios del oro",
       subtitle = "Fuente : FED de Sn Louis",
       caption = "Clase4: CTIC-UNI")+
  ylab("Precios [USD]")+
  xlab(paste("Años : " , min(PromedioAnual$año) ,"-" , max(PromedioAnual$año)))

PromedioAnual %>% 
  mutate(decada = as.factor(floor_decade(PromedioAnual$año))) %>%
  ggplot(mapping = aes(x = año , y = Promedio, colour = decada))+
  geom_point()+
  labs(title = "Promedio Anual de los precios del oro",
       subtitle = "Fuente : FED de Sn Louis",
       caption = "Clase4: CTIC-UNI")+
  ylab("Precios [USD]")+
  xlab(paste("Años : " , min(PromedioAnual$año) ,"-" , max(PromedioAnual$año)))
  



























