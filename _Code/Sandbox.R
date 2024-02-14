Temp_Convert <- function(Temp,unit.in="C"){
    # Converts back and forth between Celsius and Kelvin
    # If unit in == C assumes you want K out and vice versa
    if (unit.in == "C") {
       return(Temp+273.15)
    } else if (unit.in == "K") {
       return(Temp-273.15)
    } else {
       stop("Give a valid unit to proceed")
    }
}

TempC <- c(-10,0,10)
Temp_Convert(TempC)

TempK <- c(200,300,400)
Temp_Convert(TempC,unit.in='K')


C_s_g = 2 #MJ m-3 K-1
Delta_T = 1 #K
Delta_t = 3600 #s (1 hour)
z = 0.01 #m (1 cm)

H_g_z = C_s_g*Delta_T/Delta_t*z
sprintf('%.3f W m<sup>-2</sup>',H_g_z)



library("zoo")
library("ggplot2")
library("reshape2")
library("latex2exp")
library("patchwork")
library("tidyr")
library("plyr")
library("lubridate")

# Import the data from github & parse the timestamp for each record
data_url='https://raw.githubusercontent.com/GEOS300/AssignmentData/main/WesthamIslandSoilData/20090324.txt'
df <- read.csv(file = data_url,na.strings="-9999")

# We have to parse the timestamp explicitly to convert it to a "time aware" object
df$TIMESTAMP <- as.POSIXct(df$TIME.PST.,format = "%Y/%m/%d %H:%M")

# Use linear interpolation to estimate missing H values where available
df$H_fill = na.approx(df$H,na.rm=FALSE)
# Backfill where linear interpolation didn't work (the first observation)
df$H_fill = na.locf(df$H_fill,fromLast=TRUE)

head(df)


plot_energy_fluxes <- melt(
  df[,c('TIME.PST.','R_n','H_filled','H_g')],
  id="TIME.PST.")

p1 <- ggplot(plot_energy_fluxes, aes(x = TIMESTAMP, y = value, group = variable)) +
  geom_line(aes(color = variable,linetype = variable)) +
  scale_color_manual(labels = c('Net Radiation','Sensible Heat Flux','Soil Heat Flux'),values = c('black','red','blue')) +
  scale_linetype_manual(labels = c('Net Radiation','Sensible Heat Flux','Soil Heat Flux'), values = c("solid","dotted","dashed"))+
  
  # Note: You can use a markup language called LaTeX to format labels.  Replace Units,subscript, and superscript with the appropriate unit for radiative fluxes
  labs(y = "W m-2 s-1",x='Time')

p1 + plot_annotation(sprintf('Student # %i',Student.Number))


df[,c('TIME.PST.','R_n','H_filled','H_g')]


T_1 = (4.18+1.98)/2 # Average temperature (deg C) between 5cm and 10cm at 12:00
T_2 = (4.83+2.45)/2 # Average temperature (deg C) between 5cm and 10cm at 13:00
H_g = 18.035 # Average soi heat flux (W m-2) at 7.5 cm over the interval 

Delta_T_delta_t=(T_2-T_1)/3600 # Change in temperature over the 3600 s interval
C_s = H_g/.05/Delta_T_delta_t * 1e-6 # Rearrange Fourier's Law and solve, and convert from J to MJ

sprintf('C = %.2f MJ m-3 K-1',C_s)