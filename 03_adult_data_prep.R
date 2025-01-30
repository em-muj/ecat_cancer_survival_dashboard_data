# Emma Muijen
# 21 January 2025

# Third script in a series to prepare data for ECAT Survival Dashboard

# RUN THIS SCRIPT ONE STEP AT A TIME.
# THIS SHOULD OUTLINE THE DATA PROCESSING DONE TO PRODUCE THE ADULT SURVIVAL DATA FOR THE DASHBOARD.
# IF THE DATA STRUCTURE, COLUMN NAMES ETC. HAVE BEEN CHANGED IN THE UPDATE, THIS CODE WILL NEED UPDATING.
# AS SUCH, EACH STEP OF THE DATA CLEANING AND RESTRUCTURING IS DESCRIBED TO FACILLITATE THIS.

# The tables have been downloaded with the title, adult_cancer_survival_rcnt_table_ followed by the number corresponding to the source document.


# CLEANING COLUMN NAMES ---------------------------------------------------

# Cleaning column names of all tables
for (i in 1:5){
  
  df1 <- get(paste0("adult_cancer_survival_rcnt_table_", i))
  
  df1 <- df1 %>%
    janitor::clean_names()
  
  assign(paste0("adult_cancer_survival_rcnt_table_", i), df1)
}


###########################################################################
# CREATING SUMMARY "LEAGUE" TABLE -----------------------------------------
###########################################################################

# RETAINING ONLY RELEVANT COLUMNS AND REMOVING GENDER ---------------------

adult_cancer_survival_rcnt_table_1_ch1 <- adult_cancer_survival_rcnt_table_1 %>%
  
  # Only selecting relevant columns
  dplyr::select(cancer_site, gender, age_at_diagnosis_years, standardisation_type, 
                years_since_diagnosis, patients, net_survival_percent) %>%
  
  # Only including cancer sites where rates are not separated by gender UNLESS only one gender is included, (eg. prostate cancer only includes the male gender)
  dplyr::filter((!("Persons" %in% gender) | gender == "Persons") &
                  years_since_diagnosis %in% c(1, 5, 10)) %>%
  
  # Only including age standardisation type 5 age groups UNLESS this does not exist for a particular cancer site and stage, in which case is 4 age groups is used, this is included instead 
  dplyr::group_by(cancer_site, years_since_diagnosis) %>%
  dplyr::filter(if ("Age-standardised (5 age groups)" %in% standardisation_type) standardisation_type == "Age-standardised (5 age groups)" 
                else standardisation_type == "Age-standardised (4 age groups)") %>%
  dplyr::ungroup()


# RESTRUCTURING DATA ------------------------------------------------------

# Restructuring data to have columns with survival for 1 and 5 years.
adult_cancer_survival_rcnt_table_1_ch2 <- adult_cancer_survival_rcnt_table_1_ch1 %>%
  dplyr::group_by(cancer_site) %>%
  dplyr::mutate(
    one_year_survival = dplyr::case_when(
      years_since_diagnosis == 1 ~ as.numeric(net_survival_percent)
    ),
    five_year_survival = dplyr::case_when(
      years_since_diagnosis == 5 ~ as.numeric(net_survival_percent)
    ),
    ten_year_survival = dplyr::case_when(
      years_since_diagnosis == 10 ~ as.numeric(net_survival_percent)
    )
  ) %>%
  dplyr::summarise(one_year_survival = ifelse(sum(one_year_survival, na.rm = T) == 0, NA, sum(one_year_survival, na.rm = T)),
                   five_year_survival = ifelse(sum(five_year_survival, na.rm = T) == 0, NA, sum(five_year_survival, na.rm = T)),
                   ten_year_survival = ifelse(sum(ten_year_survival, na.rm = T) == 0, NA, sum(ten_year_survival, na.rm = T))) %>%
  dplyr::ungroup() %>%
  dplyr::select(cancer_site, one_year_survival, five_year_survival, ten_year_survival) %>%
  
  # Specifying ICD10 Codes, adding an ICD10 column
  
  dplyr::mutate(ICD10 = dplyr::case_when(
    cancer_site == "Anus" ~ "C21",
    cancer_site == "Bladder" ~ "C67",
    cancer_site == "Bowel" ~ "C18 - C20",
    cancer_site == "Brain" ~ "C71",
    cancer_site == "Breast" ~ "C50",
    cancer_site == "Colon" ~ "C18",
    cancer_site == "Diffuse large B-cell lymphoma" ~ "C83.3",
    cancer_site == "Eye" ~ "C69",
    cancer_site == "Follicular (nodular) NHL" ~ "C82",
    cancer_site == "Gallbladder" ~ "C23",
    cancer_site == "Hodgkin lymphoma" ~ "C81",
    cancer_site == "Kidney" ~ "C64",
    cancer_site == "Leukaemia" ~ "C91 - C95",
    cancer_site == "Liver" ~ "C22",
    cancer_site == "Lung" ~ "C34",
    cancer_site == "Melanoma" ~ "C43",
    cancer_site == "Mesothelioma" ~ "C45",
    cancer_site == "Myeloid leukaemia" ~ "C92",
    cancer_site == "Myeloma" ~ "C90",
    cancer_site == "Non-Hodgkin lymphoma" ~ "C82 - C85",
    cancer_site == "Oesophagus" ~ "C15",
    cancer_site == "Pancreas" ~ "C25",
    cancer_site == "Rectal" ~ "C20",
    cancer_site == "Small intestine" ~ "C17",
    cancer_site == "Stomach" ~ "C16",
    cancer_site == "Thyroid" ~ "C73"
    
  ))


###########################################################################
# CREATING SURVIVAL BY AGE TABLE ------------------------------------------
###########################################################################


# RETAINING NON-GENDERED AND GENDERED CANCERS -----------------------------

adult_cancer_age <- adult_cancer_survival_rcnt_table_1 %>%
  
  # Only including cancer sites where rates are not separated by gender UNLESS only one gender is included, (eg. prostate cancer only includes the male gender)
  dplyr::filter((!("Persons" %in% gender) | gender == "Persons") & standardisation_type == "Non-standardised" &
                  years_since_diagnosis %in% c(1, 5, 10) &
                  age_at_diagnosis_years != "All ages")


# CREATING A TABLE OF 1 YR SURVIVAL ---------------------------------------

adult_cancer_age_ONE_YR <- adult_cancer_age %>%
  
  # Retaining only cases where the survival length is one year
  dplyr::filter(years_since_diagnosis == 1) %>%
  
  # Retaining only relevant columns
  dplyr::select(cancer_site, age_at_diagnosis_years, net_survival_percent) %>%
  
  # Renaming column to make clear it is only one year survival
  dplyr::rename(one_yr_survival = net_survival_percent)




# CREATING A TABLE OF 5 YR SURVIVAL ---------------------------------------

adult_cancer_age_FIVE_YR <- adult_cancer_age %>%
  
  # Retaining only cases where the survival length is five years
  dplyr::filter(years_since_diagnosis == 5) %>%
  
  # Retaining only relevant columns
  dplyr::select(cancer_site, age_at_diagnosis_years, net_survival_percent) %>%
  
  # Renaming column to make clear it is only five year survival
  dplyr::rename(five_yr_survival = net_survival_percent)



# JOINING ONE YEAR AND FIVE YEAR DATA -------------------------------------

adult_cancer_age_ALL <- adult_cancer_age_ONE_YR %>%
  
  # Joining the one year and five year survival datasets, excluding no records.
  dplyr::full_join(adult_cancer_age_FIVE_YR, by = join_by(cancer_site, age_at_diagnosis_years)) %>%
  
  # Ordering this by the cancer (alphabetical) and age (ascending)
  dplyr::arrange(cancer_site, age_at_diagnosis_years)


###########################################################################
# CREATING SURVIVAL BY STAGE TABLE ----------------------------------------
###########################################################################


# CLEANING THE DATA -------------------------------------------------------

adult_cancer_survival_rcnt_STAGE <- adult_cancer_survival_rcnt_table_2 %>%
  
  # Retaining only relevant columns
  dplyr::select(cancer_site, gender, age_at_diagnosis, stage_at_diagnosis, standardisation_type,
                years_since_diagnosis, patients, net_survival_percent) %>%
  
  # Specifying that only age standardised cases with survival of one year or five years should be included
  dplyr::filter(age_at_diagnosis == "All ages" & 
                  years_since_diagnosis %in% c(1,5)) %>% 
  
  # Only including age standardisation type 5 age groups UNLESS this does not exist for a particular cancer site and stage, in which case is 4 age groups is used, this is included instead 
  dplyr::group_by(cancer_site, stage_at_diagnosis, years_since_diagnosis) %>%
  dplyr::filter(if ("Age-standardised (5 age groups)" %in% standardisation_type) standardisation_type == "Age-standardised (5 age groups)" 
                else standardisation_type == "Age-standardised (4 age groups)") %>%
  dplyr::ungroup() %>%
  
  # Ordering the data by cancer (alphabetical), stage (ascending), and years since diagnosis (ascending)
  dplyr::arrange(cancer_site, stage_at_diagnosis, years_since_diagnosis) %>%
  dplyr::group_by(cancer_site) %>%
  
  # Only including one gender per cancer site (eg. for gendered cancers, the specific gender, otherwise "Persons")
  filter(!("Persons" %in% gender) | gender == "Persons") %>%
  ungroup()


# RESTRUCTURING DATA FOR USE IN DASHBOARD ---------------------------------

adult_cancer_survival_rcnt_STAGE2 <- adult_cancer_survival_rcnt_STAGE %>%
  
  # Adding an additional stage column to be used
  dplyr::mutate(stage_diagnosed = as.character(stage_at_diagnosis)) %>%
  dplyr::group_by(cancer_site, stage_diagnosed) %>%
  
  # Adding one five and ten year survival columns to differentiate
  dplyr::mutate(
    one_year_survival = dplyr::case_when(
      years_since_diagnosis == 1 ~ as.numeric(net_survival_percent)
    ),
    five_year_survival = dplyr::case_when(
      years_since_diagnosis == 5 ~ as.numeric(net_survival_percent)
    ),
    ten_year_survival = dplyr::case_when(
      years_since_diagnosis == 10 ~ as.numeric(net_survival_percent)
    )
  ) %>%
  
  # Structuring data so that there is only one survival rate per cancer per stage per 1, 5, or 10 year column
  dplyr::summarise(one_year_survival = ifelse(sum(one_year_survival, na.rm = T) == 0, NA, sum(one_year_survival, na.rm = T)),
                   five_year_survival = ifelse(sum(five_year_survival, na.rm = T) == 0, NA, sum(five_year_survival, na.rm = T)),
                   ten_year_survival = ifelse(sum(ten_year_survival, na.rm = T) == 0, NA, sum(ten_year_survival, na.rm = T))) %>%
  ungroup() %>%
  
  # Retaining only relevant columns
  dplyr::select(cancer_site, stage_diagnosed, one_year_survival, five_year_survival, ten_year_survival) %>%
  
  # Only retaining cases where the stage at diagnosis is 1, 2, 3, 4 or unstageable
  dplyr::filter(!is.na(stage_diagnosed) & stage_diagnosed %in% c("1", "2", "3", "4", "Unstageable"))


###########################################################################
# CREATING SURVIVAL BY DEPRIVATION TABLE ----------------------------------
###########################################################################


# CLEANING DATA -----------------------------------------------------------

adult_cancer_survival_rcnt_DEPRIVATION <- adult_cancer_survival_rcnt_table_3 %>%
  
  # Retaining relevant columns
  dplyr::select(cancer_site, gender, imd_quintile, standardisation_type,
                years_since_diagnosis,  net_survival_percent) %>%
  
  # Retaining one and five year net survival rates.
  dplyr::filter(years_since_diagnosis %in% c(1,5)) %>% 
  
  # Only including age standardisation type 5 age groups UNLESS this does not exist for a particular cancer site and stage, in which case is 4 age groups is used, this is included instead 
  dplyr::group_by(cancer_site, imd_quintile, years_since_diagnosis) %>%
  dplyr::filter(if ("Age-standardised (5 age groups)" %in% standardisation_type) standardisation_type == "Age-standardised (5 age groups)" 
                else standardisation_type == "Age-standardised (4 age groups)") %>%
  dplyr::ungroup() %>%
  
  # Ordering data by cancer site (alphabetical) and years since diagnosis (ascending)
  dplyr::arrange(cancer_site, years_since_diagnosis) %>%
  dplyr::group_by(cancer_site) %>%
  
  # Only retaining one gender category per cancer site
  dplyr:: filter(!("Persons" %in% gender) | gender == "Persons") %>%
  dplyr::ungroup()


# GROUPING SURVIVAL RATES BY CANCER AND DEPRIVATION -----------------------

adult_cancer_survival_rcnt_DEPRIVATION_2 <- adult_cancer_survival_rcnt_DEPRIVATION %>%
  dplyr::group_by(cancer_site, imd_quintile) %>%
  
  # Creating one, five and ten year survival column
  dplyr::mutate(
    one_year_survival = dplyr::case_when(
      years_since_diagnosis == 1 ~ as.numeric(net_survival_percent)
    ),
    five_year_survival = dplyr::case_when(
      years_since_diagnosis == 5 ~ as.numeric(net_survival_percent)
    ),
    ten_year_survival = dplyr::case_when(
      years_since_diagnosis == 10 ~ as.numeric(net_survival_percent)
    )
  ) %>%
  dplyr::summarise(one_year_survival = ifelse(sum(one_year_survival, na.rm = T) == 0, NA, sum(one_year_survival, na.rm = T)),
                   five_year_survival = ifelse(sum(five_year_survival, na.rm = T) == 0, NA, sum(five_year_survival, na.rm = T)),
                   ten_year_survival = ifelse(sum(ten_year_survival, na.rm = T) == 0, NA, sum(ten_year_survival, na.rm = T))) %>%
  ungroup() %>%
  
  # Retaining only relevant columns
  dplyr::select(cancer_site, imd_quintile, one_year_survival, five_year_survival, ten_year_survival)


###########################################################################
# CREATING SURVIVAL TRENDS TABLES -----------------------------------------
###########################################################################


# CLEANING DATA -----------------------------------------------------------

adult_trends <- adult_cancer_survival_rcnt_table_5 %>%
  dplyr::group_by(cancer_site) %>%
  
  # Order by gender (alphabetical)
  dplyr::arrange(gender) %>%
  
  # Only including records for "England" and one gender per person
  dplyr::filter(
    geography_name == "England" &
      (gender == "Persons" | !any(gender == "Persons"))
  ) %>%
  dplyr::ungroup()


# CREATING A ONE YEAR DATASET ---------------------------------------------

adult_trends_ONE_1 <- adult_trends %>%
  
  # Only retaining records for one year of survival
  dplyr::filter(years_since_diagnosis == 1) %>%
  
  # Removing irrelevant columns
  dplyr::select(-c(geography_type, geography_code, geography_name, gender, years_since_diagnosis,
                   trend_estimate, significance_level))


# RESTRUCTURING ONE YEAR DATASET ------------------------------------------

adult_trends_ONE <- adult_trends_ONE_1 %>%
  
  # Pivoting the data so that the rows named after the years become columns, and the survival rate fills in the cells
  tidyr::pivot_longer(cols = c("x2007_to_2011", "x2008_to_2012", "x2009_to_2013", "x2010_to_2014", 
                               "x2011_to_2015", "x2012_to_2016", "x2013_to_2017", "x2014_to_2018",
                               "x2015_to_2019", "x2016_to_2020"),
                      names_to = "period",
                      values_to = "Survival") %>%
  
  # Renaming column names
  dplyr::mutate(period = str_replace_all(period, c("^x" = "", "_to_" = " - "))
  )%>%
  
  # Ordering by years (descending)
  dplyr::arrange(desc(period))



# CREATING FIVE YEAR DATASET ----------------------------------------------

adult_trends_FIVE_1 <- adult_trends %>%
  
  # Only retaining 5 years of survival records
  dplyr::filter(years_since_diagnosis == 5) %>%
  
  # Removing irrelevant columns
  dplyr::select(-c(geography_type, geography_code, geography_name, gender, years_since_diagnosis,
                   trend_estimate, significance_level))


# RESTRUCTURING FIVE YEAR DATASET -----------------------------------------

adult_trends_FIVE <- adult_trends_FIVE_1 %>%
  
  # Pivoting dataframe to move years to column headers and populating cells with survival rate
  tidyr::pivot_longer(cols = c("x2007_to_2011", "x2008_to_2012", "x2009_to_2013", "x2010_to_2014", 
                               "x2011_to_2015", "x2012_to_2016", "x2013_to_2017", "x2014_to_2018",
                               "x2015_to_2019", "x2016_to_2020"),
                      names_to = "period",
                      values_to = "Survival") %>%
  
  # Renaming columns
  dplyr::mutate(
    period = str_replace_all(period, c("^x" = "", "_to_" = " - "))
  ) %>%
  
  # Ordering by time (descending)
  dplyr::arrange(desc(period))


###########################################################################
# CREATING SURVIVAL BY ICB TABLE ------------------------------------------
###########################################################################


# CLEANING DATA -----------------------------------------------------------

adult_cancer_geography <- adult_cancer_survival_rcnt_table_4 %>%
  
  # Only including one gender per cancer site
  dplyr::filter((!("Persons" %in% gender) | gender == "Persons") &
                  years_since_diagnosis %in% c(1, 5, 10)) %>%
 
   # Only including age standardisation type 5 age groups UNLESS this does not exist for a particular cancer site and stage, in which case is 4 age groups is used, this is included instead 
  dplyr::group_by(cancer_site, geography_code, years_since_diagnosis) %>%
  dplyr::filter(if ("Age-standardised (5 age groups)" %in% standardisation_type) standardisation_type == "Age-standardised (5 age groups)" 
                else standardisation_type == "Age-standardised (4 age groups)") %>%
  dplyr::ungroup()



# CREATING TABLE FOR ONE YEAR SURVIVAL ------------------------------------

adult_cancer_geography_1YR <- adult_cancer_geography %>%
  
  # Filtering by one year survival and integrated care board
  dplyr::filter(years_since_diagnosis == 1 & geography_type == "Integrated Care Board") %>%
  
  # Retaining only relevant columns
  dplyr::select(geography_code, geography_name, cancer_site, net_survival_percent) %>%
  
  # Labeling one year survival for survival column
  dplyr::rename(one_yr_survival = net_survival_percent) %>%
  
  # Deleting duplicate rows
  dplyr::distinct()


# CREATING TABLE FOR FIVE YEAR SURVIVAL -----------------------------------

adult_cancer_geography_5YR <- adult_cancer_geography %>%
  
  # Filtering by five year survival and integrated care board
  dplyr::filter(years_since_diagnosis == 5 & geography_type == "Integrated Care Board") %>%
  
  # Retaining only relevant columns
  dplyr::select(geography_code, geography_name, cancer_site, net_survival_percent) %>%
  
  # Labelling survival column as five year
  dplyr::rename(five_yr_survival = net_survival_percent) %>%
  
  # Deleting duplicate rows
  dplyr::distinct()


# JOINING ONE YEAR AND FIVE YEAR DATASETS ---------------------------------

adult_cancer_geography_all <- adult_cancer_geography_1YR %>%
  
  # Joining all records in one year and five year dataset
  dplyr::full_join(adult_cancer_geography_5YR, by = join_by(cancer_site, geography_name, geography_code)) %>% 
  
  # Deleting duplicates
  dplyr::distinct()


###########################################################################
# CREATING GENDER TABLE ---------------------------------------------------
###########################################################################

# CLEANING DATA -----------------------------------------------------------

adult_cancer_gender <- adult_cancer_survival_rcnt_table_1 %>%
  
  # Only including male and female rates for cancer sites and years from diagnosis being 1, 5, or 10
  dplyr::filter(gender %in% c("Male", "Female")  &
                  years_since_diagnosis %in% c(1, 5, 10) &
                  
                  # Removing any gendered cancers
                  !(cancer_site %in% c("Vulva", "Uterus", "Testis", "Prostate", "Ovary", "Cervix", "Breast"))) %>%
  
  # Only including age standardisation type 5 age groups UNLESS this does not exist for a particular cancer site and gender, in which case is 4 age groups is used, this is included instead 
  dplyr::group_by(cancer_site, gender, years_since_diagnosis) %>%
  dplyr::filter(if ("Age-standardised (5 age groups)" %in% standardisation_type) standardisation_type == "Age-standardised (5 age groups)" 
  else standardisation_type == "Age-standardised (4 age groups)") %>%
  dplyr::ungroup()


# CREATING TABLE FOR ONE YEAR SURVIVAL ------------------------------------

adult_cancer_gender_1YR <- adult_cancer_gender %>%
  
  # Filtering by one year survival
  dplyr::filter(years_since_diagnosis == 1) %>%
  
  # Retaining only relevant columns
  dplyr::select(cancer_site, gender, net_survival_percent) %>%
  
  # Labeling one year survival for survival column
  dplyr::rename(one_yr_survival = net_survival_percent) %>%
  
  # Deleting duplicate rows
  dplyr::distinct()


# CREATING TABLE FOR FIVE YEAR SURVIVAL -----------------------------------

adult_cancer_gender_5YR <- adult_cancer_gender %>%
  
  # Filtering by five year survival and integrated care board
  dplyr::filter(years_since_diagnosis == 5) %>%
  
  # Retaining only relevant columns
  dplyr::select(cancer_site, gender, net_survival_percent) %>%
  
  # Labelling survival column as five year
  dplyr::rename(five_yr_survival = net_survival_percent) %>%
  
  # Deleting duplicate rows
  dplyr::distinct()


# JOINING ONE YEAR AND FIVE YEAR DATASETS ---------------------------------

adult_cancer_gender_all <- adult_cancer_gender_1YR %>%
  
  # Joining all records in one year and five year dataset
  dplyr::full_join(adult_cancer_gender_5YR, by = join_by(cancer_site, gender)) %>% 
  
  # Deleting duplicates
  dplyr::distinct()
