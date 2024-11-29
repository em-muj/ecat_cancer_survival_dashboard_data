# Emma Muijen
# 27 November 2024
# Uploading data to file explorer for use on Power BI


# ToC:
# 1. Saving Data in Excel File


# 1. Saving Data in Excel File --------------------------------------------


# Listing all dataframes for use in the dashboard
df_list <- list(
  survival_by_cancer_type = adult_cancer_survival_rcnt_table_1_ch2,
  survival_by_diagnosis_stage = adult_cancer_survival_rcnt_STAGE2,
  survival_by_deprivation = adult_cancer_survival_rcnt_DEPRIVATION_2,
  survival_trends_by_cancer_type = adult_cancer_survival_trends_2,
  survival_trends_by_stage = adult_STAGE_trends_2,
  one_yr_childhood_survival = one_yr_childhood_survival,
  five_yr_childhood_survival = five_yr_childhood_survival,
  ten_yr_childhood_survival = ten_yr_childhood_survival,
  all_one_yr_survival = all_cancer_survival_1_years,
  all_five_yr_survival = all_cancer_survival_5_years,
  all_ten_yr_survival = all_cancer_survival_10_years
)

# Saving each table as a tab in an excel file
writexl::write_xlsx(df_list, paste0(path_fldr,"/data_for_dashboard.xlsx"))

message("Data ready for dashboard. Excel file saved as 'data_for_dashboard.xlsx'")