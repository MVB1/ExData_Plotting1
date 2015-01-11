# Exploratory Data Analysis
# Week 1, Assignment 1
# Plot 3, MVB

## Start
message("This script will generate Plot 3")
DateStarted <- date()
DateStarted
getwd()

## Functions for download and decompression
Download <- function () {
  message("Downloading zip file")
  fileUrl <- "http://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip"
  download.file(fileUrl, destfile="./Data.zip")
  message("Download completed")
}

Unzip <- function () {
  message("Decompressing file")
  message("This may take a few minutes")
  unzip(zipfile="./Data.zip")
  message("Decompression completed") 
}

## Check if file is present in working directory (download and decompression will be skipped if file is present)
if(!file.exists("./household_power_consumption.txt")){
  message("File is not present in working directory")
  Download()
  dateDownloaded <- date()
  dateDownloaded
  Unzip()
}

## Read file
message("Reading file")
HPC1 <- read.table(file="./household_power_consumption.txt", header=TRUE, sep=";", na.strings="?")

## Inspect data
str(HPC1)
head(HPC1)

## Generate tidy data set with appropriate column names
names(HPC1) <- tolower(names(HPC1))
names(HPC1) <- gsub("_", "", names(HPC1))
names(HPC1) <- gsub("1", "kitchen", names(HPC1))
names(HPC1) <- gsub("2", "laundry", names(HPC1))
names(HPC1) <- gsub("3", "waterheaterairconditioner", names(HPC1))
names(HPC1)

## Convert date variable
HPC1$date <- as.Date(HPC1$date, format="%d/%m/%Y")
class(HPC1$date)

## Select subset
HPC2 <- subset(HPC1, date >= "2007-02-01" & date <= "2007-02-02")
str(HPC2)
head(HPC2)

## Create datetime variable ('chron' package is preferred, but not required)
if("chron" %in% rownames(installed.packages()) == FALSE) {
  message("Package 'chron' is not installed")
  datetime <- paste(HPC2$date, HPC2$time)
  HPC2$datetime <- strptime(datetime, format="%Y-%m-%d %H:%M:%S")
  HPC2$time <- as.character(HPC2$time)
  str(HPC2)
  head(HPC2)
} else {
  message("Package 'chron' is installed")
  library(chron)
  datetime <- paste(HPC2$date, HPC2$time)
  HPC2$datetime <- strptime(datetime, format="%Y-%m-%d %H:%M:%S")
  HPC2$time <- times(format(HPC2$datetime, "%H:%M:%S"))
  str(HPC2)
  head(HPC2)
}

## Generate Plot 3 on screen (for visualization)
plot(HPC2$datetime, HPC2$submeteringkitchen, type="n", xlab="", ylab="Energy sub metering")
  lines(HPC2$datetime, HPC2$submeteringkitchen, col="black")
  lines(HPC2$datetime, HPC2$submeteringlaundry, col="red")
  lines(HPC2$datetime, HPC2$submeteringwaterheaterairconditioner, col="blue")
  legend("topright", legend=c("Sub_metering_1", "Sub_metering_2", "Sub_metering_3"), lty=1, col=c("black", "red", "blue"))

## Create png file for Plot 3
png(filename="plot3.png", width=480, height=480, bg="transparent")
plot(HPC2$datetime, HPC2$submeteringkitchen, type="n", xlab="", ylab="Energy sub metering")
  lines(HPC2$datetime, HPC2$submeteringkitchen, col="black")
  lines(HPC2$datetime, HPC2$submeteringlaundry, col="red")
  lines(HPC2$datetime, HPC2$submeteringwaterheaterairconditioner, col="blue")
  legend("topright", legend=c("Sub_metering_1", "Sub_metering_2", "Sub_metering_3"), lty=1, col=c("black", "red", "blue"))
dev.off()

## Finish
message("Plot 3 is generated")
DateCompleted <- date()
DateCompleted

## This script has been optimized for Windows 7 Professional and RStudio Version 0.98.1087
