
#load packages
library(reshape2);library(plyr) ; library(dplyr)

# put in data folder or exclude this and jump to setwd to unzipped folder
if(!file.exists("./data")){dir.create("./data")}

url <- "http://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
download.file(url, destfile = "./data/UCIDataset.zip")
unzip("./data/UCIDataset.zip")

##OR
# Load datasets directly from unzipped rather than from data folder (saved here instead of data folder)
setwd("C:/Users/USER/Desktop/coursera/UCI HAR Dataset")

test.subject <- read.table("./test/subject_test.txt")
test.x <- read.table("./test/X_test.txt")
test.y <- read.table("./test/y_test.txt")

train.subject <- read.table("./train/subject_train.txt")
train.x <- read.table("./train/X_train.txt")
train.y <- read.table("./train/y_train.txt")

features <- read.table("./features.txt")
activity.labels <- read.table("./activity_labels.txt")

# Merge the test and train subject datasets
subject <- rbind(test.subject, train.subject)
colnames(subject) <- "subject"

# Merge the test and train labels; add the descriptor labels
label <- rbind(test.y, train.y)
label <- merge(label, activity.labels, by=1)[,2]

# Merge test and training datasets; add the descriptor headings
data <- rbind(test.x, train.x)
colnames(data) <- features[, 2]

# Merge datasets
data <- cbind(subject, label, data)

# Create new dataset (mean_std) with the mean and std vars
find_var <- grep("-mean|-std", colnames(data))
mean_std <- data[,c(1,2,find_var)]

# Calculate grouped means(by subject/label)
melted = melt(mean_std, id.var = c("subject", "label"))
means = dcast(melted , subject + label ~ variable, mean)

# Save tidy dataset
write.table(means, file="./tidy_data.txt")

