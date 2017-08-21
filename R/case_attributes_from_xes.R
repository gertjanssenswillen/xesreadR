#' @title Case Attributes from Xes-file
#' @description Extracts case attributes from a xes-file.
#' @param xesfile Reference to a .xes file, conforming to the xes-standard.
#' @seealso \url{http://www.xes-standard.org/}
#' @export case_attributes_from_xes

case_attributes_from_xes <- function(xesfile = file.choose()) {
	warning("Function deprecated. Please use read_xes_cases")
	return(read_xes_cases(xesfile))


}
