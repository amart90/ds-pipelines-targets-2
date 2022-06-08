# Download site data from USGS site file site
# Save output as CSV
download_nwis_site_data <- function(site_num, parameterCd = '00010', startDate="2014-05-01", endDate="2015-05-01"){

  # readNWISdata is from the dataRetrieval package
  data_out <- readNWISdata(sites=site_num, service="iv", 
                           parameterCd = parameterCd, startDate = startDate, endDate = endDate)

  # -- simulating a failure-prone web-service here, do not edit --
  set.seed(Sys.time())
  if (sample(c(T,F,F,F), 1)){
    stop(site_num, ' has failed due to connection timeout. Try tar_make() again')
  }
  # -- end of do-not-edit block
  
  return(data_out)

}

# Read download CSVs and bind them into a single data frame
#input_csv argument should be a list of nwis site data in dataframes (or similar)
combine_data <- function(input, fileout){
    bind_rows(input) %>%
    write_csv(file = fileout)
  return(fileout)
}

# Download site characteristic data
nwis_site_info <- function(fileout, site_data){
  site_data <- read_csv(site_data, show_col_types = FALSE)
  site_no <- unique(site_data$site_no)
  site_info <- dataRetrieval::readNWISsite(site_no)
  write_csv(site_info, fileout)
  return(fileout)
}