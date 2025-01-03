# Emma Muijen

# Transforming international data


# LIBRARIES ---------------------------------------------------------------

library(tidyverse)
library(readxl)
library(openxlsx)


# IMPORTING DATA ----------------------------------------------------------

file_path <- "C:/Users/Emma.Muijen/Department of Health and Social Care/NW027 - Performance Insight/ANALYSTS/Cancer/Survival and Diagnosis/Dashboard/Data/international_comparisons.xlsx"

adult <- readxl::read_excel(file_path, sheet = "Adult 5 yr net survival")

childhood <- adult <- readxl::read_excel(file_path, sheet = "Childhood 5 yr survival")



# TRANSFORMING DATA -------------------------------------------------------



# Adult data #######################


# Making columns numeric
adult_1 <- adult %>%
  mutate(across(-c(Continent, Country, Year), as.numeric, .names = "{.col}"))

# Transposing data
adult_2 <- adult_1 %>%
  tidyr::pivot_longer(cols = c(Breast, Cervix, Ovary, Prostate, `Brain (adults)`, Myeloid, Lymphoid, Oesophagus, 
                               Stomach, Colon, Rectum, Liver, Pancreas, Lung, `Melanoma of the skin`),
                      names_to = "Cancer Site",
                      values_to = "Net Survival")


# Childhood data  #######################
# Making columns numeric
childhood_1 <- childhood %>%
  mutate(across(-c(Continent, Country), as.numeric, .names = "{.col}"))

childhood_2 <- childhood_1 %>%
  tidyr::pivot_longer(cols = c(Brain, `Acute lymphoblastic leukaemia`, Lymphoma),
                      names_to = "Cancer Site",
                      values_to = "Net Survival")


# SAVING DATA -------------------------------------------------------------

# Loading workbook
wb <- openxlsx::loadWorkbook(file_path)

# Adding dataframes as new sheets
openxlsx::addWorksheet(wb, "Adult for map")
openxlsx::writeData(wb, "Adult for map", adult_2)

openxlsx::addWorksheet(wb, "Childhood for map")
openxlsx::writeData(wb, "Childhood for map", childhood_2)

# Saving workbook
openxlsx::saveWorkbook(wb, file_path, overwrite = TRUE)
