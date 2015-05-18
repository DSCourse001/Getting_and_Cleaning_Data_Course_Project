# Script will produce "tidy_data.txt" file with tidy data from source.
# Source Data need to be downloaded from the URL:
#   https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip
# 
# After that you should extract archive to R Working Directory.
# Folder with name "UCI HAR Dataset" should be created.
# 
# You can do this task manually or script will download and extract archive for you.
#
# After script execution R memory will contain "tidy_data" data.table
# You can use it for further analysis or remove.
#
# If you have Source Data in directory then this script should run 
# nearly 3-5 seconds on modern desktop PC (2015 year). This is mainly because of 
# use "data.table" and "LaF" packages.
# 

# Install Required Packages if we cannot load it
if (!require("data.table")) install.packages("data.table")
if (!require("LaF")) install.packages("LaF")
if (!require("dplyr")) install.packages("dplyr")

# Load packages
require("data.table")
require("LaF")
require("dplyr")

# If "UCI HAR Dataset" directory is not exists
#   then download ZIP archive and extract it
if (!file.exists("UCI HAR Dataset")) {
  url="https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"

  tmpZIPFile <- tempfile()
  download.file(url=url,destfile=tmpZIPFile,method="wget",quiet=T,mode="wb",extra=c("--no-check-certificate"))
  unzip(tmpZIPFile,overwrite = TRUE)
  unlink(tmpZIPFile)
}

# Getting Labels for Features and Activities
# File is really small, no metter use "fread" or "read.table"
actLab<-read.table("./UCI HAR Dataset/activity_labels.txt",header=F,colClasses="character")
setnames(actLab,1:2,c("Id","ActName"))

ftrLab<-read.table("./UCI HAR Dataset/features.txt",header=F,colClasses="character")
setnames(ftrLab,1:2,c("Id","ColName"))
colNums<-nrow(ftrLab)

# Step 1. Merges the training and the test sets to create one data set

# Fast Load Fixed Length Data (runs 3 times faster than read.table)
# You cannot load this file using "fread", it just will crush.
testlaf=laf_open_fwf(
  filename="./UCI HAR Dataset/test/X_test.txt"
  ,column_types=rep("numeric",colNums)
  ,column_widths=rep(16,colNums))
test<-testlaf[,]
close(testlaf)
setnames(test,1:ncol(test),ftrLab$ColName)

# Loading small files
test$Activity<-read.table("./UCI HAR Dataset/test/Y_test.txt",header=F,colClasses="numeric")[,1]
test$Subject<-read.table("./UCI HAR Dataset/test/subject_test.txt",header=F,colClasses="numeric")[,1]

# Using LaF package again
trainlaf=laf_open_fwf(
  filename="./UCI HAR Dataset/train/X_train.txt"
  ,column_types=rep("numeric",colNums)
  ,column_widths=rep(16,colNums))
train<-trainlaf[,]
close(trainlaf)
setnames(train,1:ncol(train),ftrLab$ColName)

train$Activity<-read.table("./UCI HAR Dataset/train/Y_train.txt",header=F,colClasses="numeric")[,1]
train$Subject<-read.table("./UCI HAR Dataset/train/subject_train.txt",header=F,colClasses="numeric")[,1]

data<-data.table(rbindlist(list(test,train),use.names=TRUE))
setcolorder(data,c(colNums+1,colNums+2,1:colNums))
rm(test,train,ftrLab,colNums)

# Step 2. Extracts only the measurements on the mean and standard deviation for each measurement. 
data<-data[,grep("(^(Activity|Subject)$|(mean|std)\\(\\))",names(data)),with=F]

# Step 3. Uses descriptive activity names to name the activities in the data set
data$Activity<-factor(data$Activity,labels=actLab$ActName)
rm(actLab)

# Step 4. Appropriately labels the data set with descriptive variable names.
data$Subject<-factor(data$Subject)
setnames(data,1:length(data),tolower(gsub("[-\\(\\)]","",names(data))))

# Step 5. From the data set in step 4, creates a second, independent tidy data 
#     set with the average of each variable for each activity and each subject.

# Set Grouping Element and Order by Grouping Element
data <- data %>% 
  group_by(activity,subject) %>%
    arrange(activity,subject)  

# Getting Average for each column by group
tidy_data<-summarise_each(data,funs(mean))
rm(data)

# Write Data to File "tidy_data.txt"
write.table(tidy_data,"tidy_data.txt",row.name=FALSE)

