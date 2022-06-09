library(targets)
source("1_fetch/src/get_nwis_data.R")
source("2_process/src/process_and_style.R")
source("3_visualize/src/plot_timeseries.R")

options(tidyverse.quiet = TRUE)
tar_option_set(packages = c("tidyverse", "dataRetrieval")) # Loading tidyverse because we need dplyr, ggplot2, readr, stringr, and purrr

p1_targets_list <- list(
  tar_target(
    site_1_data,
    download_nwis_site_data(site_num = "01427207")
  ),
  tar_target(
    site_2_data,
    download_nwis_site_data(site_num = "01432160")
  ),
  tar_target(
    site_3_data,
    download_nwis_site_data(site_num = "01436690")
  ),
  tar_target(
    site_4_data,
    download_nwis_site_data(site_num = "01466500")
  ),
  tar_target(
    site_data_csv, 
    combine_data(input = list(site_1_data, site_2_data, site_3_data, site_4_data),
                 fileout = "1_fetch/out/site_data.csv"),
    format = "file"
  ),
  tar_target(
    site_info_csv,
    nwis_site_info(fileout = "1_fetch/out/site_info.csv", site_data = site_data_csv),
    format = "file"
  )
)

p2_targets_list <- list(
  tar_target(
    site_data_processed, 
    process_data(filein = site_data_csv, site_filename = site_info_csv)
  )
)

p3_targets_list <- list(
  tar_target(
    figure_1_png,
    plot_nwis_timeseries(fileout = "3_visualize/out/figure_1.png", site_data_processed),
    format = "file"
  )
)

# Return the complete list of targets
c(p1_targets_list, p2_targets_list, p3_targets_list)
