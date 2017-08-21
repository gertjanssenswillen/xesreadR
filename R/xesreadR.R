#' @title xesreadR - Read and write XES fles
#'
#' @description Functions for reading and writing XES-files. XES (eXtensible Event Stream) is the IEEE standard for storing and sharing event data (see <http://standards.ieee.org/findstds/standard/1849-2016.html> for more info)
#' @docType package
#' @name xesreadR
#'
#' @import XML
#' @import xml2
#' @importFrom data.table data.table
#' @importFrom data.table :=
#' @import bupaR
#' @import dplyr
#' @import tidyr
#' @importFrom purrr map
#' @importFrom purrr map2
#' @importFrom purrr set_names
#' @importFrom lubridate ymd_hms
#' @import stringr
#' @importFrom stats median
#' @importFrom stats na.omit
#' @importFrom stats quantile
#' @importFrom stats sd
#' @importFrom utils head
#' @importFrom utils setTxtProgressBar
#' @importFrom utils txtProgressBar
#' @importFrom utils data

globalVariables(c("case_concept.name","event_concept.name","event_time.timestamp",
				  ".","EVENT_ID","n_attributes","attr_id","type","value","key",
				  "n_attr","CASE_ID","concept:name","case_classifier","CASE_CASE_ID", "concept_instance","lifecycle_transition","org_resource", "time_timestamp"))

NULL
