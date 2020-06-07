#### configuracion y seteo ####
rm(list = ls())
setwd("C:/Users/AZCH/Desktop/Clase4R4DS")


#### Instalar quantmod ####
library(quantmod)
library(help = "quantmod")

help("getSymbols")


#### Analisis de la media (Estacionariedad) ####
# Tesla_cte : Aparentemente tiene un comportamiento Estacionario
# Tesla_t :Aparentemente NO tiene un comportamiento Estacionario
# Estoo pues usamos una diferente ventana de tiempo

Tesla_cte <- getSymbols(Symbols = c("TSLA"),# ticket de la empresa (finance.yahoo.com)
                        from ="2010-07-01", # inicio de la ventana de tiempo (fecha de inicio)
                        to = "2012-12-31", # fina dela ventana de tiempo (fecha de fin)
                        auto.assign = FALSE, # Paradefinir una variable 
                        return.class = "data.frame") # en memoria cargue un objeto de tipo data.frame

class(Tesla_cte)
Tesla_cte <- cbind(fecha = as.Date(rownames(Tesla_cte)), Tesla_cte )
rownames(Tesla_cte) <- 1:nrow(Tesla_cte)

Tesla_t <-getSymbols(Symbols = c("TSLA"),# ticket de la empresa (finance.yahoo.com)
                   from ="2019-08-01", # inicio de la ventana de tiempo (fecha de inicio)
                   to = "2020-02-01", # fina dela ventana de tiempo (fecha de fin)
                   auto.assign = FALSE, # Paradefinir una variable 
                   return.class = "data.frame") # en memoria cargue un objeto de tipo data.frame
Tesla_t <-cbind(fecha = as.Date(rownames(Tesla_t)) , Tesla_t)
rownames(Tesla_t) <- 1:nrow(Tesla_t)


# Veamos el comportamiento de la data visualmente :
library(dplyr)
library(ggplot2)
Tesla_cte %>% 
  select(fecha, TSLA.Open) %>%
  ggplot(aes(x = fecha, y = TSLA.Open))+
  geom_point(col = "#924235")


Tesla_t %>% 
  select(fecha, TSLA.Open) %>%
  ggplot(aes(x = fecha, y = TSLA.Open))+
  geom_point(col = "#3887B2")


#### Analisis de la varianza (Estacionariedad) ####
# veamos a IBM 

IBM <- getSymbols(Symbols = c("IBM"),
                  from ="1966-01-01", 
                  to = "1975-01-01", 
                  auto.assign = FALSE, 
                  return.class = "data.frame") 
IBM <- cbind(fecha = as.Date(rownames(IBM)), IBM)
rownames(IBM) <- 1: nrow(IBM)


# Observamos que la varianza depende del tiempo
IBM %>% 
  select(fecha, IBM.Open) %>%
  ggplot(aes(x = fecha, y = IBM.Open))+
  geom_point(col = "#3887B2")


#### AMEX - NASDAQ - NYSE ####
library(TTR)
library(help = TTR)

Empresas <- stockSymbols()

View(na.omit(Empresas[Empresas$Sector == "Energy", ]))

View(na.omit(Empresas[Empresas$Sector == "Energy" & Empresas$LastSale < 30 & Empresas$Exchange == "NASDAQ", ]))

Energy1 <- na.omit(Empresas[Empresas$Sector == "Energy" & Empresas$LastSale < 30 & Empresas$Exchange == "NASDAQ", ])
class(Energy1)


getSymbols(Symbols = Energy1$Symbol,
                          from = "2010-01-01",
                          )

View(IPWR)
class(IPWR)


# Veamos la resolucion 
# Microsoft : MSFT
MicrosoftDiario <- getSymbols(Symbols = c("MSFT"),
                              from = "1986-03-01",
                              to = "2020-06-01",
                              auto.assign = FALSE)

MicrosoftSemanal <- getSymbols(Symbols = c("MSFT"),
                              from = "1986-03-01",
                              to = "2020-06-01",
                              auto.assign = FALSE,
                              periodicity = "weekly")

MicrosoftMensual <- getSymbols(Symbols = c("MSFT"),
                               from = "1986-03-01",
                               to = "2020-06-01",
                               auto.assign = FALSE,
                               periodicity = "monthly")


class(MicrosoftDiario)
start(MicrosoftMensual)
end(MicrosoftDiario)
frequency(MicrosoftDiario)
frequency(MicrosoftSemanal)
frequency(MicrosoftMensual)


#### Definamos un objeto ts ####
# En resolucion mensual
AperturaMSFT <- ts(MicrosoftMensual$MSFT.Open,
                   start = c(1983,3),
                   frequency = 12)

class(AperturaMSFT)

plot(AperturaMSFT)
abline(reg = lm(AperturaMSFT ~ time(AperturaMSFT)))

start(AperturaMSFT)
end(AperturaMSFT)
boxplot(AperturaMSFT ~ cycle(AperturaMSFT))

