# Check if file exists in working directory. Else download 
dlZip <- "household_power_consumption.zip"
dlTxt <- "household_power_consumption.txt"

if(!file.exists(dlTxt))
{
  message("Text file does not exist.. try for zip file")
  if(!file.exists(dlZip)){
    message("zip file does not exist as well... downloading...")
    download.file("https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip",dlZip )
  }
  message("extracting text file from zip")
  unzip(dlZip)
}  

# Read certain rows based on date range. 
# Initially try with lower skip value and adjust till you are near 
# the data range you want. Similarly nrow
# this way you dont load a large data set to memory.

hpc <- read.table(dlTxt, nrow=6000,skip=66000, header=TRUE, sep = ";", na.strings="?")

# Issue with creating colnames in prev command - Seems to be with skip parameter
# So create a small subset which has the column names.

hpcCol <- read.table(dlTxt, nrow=10, header=TRUE,sep = ";", na.strings="?")

# Set the column names
colnames(hpc) <- colnames(hpcCol)

# Extract the data based on the date ranges required.
hpcDate <- hpc[which(hpc$"Date" %in% c("1/2/2007", "2/2/2007")),]

# open png device
png("plot1.png")

# Hist function
hist(hpcDate$"Global_active_power", col="red", ylim = c(0,1200), main="Global Active Power ", xlab="Global Active Power (kilowatts)")

# close the device
dev.off()
