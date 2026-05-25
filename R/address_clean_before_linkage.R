#' Clean and standardize an address string for matching
#'
#' @param address_text A character vector of address(es) to clean.
#'
#' @return A character vector of the same length as \code{address_text} with
#'   all letters uppercased, spaces removed, ZIP+4 suffixes removed, punctuation
#'   removed, and street type words abbreviated.
#'
#' @details
#'   The following transformations are applied in order:
#'   \enumerate{
#'     \item Convert to uppercase via \code{toupper()}
#'     \item Remove all spaces
#'     \item Remove the extra 4-digit ZIP suffix (e.g. \code{-1234} in \code{12345-1234})
#'     \item Remove all punctuation
#'     \item Abbreviate common street types using the lookup vector
#'       \code{street_abbrev} (e.g. \code{ROAD} -> \code{RD}, \code{STREET} -> \code{ST})
#'   }
#'
#' @examples
#' clean_address("123 Main Street, 27514-1234")  # Returns "123MAINST27514"
#' clean_address("456 Old Highway Rd")           # Returns "456OLDHWYARD"
#'
#' @importFrom stringr str_replace_all str_remove str_remove_all
#' @export
address_clean_before_linkage = function(address_text) {
  ## Define street type abbreviations
  street_abbrev = c(
    "ROAD"    = "RD",
    "STREET"  = "ST",
    "AVENUE"  = "AVE",
    "BOULEVARD" = "BLVD",
    "DRIVE"   = "DR",
    "LANE"    = "LN",
    "COURT"   = "CT",
    "PARKWAY" = "PKWY",
    "HIGHWAY" = "HWY"
  )
  
  ## Make all caps...
  address_text = toupper(address_text)
  ## Remove all spaces
  address_text = str_replace_all(string = address_text,
                                 pattern = " ",
                                 repl = "")
  ## Remove extra 4 digits of ZIP
  address_text = str_remove(string = address_text, 
                            pattern = "-\\d{4}$")
  ## Remove punctuation
  address_text = str_remove_all(string = address_text, 
                                pattern = "[[:punct:]]")
  ## Abbreviate street type
  address_text = str_replace_all(string = address_text, 
                                 pattern = street_abbrev)
  ## Return cleaned address
  return(address_text)
}