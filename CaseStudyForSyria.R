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
main_data <- read_excel("REACH_SYR_Dataset_Water-Trucking_Mar24.xlsx", "Main Data")

#Data cleaning
#remove duplicate and extra spaces
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

#Check if the calculation of fuel_cost_litre is accurate
check_cal_fuel_cost_litre <- main_data %>% mutate(cal_fuel_cost_litre = round(cost_fuel_delivery1/fuel_delivery)) %>%
  mutate(cal_verify = print (cal_fuel_cost_litre == cal_fuel_cost_litre)) %>% 
  group_by(cal_verify) %>%
  select(uuid, cal_verify)

view(check_cal_fuel_cost_litre)
summarise(check_cal_fuel_cost_litre)



#Data wrangling

#use filter to obtain data related to private water trucking
#calculate fuel cost per Lite of water
fuel_water_cost <- filter(main_data, ki_type == 'private_trucker' | ki_type == 'private_owner') %>%
  select(cost_fuel_delivery1, delivery_volume, delivery_distance) %>%
  mutate(delivery_volume_litre = delivery_volume*158.987294928) %>%
  mutate(fuel_delivery_costTRY_per_waterLitre = cost_fuel_delivery1/delivery_volume_litre) %>%
  na.omit(fuel_delivery_costTRY_per_waterLitre)

#summary of the mean, minimum and maximum of the fuel cost for delivery per litre water 
fuel_water_cost_summary <- data.frame(Mean.of.fuel.cost.per.litre.water = mean(fuel_water_cost$fuel_delivery_costTRY_per_waterLitre), Min.of.fuel.cost.per.litre.water = min(fuel_water_cost$fuel_delivery_costTRY_per_waterLitre), Max.of.fuel.cost.per.litre.water = max(fuel_water_cost$fuel_delivery_costTRY_per_waterLitre)) 


#Pearson correlation
fuel_water_cost %>%
  cor.test( ~delivery_distance + fuel_delivery_costTRY_per_waterLitre, data =.)

#Data visualization
ggplot(fuel_water_cost, aes(x=delivery_distance, y=fuel_delivery_costTRY_per_waterLitre)) + 
  geom_point() +
  geom_smooth(method=lm) +
  labs(title="Fuel cost for delivery of water according to delivery distance",
       x="Delivery distance (km)", y = "Fuel cost per water (TRY/Litre)")

#Data wrangling for all ki_type
fuel_water_cost_all <- select(main_data, ki_type, cost_fuel_delivery1, delivery_volume, delivery_distance) %>%
  mutate(delivery_volume_litre = delivery_volume*158.987294928) %>%
  mutate(fuel_delivery_costTRY_per_waterLitre = cost_fuel_delivery1/delivery_volume_litre) %>%
  na.omit(fuel_delivery_costTRY_per_waterLitre)

#Data visualization for all ki_type
ggplot(fuel_water_cost_all, aes(x=delivery_distance, y=fuel_delivery_costTRY_per_waterLitre, color= ki_type)) + 
  geom_point(size=4) +
  labs(title="Fuel cost for delivery of water according to delivery distance with all types of KI",
       x="Delivery distance (km)", y = "Fuel cost per water (TRY/Litre)")
