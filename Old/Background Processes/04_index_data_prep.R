# Emma Muijen
# 22 November 2024
# Data prep for index cancer survival datasets in survival dashboard

# GOAL: TO MAKE THE BELOW CODE REPRODUCIBLE

# ToC:
# 1. Table 5 - all cancers



# Table 5 - all cancers ---------------------------------------------------

# Cleaning column names

survival_index_table_5 <- survival_index_table_5 %>%
  janitor::clean_names()

# Filtering to include relevant data only

all_cancer_survival <- survival_index_table_5 %>%
  dplyr::filter(geography_name == "England" &
                standardisation_type == "Cancer Site; Age; Gender") %>%
  dplyr::arrange(diagnosis_year) %>%
  dplyr::arrange(years_since_diagnosis)

# Saving tables for 1 year, 5 year and 10 year survival

for (i in unique(all_cancer_survival$years_since_diagnosis)){
  
  df <- all_cancer_survival %>%
    dplyr::filter(years_since_diagnosis == i) %>%
    dplyr::select(diagnosis_year, survival_percent)
  
  assign(paste0("all_cancer_survival_", i, "_years"), df)
}

message("Index data prepped.")