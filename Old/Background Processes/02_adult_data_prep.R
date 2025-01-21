# Emma Muijen
# 19 November 2024
# Data prep for adult cancer survival datasets in survival dashboard

# GOAL: TO MAKE THE BELOW CODE REPRODUCIBLE

# ToC:
# 1. Recent datasets
#   (a) Table 1 - Gender & Age
#   (b) Table 2 - Gender & Stage
#   (c) Table 3 - Gender & Deprivation
#   (d) Table 5 - Trends
#   (e) Table 4 - Geography
# 2. Trends between recent and previous datasets
#   (a) Trends for cancer sites
#   (b) Trends for cancer sites by stage


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

# Isolating relevant data
adult_cancer_survival_rcnt_table_1_ch1 <- adult_cancer_survival_rcnt_table_1 %>%
  dplyr::select(cancer_site, gender, age_at_diagnosis_years, standardisation_type, 
                years_since_diagnosis, patients, net_survival_percent) %>%
  dplyr::filter((!("Persons" %in% gender) | gender == "Persons") & standardisation_type == "Age-standardised (5 age groups)" &
                  years_since_diagnosis %in% c(1, 5, 10)) 

# Rearranging data to have columns with survival for 1 and 5 years.
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
  ungroup() %>%
  dplyr::select(cancer_site, one_year_survival, five_year_survival, ten_year_survival) %>%
  
  # Specifying ICD10 Codes
  
  mutate(ICD10 = dplyr::case_when(
    cancer_site == "Anus" ~ "C21",
    cancer_site == "Bladder" ~ "C67",
    cancer_site == "Bowel" ~ "C17 / C18 / C20",
    cancer_site == "Brain" ~ "C71",
    cancer_site == "Breast" ~ "C50",
    cancer_site == "Colon" ~ "C18",
    cancer_site == "Diffuse large B-cell lymphoma" ~ "C83.3",
    cancer_site == "Eye" ~ "C69",
    cancer_site == "Follicular (nodular) NHL" ~ "C82",
    cancer_site == "Gallbladder" ~ "C23",
    cancer_site == "Hodgkin lymphoma" ~ "C81",
    cancer_site == "Kidney" ~ "C64",
    cancer_site == "Leukaemia" ~ "C91 - C94",
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



########################## Creating Survival by Age Table ##########################

# Filtering relevant data
adult_cancer_age <- adult_cancer_survival_rcnt_table_1 %>%
  dplyr::filter((!("Persons" %in% gender) | gender == "Persons") & standardisation_type == "Non-standardised" &
                  years_since_diagnosis %in% c(1, 5, 10) &
                  age_at_diagnosis_years != "All ages")

# Calculating survival for 1 year
adult_cancer_age_ONE_YR <- adult_cancer_age %>%
  dplyr::filter(years_since_diagnosis == 1) %>%
  dplyr::select(cancer_site, age_at_diagnosis_years, net_survival_percent) %>%
  dplyr::rename(one_yr_survival = net_survival_percent)


  
# Calculating survival for 5 years
adult_cancer_age_FIVE_YR <- adult_cancer_age %>%
  dplyr::filter(years_since_diagnosis == 5) %>%
  dplyr::select(cancer_site, age_at_diagnosis_years, net_survival_percent) %>%
  dplyr::rename(five_yr_survival = net_survival_percent)


# Joining one year and five year tables
adult_cancer_age_ALL <- adult_cancer_age_ONE_YR %>%
  dplyr::full_join(adult_cancer_age_FIVE_YR, by = join_by(cancer_site, age_at_diagnosis_years)) %>%
  dplyr::arrange(cancer_site, age_at_diagnosis_years)




# (b) Table 2 - Gender & Stage-------------------------------------------------------------

# Cleaning data
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

# Specifying Stage 1/2 and 3/4
adult_cancer_survival_rcnt_STAGE2 <- adult_cancer_survival_rcnt_STAGE %>%
  # dplyr::mutate(
  #   stage_diagnosed = dplyr::case_when(
  #     stage_at_diagnosis %in% c("1","2") ~ "Stage 1 or 2",
  #     stage_at_diagnosis %in% c("3", "4") ~ "Stage 3 or 4",
  #     stage_at_diagnosis == "Unstageable" ~ "Unstageable",
  #     TRUE ~ NA
  #   )
  # ) %>%
  dplyr::mutate(stage_diagnosed = as.character(stage_at_diagnosis)) %>%
  dplyr::group_by(cancer_site, stage_diagnosed) %>%
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
  dplyr::select(cancer_site, stage_diagnosed, one_year_survival, five_year_survival, ten_year_survival) %>%
  dplyr::filter(!is.na(stage_diagnosed) & stage_diagnosed %in% c("1", "2", "3", "4", "Unstageable"))

# (c) Table 3 - Gender & Deprivation -------------------------------------------------------------

# Cleaning data
adult_cancer_survival_rcnt_DEPRIVATION <- adult_cancer_survival_rcnt_table_3 %>%
  dplyr::select(cancer_site, gender, imd_quintile, standardisation_type,
                years_since_diagnosis,  net_survival_percent) %>%
  dplyr::filter(standardisation_type == "Age-standardised (5 age groups)" & 
                  years_since_diagnosis %in% c(1,5)) %>% 
  dplyr::arrange(cancer_site, years_since_diagnosis) %>%
  dplyr::group_by(cancer_site) %>%
  filter(!("Persons" %in% gender) | gender == "Persons") %>%
  ungroup()

# Grouping survival rates by cancer and deprivation quintile
adult_cancer_survival_rcnt_DEPRIVATION_2 <- adult_cancer_survival_rcnt_DEPRIVATION %>%
  dplyr::group_by(cancer_site, imd_quintile) %>%
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
  dplyr::select(cancer_site, imd_quintile, one_year_survival, five_year_survival, ten_year_survival)




# (d) Table 5 - Trends ----------------------------------------------------

adult_trends <- adult_cancer_survival_rcnt_table_5 %>%
  dplyr::group_by(cancer_site) %>%
  dplyr::arrange(gender) %>%
  dplyr::filter(
    geography_name == "England" &
    (gender == "Persons" | !any(gender == "Persons"))
  ) %>%
  dplyr::ungroup()


# ONE YEAR DATASET

adult_trends_ONE_1 <- adult_trends %>%
  dplyr::filter(years_since_diagnosis == 1) %>%
  dplyr::select(-c(geography_type, geography_code, geography_name, gender, years_since_diagnosis,
                   trend_estimate, significance_level))

adult_trends_ONE <- adult_trends_ONE_1 %>%
  tidyr::pivot_longer(cols = c("x2007_to_2011", "x2008_to_2012", "x2009_to_2013", "x2010_to_2014", 
                               "x2011_to_2015", "x2012_to_2016", "x2013_to_2017", "x2014_to_2018",
                               "x2015_to_2019", "x2016_to_2020"),
                      names_to = "period",
                      values_to = "Survival") %>%
  dplyr::mutate(period = str_replace_all(period, c("^x" = "", "_to_" = " - "))
                      )%>%
  dplyr::arrange(desc(period))

# FIVE YEAR DATASET

adult_trends_FIVE_1 <- adult_trends %>%
  dplyr::filter(years_since_diagnosis == 5) %>%
  dplyr::select(-c(geography_type, geography_code, geography_name, gender, years_since_diagnosis,
                   trend_estimate, significance_level))

adult_trends_FIVE <- adult_trends_FIVE_1 %>%
  tidyr::pivot_longer(cols = c("x2007_to_2011", "x2008_to_2012", "x2009_to_2013", "x2010_to_2014", 
                               "x2011_to_2015", "x2012_to_2016", "x2013_to_2017", "x2014_to_2018",
                               "x2015_to_2019", "x2016_to_2020"),
                      names_to = "period",
                      values_to = "Survival") %>%
  dplyr::mutate(
    period = str_replace_all(period, c("^x" = "", "_to_" = " - "))
  ) %>%
  dplyr::arrange(desc(period))



# (e) Table 4 - Geography -------------------------------------------------

adult_cancer_geography <- adult_cancer_survival_rcnt_table_4 %>%
  dplyr::filter((!("Persons" %in% gender) | gender == "Persons") & standardisation_type == "Age-standardised (5 age groups)" &
                         years_since_diagnosis %in% c(1, 5, 10))


##### Creating 1 yr table #################

adult_cancer_geography_1YR <- adult_cancer_geography %>%
  dplyr::filter(years_since_diagnosis == 1 & geography_type == "Integrated Care Board") %>%
  dplyr::select(geography_code, geography_name, cancer_site, net_survival_percent) %>%
  dplyr::rename(one_yr_survival = net_survival_percent) %>%
  dplyr::distinct()

##### Creating 5 yr table #################

adult_cancer_geography_5YR <- adult_cancer_geography %>%
  dplyr::filter(years_since_diagnosis == 5 & geography_type == "Integrated Care Board") %>%
  dplyr::select(geography_code, geography_name, cancer_site, net_survival_percent) %>%
  dplyr::rename(five_yr_survival = net_survival_percent) %>%
  dplyr::distinct()

##### Joining #################


adult_cancer_geography_all_1 <- adult_cancer_geography_1YR %>%
  dplyr::full_join(adult_cancer_geography_5YR, by = join_by(cancer_site, geography_name, geography_code)) %>% 
  dplyr::distinct()


######################################################
# 2. Trends between recent and previous datasets
######################################################


# (a) Trends for cancer sites ---------------------------------------------

# Cleaning table 1 from previous data

adult_cancer_survival_prev_table_1_clean <- adult_cancer_survival_prev_table_1 %>%
  dplyr::select(cancer_site, gender, age_at_diagnosis, standardisation_type, 
                x1_year_survival_percent, x5_year_survival_percent) %>%
  dplyr::filter((!("Persons" %in% gender) | gender == "Persons") & standardisation_type == "Age-standardised (5 gps)") %>%
  dplyr::select(cancer_site, x1_year_survival_percent, x5_year_survival_percent) %>%
  dplyr::rename(one_year_survival_prev = x1_year_survival_percent, five_year_survival_prev = x5_year_survival_percent)

# Joining previous and recent datasets
adult_cancer_survival_trends <- 
  dplyr::inner_join(adult_cancer_survival_rcnt_table_1_ch2, adult_cancer_survival_prev_table_1_clean)

# Assessing percentage change
adult_cancer_survival_trends_2 <- adult_cancer_survival_trends %>%
  dplyr::mutate(
    prcnt_chng_one_yr = ifelse(!is.na((one_year_survival - as.numeric(one_year_survival_prev))/as.numeric(one_year_survival_prev)),paste0(round(100*(one_year_survival - as.numeric(one_year_survival_prev))/as.numeric(one_year_survival_prev), 1), "%"), NA),
    prcnt_chng_five_yr = ifelse(!is.na((five_year_survival - as.numeric(five_year_survival_prev))/as.numeric(five_year_survival_prev)), paste0(round(100*(five_year_survival - as.numeric(five_year_survival_prev))/as.numeric(five_year_survival_prev), 1), "%"), NA),
    #prcnt_chng_ten_yr = 100*(ten_year_survival - as.numeric(ten_year_survival_prev))/as.numeric(ten_year_survival_prev)
  ) %>%
  dplyr::select(cancer_site, prcnt_chng_one_yr, prcnt_chng_five_yr)#, prcnt_chng_ten_yr)



# (b) Trends for cancer sites by stage ------------------------------------

# Cleaning table 2 from previous data

adult_cancer_survival_prev_table_2_clean <- adult_cancer_survival_prev_table_2 %>%
  dplyr::group_by(cancer_site) %>%
  dplyr::filter((!("Persons" %in% gender) | gender == "Persons")) %>%
  dplyr::ungroup() %>%
  dplyr::mutate_at(c('x1_year_stage_1', 'x1_year_stage_2', 'x1_year_stage_3',
                     'x1_year_stage_4', 'x5_year_stage_1', 'x5_year_stage_2',
                     'x5_year_stage_3', 'x5_year_stage_4'), as.numeric) %>%
  dplyr::mutate(
    stage_1_2_survival_1yr = 100*(x1_year_stage_1 + x1_year_stage_2)/200,
    stage_3_4_survival_1yr = 100*(x1_year_stage_3 + x1_year_stage_4)/200,
    stage_1_2_survival_5yr = 100*(x5_year_stage_1 + x5_year_stage_2)/200,
    stage_3_4_survival_5yr = 100*(x5_year_stage_3 + x5_year_stage_4)/200,
  ) %>%
  dplyr::select(cancer_site, stage_1_2_survival_1yr, stage_3_4_survival_1yr,
                stage_1_2_survival_5yr, stage_3_4_survival_5yr)

# Structuring similarly to the recent data table
adult_cancer_survival_prev_table_2_clean_2 <- adult_cancer_survival_prev_table_2_clean %>%
  dplyr::bind_rows(adult_cancer_survival_prev_table_2_clean) %>%
  dplyr::arrange(cancer_site) %>%
  dplyr::group_by(cancer_site) %>%
  dplyr::mutate(stage_diagnosed = c("Stage 1 or 2", "Stage 3 or 4"),
                one_year_prev = dplyr::case_when(
                  stage_diagnosed == "Stage 1 or 2" ~ stage_1_2_survival_1yr,
                  stage_diagnosed == "Stage 3 or 4" ~ stage_3_4_survival_1yr
                ),
                five_year_prev = dplyr::case_when(
                  stage_diagnosed == "Stage 1 or 2" ~ stage_1_2_survival_5yr,
                  stage_diagnosed == "Stage 1 or 2" ~ stage_3_4_survival_5yr
                )
  ) %>%
  dplyr::ungroup() %>%
  dplyr::select(cancer_site, stage_diagnosed, one_year_prev, five_year_prev)

  # Joining the recent and previous datasets

adult_STAGE_trends <- inner_join(adult_cancer_survival_rcnt_STAGE2, adult_cancer_survival_prev_table_2_clean_2, by = c("cancer_site", "stage_diagnosed"))

# Calculating percentage increase/decrease

adult_STAGE_trends_2 <- adult_STAGE_trends %>%
  dplyr::mutate(
    one_year_pct_change = 
      dplyr::case_when(
        !is.na(one_year_survival) & !is.na(one_year_prev) ~ 
          100*(one_year_survival - one_year_prev)/one_year_prev,
        TRUE ~ NA
      ),
    five_year_pct_change = 
      dplyr::case_when(
        !is.na(five_year_survival) & !is.na(five_year_prev) ~ 
          100*(five_year_survival - five_year_prev)/five_year_prev,
        TRUE ~ NA
      )
  )

message("Adult cancer survival data prepped")
