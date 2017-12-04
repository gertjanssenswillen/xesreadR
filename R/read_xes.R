#' @title read_xes
#' @description Extracts eventlog from a xes-file.
#' @param xesfile Reference to a .xes file, conforming to the xes-standard.
#' @seealso \url{http://www.xes-standard.org/}
#' @export read_xes

read_xes <- function(xesfile = file.choose()){


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
		map(~.x[xml_name(.x) == "event"]) %>%
		map(map, xml_children) -> all_events


	t %>%
		map(~.x[xml_name(.x) != "event"]) -> all_cases

	all_events %>%
		map(map, xml_attrs) -> all_attrs

	n_attributes_per_event = map(all_attrs, lengths)

	data_frame(CASE_ID = 1:length(all_events)) %>%
		mutate(EVENT_ID = map2(lengths(all_events), n_attributes_per_event, ~data.frame(EVENT_ID = 1:.x,
																						n_attributes = .y))) %>%
		unnest(EVENT_ID) %>%
		mutate(attr_id = map(n_attributes, ~data.frame(attr_id = 1:.x))) %>%
		unnest(attr_id) -> eventlog

	all_attrs %>%
		unlist() %>%
		as_data_frame() %>%
		mutate(type = rep(c("key","value"), length = nrow(.)),
			   attr_id = rep(1:(nrow(.)/2),each = 2)) %>%
		spread(type, value) %>%
		select(-attr_id) %>%
		bind_cols(eventlog) %>%
		select(-n_attributes, -attr_id) %>%
		spread(key, value) -> eventlog



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


		case_classifier <- "CASE_concept_name"
		eventlog %>%
			inner_join(cases, ., by = "CASE_ID") -> eventlog

	} else {
		case_classifier <- "CASE_ID"
	}


	if(!("concept:name" %in% names(eventlog))) {
		stop("XES-file does not contain event")
	}


	eventlog %>%
		rename(activity_id =  `concept:name`) %>%
		set_names(str_replace_all(names(.),":", "_")) %>%
		select(-EVENT_ID) -> eventlog

	if(nrow(cases) > 0) {
		eventlog %>%
			select(-CASE_ID) -> eventlog
	}

	if("org_resource" %in% names(eventlog)) {
		eventlog %>%
			rename(resource_id = org_resource) -> eventlog
	} else {
		warning("No resource_id specified in xes-file")
		eventlog %>%
			mutate(resource_id = NA) -> eventlog
	}
	if("time_timestamp" %in% names(eventlog)) {
		eventlog %>%
			rename(timestamp = time_timestamp) %>%
			mutate(timestamp = ymd_hms(timestamp)) -> eventlog
	} else {
		stop("XES-file does not contain timestamp")
	}
	if("lifecycle_transition" %in% names(eventlog)) {
		eventlog %>%
			rename(lifecycle_id = lifecycle_transition) -> eventlog
	} else {
		warning("No lifecycle transition id specified in xes-file")
		eventlog %>%
			mutate(lifecycle_id = NA) -> eventlog
	}
	if("concept_instance" %in% names(eventlog)) {
		eventlog %>%
			rename(activity_instance_id = concept_instance) -> eventlog
	} else {
		warning("No activity instance identifier specified in xes-file. By default considered each event as a different activity instance. Please check!")
		eventlog %>%
			mutate(activity_instance_id = 1:nrow(.)) -> eventlog
	}

	eventlog %>%
		eventlog(case_id = case_classifier,
				 activity_id = "activity_id",
				 activity_instance_id = "activity_instance_id",
				 timestamp = "timestamp",
				 lifecycle_id = "lifecycle_id",
				 resource_id = "resource_id") -> eventlog


	return(eventlog)

}
