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
