library(targets)
source("1_fetch/src/get_nwis_data.R")
source("2_process/src/process_and_style.R")
source("3_visualize/src/plot_timeseries.R")

options(tidyverse.quiet = TRUE)
tar_option_set(packages = c("tidyverse", "dataRetrieval")) # Loading tidyverse because we need dplyr, ggplot2, readr, stringr, and purrr

p1_targets_list <- list(
  tar_target(
    site_1_data,
    download_nwis_site_data(site_num = "01427207", fileout = "1_fetch/out/nwis_01427207_data.csv"),
    format = "file"
  ),
  tar_target(
    site_2_data,
    download_nwis_site_data(site_num = "01432160", fileout = "1_fetch/out/nwis_01432160_data.csv"),
    format = "file"
  ),
  tar_target(
    site_3_data,
    download_nwis_site_data(site_num = "01436690", fileout = "1_fetch/out/nwis_01436690_data.csv"),
    format = "file"
  ),
  tar_target(
    site_4_data,
    download_nwis_site_data(site_num = "01466500", fileout = "1_fetch/out/nwis_01466500_data.csv"),
    format = "file"
  ),
  tar_target(
    site_data, 
    combine_csvs(c(site_1_data, site_2_data, site_3_data, site_4_data))
  ),
  tar_target(
    site_info_csv,
    nwis_site_info(fileout = "1_fetch/out/site_info.csv", site_data),
    format = "file"
  )
)

p2_targets_list <- list(
  tar_target(
    site_data_clean, 
    process_data(site_data)
  ),
  tar_target(
    site_data_annotated,
    annotate_data(site_data_clean, site_filename = site_info_csv)
  )
)

p3_targets_list <- list(
  tar_target(
    figure_1_png,
    plot_nwis_timeseries(fileout = "3_visualize/out/figure_1.png", site_data_annotated),
    format = "file"
  )
)

# Return the complete list of targets
c(p1_targets_list, p2_targets_list, p3_targets_list)
