# Emma Muijen
# 15 January 2024
# Joining longitude and latitude data to ICB survival dataset

# GOAL: TO MAKE THE BELOW CODE REPRODUCIBLE

# ToC:
# 1. Data Prep for Longitude and Latitude Dataset
# 2. Joining longitude and latitude dataset to survival by ICB dataset



# 1. Data Prep for Longitude and Latitude Dataset -------------------------

ICB_loc_1 <- ICB_loc %>%
  janitor::clean_names() %>%
  dplyr::select(icb23cd, long, lat)



# 2. Joining longitude and latitude dataset to survival by ICB dat --------

adult_cancer_geography_all <- adult_cancer_geography_all_1 %>%
  dplyr::left_join(ICB_loc_1, by = c("geography_code" = "icb23cd")) %>%
  dplyr::filter(!is.na(one_yr_survival) | !is.na(five_yr_survival))
