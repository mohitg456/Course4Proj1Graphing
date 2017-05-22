library(readr)

# select required dates from file by piping to Windows FINDSTR command and read it in
# Force the Date Column in file to d/m/yyyy... readr figures the others out correctly 
pow<- read_delim(
	pipe("findstr \"^Date ^1/2/2007 ^2/2/2007\" household_power_consumption.txt", open="rb"), 
	delim=";",  na="?", quote="", col_names = T, 
	col_types = cols(Date = col_datetime(format="%d/%m/%Y")) 
)
closeAllConnections()  # close the pipe 

# open a screen of the same size as target png to avoid mess ups due to resizing while copying to png
windows(12, 12, xpinch=40, ypinch=40 )  # 12x12 inch, 40 dpi = 480x480  

xvals <- pow$Date+pow$Time

par(mfrow=c(2,2), cex=0.6)

# First Plot
plot(xvals, pow$Global_active_power, col = "black", type="l", xlab="", ylab = "Global Active Power")

# Second Plot
plot(xvals, pow$Voltage, col = "black", type="l", xlab="datetime", ylab = "Voltage", yaxp=c(232,248,8))

# Third plot - First make an empty layout on screen since we will be plotting three series
# Then add 3 sets of points and legend
plot3Ycolumns <- c("Sub_metering_1", "Sub_metering_2", "Sub_metering_3")
plot3Colors <- c("black", "red", "blue")
plot(xvals, pow$Sub_metering_1, ylim =  range( pow[plot3Ycolumns]), 
	 col = "black", type="n", xlab="", ylab = "Energy sub metering"
)
for (i in 1:3) points(xvals, pow[[plot3Ycolumns[i]]], col=plot3Colors[i], type="l")
legend("topright", legend=plot3Ycolumns, lty=1, col=plotColors, bty="n") 


# Fourth Plot
plot(xvals, pow$Global_reactive_power, col = "black", type="l", xlab = "datetime")



##copy screen plot to png and close png
myplot<-dev.copy(png, filename="plot4.png")
dev.off(myplot)