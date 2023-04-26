# Load data
titanic_train = read.csv("titanic_train.csv")
titanic_test = read.csv("titanic_test.csv")

# Setting Survived column for test data to NA
titanic_test$Survived = NA

# Combining training and testing dataset
complete_data = rbind(titanic_train, titanic_test)

# Check data structure
str(complete_data)

# Check for any missing values in the data
colSums(is.na(complete_data))

# Check for empty values
colSums(complete_data=='')

# Check number of unique values for each of the column to find out
# columns which we can convert to factors
sapply(complete_data, function(x) length(unique(x)))

# Impute missing values
complete_data$Embarked[complete_data$Embarked==''] = 'S'
complete_data$Age[is.na(complete_data$Age)] = median(complete_data$Age,
                                                     na.rm = TRUE)

# Removing Cabin (as it has very high missing values), passengerId,
# Ticket and Name are not required
library(dplyr)
titanic_data = complete_data %>% select(-c(Cabin, PassengerId, Ticket, Name))

# Converting 'Survived','Pclass','Sex','Embarked' to factors
for(i in c('Survived', 'Pclass', 'Sex', 'Embarked')){
  titanic_data[,i] = as.factor(titanic_data[,i])
}

# Spliting data into training and testing datasets
train = titanic_data[1:667,]
test = titanic_data[668:889,]

# Model Creation
model = glm(Survived ~., family=binomial(link = 'logit'), data = train)

# Model summary
summary(model)

# Using ANOVA to analyze the table of devaiance
anova(model, test='Chisq')

# Predicting test data
result = predict(model, newdata = test, type = 'response')
result = ifelse(result > 0.5, 1, 0)
result = as.factor(result)
test$Survived = as.factor(test$Survived)

# Confusion matrix and statistics
# install.packages('caret')
library(caret)

confusionMatrix(data = result, reference = test$Survived)