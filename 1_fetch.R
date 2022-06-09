source("1_fetch/src/get_nwis_data.R")

p1_targets_list <- list(
  tar_target(
    p1_site_1_data,
    download_nwis_site_data(site_num = "01427207")
  ),
  tar_target(
    p1_site_2_data,
    download_nwis_site_data(site_num = "01432160")
  ),
  tar_target(
    p1_site_3_data,
    download_nwis_site_data(site_num = "01436690")
  ),
  tar_target(
    p1_site_4_data,
    download_nwis_site_data(site_num = "01466500")
  ),
  tar_target(
    p1_site_data_csv, 
    combine_data(input = list(p1_site_1_data, p1_site_2_data, p1_site_3_data, p1_site_4_data),
                 fileout = "1_fetch/out/site_data.csv"),
    format = "file"
  ),
  tar_target(
    p1_site_info_csv,
    nwis_site_info(fileout = "1_fetch/out/site_info.csv", site_data = p1_site_data_csv),
    format = "file"
  )
)