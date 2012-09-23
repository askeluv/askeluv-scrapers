library(twitteR)
library(ggplot2)

#companies <- c('seadrill','algeta','funcom','diagenic','subsea 7','bionor')
companies <- c('netconnect')

for (c in companies) {
  tweets <- searchTwitter(c,n=3000)
  df <- twListToDF(tweets)
  write.table(df,file=paste(c,"20120806.csv",sep=""),sep=";")
}

#pos.words <- scan('positive_words.txt',what='character',comment.char=';')
#neg.words <- scan('negative_words.txt',what='character',comment.char=';')

score.sentiment <- function(sentences,pos.words,neg.words,.progress='none')
    {	require(plyr)	
			require(stringr)		
      #wegotavectorofsentences.plyrwillhandlealistoravectorasan"l"forus	
      #wewantasimplearrayofscoresback,soweuse"l"+"a"+"ply"=laply:	
      scores=laply(sentences,function(sentence,pos.words,neg.words){				
      #cleanupsentenceswithR'sregex-drivenglobalsubstitute,gsub():		
      sentence=gsub('[[:punct:]]','',sentence)		
      sentence=gsub('[[:cntrl:]]','',sentence)		
      sentence=gsub('\\d+','',sentence)		
      #andconverttolowercase:		
      sentence=tolower(sentence)		
      #splitintowords.str_splitisinthestringrpackage		
      word.list=str_split(sentence,'\\s+')		
      #sometimesalist()isonelevelofhierarchytoomuch		
      words=unlist(word.list)		
      #compareourwordstothedictionariesofpositive&negativeterms		
      pos.matches=match(words,pos.words)		
      neg.matches=match(words,neg.words)			
      #match()returnsthepositionofthematchedtermorNA		
      #wejustwantaTRUE/FALSE:		
      pos.matches=!is.na(pos.matches)		
      neg.matches=!is.na(neg.matches)		
      #andconvenientlyenough,TRUE/FALSEwillbetreatedas1/0bysum():		
      score=sum(pos.matches)-sum(neg.matches)		
      return(score)	
      },pos.words,neg.words,
      .progress=.progress)	
      scores.df=data.frame(score=scores,text=sentences)	
      return(scores.df)
}

#s <- score.sentiment(df$text,pos.words,neg.words)
#qplot(s$score)