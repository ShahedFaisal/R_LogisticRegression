# Predictive Modeling with R: Logistic Regression

## Overview

This repository contains R code for predictive modeling using logistic regression on a dataset named "HeartDisease.csv." The goal is to predict the likelihood of Chronic Heart Disease (CHD) in ten years ("TenYearCHD") based on various health-related factors. The code covers data preprocessing, logistic regression modeling, and model evaluation.

## Key Steps

-   Read the "HeartDisease.csv" dataset and perform initial checks, such as displaying the first 10 observations and exploring variable information.

-   Identify factor variables, count missing values, and remove them from the dataset.

-   Calculate the probability and odds of having CHD in ten years based on the cleaned dataset.

-   Create dummy variables for factor variables, and split the dataset into training and testing sets, with 60% of observations in the training set and 40% in the testing set.

-   Perform logistic regression on the training set and identify significant variables at a 10% significance level.

-   Report coefficients, p-values, and other summary characteristics of the logistic regression model.

-   Predict CHD probabilities on both training and testing sets, convert probabilities to binary predictions, and calculate classification metrics such as hit rate, sensitivity, and specificity.

-   Plot the ROC curve for the test set and calculate the area under the ROC curve.

## Note

Ensure the presence of the "HeartDisease.csv" dataset in the working directory before running the code.