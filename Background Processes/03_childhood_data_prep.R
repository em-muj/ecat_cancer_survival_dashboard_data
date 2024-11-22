# Emma Muijen
# 22 November 2024
# Data prep for childhood cancer survival datasets in survival dashboard

# GOAL: TO MAKE THE BELOW CODE REPRODUCIBLE

# ToC:
# 1. Overall childhood survival


# 1. Overall Childhood Survival -------------------------------------------

# Cleaning column names

childhood_survival_recent_table_2 <- childhood_survival_recent_table_2 %>%
    janitor::clean_names()
  
# Filtering to include all 0 - 14

childhood_survival <- childhood_survival_recent_table_2 %>%
  dplyr::filter(standardisation_type == "Standardised" & method == "Cohort") %>%
  dplyr::select(year_of_diagnosis, overall_survival_percent)
