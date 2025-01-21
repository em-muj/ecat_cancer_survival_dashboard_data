# Emma Muijen
# 03 January 2024
# Data prep for cancer incidence dataset in survival dashboard

# GOAL: TO MAKE THE BELOW CODE REPRODUCIBLE

# ToC:
# 1. Table 1 - Grouping by Cancer


# Table 1 - Grouping by cancer --------------------------------------------



################## Summing Total Cases of Each Cancer #######################


# Cleaning column names

incidence_table_1 <- incidence_table_1 %>%
  janitor::clean_names()


# Preparing data to be matched to survival table

incidence_table_1_p1 <- incidence_table_1 %>%
  dplyr::mutate(rate = as.numeric(rate),
                count = as.numeric(count)) %>%
  
  # Only including age-standardised relevant cancer types
  dplyr::filter(
    stage_at_diagnosis == "All stages" &
    type_of_rate == "Age-standardised" &
    (is.na(hormone_receptor) | hormone_receptor == "All") &
    ndrs_detailed_group %in% c("All Anus", "All Bladder", "All Bowel", "All Brain", "All Breast", "Colon", 
                               "Diffuse large B-cell lymphoma (DLBCL) and other high grade mature B-cell neoplasms",
                               "All Eye", "Follicular lymphoma", "Gallbladder", "Hodgkin lymphoma",
                               "All Kidney", "All Liver and biliary tract", "All Lung",
                               "Melanoma", "All Mesothelioma", "Acute myeloid leukaemia (AML)", "Chronic myeloid leukaemia (CML)",
                               "Myeloma", "All Oesophagus", "All Pancreas", "Rectum", "All Small intestine", "All Stomach",
                               "Thyroid")
  ) %>%
  
  # Renaming cancer types to match survival table
  dplyr::mutate(
    cancer_site = dplyr::case_when(
      ndrs_detailed_group == "All Anus" ~ "Anus",
      ndrs_detailed_group == "All Bladder" ~ "Bladder",
      ndrs_detailed_group == "All Bowel" ~ "Bowel",
      ndrs_detailed_group == "All Brain" ~ "Brain",
      ndrs_detailed_group == "All Breast" ~ "Breast",
      ndrs_detailed_group == "Diffuse large B-cell lymphoma (DLBCL) and other high grade mature B-cell neoplasms" ~ "Diffuse large B-cell lymphoma",
      ndrs_detailed_group == "All Eye" ~ "Eye",
      ndrs_detailed_group == "Follicular lymphoma" ~ "Follicular (nodular) NHL",
      ndrs_detailed_group == "All Kidney" ~ "Kidney",
      ndrs_detailed_group == "All Liver and biliary tract" ~ "Liver",
      ndrs_detailed_group == "All Lung" ~ "Lung",
      ndrs_detailed_group == "All Mesothelioma" ~ "Mesothelioma",
      ndrs_detailed_group == "Acute myeloid leukaemia (AML)" ~ "Myeloid leukaemia",
      ndrs_detailed_group == "Chronic myeloid leukaemia (CML)" ~ "Myeloid leukaemia",
      ndrs_detailed_group == "All Oesophagus" ~ "Oesophagus",
      ndrs_detailed_group == "All Pancreas" ~ "Pancreas",
      ndrs_detailed_group == "Rectum" ~ "Rectal",
      ndrs_detailed_group == "All Small intestine" ~ "Small intestine",
      ndrs_detailed_group == "All Stomach" ~ "Stomach",
      TRUE ~ ndrs_detailed_group
    )
  ) %>%
  
  # Summing Count by Cancer Type (Would be preferable as rate but cannot combine genders easily)
  dplyr::group_by(cancer_site) %>%
  dplyr::summarise( total_2022 = sum(count)) %>%
  dplyr::ungroup()

################## Calculating Weighted Mean of Stage at Diagnosis #######################

incidence_table_1_p2 <- incidence_table_1 %>%
  dplyr::mutate(rate = as.numeric(rate),
                count = as.numeric(count)
                ) %>%
  
  # Only including age-standardised relevant cancer types and cases where stage at diagnosis is known
  dplyr::filter(
    stage_at_diagnosis != "All stages" &
      type_of_rate == "Age-standardised" &
      (is.na(hormone_receptor) | hormone_receptor == "All") &
      ndrs_detailed_group %in% c("All Anus", "All Bladder", "All Bowel", "All Brain", "All Breast", "Colon", 
                                 "Diffuse large B-cell lymphoma (DLBCL) and other high grade mature B-cell neoplasms",
                                 "All Eye", "Follicular lymphoma", "Gallbladder", "Hodgkin lymphoma",
                                 "All Kidney", "All Liver and biliary tract", "All Lung",
                                 "Melanoma", "All Mesothelioma", "Acute myeloid leukaemia (AML)", "Chronic myeloid leukaemia (CML)",
                                 "Myeloma", "All Oesophagus", "All Pancreas", "Rectum", "All Small intestine", "All Stomach",
                                 "Thyroid")
  ) %>%
  
  # Renaming cancer types to match survival table
  dplyr::mutate(
    cancer_site = dplyr::case_when(
      ndrs_detailed_group == "All Anus" ~ "Anus",
      ndrs_detailed_group == "All Bladder" ~ "Bladder",
      ndrs_detailed_group == "All Bowel" ~ "Bowel",
      ndrs_detailed_group == "All Brain" ~ "Brain",
      ndrs_detailed_group == "All Breast" ~ "Breast",
      ndrs_detailed_group == "Diffuse large B-cell lymphoma (DLBCL) and other high grade mature B-cell neoplasms" ~ "Diffuse large B-cell lymphoma",
      ndrs_detailed_group == "All Eye" ~ "Eye",
      ndrs_detailed_group == "Follicular lymphoma" ~ "Follicular (nodular) NHL",
      ndrs_detailed_group == "All Kidney" ~ "Kidney",
      ndrs_detailed_group == "All Liver and biliary tract" ~ "Liver",
      ndrs_detailed_group == "All Lung" ~ "Lung",
      ndrs_detailed_group == "All Mesothelioma" ~ "Mesothelioma",
      ndrs_detailed_group == "Acute myeloid leukaemia (AML)" ~ "Myeloid leukaemia",
      ndrs_detailed_group == "Chronic myeloid leukaemia (CML)" ~ "Myeloid leukaemia",
      ndrs_detailed_group == "All Oesophagus" ~ "Oesophagus",
      ndrs_detailed_group == "All Pancreas" ~ "Pancreas",
      ndrs_detailed_group == "Rectum" ~ "Rectal",
      ndrs_detailed_group == "All Small intestine" ~ "Small intestine",
      ndrs_detailed_group == "All Stomach" ~ "Stomach",
      TRUE ~ ndrs_detailed_group
    )
  ) %>%
  
  # Summing Count by Cancer Type (Would be preferable as rate but cannot combine genders easily)
  dplyr::group_by(cancer_site) %>%
  dplyr::summarise( common_stage_2022 = stage_at_diagnosis[which.max(count)]) %>%
  dplyr::ungroup()




################### Joining to survival rates table: ##################
adult_cancer_survival_rcnt_table_1_ch2 <- adult_cancer_survival_rcnt_table_1_ch2 %>%
  dplyr::left_join(incidence_table_1_p1) %>%
  dplyr::left_join(incidence_table_1_p2)
  
  
  
