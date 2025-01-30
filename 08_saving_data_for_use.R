# Emma Muijen
# 22 January 2025

# Eighth script in a series to prepare data for ECAT Survival Dashboard

# RUN THIS SCRIPT ONE STEP AT A TIME.
# THIS SHOULD SAVE THE CLEANED DATA FRAMES TO AN EXCEL FILE WHICH IS USED TO IMPORT DATA TO THE SURVIVAL DASHBOARD.
# IF THE PREVIOUS SCRIPTS HAVE BEEN RUN SUCCESSFULLY, THIS SCRIPT SHOULD NOT REQUIRE ANY CHANGES.



# LISTING CREATED DATA FRAMES FOR USE -------------------------------------

df_list <- list(
  survival_by_cancer_type = adult_cancer_survival_rcnt_table_1_ch2,
  survival_by_diagnosis_stage = adult_cancer_survival_rcnt_STAGE2,
  survival_by_deprivation = adult_cancer_survival_rcnt_DEPRIVATION_2,
  survival_by_gender = adult_cancer_gender_all,
  one_yr_childhood_survival = one_yr_childhood_survival,
  five_yr_childhood_survival = five_yr_childhood_survival,
  ten_yr_childhood_survival = ten_yr_childhood_survival,
  all_one_yr_survival = all_cancer_survival_1_years,
  all_five_yr_survival = all_cancer_survival_5_years,
  all_ten_yr_survival = all_cancer_survival_10_years,
  trends_one_yr_survival = adult_trends_ONE,
  trends_five_yr_survival = adult_trends_FIVE,
  survival_by_age = adult_cancer_age_ALL,
  survival_by_region = adult_cancer_geography_all
)

# Saving each table as a tab in an excel file
writexl::write_xlsx(df_list, paste0(path_fldr,"/data_for_dashboard.xlsx"))

message("Data ready for dashboard. Excel file saved as 'data_for_dashboard.xlsx'")
