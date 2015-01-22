

subject_test <- read.table("./subject_test.txt", quote="\"")
X_test <- read.table("./X_test.txt", quote="\"")
y_test <- read.table("./y_test.txt", quote="\"")

subject_train <- read.table("./subject_train.txt", quote="\"")
X_train <- read.table("./X_train.txt", quote="\"")
y_train <- read.table("./y_train.txt", quote="\"")


features <- read.table("./features.txt", quote="\"")


Y_name <- gsub("1","WALKING",y_test$V1)
Y_name <- gsub("2","WALKING_UPSTAIRS",Y_name)
Y_name <- gsub("3","WALKING_DOWNSTAIRS",Y_name)
Y_name <- gsub("4","SITTING",Y_name)
Y_name <- gsub("5","STANDING",Y_name)
Y_name <- gsub("6","LAYING",Y_name)
Y_test = as.data.frame(Y_name)


Y_name <- gsub("1","WALKING",y_train$V1)
Y_name <- gsub("2","WALKING_UPSTAIRS",Y_name)
Y_name <- gsub("3","WALKING_DOWNSTAIRS",Y_name)
Y_name <- gsub("4","SITTING",Y_name)
Y_name <- gsub("5","STANDING",Y_name)
Y_name <- gsub("6","LAYING",Y_name)
Y_train = as.data.frame(Y_name)


# creatubg 3 sets of datasets by rbinds.
X <- rbind(X_test,X_train)
y <- rbind(Y_test,Y_train)
subject <- rbind(subject_test,subject_train)

# change the column name for y and subject to "activity" and "subjects"
names(y) <- "activity"
names(subject) <- "subjects"

# adding the features column names to the merged data set
header <- features$V2
names(X) <- header

#merging the six datasets from the 3 sets of 2 datasets formed by rbind()
(merged <- cbind(X,y,subject))


# search for columns that contains mean() and std() to subset the data
means <-grep("mean\\(\\)",names(merged), value=TRUE)  # took value=TRUE to see if it becomes logical
stds <- grep("std\\(\\)",names(merged), value = TRUE) 

# adding activity and sujects columns to shorted dataset columns
total_subsets <- c("activity","subjects",means,stds)

# created a new data set from the six original datasets with only mean() and std() values
# along with subjects and their activities
sub_set <- merged[,total_subsets]


#converting names to lower to keep with standar R names
colnames(sub_set) <- tolower(gsub(".","",total_subsets,fixed=TRUE))

# the list needed for aggregation of data
sub <-list(sub_set$subjects,as.character(sub_set$activity))

result = aggregate(sub_set, by=sub, FUN=mean, na.action="")  ##[2]

drops <- c("activity","subjects") # dropping the two columns some how introduced by aggregate funcion

# The final 'tidy' data frame
tidy <- result[,!(names(result) %in% drops)]
names(tidy)[names(tidy) == 'Group.1'] <- 'subjects'
names(tidy)[names(tidy) == 'Group.2'] <- 'activity'


write.table(tidy,"~/john_hopkins/GCdata/data/tidy.txt",row.names=FALSE, col.names=TRUE,sep="\t\t")
