# Emma Muijen
# 19 November 2024
# Data prep for adult cancer survival datasets in survival dashboard

# GOAL: TO MAKE THE BELOW CODE REPRODUCIBLE

# ToC:
# 1. Recent datasets
#   (a) Table 1 - Gender & Age
#   (b) Table 2 - Gender & Stage
#   (c) Table 3 - Gender & Deprivation
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
  dplyr::select(cancer_site, one_year_survival, five_year_survival, ten_year_survival)


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
  dplyr::mutate(
    stage_diagnosed = dplyr::case_when(
      stage_at_diagnosis %in% c("1","2") ~ "Stage 1 or 2",
      stage_at_diagnosis %in% c("3", "4") ~ "Stage 3 or 4",
      stage_at_diagnosis == "Unstageable" ~ "Unstageable",
      TRUE ~ NA
    )
  ) %>%
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
  dplyr::summarise(one_year_survival = ifelse(sum(one_year_survival, na.rm = T) == 0, NA, 100*sum(one_year_survival, na.rm = T)/200),
                   five_year_survival = ifelse(sum(five_year_survival, na.rm = T) == 0, NA, 100*sum(five_year_survival, na.rm = T)/200),
                   ten_year_survival = ifelse(sum(ten_year_survival, na.rm = T) == 0, NA, 100*sum(ten_year_survival, na.rm = T)/200)) %>%
  ungroup() %>%
  dplyr::select(cancer_site, stage_diagnosed, one_year_survival, five_year_survival, ten_year_survival) %>%
  dplyr::filter(!is.na(stage_diagnosed))

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
    prcnt_chng_one_yr = 100*(one_year_survival - as.numeric(one_year_survival_prev))/as.numeric(one_year_survival_prev),
    prcnt_chng_five_yr = 100*(five_year_survival - as.numeric(five_year_survival_prev))/as.numeric(five_year_survival_prev),
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
