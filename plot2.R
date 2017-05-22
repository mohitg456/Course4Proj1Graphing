library(readr)

# select required dates from file by piping to Windows FINDSTR command and read it in
# Force the Date Column in file todatetime... readr figures the others out correctly 
pow<- read_delim(
	pipe("findstr \"^Date ^1/2/2007 ^2/2/2007\" household_power_consumption.txt", open="rb"), 
	delim=";",  na="?", quote="", col_names = T, 
	col_types = cols(Date = col_datetime(format="%d/%m/%Y")) 
)
closeAllConnections()  # close the pipe 

# make a plot on screen
plot((pow$Date+pow$Time), pow$Global_active_power, 
	 col = "black", type="l", 
	 xlab="",
	 ylab = "Global Active Power (kilowatts)"
)

#copy screen plot to png and close png
myplot<-dev.copy(png, filename="plot2.png")
dev.off(myplot)