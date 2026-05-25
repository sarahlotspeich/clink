# Setup ------------------------------------------------------------------------
## Load data
lookup_babies = read.csv("~/Documents/ehr_linkage/patient_data/lookup_babies.csv")
lookup_moms = read.csv("~/Documents/ehr_linkage/patient_data/lookup_moms.csv")

## Load packages
library(clink)

## Test functions on first baby
baby1 = lookup_babies[1, ]
baby_to_match = baby1
parents_to_match = lookup_moms
key_baby = c("guarantor_mother_name", "relation_mother_name1", "demo_address")
key_parent = c("m_name", "m_name", "m_add")
id_parent = "mom_mrn"
jaro_col_name = c("jaro_guarantor_mother_name", "jaro_relation_mother_name1", "jaro_demo_address")

evaluate_candidate_parent_pool(
  baby_to_match = baby1,
  parents_to_match = lookup_moms,
  key_baby = c("guarantor_mother_name", "relation_mother_name1", "demo_address"),
  key_parent = c("m_name", "m_name", "m_add"),
  id_parent = "mom_mrn",
  jaro_col_name = c("jaro_guarantor_mother_name", "jaro_relation_mother_name1", "jaro_demo_address")
)
