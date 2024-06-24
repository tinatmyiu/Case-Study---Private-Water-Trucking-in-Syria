# Case Study - Private Water Trucking in Syria

## Objective
By using the dataset from the questionnaire of water trucking in Syria from REACH, this case study is to examine the cost and effectiveness of private water trucking in Northwest Syria (NWS).

Data wrangling, data analysis and data visualization were performed, using R, in order to know the cost per quantity of water of private water trucking activities. This case study will be focus on the fuel cost for delivery of water.

## Data cleaning
1. Remove duplicate data
Using distinct() in R.

2. Remove extra spaces in each cell
Using str_rm_whitespace_df() in R.

3. Remove data cells with NA in currency and fuel_unit columns
Without currency and fuel unit, the cost was not measurable and comparable with the others so the data with currency and fuel unit of NA was removed.

4. Check if the units for currency, fuel_unit and delivery distance are the same for all uuid.
If they have different units within the same variable, a conversion of unit should be applied to unify the units.

```r
# install.packages
install.packages("dplyr")
library(dplyr)
install.packages("tidyverse")
library(tidyverse)
library(readxl)
install.packages("hablar")
library(hablar)
install.packages('base')
library('base')
install.packages("forstringr")
library(forstringr)


#load data file
setwd("C:/Users/danny/Desktop/Tina/Syria")
main_data <- read_excel("REACH_SYR_Dataset_Water-Trucking_Mar24.xlsx", "Main Data")

#Data cleaning
#remove duplicate and extra spaces in a data point
main_data <- distinct(main_data)
main_data <- str_rm_whitespace_df(main_data)

#remove currency and fuel unit with a value of NA
main_data <- main_data[!is.na(main_data$currency),]
main_data <- main_data[!is.na(main_data$fuel_unit),]

#check if currency and fuel unit are the same for all data. result showed all currency and fuel unit were the same
currency <- main_data %>% group_by(currency) %>% count(currency)
view(currency)

fuel_unit <- main_data %>% group_by(fuel_unit) %>% count(fuel_unit)
view(fuel_unit)

truck_volume_unit <- main_data %>% group_by(truck_volume_unit) %>% count(truck_volume_unit)
view(truck_volume_unit)
