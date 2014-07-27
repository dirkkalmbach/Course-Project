#1 READ DATA
##1.1 Set Filepaths
path_of_X_train <- "~/UCI\ HAR\ Dataset/train/X_train.txt"
path_of_y_train <- "~/UCI\ HAR\ Dataset/train/y_train.txt"
path_of_X_test <- "~/UCI\ HAR\ Dataset/test/X_test.txt"
path_of_y_test <- "~/UCI\ HAR\ Dataset/test/y_test.txt"
path_of_features <- "~/UCI\ HAR\ Dataset/features.txt"
path_of_subject_train <- "~/UCI\ HAR\ Dataset/train/subject_train.txt"
path_of_subject_test <- "~/UCI\ HAR\ Dataset/test/subject_test.txt"

##1.2 Read Training- & Test-Data & their Label-Data
###1.2.1 Read Training-Data (X_train.txt -> train)
  #Problem: Variables are seperated by 2 whitespaces and every line begins with 
  #2 whitespaces (more Info to solve this: http://stackoverflow.com/a/20807399)
r <- readLines(path_of_X_train) #read the file
r2 <- gsub("([[:alpha:]]+) +([[:alpha:]]+)","'\\1 \\2'",r) #get rid off whitespace
train <- read.table(textConnection(r2)) #create target-file

###1.2.2 Read Training-Label-Data (X_label.txt -> train_label)
r <- readLines(path_of_y_train)
r2 <- gsub("([[:alpha:]]+) +([[:alpha:]]+)","'\\1 \\2'",r)
train_label <- read.table(textConnection(r2))

###1.2.3 Read Test-Data (X_test.txt -> test)
r <- readLines(path_of_X_test)
r2 <- gsub("([[:alpha:]]+) +([[:alpha:]]+)","'\\1 \\2'",r)
test <- read.table(textConnection(r2))

###1.2.4 Read Test-Label-Data (X_label.txt -> test_label)
r <- readLines(path_of_y_test)
r2 <- gsub("([[:alpha:]]+) +([[:alpha:]]+)","'\\1 \\2'",r)
test_label <- read.table(textConnection(r2))

##1.3 Read Features- & Subject-Files
###1.3.1 Read features.txt & store in vector-File FEATURES
r<-read.csv(path_of_features, sep=" ", header=FALSE)
features<-as.vector(r$V2)

###1.3.2 Read Subject-Files & Rename Test-/Train-Column
subject_train <- read.csv(path_of_subject_train, sep=" ", header=FALSE)
subject_test <- read.csv(path_of_subject_test, sep=" ", header=FALSE)

#####################################################################

#2 RENAME COLUMN
##2.1 Rename Test-/Train-Column
colnames(subject_train) <- c("Subject")
colnames(subject_test) <- c("Subject")

##2.1 Rename Column of Label-Files
colnames(train_label) <-c("Activity")
colnames(test_label) <-c("Activity")

#####################################################################

#3 MERGE
##3.1 Merge Activity-Column with TRAIN & TEST (cbind)
train<-cbind(train_label,train)
test<-cbind(test_label,test)

#3.2 Merge Subject-Colomn with TRAIN & TEST (cbind)
train<-cbind(subject_train, train)
test<-cbind(subject_test, test)

#3.3 Insert a GROUP Variable to identify Test- & Training-Subjects in the Endfile
g<- data.frame(matrix(nrow=7352, ncol=0))
g$Group=c("TRAIN")
train<-cbind(g, train)

g<- data.frame(matrix(nrow=2947, ncol=0))
g$Group=c("TEST")
test<-cbind(g, test)

#3.4 Merge TRAIN & TEST (rbind)
df <- rbind(train,test)

#####################################################################

#4 MAKING DF NICER
#4.1 Label the Activity-Values
df$Activity[df$Activity==1] <- "WALKING"
df$Activity[df$Activity==2] <- "WALKING_UPSTAIRS"
df$Activity[df$Activity==3] <- "WALKING_DOWNSTAIRS"
df$Activity[df$Activity==4] <- "SITTING"
df$Activity[df$Activity==5] <- "STANDING"
df$Activity[df$Activity==6] <- "LAYING"

#4.2 Rename all Column in df with feature-names
colnames(df) <- c("Group", "Subject", "Activity", features)

#4 EXTRACT ALL COLOMNS WITH CHARACTER-SEQUENCE MEAN OR STD
  #The following Code extracts all Columns in which the character-sequence
  #mean() or std() occured
  
  #buld empty data.frame
d <- data.frame(matrix(nrow=10299, ncol=0))

  #extract first 3 column (group, subject, activity) manually
d[1] <- df[1] 
d[2] <- df[2]
d[3] <- df[3]

  #extract the mean and std-columns automatically
for (i in 4:564) {
  if ( grepl("mean()", colnames(df[i])) | grepl("std()", colnames(df[i]))){
    d[colnames(df[i])] <- df[i] }
      }

write.csv(d, file="~/tidy_df.csv")
