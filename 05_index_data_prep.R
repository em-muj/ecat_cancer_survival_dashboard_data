# Emma Muijen
# 22 January 2025

# Fifth script in a series to prepare data for ECAT Survival Dashboard

# RUN THIS SCRIPT ONE STEP AT A TIME.
# THIS SHOULD OUTLINE THE DATA PROCESSING DONE TO PRODUCE THE INDEX SURVIVAL DATA FOR THE DASHBOARD.
# IF THE DATA STRUCTURE, COLUMN NAMES ETC. HAVE BEEN CHANGED IN THE UPDATE, THIS CODE WILL NEED UPDATING.
# AS SUCH, EACH STEP OF THE DATA CLEANING AND RESTRUCTURING IS DESCRIBED TO FACILLITATE THIS.

# The tables have been downloaded with the title, survival_index_table_ followed by the number corresponding to the source document.

###########################################################################
# CREATING ALL CANCER SURVIVAL INDEX TABLE FOR DASHBOARD ------------------
###########################################################################


# CLEANING COLUMN NAMES ---------------------------------------------------

survival_index_table_5 <- survival_index_table_5 %>%
  janitor::clean_names()


# CLEANING DATA -----------------------------------------------------------

all_cancer_survival <- survival_index_table_5 %>%
  
  # Ensuring only records from England that are standardised are included.
  dplyr::filter(geography_name == "England" &
                  standardisation_type == "Cancer Site; Age; Gender") %>%
  dplyr::arrange(diagnosis_year) %>%
  dplyr::arrange(years_since_diagnosis)



# CREATING TABLES FOR 1, 5 AND 10 YEAR SURVIVAL ---------------------------

for (i in unique(all_cancer_survival$years_since_diagnosis)){
  
  df <- all_cancer_survival %>%
    
    # Only including 1, 5, and 10 years of survival for each table respectively
    dplyr::filter(years_since_diagnosis == i) %>%
    
    # Only retaining relevant columns
    dplyr::select(diagnosis_year, survival_percent)
  
  
  # Saving these tables
  assign(paste0("all_cancer_survival_", i, "_years"), df)
}

