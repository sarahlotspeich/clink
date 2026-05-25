# Setup ------------------------------------------------------------------------
## Load data (already cleaned in data_setup_clink.R)
lookup_babies = read.csv("~/Documents/ehr_linkage/linkages/single_variable/single_deterministic_matches.csv")
lookup_moms = read.csv("~/Documents/ehr_linkage/patient_data/lookup_moms.csv")

## Load packages
library(clink)

## Test functions on first baby
baby1 = lookup_babies[1, ]

# Key 1: Guarantor name
deterministic_baby_parent_linkage(baby_to_match = baby1,
                                  parents_to_match = lookup_moms,
                                  key_baby = "guarantor_mother_name",
                                  key_parent = "m_name")

# Key 2: Patient relation name
deterministic_baby_parent_linkage(baby_to_match = baby1,
                                  parents_to_match = lookup_moms,
                                  key_baby = "relation_mother_name",
                                  key_parent = "m_name")

# Key 3: Address
deterministic_baby_parent_linkage(baby_to_match = baby1,
                                  parents_to_match = lookup_moms,
                                  key_baby = "demo_address",
                                  key_parent = "m_add")

# Key 5: MyChart email (mom_email_col was already a variable in the original)
deterministic_baby_parent_linkage(baby_to_match = baby1,
                                  parents_to_match = lookup_moms,
                                  key_baby = "myc_prxy_email",
                                  key_parent = "m_myc_email")

# Key 6: MyChart address
deterministic_baby_parent_linkage(baby_to_match = baby1,
                                  parents_to_match = lookup_moms,
                                  key_baby = "myc_prxy_address",
                                  key_parent = "m_add")
