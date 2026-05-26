#' Combined deterministic + probabilistic parent-child linkage based on Jaro similarity using a single matching key
#'
#' @param baby_to_match data.frame (with one row) for a single baby that includes at least \code{key_baby} as a column.
#' @param parents_to_match data.frame (with multiple rows) for all potential parent matches that includes at least \code{key_parent} as a column.
#' @param key_baby string variable name to match on from \code{baby_to_match}.
#' @param key_parent string variable name to match on from \code{parents_to_match}.
#' @param jaro_col_name if needed, string variable name for the added column of the Jaro similarity. Default is \code{jaro_col_name = "jaro_similarity"}.
#' @param skip_probabilistic optional, logical argument for whether only deterministic linkage should be tried. Default is \code{skip_probabilistic = FALSE}.
#' @return A list containing
#' \describe{
#'     \item{\code{match}}{A copy of \code{baby_to_match} with added columns for
#'       the best-matching parent.}
#'     \item{\code{type}}{A string indicator of the type of linkage used:
#'       \code{"deterministic"} or \code{"probabilistic"}.}
#'   }
#' @export
combined_baby_parent_linkage = function(baby_to_match, parents_to_match, key_baby, key_parent, jaro_col_name = "jaro_similarity", skip_probabilistic = FALSE) {
  ## Indicator for which type of linkage was done
  type = "deterministic"
  ## Check for the baby key to be missing
  if (all(is.na(baby_to_match[key_baby]))) {
    ## Return
    return(
      list(
        match = NULL,
        type = "baby key missing"
      )
    )
  }
  ## Start by trying deterministic linkage
  links = deterministic_baby_parent_linkage(
    baby_to_match = baby_to_match,
    parents_to_match = parents_to_match,
    key_baby = key_baby,
    key_parent = key_parent
  )
  ## If it fails, find the best probabilistic linkage
  if (nrow(links) == 0 & !skip_probabilistic) {
    links = jaro_baby_parent_linkage(
      baby_to_match = baby_to_match,
      parents_to_match = parents_to_match,
      key_baby = key_baby,
      key_parent = key_parent,
      jaro_col_name = jaro_col_name
    )
    type = "probabilistic"
  } else if (nrow(links) == 0 & skip_probabilistic) {
    type = 'deterministic'
  }
  ## Return
  return(
    list(
      match = links,
      type = type
    )
  )
}
