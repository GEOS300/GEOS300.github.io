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
