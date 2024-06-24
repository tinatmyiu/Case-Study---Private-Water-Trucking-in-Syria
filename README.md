# Case Study - Private Water Trucking in Syria

## Objective
By using the dataset from the questionnaire of water trucking in Syria from REACH, this case study is to examine the cost and effectiveness of private water trucking in Northwest Syria (NWS).

Data cleaning, data wrangling, data analysis and data visualization were performed, using R, in order to know the cost per quantity of water of private water trucking activities. This case study will be focus on the fuel cost for delivery of water.

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
```


## Data wrangling
We will create 2 tables for examination of the fuel cost for delivering waterin water trucking activies

The 1st table 'fuel_water_cost' will contain ki_type of 'private_trucker' or 'private_owner'. 4 variables needed for calculation of fuel cost (TRY) per a litre of water are extracted from the cleaned data.
A new column 'fuel_delivery_per_trip_TRY' is added add a result of fuel cost per trip (TRY).
An other new collumn 'fuel_delivery_costTRY_per_waterLitre' presents the fuel cost per liter of water (TRY/Litre).
Table 'fuel_water_cost' was cleaned agiin with na.omit() to remove NA value.


```r
#Data wrangling

#use filter to obtain data related to private water trucking
#calculate fuel cost per Lite of water
fuel_water_cost <- filter(main_data, ki_type == 'private_trucker' | ki_type == 'private_owner') %>%
  select(fuel_delivery, fuel_cost_litre, delivery_volume, delivery_distance) %>%
  mutate(fuel_delivery_per_trip_TRY = fuel_delivery*fuel_cost_litre*158.987294928) %>%
  mutate(fuel_delivery_costTRY_per_waterLitre = fuel_delivery_per_trip_TRY/delivery_volume) %>%
  na.omit(fuel_water_cost)
```
![paste to excel](https://77a5c0a3f9174366ab970d0e4c2e2c0b.app.posit.cloud/file_show?path=%2Fcloud%2Fproject%2FRplot.png)


The 2nd table 'fuel_water_cost_summary' is a summary of table 1 
  
```r
#summary of the mean, minimum and maximum of the fuel cost for delivery per litre water 
fuel_water_cost_summary <- data.frame(mean(fuel_water_cost$fuel_delivery_costTRY_per_waterLitre), min(fuel_water_cost$fuel_delivery_costTRY_per_waterLitre), max(fuel_water_cost$fuel_delivery_costTRY_per_waterLitre))
```
