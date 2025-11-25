get_basic_metadata <- function(ds_list) {
  timestamp <- get_meta_timestamp(ds_list)

  basic_metadata <- data.frame(
    # opus_filename,
    # opus_path,
    opus_sample_name = get_meta_sample_name(ds_list),
    timestamp_string = paste(timestamp$datetime, timestamp$timezone),
    local_datetime = timestamp$datetime,
    local_timezone = timestamp$timezone,
    utc_datetime_posixct = get_meta_utc_datetime(timestamp)
  )

  return(basic_metadata)
}

get_meta_timestamp <- function(ds_list) {
  text <- ds_list$history$text
  history <- paste(text, collapse = "")
  save_file_time <- gsub(
    ".*\t\t(\\d.*)\t\t\t.*",
    "\\1",
    history
  )

  time_hour_tz <- strsplit(x = save_file_time, split = " ")[[1L]]
  time_hour <- paste(time_hour_tz[1L], time_hour_tz[2L])
  tz <- gsub(pattern = "\\(|\\)|\\s+", "", x = time_hour_tz[3L])
  etc_tz <- paste0("Etc/", tz) # see ?strptime for details

  if (etc_tz == "Etc/GMT+10.5") {
    # avoid unknown timezone 'Etc/GMT+10.5'
    etc_tz <- "Australia/Adelaide"
  }

  # note that negative offsets denote UTC+x time stamps
  time <- as.POSIXct(strptime(
    time_hour,
    format = "%Y/%m/%d %H:%M:%S",
    tz = etc_tz
  ))

  list_datetime_tz <- list(
    datetime = as.character(sort(time)[1]),
    timezone = tz
  )

  return(list_datetime_tz)
}

get_meta_utc_datetime <- function(timestamp) {
  tz <- timestamp$timezone
  utc_diff <- as.integer(gsub("\\D+(\\+\\d)", "\\1", tz))
  utc_datetime <- as.POSIXct(strptime(
    timestamp$datetime,
    format = "%Y-%m-%d %H:%M:%S",
    tz = "UTC"
  )) -
    (utc_diff * 3600)

  return(utc_datetime)
}


get_meta_sample_name <- function(ds_list) {
  ds_parameter <- ds_list[
    vapply(ds_list, class, FUN.VALUE = character(1L)) == "parameter"
  ]

  sample <- ds_parameter$sample
  sample_name_long <- sample$parameters$SNM$parameter_value
  sample_name <- strsplit(sample_name_long, split = ";")[[1L]][1L]
  return(sample_name)
}
