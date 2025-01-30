# Emma Muijen
# 21 January 2025

# Fourth script in a series to prepare data for ECAT Survival Dashboard

# RUN THIS SCRIPT ONE STEP AT A TIME.
# THIS SHOULD OUTLINE THE DATA PROCESSING DONE TO PRODUCE THE CHILDHOOD SURVIVAL DATA FOR THE DASHBOARD.
# IF THE DATA STRUCTURE, COLUMN NAMES ETC. HAVE BEEN CHANGED IN THE UPDATE, THIS CODE WILL NEED UPDATING.
# AS SUCH, EACH STEP OF THE DATA CLEANING AND RESTRUCTURING IS DESCRIBED TO FACILLITATE THIS.

# The tables have been downloaded with the title, childhood_survival_recent_table_ followed by the number corresponding to the source document.


###########################################################################
# CREATING ONE YEAR CHILDHOOD SURVIVAL DATASET FOR DASHBOARD --------------
###########################################################################


# CLEANING COLUMN NAMES ---------------------------------------------------

childhood_survival_recent_table_1 <- childhood_survival_recent_table_1 %>%
  janitor::clean_names()


# CLEANING DATA -----------------------------------------------------------

one_yr_childhood_survival <- childhood_survival_recent_table_1 %>%
  
  # Only retaining standardised records using the cohort method
  dplyr::filter(standardisation_type == "Standardised" & method == "Cohort") %>%
  
  # Retaining only relevant columns
  dplyr::select(year_of_diagnosis, overall_survival_percent)


###########################################################################
# CREATING FIVE YEAR CHILDHOOD SURVIVAL DATASET FOR DASHBOARD -------------
###########################################################################


# CLEANING COLUMN NAMES ---------------------------------------------------

childhood_survival_recent_table_2 <- childhood_survival_recent_table_2 %>%
  janitor::clean_names()



# CLEANING DATA -----------------------------------------------------------

five_yr_childhood_survival <- childhood_survival_recent_table_2 %>%
  
  # Only retaining standardised records using the Cohort method
  dplyr::filter(standardisation_type == "Standardised" & method == "Cohort") %>%
  
  # Retaining only relevant columns
  dplyr::select(year_of_diagnosis, overall_survival_percent)


###########################################################################
# CREATING TEN YEAR CHILDHOOD SURVIVAL DATASET FOR DASHBOARD --------------
###########################################################################


# CLEANING COLUMN NAMES ---------------------------------------------------

childhood_survival_recent_table_3 <- childhood_survival_recent_table_3 %>%
  janitor::clean_names()


# CLEANING DATA -----------------------------------------------------------

ten_yr_childhood_survival <- childhood_survival_recent_table_3 %>%
  
  # Only retaining standardised records using the cohort method
  dplyr::filter(standardisation_type == "Standardised" & method == "Cohort") %>%
  
  # Retaining only relevant columns
  dplyr::select(year_of_diagnosis, overall_survival_percent)