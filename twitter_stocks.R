library(twitteR)
library(ggplot2)
library(lubridate)
library(stringr)

# companies (keywords) to search for tweets for
companies <- c('seadrill','algeta','funcom','diagenic','subsea 7','bionor','netconnect')

# generate timestamp
timestamp <- sprintf('%04d%02d%02d',year(now()),month(now()),day(now()))

# fetch out_path from command line argument
args <- commandArgs(TRUE)
out_path <- args[1]
end_str <- str_length(out_path)
# ... and append '/' if out_path doesn't already end with one
if (substr(out_path,end_str,end_str)!='/') {
  out_path <- paste(out_path,'/',sep='')
}

# loop through companies and fetch tweets
for (c in companies) {
  tweets <- searchTwitter(c,n=3000)
  df <- twListToDF(tweets)
  write.table(df,file=paste(out_path,timestamp,"_",str_replace(c,' ','_'),".csv",sep=""),sep=";")
}

