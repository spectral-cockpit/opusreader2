get_data_metadata <- function(ds_list){

  data_metadata <- ds_list[grep("data_param", names(ds_list))]

  test <- lapply(data_metadata, function(x) create_table(x))

  names(test) <- NULL

  full_frame <- do.call(rbind.data.frame, test)

  full_frame <- full_frame[,c(5,1:3)]
}



create_table <- function(param_list){

  names(param_list$parameters) <- NULL

  param_frame <- do.call(rbind.data.frame, param_list$parameters)

  param_frame$spectrum_type <- gsub("_data_param", "",param_list$block_type_name)

  return(param_frame)
}


get_metadata_dump <- function(ds_list){

  ds_list <- parsed_data[sapply(parsed_data, class) == "parameter"]

  non_data_metadata <- ds_list[!grepl("data_param", names(ds_list))]

  test <- lapply(non_data_metadata, function(x) create_table(x))

  names(test) <- NULL

  full_frame <- do.call(rbind.data.frame, test)

  full_frame <- full_frame[,c(5,1:3)]

  return(full_frame)
}



get_file_metadata <- function(meta_dump, history){

  needed_params <- c(
    "LWN", "ASS", "HUM", "RSN", "TSC", "INS",
    "AQM", "PLF", "RES", "SNM", "EXP", "XPP",
    "FE3", "FC2", "FE1", "ACC", "APT", "DTC",
    "SRC")

  history <- paste0(history, collapse = "")
  save_file_time <- gsub(".*Save File\t\t(\\d.*)\t\t\t.*", "\\1", history)
  opus_version <- gsub(".*Bruker\\\\(OPUS_.*)\\\\.*", "\\1", history)

  test <- meta_dump[meta_dump$parameter_name %in% needed_params & !grepl("_ref", meta_dump$spectrum_type),]

  test$parameter_col_name <- tolower(gsub(" |[[:punct:]]", "_", test$parameter_name_long))

  test$parameter_value <- ifelse(test$parameter_name == "SNM",sub(';.*$','', test$parameter_value, useBytes = TRUE), test$parameter_value)

  test_small <- as.data.frame(t(test[,c(4)]))

  names(test_small) <- test$parameter_col_name
}
