# Download site data from USGS site file site
# Save output as CSV
download_nwis_site_data <- function(site_num, fileout, parameterCd = '00010', startDate="2014-05-01", endDate="2015-05-01"){

  # readNWISdata is from the dataRetrieval package
  data_out <- readNWISdata(sites=site_num, service="iv", 
                           parameterCd = parameterCd, startDate = startDate, endDate = endDate)

  # -- simulating a failure-prone web-service here, do not edit --
  set.seed(Sys.time())
  if (sample(c(T,F,F,F), 1)){
    stop(site_num, ' has failed due to connection timeout. Try tar_make() again')
  }
  # -- end of do-not-edit block
  
  write_csv(data_out, file = fileout)
  return(fileout)

}

# Read download CSVs and bind them into a single data frame
#input_csv argument should be a vector of nwis data csv file paths
combine_csvs <- function(input_csvs){
  lapply(input_csvs, read_csv, show_col_types = FALSE) %>% 
    bind_rows()
}

# Download site characteristic data
nwis_site_info <- function(fileout, site_data){
  site_no <- unique(site_data$site_no)
  site_info <- dataRetrieval::readNWISsite(site_no)
  write_csv(site_info, fileout)
  return(fileout)
}