library(readr)
library(dplyr)
library(tidyr)
library(ggplot2)

read_csv <- function(path) {
  # Loads all .csv files present in path into a list
  csv_list <- list()
  files <- list.files(path)
  for (file in files) {
    if (grepl("\\.csv$", file)) {
      prefix <- sub("\\.csv$", "", file)
      csv_list[[prefix]] <- read_csv(file.path(path, file))
    }
  }
  return(csv_list)
}

read_csv_v2 <- function(path) {
  # Just like read_csv but removes padding
  csv_list <- list()
  files <- list.files(path)
  for (file in files) {
    if (grepl("\\.csv$", file)) {
      prefix <- sub("\\.csv$", "", file)
      csv_list[[as.numeric(prefix)]] <- read_csv(file.path(path, file))
    }
  }
  return(csv_list)
}

remove_padding <- function(tgt_string) {
  # Removes the padding from the file
  str_out <- as.numeric(tgt_string)
  return(str_out)
}

read_csv_v3 <- function(path) {
  # Removes padding using another function
  csv_list <- list()
  files <- list.files(path)
  for (file in files) {
    if (grepl("\\.csv$", file)) {
      prefix <- sub("\\.csv$", "", file)
      csv_list[[remove_padding(prefix)]] <- read_csv(file.path(path, file))
    }
  }
  return(csv_list)
}

read_csv_v4 <- function(path, id_list=NULL) {
  # Makes it possible to load only a subset of the data
  csv_list <- list()
  files_listed <- paste(sprintf("%03d", id_list), ".csv", sep="")
  files <- list.files(path)
  for (file in files) {
    if (grepl("\\.csv$", file)) {
      if (is.null(id_list) | file %in% files_listed) {
        prefix <- sub("\\.csv$", "", file)
        csv_list[[remove_padding(prefix)]] <- read_csv(file.path(path, file))
      }
    }
  }
  return(csv_list)
}

plot_monitoring_station <- function(df, id_vars=c("Date", "ID"), value_vars=c("sulfate", "nitrate")) {
  # Plots the monitoring station data
  data_plotted <- pivot_longer(df, cols=value_vars, names_to="variable", values_to="value")
  g <- ggplot(data_plotted, aes(x=Date, y=value, color=variable)) +
       geom_line() +
       facet_wrap(~ ID, ncol=2) +
       theme(legend.position="bottom")
  print(g)
}

get_monitor <- function(station_ids, dropna=TRUE, plot=TRUE) {
  # Returns the monitoring station data for a list of station IDs
  stations_data <- read_csv_v4("./specdata", station_ids)
  stations_data <- bind_rows(stations_data)
  if (dropna) {
    stations_data <- stations_data %>% drop_na()
  }
  if (plot) {
    plot_monitoring_station(stations_data)
  }
  return(stations_data)
}