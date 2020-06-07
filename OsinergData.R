rm(list = ls())
setwd(dir = "C:/Users/AZCH/Desktop/Clase4R4DS")
getwd()
dir()
# Algo de lectura previa
# https://www.r-bloggers.com/using-colclasses-to-load-data-more-quickly-in-r/
OsinergEnero2k18 <- read.table("201801_TABLA04_SICLI.txt", header = TRUE,sep = "\t",
                          col.names = c("CodEmpresa","Suministro", "PuntoSuministro","Fecha","RegistroActiva","RegistroPasiva","Periodo"),
                          colClasses = c("factor","factor","factor","character","numeric", "numeric", "character"))
class(OsinergEnero2k18)
str(OsinergEnero2k18)
dim(OsinergEnero2k18)

#### Conversion de la variable fecha ####
OsinergEnero2k18$Fecha

library(lubridate)
library(help = "lubridate")

# Creamos la variable FechaDate para recuperar la cadena que se tiene en el 
# data frame original 
OsinergEnero2k18$FechaDate <- ymd_hm(OsinergEnero2k18$Fecha)
class(OsinergEnero2k18$FechaDate)

# Usando libreria base
OsinergEnero2k18$year <- format(OsinergEnero2k18$FechaDate,"%Y")
OsinergEnero2k18$month <- format(OsinergEnero2k18$FechaDate,"%m")
OsinergEnero2k18$day <- format(OsinergEnero2k18$FechaDate,"%d")
OsinergEnero2k18$hour <- format(OsinergEnero2k18$FechaDate,"%H")
OsinergEnero2k18$minute <- format(OsinergEnero2k18$FechaDate,"%M")

# Usando funciones de lubridate
year(OsinergEnero2k18$FechaDate)
day(OsinergEnero2k18$FechaDate)
month(OsinergEnero2k18$FechaDate)
hour(OsinergEnero2k18$FechaDate)
minute(OsinergEnero2k18$FechaDate)

#### Evaluacio 1 ####
# La data proviene de : 
# https://www.osinergmin.gob.pe/seccion/institucional/regulacion-tarifaria/publicaciones/regulacion-tarifaria
# Algunos comentarios se encuentran en el foro del aula virtual 

# Reparticion de meses ::
# Alfredo Ortega : Enero (2018-2019)
# Gerson Padilla : Febrero (2018-2019)
# Jesus Mimbela : Marzo (2018-2019)
# Jorge Gallo : Abril (2018-2019) 
# Lady : MAyo (2018-2019) 
# Lazo Arroyo :Junio (2018-2019) 
# Leonardo Castillo : Julio (2018-2019)
# Lorena Dueñas : Agosto (2018-2019)  
# MArilyn Zapata : Setiembre (2018-2019)
# Renzo Peñaranda : Octubre (2018-2019)
# Ronny Delgado : Noviembre (2018-2019)
# Victor Lazo : Diciembre (2018-2019)

# Recordar que las variables son :
# Código de la Empresa Eléctrica Suministradora	
# Código del Suministro del Usuario Libre	
# Código del Punto de Suministro	
# Fecha (AAAAMMDDHHMM)	
# Registro de Energía Activa en kW.h	
# Registro de Energía Reactiva en kVarh	
# Periodo	


### habra evaluaciones de las clases 4ta, 5ta y 6ta
### Fecha de entrega : siguiente domingo hasta las 6:00AM
### Evaluacion clase 4 : 14/06/2020 [6:00AM]
### Evaluacion clase 5 : 21/06/2020 [6:00AM]
### Evaluacion clase 6 : 28/06/2020 [6:00AM]





