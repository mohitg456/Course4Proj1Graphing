library(readr)

# select required dates from file by piping to Windows FINDSTR command and read it in
# Force the Date Column in file to datetime... readr figures the others out correctly 
pow<- read_delim(
	pipe("findstr \"^Date ^1/2/2007 ^2/2/2007\" household_power_consumption.txt", open="rb"), 
	delim=";",  na="?", quote="", col_names = T, 
	col_types = cols(Date = col_datetime(format="%d/%m/%Y")) 
)
closeAllConnections()  # close the pipe 

# make a histogram on screen
hist(pow$Global_active_power, 
	 col = "red",
	 main = "Global Active Power",
	 xlab = "Global Active Power (kilowatts)", 
	 ylab = "Frequency"
)

#copy screen plot to png and close png
plot1<-dev.copy(png, filename="plot1.png")
dev.off(plot1)