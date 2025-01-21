# Emma Muijen
# 22 November 2024
# Data prep for childhood cancer survival datasets in survival dashboard

# GOAL: TO MAKE THE BELOW CODE REPRODUCIBLE

# ToC:
# 1. Five Year childhood survival
# 2. Ten Year Childhood Survival
# 3. One Year Childhood Survival


# 1. Five Year Childhood Survival -------------------------------------------

# Cleaning column names

childhood_survival_recent_table_2 <- childhood_survival_recent_table_2 %>%
    janitor::clean_names()
  
# Filtering to include all 0 - 14

five_yr_childhood_survival <- childhood_survival_recent_table_2 %>%
  dplyr::filter(standardisation_type == "Standardised" & method == "Cohort") %>%
  dplyr::select(year_of_diagnosis, overall_survival_percent)

# 2. Ten Year Childhood Survival -------------------------------------------

# Cleaning column names

childhood_survival_recent_table_3 <- childhood_survival_recent_table_3 %>%
  janitor::clean_names()

# Filtering to include all 0 - 14

ten_yr_childhood_survival <- childhood_survival_recent_table_3 %>%
  dplyr::filter(standardisation_type == "Standardised" & method == "Cohort") %>%
  dplyr::select(year_of_diagnosis, overall_survival_percent)

# 3. One Year Childhood Survival -------------------------------------------

# Cleaning column names

childhood_survival_recent_table_1 <- childhood_survival_recent_table_1 %>%
  janitor::clean_names()

# Filtering to include all 0 - 14

one_yr_childhood_survival <- childhood_survival_recent_table_1 %>%
  dplyr::filter(standardisation_type == "Standardised" & method == "Cohort") %>%
  dplyr::select(year_of_diagnosis, overall_survival_percent)

message("Childhood data prepped.")

