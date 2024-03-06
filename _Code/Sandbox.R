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


DOY = 13
latitude = 49.12940598 # degrees
longitude = -122.9849319 # degrees
central_meridian_PST = -120 # degrees
I_0 = 1361 # Wm-2

gamma = 2*pi /365*(DOY-1) 
sprintf('gamma = %f',gamma)
delta = 0.006918 - 0.399912 *cos(gamma)+0.070257 *sin(gamma)-0.006758* cos(2*gamma) + 0.000907*sin(2*gamma)-0.002697*cos(3*gamma)+0.00148 *sin(3*gamma)
sprintf('delta = %f in radians, or %f in degrees works too',delta,delta*180/pi)

LMST = 12.75+(longitude-central_meridian_PST)*4/60
sprintf('LMST = %f in hours',LMST)
sprintf('**Note**: their was an error in the LMST equation in the lecture slide, which has since been corrected.')
LMST_error = 12.75-(longitude-central_meridian_PST)*4/60
sprintf('Following the incorrect equation would yield: %f accept this, along with calculations of LAT, h, and z based on it',LMST_error)

Delta_LAT = 229.18*(0.000075+0.001868*cos(gamma)-0.032077*sin(gamma)
             -0.014615*cos(2*gamma)-0.040849*sin(2*gamma))
sprintf('Delta_LAT = ',Delta_LAT,' in minutes')

LAT = LMST-Delta_LAT/60
sprintf('LAT %f',LAT)
LAT_error=LMST_error-Delta_LAT/60
sprintf('**Note**: %f'' is also acceptable as per above',LAT_error)

h = 15*(12-LAT)
sprintf('hour-angle = %f in degrees',h)
h_error = 15*(12-LAT_error)
sprintf('**Note**: %f is also acceptable as per above',h_error)

cos_z = sin(latitude*pi/180)*sin(delta)+cos(latitude*pi/180)*cos(delta)*cos(h*pi/180)
z = acos(cos_z)*180/pi
sprintf('zenith angle = %f in degrees',z)
cos_z_error = sin(latitude*pi/180)*sin(delta)+cos(latitude*pi/180)*cos(delta)*cos(h_error*pi/180)
z_error = acos(cos_z_error)*180/pi
sprintf('**Note** %f s also acceptable as per above < the error has a minor impact on the final answer.',z_error)

R_av_Rsq = 1.00011+0.034221*cos(gamma)+0.001280*sin(gamma)+\
            0.000819*cos(2*gamma)+0.000077*sin(2*gamma)
I_ex=I_0*R_av_Rsq*cos(z*pi/180)
sprintf('Extraterrestrial Irradiance = %f W m-2',I_ex)
I_ex_error=I_0*R_av_Rsq*cos(z_error*pi/180)
sprintf('**Note** %f is also acceptable as per above < the error has a minor impact on the answer.',I_ex_error)

m = 1/cos(z*pi/180)
m_error = 1/cos(z_error*pi/180)

SW_in = Selection['SW_IN_1_1_1'].max()
Psi_a = (SW_in/I_ex)**(1/m)
sprintf('Bulk transimissivity = %f',Psi_a)
Psi_a_error = (SW_in/I_ex)**(1/m_error)
sprintf('**Note** %f is also acceptable as per above < the error has a minor impact on the answer.',Psi_a_error)



# Import the data from github & parse the timestamp for each record
data_url='https://raw.githubusercontent.com/GEOS300/AssignmentData/main/Climate_Summary_BB.csv'
df <- read.csv(file = data_url)

# We have to parse the timestamp explicitly to convert it to a "time aware" object
df$TIMESTAMP <- as.POSIXct(df$TIMESTAMP,format = "%Y-%m-%d %H%M")
# Using this we can get a extra variables (DOY & HOUR) that will be helpful later
df$HOUR <- format(df$TIMESTAMP,format = "%H")
df$DOY <- format(df$TIMESTAMP,format = "%j")

# Calculate Albedo
df$Albedo = df$SW_OUT_1_1_1/df$SW_IN_1_1_1

Start ='2024-01-12 0000'
End ='2024-01-20 0000'

# Select a subset of the variables
Query.Cols <- c('TIMESTAMP','DOY','HOUR','SW_IN_1_1_1','LW_IN_1_1_1','SW_OUT_1_1_1', 'LW_OUT_1_1_1','TA_1_1_1','TS_1','RH_1_1_1')

# Run the query and save it to a new dataframe called "Selection"
Selection <- df[which((df$TIMESTAMP >= Start) & (df$TIMESTAMP <End)),
        Query.Cols]

Max_SW_Obs <- Selection[Selection$TA_1_1_1==max(Selection$TA_1_1_1), c('TIMESTAMP','TA_1_1_1')]

# Must divide minutes by 60 and subtract 15/60 to get fractional hour of mid-point
Time <- as.numeric(format(Max_SW_Obs$TIMESTAMP, "%H")) +
               as.numeric(format(Max_SW_Obs$TIMESTAMP, "%M"))/60 -15/60

Time

DOY = as.numeric(Selection[Selection$TA_1_1_1==max(Selection$TA_1_1_1), c('DOY')])
DOY


12.5 %% 1

floor(12.4)

T<- 14.35
sprintf('%d:%d',floor(T),floor((T%%1)*100))




# Number of seconds in a year
P = 60 * 60 * 24 
# Solve
omega_a = 2*pi/P
sprintf('Angular Frequncy of a year %0.3e s-1',omega_a)



#| warning: false
# Import the data from github & parse the timestamp for each record
## **NOTE**  Make sure to edit the filename in the URL so it corresponds to the date you were assigned.


# # We have to parse the timestamp explicitly to convert it to a "time aware" object

# # All sub-surface data were collected at the same frequency (15-minute intervals).  
# # However, H data were only available at 30-minute resolution.  
# # So we'll use a simple gap-filling procedure to estimate missing values from the nearest available observations.   
# # Use linear interpolation to estimate missing H values where available
# df$H_filled = na.approx(df$H,na.rm=FALSE)
# # Backfill where linear interpolation didn't work (the first observation)
# df$H_filled = na.locf(df$H_filled,fromLast=TRUE)

# print('Data imported and gap-filled successfully.')
data_url='C:/Users/User/Teaching/GEOS300/Assignment03/'
Time = '200008021530'
Turbulence = sprintf('%sturbulence%s.txt',data_url,Time)
df_Turbulence <- read.csv(file = Turbulence,na.strings="-9999",skip=7)
df_Turbulence$TIMESTAMP <- as.POSIXct(df_Turbulence$YYYY.MM.DD.HH.MM.SS.,format = "%Y-%m-%d %H:%M%:%s")
head(df_Turbulence)


Wind = sprintf('%swind%s.txt',data_url,Time)
df_Wind <- read.csv(file = Wind,na.strings="-9999",skip=6)
head(df_Wind)




# Import the data from github & parse the timestamp for each record
## **NOTE**  Make sure to edit the timestamp variable so it corresponds to the timestamp you were assigned.
data_url='https://raw.githubusercontent.com/GEOS300/AssignmentData/main/KettlemanCityCottonField/'
TimeStamp = '200008191630'


Turbulence <- read.csv(file = sprintf('%sturbulence%s.txt',data_url,Time),
                        na.strings="-9999",skip=7)
Turbulence$TIMESTAMP <- as.POSIXct(Turbulence$YYYY.MM.DD.HH.MM.SS,format = "%Y-%m-%d %H:%M:%S")
Turbulence=Turbulence[,!(names(Turbulence) %in% c('YYYY.MM.DD.HH.MM.SS'))]

Wind <- read.csv(file = sprintf('%swind%s.txt',data_url,Time),
                na.strings="-9999",skip=6)

print('Data imported and gap-filled successfully.')


Wind$lnz <- log(Wind$Height..m.)
Wind$U <- Wind$Horizontal.wind.velocity..m.s.

modelFit <- lm(lnz~U,data=Wind)
summary(modelFit)
Wind
