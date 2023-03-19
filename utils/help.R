read_csv <- function(path) {
  csv_dict <- list()
  files <- list.files(path)
  
  for (file in files) {
    name_parts <- strsplit(file, "\\.")[[1]]
    prefix <- name_parts[1]
    suffix <- name_parts[2]
    
    if (suffix == "csv") {
      csv_dict[prefix] <- read.csv(file.path(path, file))
    }
  }
  
  return(csv_dict)
}

read_csv_v2 <- function(path) {
  csv_dict <- list()
  files <- list.files(path)
  
  for (file in files) {
    name_parts <- strsplit(file, "\\.")[[1]]
    prefix <- name_parts[1]
    suffix <- name_parts[2]
    
    if (suffix == "csv") {
      csv_dict[as.character(as.integer(prefix))] <- read.csv(file.path(path, file))
    }
  }
  
  return(csv_dict)
}

read_csv_v3 <- function(path) {
  csv_dict <- list()
  files <- list.files(path)
  
  for (file in files) {
    name_parts <- strsplit(file, "\\.")[[1]]
    prefix <- name_parts[1]
    suffix <- name_parts[2]
    
    if (suffix == "csv") {
      csv_dict[remove_padding(prefix)] <- read.csv(file.path(path, file))
    }
  }
  
  return(csv_dict)
}

read_csv_v4 <- function(path, file_subset=NULL) {
  csv_dict <- list()
  files <- list.files(path)
  
  for (file in files) {
    name_parts <- strsplit(file, "\\.")[[1]]
    prefix <- name_parts[1]
    suffix <- name_parts[2]
    
    if (suffix == "csv") {
      if (is.null(file_subset) || file %in% file_subset) {
        csv_dict[remove_padding(prefix)] <- read.csv(file.path(path, file))
      }
    }
  }
  
  return(csv_dict)
}

test_read_csv <- function(path) {
  dict_full <- read_csv(path)
  assertthat::assert_that(length(dict_full) == length(list.files(path, pattern = "\\.csv$")))
  print(paste0("Tests passed for the test_read_csv(", path, ")"))
}

remove_padding <- function(tgt_string) {
  str_out <- as.character(as.integer(tgt_string))
  return(str_out)
}

test_remove_padding <- function(test_cases=c('0125', '1250')) {
  assertthat::assert_that(remove_padding(test_cases[1]) == '125')
  print(paste0("remove_padding(", test_cases[1], ") -> ", remove_padding(test_cases[1]), " Test OK"))
  assertthat::assert_that(remove_padding(test_cases[2]) == '1250')
  print(paste0("remove_padding(", test_cases[2], ") -> ", remove_padding(test_cases[2]), " Test OK"))
}

get_minmax_date <- function(df) {
  df$Date <- as.Date(df$Date)
  min_d <- min(df$Date)
  max_d <- max(df$Date)
  
  df_out <- data.frame(id = df$ID[1],
                       min_d = min_d,
                       max_d = max_d,
                       days_diff = as.integer(max_d - min_d))
  return(df_out)
}

# concat_date_ranges <- function(dfs_all, subset=NULL) {
#   date_ranges <- list()
#   
#   for (k in names(dfs_all)) {
#     if (is.null(subset) || k %in% subset) {
#       date_ranges[[k]] <- get_minmax