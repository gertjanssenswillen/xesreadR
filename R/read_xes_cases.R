#' @title Case Attributes from Xes-file
#' @description Extracts case attributes from a xes-file.
#' @param xesfile Reference to a .xes file, conforming to the xes-standard.
#' @seealso \url{http://www.xes-standard.org/}
#' @export read_xes_cases

read_xes_cases <- function(xesfile = file.choose()) {


	EVENT_ID <- NULL
	n_attributes <- NULL
	attr_id <- NULL
	type <- NULL
	value <- NULL
	key <- NULL
	case_id <- NULL
	n_attr <- NULL
	CASE_ID <- NULL
	`concept:name` <- NULL
	CASE_CASE_ID <- NULL
	org_resource <- NULL
	time_timestamp <- NULL
	lifecycle_transition <- NULL
	concept_instance <- NULL


	xml2::read_xml(xesfile) %>%
		xml_children() %>%
		.[xml_name(.) == "trace"] %>%
		map(xml_children) -> t


	t %>%
		map(~.x[xml_name(.x) != "event"]) -> all_cases


	n_attributes_per_case = lengths(all_cases)

	data_frame(CASE_ID = 1:length(all_cases),
			   n_attr = n_attributes_per_case) %>%
		mutate(attr_id = map(n_attr,  ~data.frame(attr_id = seq_len(.x)))) %>%
		unnest(attr_id) -> cases

	if(nrow(cases) > 0) {
		all_cases %>%
			map(xml_attrs) %>%
			unlist() %>%
			as_data_frame() %>%
			mutate(type = rep(c("key","value"), length = nrow(.)),
				   attr_id = rep(1:(nrow(.)/2),each = 2)) %>%
			spread(type, value) %>%
			select(-attr_id) %>%
			bind_cols(cases) %>%
			select(-n_attr, -attr_id) %>%
			spread(key, value) -> cases

		cases <- cases %>% select(CASE_ID, concept_name = `concept:name`, everything()) %>%
			set_names(paste0("CASE_",names(.))) %>%
			rename(CASE_ID = CASE_CASE_ID)

	} else {
		stop("xes-file does not contain case attributes")
	}

	cases %>%
		select(-CASE_ID) -> cases

	return(cases)


}
