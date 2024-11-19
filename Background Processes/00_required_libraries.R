# Emma Muijen
# 19 November 2024
# Libraries needed for data prep of survival dashboard


#Automation workbook
# rm(list = ls())
# Check if pacman is installed
if (!requireNamespace("pacman", quietly = TRUE)) {
  install.packages("pacman")
}

# Load the pacman and checkpoint package
library(pacman)

# Use p_load to check for, install, and load packages
pacman::p_load(tidyverse, stringr, lubridate, readxl, openxlsx, dplyr, janitor)
