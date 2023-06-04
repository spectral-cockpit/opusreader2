get_basic_metadata <- function(ds_list) {
  timestamp <- get_meta_timestamp(ds_list)

  basic_metadata <- data.frame(
    # opus_filename,
    # opus_path,
    opus_sample_name = get_meta_sample_name(ds_list)
    timestamp_string = paste(timestamp$datetime, timestamp$timezone),
    local_datetime = timestamp$datetime,
    local_timezone = timestamp$timezone#,
    # utc_datetime_posixct = get_meta_utc_datetime(timestamp)
  )

  return(basic_metadata)
}

get_meta_timestamp <- function(ds_list) {
  text <- ds_list$history$text
  history <- paste0(text, collapse = "") 
  save_file_time <- gsub(".*Save File\t\t(\\d.*)\t\t\t.*", "\\1", history)

  time_hour_tz <- strsplit(x = save_file_time, split = " ")[[1L]]
  time_hour <- paste(time_hour_tz[1L], time_hour_tz[2L])
  tz <- gsub(pattern = "\\(|\\)", "", x = time_hour_tz[3L])
  etc_tz <- paste0("Etc/", tz) # see ?strptime for details

  # note that negative offsets denote UTC+x time stamps
  time <- as.POSIXct(strptime(time_hour,
    format = "%Y/%m/%d %H:%M:%S",
    tz = etc_tz
  ))

  list_datetime_tz <- list(
    datetime = as.character(time),
    timezone = tz
  )

  return(list_datetime_tz)
}

get_meta_utc_datetime <- function(timestamp) {
  tz <- timestamp$timezone
  # utc_diff <-
  # utc_datetime <-
  # return(utc_datetime)
}


get_meta_sample_name <- function(ds_list) {
  ds_parameter <- ds_list[vapply(ds_list, class,
    FUN.VALUE = character(1L)
  ) == "parameter"]

  sample <- ds_parameter$sample
  sample_name_long <- sample$parameters$SNM$parameter_value
  sample_name <- strsplit(sample_name_long, split = ";")[[1L]][1L]
  return(sample_name)
}
