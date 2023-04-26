# Logistic Regression with R

This repository contains two datasets and R scripts for each that demonstrate the use of logistic regression with R.

## Datasets

### Titanic Dataset

The Titanic dataset contains information about passengers on the Titanic, including whether they survived, their class, age, gender, and more.

### Organics Dataset

The Organics dataset contains information about customers' demographics and purchasing behavior, including their age, gender, promotion class, promotion spending, and whether they bought a certain product.

## R Scripts

### Titanic Logistic Regression

The `TitanicSurvived.R` script demonstrates how to use logistic regression to predict whether a passenger on the Titanic survived based on their class, gender, and age. The script loads the Titanic dataset and then performs data cleaning and preparation before fitting a logistic regression model and making predictions.

### Organics Logistic Regression

The `OrganicsTargetBuy.R` script demonstrates how to use logistic regression to predict whether a customer will buy a certain product based on their demographics and purchasing behavior. The script loads the Organics dataset and then performs data cleaning and preparation before fitting a logistic regression model and making predictions.

## Requirements
To run the scripts, you will need to have R and the following R packages installed: `dyplr` and `caret`.