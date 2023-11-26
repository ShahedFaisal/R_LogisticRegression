# 1. Using 'HeartDisease.csv' create a data set called 'CHD' in R. The code
# values for each of the variables are given in the document
# 'Variables_HeartDisease.txt'

CHD = read.csv("HeartDisease.csv", stringsAsFactors=TRUE)


# 2. (a) Do preliminary checks to see the number of observations, first 10
# observations, names of the variables and types of the variables etc.

head(CHD, 10)
names(CHD)
str(CHD)
dim(CHD)

# (b) Which variables are factor variables?

# 'currentSmoker' and 'diabetes' are factor variables.


# 3. Count the number of missing values for each of the variable. Which variable
# has the highest number of missing values?

colSums(is.na(CHD))
# 'glucose' has the highest number (388) of missing values.


# 4. Remove all missing values from the dataset. How many observations are there
# in the dataset after removing missing values?

CHD = na.omit(CHD)
dim(CHD)
# There are 3656 observations in the dataset after removing missing values.


# 5. The dependent variable, you need to predict is whether a person gets
# Chronic Heart Disease in Ten Years (i.e.'TenYearCHD').

# (a) Based on this data (i.e. the data after removing missing values),
# calculate the Probability of TenYearCHD.

table(CHD$TenYearCHD)['1'] / length(CHD$TenYearCHD)
# Probability of TenYearCHD is 0.1523523.


# (b) What are the Odds of TenYearCHD?

table(CHD$TenYearCHD)['1'] / table(CHD$TenYearCHD)['0']
# Odds of TenYearCHD is  0.1797354.


# 6. Create dummy variables for variables that are factors (library called caret
# may be used for creating dummy variables). This dataset can be saved as CHD1.

library(caret)

dmy = dummyVars(~ ., data = CHD, fullRank = T)
CHD1 = data.frame(predict(dmy, newdata = CHD))
head(CHD1)


# (a) How many observations and variables are there in CHD1?

dim(CHD1)
# There are 3656 observations and 18 variables in CHD1.

 
# 7. Now split the dataset, CHD1 to training and testing samples with 60%
# observations in CHD_Train and 40% in CHD_Test (library, CaTools will be
# helpful to split the sample – similar code is available in Logistic Regression
# Tutorial.R)

library(caTools)

set.seed(1234)
sample1 = sample.split(CHD1$TenYearCHD, SplitRatio = 0.6)
CHD_Train = subset(CHD1, sample1 == T)
CHD_Test = subset(CHD1, sample1 == F)


# (a) What are the Prob(TenYearCHD) in CHD_Train and CHD_Test datasets?

table(CHD_Train$TenYearCHD)['1'] / length(CHD_Train$TenYearCHD)
# Probability of TenYearCHD in CHD_Train is 0.1523028.

table(CHD_Test$TenYearCHD)['1'] / length(CHD_Test$TenYearCHD)
# Probability of TenYearCHD in CHD_Test is 0.1524265.


# 8. Now run the logistic regression (using CHD_Train) with "TenYearCHD" as the
# dependent variable and all relevant variables as independent variables.

logit1 = glm(TenYearCHD ~ ., data = CHD_Train, family = 'binomial')
summary(logit1)


# 9. Get a best fitting Logistic Regression of "TenYearCHD" on relevant
# variables - Retain variables for which the coefficients are significant at 10%
# (Running a stepwise logistic regression first and then re-running the model
# with all variables significant at 10% level will give you the final model)

library(MASS)

step_logit = step(logit1, direction = 'both', trace = F)
summary(step_logit)

logit2 = glm(TenYearCHD ~ age + gender.Male + cigsPerDay + totChol + sysBP +
               glucose, data = CHD_Train, family = 'binomial')


# 10. Report Coefficients, p-values and other summary characteristics

summary(logit2)
# Coefficients:
#              Estimate Std. Error z value Pr(>|z|)    
# (Intercept) -9.266672   0.613882 -15.095  < 2e-16 ***
# age          0.065533   0.008434   7.770 7.84e-15 ***
# gender.Male  0.547043   0.138285   3.956 7.62e-05 ***
# cigsPerDay   0.018947   0.005384   3.519 0.000433 ***
# totChol      0.002503   0.001432   1.747 0.080598 .  
# sysBP        0.016735   0.002708   6.181 6.39e-10 ***
# glucose      0.009839   0.002293   4.291 1.78e-05 ***


# 11. (a) Predict the probability of "TenYearCHD" in the training data set
# (CHD_Train)

CHD_Train$ProbTenYearCHD = predict(logit2, newdata = CHD_Train,
                                   type = 'response')
head(CHD_Train)


# (b) Convert predicted probabilities to 0 or 1

CHD_Train$PredTenYearCHD = ifelse(CHD_Train$ProbTenYearCHD >= 0.5, 1, 0)
head(CHD_Train)


# 12. (a) Get the classification table (i.e. Cross tabulation of ‘TenYearCHD’
# and Predicted values of the same variable) and

conf_matrix = table(CHD_Train$TenYearCHD, CHD_Train$PredTenYearCHD)
conf_matrix
#      0    1
# 0 1847   12
# 1  309   25


# (b) calculate the Hit Rate, True Positive Rate (Sensitivity) and True Negative
# Rate (Specificity) -- This is for the training data (Example calculations are
# in ‘Logistic Regression Tutorial.R’)

hit_rate = sum(diag(conf_matrix)) / sum(conf_matrix)
hit_rate
# Hit rate: 0.8536252

sensitivity = conf_matrix[2,2] / sum(conf_matrix[2,])
sensitivity
# Sensitivity: 0.0748503

specificity = conf_matrix[1,1] / sum(conf_matrix[1,])
specificity
# Specificity: 0.9935449


# 13. (a) Now, predict the probability of "TenYearCHD" in the test data set
# (CHD_Test).

CHD_Test$ProbTenYearCHD = predict(logit2, newdata = CHD_Test, type = 'response')
head(CHD_Test)


# (b) Convert predicted probabilities to 0 or 1

CHD_Test$PredTenYearCHD = ifelse(CHD_Test$ProbTenYearCHD >= 0.5, 1, 0)
head(CHD_Test)


# 14. (a) Get the classification table (Cross tabulation of TenYearCHD and
# Predicted value of the same variable) and

conf_matrix = table(CHD_Test$TenYearCHD, CHD_Test$PredTenYearCHD)
conf_matrix
#      0    1
# 0 1233    7
# 1  205   18


# (b) calculate the Hit Rate (This is for the test data).

hit_rate = sum(diag(conf_matrix)) / sum(conf_matrix)
hit_rate
# Hit rate: 0.8550923


# 15. Get the ROC curve for test data. What is the area under the ROC curve?

library(pROC)

roc_obj = roc(CHD_Test$TenYearCHD, CHD_Test$ProbTenYearCHD)
plot(roc_obj)
# The curve is above the diagonal line, which is good.

auc(roc_obj)
# Area under the curve: 0.734