get_timestamp <- function(ds_list) {
  text <- ds_list$history$text
  history <- paste0(text, collapse = "")
  save_file_time <- gsub(".*Save File\t\t(\\d.*)\t\t\t.*", "\\1", history)

  time_hour_tz <- strsplit(x = save_file_time, split = " ")[[1]]
  time_hour <- paste(time_hour_tz[1], time_hour_tz[2])
  tz <- gsub(pattern = "\\(|\\)", "", x = time_hour_tz[3])
  etc_tz <- paste0("Etc/", tz) # see ?strptime for details

  # note that negative offsets denote UTC+x time stamps
  time <- as.POSIXct(strptime(time_hour, format = "%Y/%m/%d %H:%M:%S",
                              tz = etc_tz))

  list_datetime_tz <- list(
    datetime = as.character(time),
    timezone = tz
  )

  return(list_datetime_tz)
}

get_sample_name <- function(ds_list) {
  ds_parameter <- ds_list[vapply(ds_list, class,
    FUN.VALUE = character(1)) == "parameter"]

  sample <- ds_parameter$sample
  sample_name_long <- sample$parameters$SNM$parameter_value
  sample_name <- strsplit(sample_name_long, split = ";")[[1]][1]
}
