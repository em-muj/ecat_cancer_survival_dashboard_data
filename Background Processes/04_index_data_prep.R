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
  dplyr::filter()
