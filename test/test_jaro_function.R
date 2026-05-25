# Setup ------------------------------------------------------------------------
## Load data
lookup_babies = read.csv("~/Documents/ehr_linkage/patient_data/lookup_babies.csv")
lookup_moms = read.csv("~/Documents/ehr_linkage/patient_data/lookup_moms.csv")

## Load packages
library(clink)

## Test functions on first baby
baby1 = lookup_babies[1, ]

# Key 1: Guarantor name
jaro_baby_parent_linkage(baby_to_match = baby1,
                         parents_to_match = lookup_moms,
                         key_baby = "guarantor_mother_name",
                         key_parent = "m_name",
                         jaro_col_name = "jaro_guarantor_mother_name")

# Key 2: Patient relation name (potentially multiple per baby)
# > baby1[paste0("relation_mother_name", 1:3)]
# relation_mother_name1 relation_mother_name2 relation_mother_name3
# 1   FARLOWVICTORIAPAIGE                  <NA>                  <NA>
jaro_baby_parent_linkage(baby_to_match = baby1,
                         parents_to_match = lookup_moms,
                         key_baby = "relation_mother_name1",
                         key_parent = "m_name",
                         jaro_col_name = "jaro_relation_mother_name1")
# jaro_baby_parent_linkage(baby_to_match = baby1,
#                          parents_to_match = lookup_moms,
#                          key_baby = "relation_mother_name2",
#                          key_parent = "m_name",
#                          jaro_col_name = "jaro_relation_mother_name2")
# jaro_baby_parent_linkage(baby_to_match = baby1,
#                          parents_to_match = lookup_moms,
#                          key_baby = "relation_mother_name3",
#                          key_parent = "m_name",
#                          jaro_col_name = "jaro_relation_mother_name3")

# Key 3: Address
jaro_baby_parent_linkage(baby_to_match = baby1,
                         parents_to_match = lookup_moms,
                         key_baby = "demo_address",
                         key_parent = "m_add",
                         jaro_col_name = "jaro_address")

# Key 5: MyChart email (potentially multiple per baby)
# > baby1[paste0("myc_prxy_email_", 1:3)]
# myc_prxy_email_1 myc_prxy_email_2 myc_prxy_email_3
# 1 plybonvictoria@gmail.com             <NA>             <NA>
jaro_baby_parent_linkage(baby_to_match = baby1,
                         parents_to_match = lookup_moms,
                         key_baby = "myc_prxy_email_1",
                         key_parent = "m_myc_email",
                         jaro_col_name = "jaro_myc_email")
# jaro_baby_parent_linkage(baby_to_match = baby1,
#                          parents_to_match = lookup_moms,
#                          key_baby = "myc_prxy_email_2",
#                          key_parent = "m_myc_email",
#                          jaro_col_name = "jaro_myc_email")
# jaro_baby_parent_linkage(baby_to_match = baby1,
#                          parents_to_match = lookup_moms,
#                          key_baby = "myc_prxy_email_3",
#                          key_parent = "m_myc_email",
#                          jaro_col_name = "jaro_myc_email")

# Key 6: MyChart address (potentially multiple per baby)
# > baby1[paste0("myc_prxy_address_", 1:3)]
# myc_prxy_address_1 myc_prxy_address_2
# 1 253LIVENGOODRDADVANCENORTHCAROLINA27006               <NA>
#   myc_prxy_address_3
# 1               <NA>
jaro_baby_parent_linkage(baby_to_match = baby1,
                         parents_to_match = lookup_moms,
                         key_baby = "myc_prxy_address_1",
                         key_parent = "m_add",
                         jaro_col_name = "jaro_myc_address_1")
# jaro_baby_parent_linkage(baby_to_match = baby1,
#                          parents_to_match = lookup_moms,
#                          key_baby = "myc_prxy_address_2",
#                          key_parent = "m_add",
#                          jaro_col_name = "jaro_myc_address_2")
# jaro_baby_parent_linkage(baby_to_match = baby1,
#                          parents_to_match = lookup_moms,
#                          key_baby = "myc_prxy_address_3",
#                          key_parent = "m_add",
#                          jaro_col_name = "jaro_myc_address_3")
