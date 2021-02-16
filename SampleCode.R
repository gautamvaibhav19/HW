library(tidyverse)
library(dplyr)
library(dslabs)
library(readxl)

# getwd()
# path <- system.file("extdata", package = "dslabs")
# list.files(path)
# filename <- "murders.csv"
# fullpath <- file.path(path, filename)
# fullpath
# file.copy(fullpath, getwd())
# file.exists(filename)
# 
# read_lines("murders.csv", n_max = 3)
# dat <- read.csv("murders.csv")
# head(dat)
# class(dat)
# dat2 <- read_csv("murders.csv")
# class(dat2)
# head(dat2)
# 
# read_lines("https://archive.ics.uci.edu/ml/machine-learning-databases/breast-cancer-wisconsin/wdbc.data", n_max = 3)
# ?read_csv
# dat3 <- read_csv("https://archive.ics.uci.edu/ml/machine-learning-databases/breast-cancer-wisconsin/wdbc.data", col_names = FALSE)
# nrow(dat3)
# ncol(dat3)
# 
# data("co2")
# co2
# 
# co2_wide <- data.frame(matrix(co2, ncol = 12, byrow = TRUE)) %>% 
#   setNames(1:12) %>%
#   mutate(year = as.character(1959:1997))
# 
# co2_tidy <- gather(co2_wide,month,co2,-year)
# co2_tidy %>% ggplot(aes(as.numeric(month), co2, color = year)) + geom_line()
# 
# data("admissions")
# head(admissions)

library(Lahman)
top <- Batting %>% filter(yearID==2016) %>% arrange(desc(HR)) %>% slice(1:10)
top %>% as_tibble()
Master %>% as_tibble()
top_names <- top %>% left_join(Master) %>% select(playerID,nameFirst,nameLast,HR)
top_names
data("Salaries")
str(Salaries)
top_salaries <- Salaries %>% filter(yearID==2016) %>% right_join(top_names) %>% 
  select(nameFirst, nameLast, teamID, HR, salary)
top_salaries
awards <- AwardsPlayers %>% filter(yearID == 2016) %>% as_tibble()
awards
inner_join(top_names,awards)
unique(awards$playerID)

library(rvest)
library(stringr)
url <- "https://en.wikipedia.org/w/index.php?title=Opinion_polling_for_the_United_Kingdom_European_Union_membership_referendum&oldid=896735054"
tab <- read_html(url) %>% html_nodes("table")
polls <- tab[[5]] %>% html_table(fill = TRUE)
head(polls)
nrow(polls)

library(lubridate)
data(brexit_polls)
str(brexit_polls)
releve <- brexit_polls %>% filter(enddate >= "2016-06-09" & enddate <= "2016-06-15")
nrow(releve)
?round_date()
x <- ymd("2016-06-15")
round_date(x, unit = "week")
sum(weekdays(brexit_polls$enddate) == "Sunday")

data("movielens")
head(movielens)
new_movie <- movielens %>% mutate(date_review = as_datetime(timestamp), year_review = year(date_review), hour_review = hour(date_review))
head(new_movie)
summ <- new_movie %>% group_by(hour_review) %>% summarise(n = n())
summ 

library(gutenbergr)
library(tidytext)
library(textdata)
options(digits = 3)
gutenberg_metadata
class(gutenberg_metadata)
data("gutenberg_metadata")
str(gutenberg_metadata)
P_and_P <- gutenberg_metadata %>% filter(str_detect(title, "Pride and Prejudice"))
P_and_P
gutenberg_works(title == "Pride and Prejudice")
book <- gutenberg_download(1342, mirror = "http://gutenberg.readingroo.ms/")
words <- book %>% unnest_tokens(word,text) %>% 
  filter(!word %in% stop_words$word & !str_detect(word, "\\d+")) %>% 
  count(word) %>%
  mutate(word = reorder(word, n)) %>%
  arrange(desc(n))
afinn <- get_sentiments("afinn")
afinn_sentiment <- inner_join(words, afinn)
