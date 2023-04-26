organics = read.csv("organics.csv")
str(organics)

# 1. Finding variables with missing values
colSums(is.na(organics))

# The variables DemAffl, DemAge and PromTime have missing values
# DemAge has the most number of missing values


# 2. Imputing missing values with mean values
for(i in c('DemAffl', 'DemAge', 'PromTime')){
  organics[is.na(organics[,i]), i] = mean(organics[,i], na.rm = T)
}

# Checking missing values after imputation
colSums(is.na(organics))


# 3. Creating boxplot with DemAffl
boxplot(organics$DemAffl, horizontal = T)

# The distribution of DemAffl is right-skewed


# 4. Creating log transformation of DemAffl
organics$LogDemAffl = log(organics$DemAffl + 1)


# 5. Finding skewness of LogDemAffl
boxplot(organics$LogDemAffl, horizontal = T)

# The distribution of LogDemAffl is left-skewed


# 6. Creating log transformation of all interval input variables
organics$LogDemAge = log(organics$DemAge + 1)
organics$LogPromSpend = log(organics$PromSpend + 1)
organics$LogPromTime = log(organics$PromTime + 1)


# 7. Removing original interval input variables and saving as a new dataframe
library(dplyr)
organics_new = organics %>%
  select(-c(X, ID, DemAffl, DemAge, PromSpend, PromTime))

# Checking structure of the new dataframe
str(organics_new)

# Converting char and int variables to factor
for(i in c('DemClusterGroup', 'DemGender', 'DemReg', 'DemTVReg',
           'PromClass', 'TargetBuy')){
  organics_new[,i] = as.factor(organics_new[,i])
}


# 8. Spliting data into training and testing datasets
train = organics_new[1:20000,]
test = organics_new[20001:22223,]


# 9. Creating logistic model
model = glm(TargetBuy ~., family=binomial(link = 'logit'), data = train)
summary(model)


# 10. Conducting ANOVA to analysis
anova(model, test='Chisq')

# DemClusterGroup, DemGender, DemReg, DemTVReg, PromClass, LogDemAffl
# and LogDemAge are statistically significant at 0.05 level


# 11. Predicting test data
result = predict(model, newdata = test, type = 'response')
result = ifelse(result > 0.5, 1, 0)
result = as.factor(result)


# 12. Creating a confusion matrix
test$TargetBuy = as.factor(test$TargetBuy)

library(caret)
confusionMatrix(data = result, reference = test$TargetBuy)

# Model's accuracy is 80.34%