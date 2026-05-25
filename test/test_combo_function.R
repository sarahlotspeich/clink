# Setup ------------------------------------------------------------------------
## Load data
lookup_babies = read.csv("~/Documents/ehr_linkage/patient_data/lookup_babies.csv")
lookup_moms = read.csv("~/Documents/ehr_linkage/patient_data/lookup_moms.csv")

## Load packages
library(clink)

## Test functions on first baby
baby1 = lookup_babies[1, ]

# Key 1: Guarantor name
combined_baby_parent_linkage(
  baby_to_match = baby1,
  parents_to_match = lookup_moms,
  key_baby = "guarantor_mother_name",
  key_parent = "m_name",
  jaro_col_name = "jaro_guarantor_mother_name"
  )
