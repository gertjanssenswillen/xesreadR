#' @title Write XES file
#' @description Function for writing xes-file
#' @param eventlog An event log object
#' @param case_attributes List of columns containing case_attributes
#' @param file Destination file
#'
#' @export write_xes

write_xes <- function(eventlog,
					  file = file.choose(),
					  case_attributes = NULL) {
	e <- eventlog
	eventlog <- eventlog %>% arrange(!!as.symbol(timestamp(eventlog)))


	if(is.null(case_attributes)){
		if(any(str_detect(colnames(eventlog), "CASE"))) {
			case_attributes <- eventlog %>%
				select(starts_with("CASE_")) %>%
				unique

			sel <- setdiff(colnames(eventlog), colnames(case_attributes))
			eventlog %>% select(one_of(c(case_id(e), sel))) -> eventlog
		} else {
			colnames(eventlog)[colnames(eventlog) == case_id(e)] <- "case_classifier"
			case_attributes <- data.frame(as.character(unique(eventlog$case_classifier)))
			colnames(case_attributes)[1] <- case_id(e)
		}

	}

	colnames(eventlog)[colnames(eventlog) == case_id(e)] <- "case_classifier"
	eventlog %>%
		as.data.frame() %>%
		mutate_if(is.numeric, as.character) %>%
		rename_("lifecycle:transition" = lifecycle_id(e),
				"org:resource" = resource_id(e),
				"concept:name" = activity_id(e),
				"time:timestamp" = timestamp(e),
				"concept:instance" = activity_instance_id(e)) %>%
		select(case_classifier, everything()) -> eventlog

	createXES(file, traces = case_attributes , events = as.data.frame(eventlog), case_classifier = case_id(e))

}
