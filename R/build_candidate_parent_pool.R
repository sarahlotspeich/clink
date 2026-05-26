#' Build pool of candidate parent matches based on multiple variables
#'
#' @param baby_to_match data.frame (with one row) for a single baby that includes at least \code{key_baby} as a column.
#' @param parents_to_match data.frame (with multiple rows) for all potential parent matches that includes at least \code{key_parent} as a column.
#' @param key_baby string variable name(s) to match on from \code{baby_to_match}.
#' @param key_parent string variable name(s) to match on from \code{parents_to_match}.
#' @param id_parent string variable name to identify observations in \code{parents_to_match}.
#' @param jaro_col_name string variable name(s) for the added column of the Jaro similarity corresponding to the keys.
#' @param deterministic_only optional, string variable name(s) in \code{key_baby} that should only undergo deterministic linkage.
#' @return A vector containing all unique \code{id_parent} values matching one or more keys.
#' @export
build_candidate_parent_pool = function(baby_to_match, parents_to_match, key_baby, key_parent, id_parent, jaro_col_name, deterministic_only = NULL) {
  # Initialize empty vector for matching parent IDs
  candidate_parent_ids = vector()
  # Loop through baby's non-missing keys
  for (k in which(!is.na(baby_to_match[1, key_baby]) & baby_to_match[1, key_baby] != "")) {
    if (key_baby[k] %in% deterministic_only) {
      ### Do combined (deterministic --> probabilistic linkage)
      ### Based on the kth baby/parent keys provided
      link_on_k = deterministic_baby_parent_linkage(
        baby_to_match = baby_to_match,
        parents_to_match = parents_to_match,
        key_baby = key_baby[k],
        key_parent = key_parent[k]
        )
      ## If successful, save ID(s)
      if (nrow(link_on_k) > 0) {
        candidate_parent_ids = append(candidate_parent_ids,
                                      link_on_k$match[, id_parent])
      }
    } else {
      ### Do combined (deterministic --> probabilistic linkage)
      ### Based on the kth baby/parent keys provided
      link_on_k = combined_baby_parent_linkage(
        baby_to_match = baby_to_match,
        parents_to_match = parents_to_match,
        key_baby = key_baby[k],
        key_parent = key_parent[k],
        jaro_col_name = jaro_col_name[k]
        )
      ## If successful, save ID(s)
      candidate_parent_ids = append(candidate_parent_ids,
                                    link_on_k$match[, id_parent])
    }
  }
  ## Return the vector
  return(unique(candidate_parent_ids))
}
