library(readr)

# select required dates from file by piping to Windows FINDSTR command and read it in
# Force the Date Column in file to d/m/yyyy... readr figures the others out correctly 
pow<- read_delim(
	pipe("findstr \"^Date ^1/2/2007 ^2/2/2007\" household_power_consumption.txt", open="rb"), 
	delim=";",  na="?", quote="", col_names = T, 
	col_types = cols(Date = col_datetime(format="%d/%m/%Y")) 
)
closeAllConnections()  # close the pipe 

# open a screen of the same size as target png to avoid messing labels due to resizing while copying to png
windows(8, 8, xpinch=60, ypinch=60 )  # 8x8 inch, 60 dpi = 480x480

# Third plot - First make an empty layout on screen since we will be plotting three series
# Then add 3 sets of points and legend
xvals <- pow$Date+pow$Time
plotYcolumns <- c("Sub_metering_1", "Sub_metering_2", "Sub_metering_3")
plotColors <- c("black", "red", "blue")
plot(xvals, pow$Sub_metering_1, ylim =  range( pow[plotYcolumns]), 
	 col = "black", type="n", xlab="", ylab = "Energy sub metering"
)
for (i in 1:3) points(xvals, pow[[plotYcolumns[i]]], col=plotColors[i], type="l")
legend("topright", legend=plotYcolumns, lty=1, col=plotColors) 

##copy screen plot to png and close png
myplot<-dev.copy(png, filename="plot3.png")
dev.off(myplot)