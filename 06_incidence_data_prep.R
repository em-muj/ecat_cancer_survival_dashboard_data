# Emma Muijen
# 22 January 2025

# Sixth script in a series to prepare data for ECAT Survival Dashboard

# RUN THIS SCRIPT ONE STEP AT A TIME.
# THIS SHOULD OUTLINE THE DATA PROCESSING DONE TO PRODUCE THE INCIDENCE / CANCER REGISTRATION DATA FOR THE DASHBOARD.
# IF THE DATA STRUCTURE, COLUMN NAMES ETC. HAVE BEEN CHANGED IN THE UPDATE, THIS CODE WILL NEED UPDATING.
# AS SUCH, EACH STEP OF THE DATA CLEANING AND RESTRUCTURING IS DESCRIBED TO FACILLITATE THIS.

# The tables have been downloaded with the title,incidence_table followed by the number corresponding to the source document.

###########################################################################
# CREATING INCIDENCE COLUMN FOR DASHBOARD ---------------------------------
###########################################################################


# CLEANING TABLE COLUMN NAMES ---------------------------------------------

incidence_table_0 <- incidence_table_0 %>%
  janitor::clean_names()



# CLEANING DATA -----------------------------------------------------------

incidence_table_1_p1 <- incidence_table_0 %>%
  
  # Ensuring that the rate and count columns are recorded as numeric
  dplyr::mutate(rate = as.numeric(rate_per_100_000_population),
                count = as.numeric(count)) %>%
  
  # Only including age-standardised and relevant cancer types (cancer types included in the survival data)
  dplyr::filter(
      type_of_rate == "Age-standardised" &
      geography_name == "England" &
      icd10_code %in% c("C21", "C67", "C17", "C18", "C20", "C71", "C50", "C18", "C18-C20", "C69", "C82", "C23", "C81", "C64", "C91-C95", "C22", "C34", "C43", "C45", "C92",
                        "C90", "C82-C85", "C15", "C25", "C20", "C17", "C16", "C73")
  ) %>%
  
  # Renaming cancer types to match survival table
  dplyr::mutate(
    cancer_site = dplyr::case_when(
      icd10_code == "C21" ~ "Anus",
      icd10_code == "C67" ~ "Bladder",
      icd10_code == "C18-C20" ~ "Bowel",
      icd10_code == "C71" ~ "Brain",
      icd10_code == "C50" ~ "Breast",
      icd10_code == "C18" ~ "Colon",
      icd10_code == "C69" ~ "Eye",
      icd10_code == "C82" ~ "Follicular (nodular) NHL",
      icd10_code == "C23" ~ "Gallbladder",
      icd10_code == "C81" ~ "Hodgkin lymphoma",
      icd10_code == "C64" ~ "Kidney",
      icd10_code == "C91-C95" ~ "Leukaemia",
      icd10_code == "C22" ~ "Liver",
      icd10_code == "C34" ~ "Lung",
      icd10_code == "C43" ~ "Melanoma",
      icd10_code == "C45" ~ "Mesothelioma",
      icd10_code == "C92" ~ "Myeloid leukaemia",
      icd10_code == "C90" ~ "Myeloma",
      icd10_code == "C82-C85" ~ "Non-Hodgkin lymphoma",
      icd10_code == "C15" ~ "Oesophagus",
      icd10_code == "C25" ~ "Pancreas",
      icd10_code == "C20" ~ "Rectal",
      icd10_code == "C17" ~ "Small intestine",
      icd10_code == "C16" ~ "Stomach",
      icd10_code == "C73" ~ "Thyroid",
      TRUE ~ icd10_code
    )
  ) %>%
  
  # Summing Count by Cancer Type (Would be preferable as rate but cannot combine genders easily)
  dplyr::group_by(cancer_site) %>%
  dplyr::summarise( total_2018 = prettyNum(sum(count), big.mark = ",", scientific = F)) %>%
  dplyr::ungroup()



# JOINING DATASET TO THE SURVIVAL RATES TABLE -----------------------------

adult_cancer_survival_rcnt_table_1_ch2 <- adult_cancer_survival_rcnt_table_1_ch2 %>%
  dplyr::left_join(incidence_table_1_p1)
