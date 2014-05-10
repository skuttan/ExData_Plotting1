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

# Create days based on Date and Time fields
days <- strptime(paste(hpcDate$"Date",hpcDate$"Time", sep = " "),format = '%d/%m/%Y %H:%M:%S')

# open png device
png("plot4.png")

# Create space for the 4 plots
par(mfrow = c(2,2))

# Plot Global Active Power
plot(days,hpcDate[,3], type="l", ylab="Global Active Power", xlab="")

# Plot Voltage
plot(days,hpcDate[,5], type="l", ylab="Voltage", xlab="datetime")

# Plot Sub metering - multiple graphs overlay
plot(days,hpcDate[,7], type="l", ylab="Energy sub metering",xlab="")
par(new=T)
plot(days,hpcDate[,8], type="l", ylab="Energy sub metering", axes=F, col="red", ylim=c(0,30),,xlab="")
par(new=T)
plot(days,hpcDate[,9], type="l", ylab="Energy sub metering", axes=F, col="blue", ylim=c(0,30),,xlab="")
par(new=T)
legend("topright",cex=0.7,lty=1,col=c("black","blue","red"),legend=c(colnames(hpcDate)[7],colnames(hpcDate)[8],colnames(hpcDate)[9]))
par(new=F)

# Plot Global Reactive Power
plot(days,hpcDate[,4], type="l", ylab="Global_reactive_power",xlab="datetime")

# close the device
dev.off()

