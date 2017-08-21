#' @title eventlog_from_xes
#' @description Extracts eventlog from a xes-file.
#' @param xesfile Reference to a .xes file, conforming to the xes-standard.
#' @seealso \url{http://www.xes-standard.org/}
#' @export eventlog_from_xes

eventlog_from_xes <- function(xesfile = file.choose()){
	warning("Function deprecated. Please use read_xes")

	return(read_xes(xesfile))
}
