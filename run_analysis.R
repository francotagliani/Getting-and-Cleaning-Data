initial_folder <- "./data/"
filename <- paste(initial_folder,"Final_Exam_W4_Coursera.zip",sep="")
   
# Checking if archieve already exists.
if (!file.exists(filename)){
  fileURL <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
  download.file(fileURL, filename)
}  
resulting_folder <- paste(initial_folder,"UCI HAR Dataset",sep="")
# Checking if folder exists
if (!file.exists(resulting_folder)) { 
  unzip(filename,exdir=gsub("/$","",initial_folder)) 
}

#Import Data Phase
initial_folder <-paste(initial_folder,"UCI HAR Dataset/",sep="")
test_folder <- paste(initial_folder,"test/",sep = "")
train_folder <- paste(initial_folder,"train/",sep = "")
initial_files <- list.files(initial_folder)
test_files <- list.files(test_folder)
train_files <- list.files(train_folder)
library(dplyr)
features <- read.table(paste(initial_folder,initial_files[grep("^[Ff]eatures.?t",initial_files)],sep=""), col.names = c("function_id","function_val"))
activities <- read.table(paste(initial_folder,initial_files[grep("^[Aa]ctivity.?",initial_files)],sep=""), col.names = c("activity_id", "activity"))
subject_test <- read.table(paste(test_folder,test_files[grep("^[Ss]ubject?",test_files)],sep=""), col.names = "subject_id")
x_test <- read.table(paste(test_folder,test_files[grep("^[Xx]_?",test_files)],sep=""), col.names = features$function_val)
y_test <- read.table(paste(test_folder,test_files[grep("^[Yy]_?",test_files)],sep=""), col.names = "code")
subject_train <- read.table(paste(train_folder,train_files[grep("^[Ss]ubject?",train_files)],sep=""), col.names = "subject_id")
x_train <- read.table(paste(train_folder,train_files[grep("^[Xx]_?",train_files)],sep=""), col.names = features$function_val)
y_train <- read.table(paste(train_folder,train_files[grep("^[Yy]_?",train_files)],sep=""), col.names = "code")

#Merges the training and the test sets to create one data set.
X <- rbind(x_train,x_test)
Y <- rbind(y_train,y_test)
subject <- rbind(subject_train,subject_test)
dataset <- cbind(subject,Y,X) 

#LABELLING
tidy_dataset <- dataset %>% select(subject_id, code, contains("mean"), contains("std"))
tidy_dataset$code <- activities[tidy_dataset$code, 2]
names(tidy_dataset)<-gsub("Acc", "Accelerometer", names(tidy_dataset))
names(tidy_dataset)<-gsub("Jerk", "Jerk", names(tidy_dataset)) 
names(tidy_dataset)<-gsub("Gyro", "Gyroscope", names(tidy_dataset))
names(tidy_dataset)<-gsub("BodyBody", "Body", names(tidy_dataset))
names(tidy_dataset)<-gsub("Body", "Body", names(tidy_dataset))
names(tidy_dataset)<-gsub("Mag", "Magnitude", names(tidy_dataset))
names(tidy_dataset)<-gsub("^t", "Time", names(tidy_dataset))
names(tidy_dataset)<-gsub("tBody", "TimeBody", names(tidy_dataset))
names(tidy_dataset)<-gsub("mean", "_Mean", names(tidy_dataset), ignore.case = TRUE)
names(tidy_dataset)<-gsub("std", "_Std", names(tidy_dataset), ignore.case = TRUE)
names(tidy_dataset)<-gsub("freq", "Frequency", names(tidy_dataset), ignore.case = TRUE)
names(tidy_dataset)<-gsub("^f", "Frequency", names(tidy_dataset))
names(tidy_dataset)<-gsub("angle", "Angle", names(tidy_dataset))
names(tidy_dataset)<-gsub("[Gg]ravity", "Gravity", names(tidy_dataset))
names(tidy_dataset)<-gsub("[.]", "", names(tidy_dataset)) 
names(tidy_dataset)<-gsub("[_]", "", names(tidy_dataset)) 
names(tidy_dataset)[2] = "ActivityName"
names(tidy_dataset)[1] = "SubjectId"
names(tidy_dataset)<-gsub("std", "STD", gsub("^[_]", "", gsub('([[:upper:]])', '_\\1', names(tidy_dataset))), ignore.case = TRUE)

#Second Dataset
FinalData <- tidy_dataset %>% group_by(Subject_Id, Activity_Name) %>% summarise_all(funs(mean))
write.table(FinalData, "FinalData.txt", row.name=FALSE)
str(FinalData)
