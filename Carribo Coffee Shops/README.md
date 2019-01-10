# Carribou Coffee Marketing Analysis

This data on Caribou Coffee locations was scraped from the store locator portion of Caribou Coffee’s website (https://www4.stat.ncsu.edu/~post/558/datasets/ajax.xml).

This data set proved pretty difficult to really understand due to the large amount of missing data. The missing data is seen as an empty character string since the variables are almost all character (only latitude and longitude coordinates are numeric), and can easily be removed or replaced with a more clear missing value marker (dplyr::na_if() function should work). There were also discrepancies within variables in terms of the responses provided, as is seen in grocery_count object where the only two responses given were ‘Y’ and ‘y’ (absent were any negative responses like ‘N’ or ‘n’). This makes it impossible to determine whether the observations where there was no input given were meant to be a negative response (e.g. ‘No’, ‘N’, ‘n’) or just missing, and so there wasn’t much analysis we could perform without further information. Based on the fact that this was web-scraped data, I’d assume the values just weren’t present on the website that was scraped and could be either affirmative (‘Y’) or negative (‘N’).

Given the dearth of numeric variables, we wanted to make sure to utilize the two we had in order to create a figure with an interactive map of the Caribou locations throughout the country. There a few hundred locations outside the US that are located almost entirely in the Middle East (United Arab Emirates (AE), Bahrain (BH), Jordan (JO), Kuwait (KW), Lebanon (LB), Oman (OM), Qatar (QA), Turkey (TR)) with some in South Korea (KR) and South Africa (SA), as well.

## Exploration of data

![Image of ggmap](https://github.com/donkeyrob/Statistics-with-R/blob/master/Carribo%20Coffee%20Shops/Rplot.png)
