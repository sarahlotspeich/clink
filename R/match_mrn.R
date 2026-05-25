# Function to return MRNs for matching moms based on key_baby = key_parent
## Arguments:
## from_baby_chart = dataset for babies to match
## key_baby = column in from_baby_chart to use for match
## from_parent_chart = dataset for moms to match
## key_parent = column in from_parent_chart to use for match
## mrn_parent = column in from_parent_chart to return as match identifier
match_mrn = function(from_baby_chart, key_baby, from_parent_chart, key_parent, mrn_parent) {
  vec = vector()
  if (length(key_baby) > 1) {
    for (k in 1:length(key_baby)) {
      if (is.null(nrow(from_baby_chart))) {
        vec = append(vec, 
                     from_parent_chart[which(from_parent_chart[, key_parent] == from_baby_chart[key_baby[k]]), mrn_parent])
      } else {
        vec = append(vec, 
                     from_parent_chart[which(from_parent_chart[, key_parent] == from_baby_chart[, key_baby[k]]), mrn_parent])
      }
    }
  } else {
    if (is.null(nrow(from_baby_chart))) {
      vec = append(vec, 
                   from_parent_chart[which(from_parent_chart[, key_parent] == from_baby_chart[key_baby]), mrn_parent])
    } else {
      vec = append(vec, 
                   from_parent_chart[which(from_parent_chart[, key_parent] == from_baby_chart[, key_baby]), mrn_parent])
    }
  }
  return(vec)
}
