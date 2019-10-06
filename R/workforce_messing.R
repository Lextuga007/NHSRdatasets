
library(readxl)
library(dplyr)

cols<-read_excel(path="./data/workforce.xlsx",
               sheet = 1, n_max = 1, na = "", trim_ws = TRUE) %>%
  names()

# This is awkward.  Missing values between dates
# need to repeat it for next three columns.  We know they occure every 4, skipping the first one, so use
# a sequence to pull names at those location.  This is applied across the sequent.  It's in a custom function,
# this allows us to pass our sequence (x) to the 'cols' to act as an index, e.g. seq value = 2, function pulls cols[2]
red_cols<-sapply(seq(2,33,4), function(x){cols[x]})

cols <-c("Reason", rep(red_cols, each=4))


# Now crete column valuse, we know it's Q1-Q4 repeatedly
cols2<- rep(c("Q1", "Q2", "Q3", "Q4"), 8)


cnames <- paste0(cols, c("", cols2))

data <- read_excel(path="./data/workforce.xlsx", sheet=1,
                   skip=2, col_names = FALSE)


names(data) <- cnames



library(tidyr)
library(lubridate)
library(ggplot2)

piv <-
  pivot_longer(data, -Reason, "period") %>%
  mutate(yr = substring(period, 1,4))

piv %>%
  group_by(yr) %>%
  summarise(sum(value))


piv %>%
  ggplot(aes(x=Reason, col=Reason, y=value)) +
    geom_boxplot()+
    scale_x_discrete()+
    theme(#axis.text.x = element_blank,
          legend.position = "bottom")
