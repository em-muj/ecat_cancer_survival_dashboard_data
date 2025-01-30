# Emma Muijen
# 22 January 2025

# Seventh script in a series to prepare data for ECAT Survival Dashboard

# THIS SCRIPT IS OPTIONAL AND SHOULD ONLY BE USED IF THE USER WOULD LIKE TO RESTRUCTURE THE CONCORD DATA ON R.
# THESE STEPS CAN BE DONE EQUIVALENTLY ON EXCEL BY USING A PIVOT TABLE.
# IF YOU WOULD LIKE TO USE R, PLEASE ENSURE THE INTERNATIONAL DATA IS SAVED AS INSTRUCTED IN SCRIPT "01_links_to_data.R"

# RUN THIS SCRIPT ONE STEP AT A TIME.
# THIS SHOULD OUTLINE THE DATA PROCESSING DONE TO PRODUCE THE INTERNATIONAL DATA FOR THE DASHBOARD.
# TO WORK, THE DATA WILL NEED TO BE STRUCTURED IN THE SAME WAY AS THE PREVIOUS ITERATION WAS.


# TRANSFORMING DATA -------------------------------------------------------



###########################################################################
# CREATING UP-TO-DATE ADULT DATASET ---------------------------------------
###########################################################################


# CLEANING DATA -----------------------------------------------------------

adult_1 <- adult %>%
  
  # Ensuring numeric columns are interpreted as numeric by R
  mutate(across(-c(Continent, Country, Year), as.numeric, .names = "{.col}"))


# TRANSFORMING THE DATA FRAME ---------------------------------------------

adult_2 <- adult_1 %>%
  
  # Arranging the data so that the cancer types are rows rather than column headers
  tidyr::pivot_longer(cols = c(Breast, Cervix, Ovary, Prostate, `Brain (adults)`, Myeloid, Lymphoid, Oesophagus, 
                               Stomach, Colon, Rectum, Liver, Pancreas, Lung, `Melanoma of the skin`),
                      names_to = "Cancer Site",
                      values_to = "Net Survival")

###########################################################################
# CREATING UP-TO-DATE CHILDHOOD DATASET -----------------------------------
###########################################################################


# CLEANING DATA -----------------------------------------------------------


childhood_1 <- childhood %>%
  
  # Ensuring numeric columns are interpreted as numeric by R
  mutate(across(-c(Continent, Country), as.numeric, .names = "{.col}"))

# TRANSFORMING THE DATA FRAME ---------------------------------------------

childhood_2 <- childhood_1 %>%
  
  # Arranging the data so that the cancer types are rows rather than column headers
  tidyr::pivot_longer(cols = c(Brain, `Acute lymphoblastic leukaemia`, Lymphoma),
                      names_to = "Cancer Site",
                      values_to = "Net Survival")


###########################################################################
# CREATING PREVIOUS ITERATION OF ADULT DATASET ----------------------------
###########################################################################



# CLEANING DATA -----------------------------------------------------------

adult_his_1 <- adult_historic %>%
  
  # Ensuring numeric columns are interpreted as numeric by R
  mutate(across(-c(Continent, Country, Year), as.numeric, .names = "{.col}"))



# TRANSFORMING THE DATA FRAME ---------------------------------------------

adult_his_2 <- adult_his_1 %>%
  
  # Arranging the data so that the cancer types are rows rather than column headers
  tidyr::pivot_longer(cols = c(Breast, Cervix, Ovary, Prostate, `Brain (adults)`, Myeloid, Lymphoid, Oesophagus, 
                               Stomach, Colon, Rectum, Liver, Pancreas, Lung, `Melanoma of the skin`),
                      names_to = "Cancer Site",
                      values_to = "Net Survival")

###########################################################################
# CREATING PREVIOUS ITERATION OF CHILDHOOD DATASET ------------------------
###########################################################################


# CLEANING DATA -----------------------------------------------------------

childhood_his_1 <- childhood_historic %>%
  
  # Ensuring numeric columns are interpreted as numeric by R
  mutate(across(-c(Continent, Country), as.numeric, .names = "{.col}"))


# TRANSFORMING THE DATA FRAME ---------------------------------------------

childhood_his_2 <- childhood_his_1 %>%
  
  # Arranging the data so that the cancer types are rows rather than column headers
  tidyr::pivot_longer(cols = c(Brain, `Acute lymphoblastic leukaemia`, Lymphoma),
                      names_to = "Cancer Site",
                      values_to = "Net Survival")

###########################################################################
# SAVING THE DATA AS AN EXCEL FILE ----------------------------------------
###########################################################################


# LOADING WORKBOOK --------------------------------------------------------

# Loading the workbook where the Concord data has been saved by the user
wb <- openxlsx::loadWorkbook(file_path)


# CREATING TAB FOR UP-TO-DATE ADULT DATA ----------------------------------

# Creating new sheet
openxlsx::addWorksheet(wb, "Adult for map")

# Saving the data on this sheet
openxlsx::writeData(wb, "Adult for map", adult_2)


# CREATING TAB FOR UP-TO-DATE CHILDHOOD DATA ------------------------------

# Creating new sheet
openxlsx::addWorksheet(wb, "Childhood for map")

# Saving the data on this sheet
openxlsx::writeData(wb, "Childhood for map", childhood_2)


# CREATING TAB FOR PREVIOUS ADULT DATA ------------------------------------

# Creating new sheet
openxlsx::addWorksheet(wb, "Historic adult for dashboard")

# Saving the data on this sheet
openxlsx::writeData(wb, "Historic adult for dashboard", adult_his_2)

openxlsx::addWorksheet(wb, "Historic child for dashboard")
openxlsx::writeData(wb, "Historic child for dashboard", childhood_his_2)

# Saving workbook
openxlsx::saveWorkbook(wb, file_path, overwrite = TRUE)


