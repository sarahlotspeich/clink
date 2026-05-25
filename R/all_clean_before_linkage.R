#' Clean data in preparation for linkage
#'
#' @param baby_to_match data.frame (with one row) for a single baby that includes at least \code{key_baby} as a column.
#' @param parents_to_match data.frame (with multiple rows) for all potential parent matches that includes at least \code{key_parent} as a column.
#' @param key_baby variable name(s) to match on from \code{baby_to_match}.
#' @param type_key_baby Character string. The variable type of \code{key_baby}, used to
#'    determine which cleaning function to apply. One of \code{"name"} or \code{"address"}. For other types, use \code{""}.
#' @param key_parent variable name(s) to match on from \code{parents_to_match}.
#' @param type_key_parent Character string. The variable type of \code{key_parent}, used to
#'    determine which cleaning function to apply. One of \code{"name"} or \code{"address"}. For other types, use \code{""}.
#' @return A list containing cleaned versions of \code{baby_to_match} and \code{parents_to_match}.
#' @export
#' @importFrom dplyr mutate na_if across all_of
all_clean_before_linkage = function(baby_to_match, parents_to_match, key_baby, type_key_baby, key_parent, type_key_parent) {
  ## Make sure "" match keys are treated as NA ...
  ### ... in baby data ...
  baby_to_match = baby_to_match |>
    mutate(across(all_of(key_baby), ~ na_if(.x, "")))
  ### ... in parent data ...
  parents_to_match = parents_to_match |>
    mutate(across(all_of(key_parent), ~ na_if(.x, "")))

  ## Clean name keys
  ### ... in baby data ...
  name_keys_baby = key_baby[type_key_baby == "name"]
  if (length(name_keys_baby) > 0) {
    baby_to_match = baby_to_match |>
      mutate(across(all_of(name_keys_baby), name_clean_before_linkage))
  }
  ### ... in parent data ...
  name_keys_parent = key_parent[type_key_parent == "name"]
  if (length(name_keys_parent) > 0) {
    parents_to_match = parents_to_match |>
      mutate(across(all_of(name_keys_parent), name_clean_before_linkage))
  }

  ## Clean address keys
  ### ... in baby data ...
  address_keys_baby = key_baby[type_key_baby == "address"]
  if (length(address_keys_baby) > 0) {
    baby_to_match = baby_to_match |>
      mutate(across(all_of(address_keys_baby), address_clean_before_linkage))
  }
  ### ... in parent data ...
  address_keys_parent = key_parent[type_key_parent == "address"]
  if (length(address_keys_parent) > 0) {
    parents_to_match = parents_to_match |>
      mutate(across(all_of(address_keys_parent), address_clean_before_linkage))
  }

  ## Return list with both cleaned datasets
  return(
    list(
      clean_baby_to_match = baby_to_match,
      clean_parents_to_match = parents_to_match
    )
  )
}
