# Emma Muijen
# 27 November 2024
# Uploading data to file explorer for use on Power BI


# ToC:
# 1. Adult Cancer Data
#   (a) Survival by Cancer
#   (b) Survival by Stage
#   (c) Survival by Deprivation
#   (d) Survival Trends by Cancer Site
#   (e) Survival Trends by Stage
# 2. Childhood Cancer Data
# 3. All Cancer Survival
#   (a) One Year Survival
#   (b) Five Year Survival
#   (c) Ten Year Survival

######################################################
# 1. Adult Cancer Data
######################################################


# (a) Survival by Cancer --------------------------------------------------

openxlsx::write.xlsx(adult_cancer_survival_rcnt_table_1_ch2, 
                       paste0(path_fldr, "/survival_by_cancer_type.xlsx"), 
                       overwrite = TRUE)


# (b) Survival by Stage ---------------------------------------------------

openxlsx::write.xlsx(adult_cancer_survival_rcnt_STAGE2, 
                       paste0(path_fldr, "/survival_by_diagnosis_stage.xlsx"), 
                       overwrite = TRUE)


# (c) Survival by Deprivation ---------------------------------------------

openxlsx::write.xlsx(adult_cancer_survival_rcnt_DEPRIVATION_2, 
                       paste0(path_fldr, "/survival_by_deprivation.xlsx"), 
                       overwrite = TRUE)


# (d) Survival Trends by Cancer Site --------------------------------------

openxlsx::write.xlsx(adult_cancer_survival_trends_2, 
                       paste0(path_fldr, "/survival_trends_by_cancer_type.xlsx"), 
                       overwrite = TRUE)

# (e) Survival Trends by Stage --------------------------------------

openxlsx::write.xlsx(adult_STAGE_trends_2, 
                       paste0(path_fldr, "/survival_trends_by_stage.xlsx"), 
                       overwrite = TRUE)

######################################################
# 2. Childhood Cancer Data
######################################################

openxlsx::write.xlsx(childhood_survival, 
                       paste0(path_fldr, "/childhood_survival.xlsx"), 
                       overwrite = TRUE)

######################################################
# 3. All Cancer Survival
######################################################


# (a) One Year Survival ---------------------------------------------------

openxlsx::write.xlsx(all_cancer_survival_1_years, 
                       paste0(path_fldr, "/all_one_yr_survival.xlsx"), 
                       overwrite = TRUE)


# (b) Five Year Survival --------------------------------------------------

openxlsx::write.xlsx(all_cancer_survival_5_years, 
                       paste0(path_fldr, "/all_five_yr_survival.xlsx"), 
                       overwrite = TRUE)


# (c) Ten Year Survival ---------------------------------------------------

openxlsx::write.xlsx(all_cancer_survival_10_years, 
                       paste0(path_fldr, "/all_ten_yr_survival.xlsx"), 
                       overwrite = TRUE)

