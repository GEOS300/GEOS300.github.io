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
