#### Ejemplos : Series economicas ####

rm(list = ls())
setwd("C:/Users/AZCH/Desktop/Clase4_R/")
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
















