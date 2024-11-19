# Emma Muijen
# 19 November 2024
# Data prep for adult cancer survival datasets in survival dashboard

# ToC:
# 1. Recent datasets
#   (a) Table 1 - Gender & Age
#   (b) Table 2 - Gender & Stage
#   (c) Table 3 - Gender & Deprivation
#   (d) Table 4 - Gender & Country
#   (e) Table 5 - Gender & Region

# Cleaning column names of all tables
for (i in 1:5){
  
  df <- get(paste0("adult_cancer_survival_prev_table_", i))
  df1 <- get(paste0("adult_cancer_survival_rcnt_table_", i))
  
  df <- df %>%
    janitor::clean_names()
  
  df1 <- df1 %>%
    janitor::clean_names()
  
  assign(paste0("adult_cancer_survival_prev_table_", i), df)
  assign(paste0("adult_cancer_survival_rcnt_table_", i), df1)
}


######################################################
# 1. Recent Datasets
######################################################


# (a) Table 1 - Gender & Age ----------------------------------------------

adult_cancer_survival_rcnt_table_1_ch1 <- adult_cancer_survival_rcnt_table_1 %>%
  dplyr::select(cancer_site, gender, age_at_diagnosis_years, standardisation_type, 
                years_since_diagnosis, patients, net_survival_percent) %>%
  dplyr::filter(gender == "Persons" & standardisation_type == "Age-standardised (5 age groups)" &
                  years_since_diagnosis %in% c(1, 5)) # SEPARATE THESE INTO TABLES WITH 1 AND 5 YR SURVIVAL?


# (b) Table 2 - Gender & Stage-------------------------------------------------------------

# Need a table that has each cancer type by each stage
adult_cancer_survival_rcnt_STAGE <- adult_cancer_survival_rcnt_table_2 %>%
  dplyr::select(cancer_site, gender, age_at_diagnosis, stage_at_diagnosis, standardisation_type,
                years_since_diagnosis, patients, net_survival_percent) %>%
  dplyr::filter(age_at_diagnosis == "All ages" & 
                  standardisation_type == "Age-standardised (5 age groups)" & 
                  years_since_diagnosis %in% c(1,5)) %>% 
  dplyr::arrange(cancer_site, stage_at_diagnosis, years_since_diagnosis) %>%
  dplyr::group_by(cancer_site) %>%
  filter(!("Persons" %in% gender) | gender == "Persons") %>%
  ungroup()
# NEED TO WRITE SOME CODE TO EXCLUDE GENDER SPECIFYING WHEN PERSONS PRESENT