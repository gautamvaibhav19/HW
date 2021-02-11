library(tidyverse)
library(dplyr)
library(dslabs)
library(readxl)

getwd()
path <- system.file("extdata", package = "dslabs")
list.files(path)
filename <- "murders.csv"
fullpath <- file.path(path, filename)
fullpath
file.copy(fullpath, getwd())
file.exists(filename)

read_lines("murders.csv", n_max = 3)
dat <- read.csv("murders.csv")
head(dat)
class(dat)
dat2 <- read_csv("murders.csv")
class(dat2)
head(dat2)

read_lines("https://archive.ics.uci.edu/ml/machine-learning-databases/breast-cancer-wisconsin/wdbc.data", n_max = 3)
?read_csv
dat3 <- read_csv("https://archive.ics.uci.edu/ml/machine-learning-databases/breast-cancer-wisconsin/wdbc.data", col_names = FALSE)
nrow(dat3)
ncol(dat3)

data("co2")
co2

co2_wide <- data.frame(matrix(co2, ncol = 12, byrow = TRUE)) %>% 
  setNames(1:12) %>%
  mutate(year = as.character(1959:1997))

co2_tidy <- gather(co2_wide,month,co2,-year)
co2_tidy %>% ggplot(aes(as.numeric(month), co2, color = year)) + geom_line()

data("admissions")
head(admissions)
