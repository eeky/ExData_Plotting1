##########################################################
#
#Exploratory Data Analysis Course - Week 1 Assignment
#
#Created by Luis Gama
#
#09-28-2016
#
##########################################################

#Assignment dataset download
fileURL <- "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip"
download.file(fileURL, "./data/ElectricPwrCons.zip")

#Unzip the compressed file
unzip("./data/ElectricPwrCons.zip", exdir = "./data")

#Estimating how much memmory will be needed to load the file into R
#2,075,269 lines x 9 cols x 8 bytes/numeric = 149,419,368 bytes or ~149,41MB.
#My current system has 16GB of RAM, so that's fine

#We need all samples generated in 1/2/2007 and 2/2/2007.
#So 60 minutes * 48 hours = 2880 rows + 1 row for Saturday to appear in the x-axis :-)

#I take a look in the file using Notepad++ and saw that the last reading
#before 1/2/2007 was in 31/1/2007;23:59:00, so I used it as a starting
#point for the grep function inside skip param.

electricData <- read.table("./data/household_power_consumption.txt", 
                           header = FALSE,
                           sep = ";",
                           col.names = c("Date","Time","Global_active_power","Global_reactive_power","Voltage","Global_intensity","Sub_metering_1","Sub_metering_2","Sub_metering_3"),
                           na.strings = "?",
                           colClasses = c("character", "character", "numeric", "numeric", "numeric", "numeric", "numeric", "numeric", "numeric"),
                           skip = grep("31/1/2007;23:59:00", readLines("./data/household_power_consumption.txt")), nrows = 2881)

#Using lubridate to convert from char to date
require("lubridate")

#Concatenating Date and Time
datetime <- dmy_hms(paste(electricData$Date, electricData$Time, sep = " "))

#Changing locale to English, so weekdays are shown as the assignment requires
Sys.setlocale("LC_TIME", "English")

#Plot 2
with(electricData, plot(Global_active_power ~ datetime, xlab = "", ylab = "Global Active Power (kilowatts)", type = "l"))

#Creating PNG file
dev.copy(png, file = "plot2.png")
dev.off()