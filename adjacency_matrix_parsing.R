#@author David Khatami
#PUBLIC RELEASE VERSION
#@last_edit 4/8/14
#NONZERO MATRICES ARE 41-78
###This code parses through the enron corpus and generates month-binned adjacency matrices for the 150 persons of interest. The code takes in ff-dataframe formatted data for memory-efficient parsing. The ff dataframes were created in the supporting file sampleset.R###
library(sqldf)
library(ff)
library(ffbase)
library(chron)
library(stringr)
library(ggplot2)
library(grid)

###remove artefacts in directory listings###
dir <- dir[-29]
dir <- dir[-124]
dir <- dir[5:163]



#retrieve the ff dataframes that were created in sampleset.R
for(i in 1:length(dir)){
	print(i)
	load.ffdf(paste("/Users/dkhatami/MATH119/metanautixenron/",dir[i],sep=""))
	assign(paste("bigdf",i,sep=""),bigdf)
}


inbox <- bigdf1 #bigdf1,bigdf2,...,bigdf150

#timestamps of each email
dates <- as.character((bigdf1["Date"])[,1])

#convert into standardised format for easier parsing
convdates <- as.character(strptime(dates,"%a, %d %b %Y %H:%M:%S %z"))


yyyymmdd <- substring(convdates,1,10)
hhmmss <- substring(convdates,first=12)
dayofweek <- substring(dates,1,3)

formtime <- chron(yyyymmdd,hhmmss,format=c("y-m-d","h:m:s"))


#load in the aliases of each person whose inbox was subpoenaed
aliases <- read.table("aliases.csv",header=FALSE,sep=",",skip=1,colClasses=c(rep("character",7)))

names <- aliases[,2]


aliases <- aliases[,-1:-2]


pataliases <- aliases[,1]

pataliases <- substring(pataliases,first=1,last=regexpr("@",pataliases)-1)

#-------------START ACTUAL RUNNING CODE-----------------

yrcount <- matrix(0,nrow=10,ncol=1)
mthcount <- matrix(0,nrow=12,ncol=1)
daycount <- matrix(0,nrow=31,ncol=1)
dowcount <- matrix(0,nrow=7,ncol=1)

rownames(yrcount) <- t(as.character(1996:2005))
rownames(mthcount) <- t(c("Jan","Feb","Mar","Apr","May","Jun","Jul","Aug","Sep","Oct","Nov","Dec"))
rownames(daycount) <- t(as.character(1:31))

yrs <- 1996:2004
mths <- 1:12
days <- 1:31

rownames(dowcount) <- t(c("Mon","Tue","Wed","Thu","Fri","Sat","Sun"))

MATS <- list()
initptm <- round(proc.time()[3],4)
for(i in 1:97){
	MATS[[i]] <- matrix(0,nrow=156,ncol=156)
}

CCMATS <- list()
for(i in 1:97){
	CCMATS[[i]] <- matrix(0,nrow=156,ncol=156)
}
datlist <-seq.dates(from="01/01/96",to="01/01/04",by="months")
datemap <- data.frame(as.integer(months(datlist)),as.integer(years(datlist))+1995,1:97)

#parse through all inboxes
for(i in 1:150){
	ptm <- round(proc.time()[3],4)
	print(paste("now loading df",i,sep=""))
	
	bigdftmp <- get(paste("bigdf",i,sep=""))
	
	datelist <- as.character(bigdftmp["Date"][,1])
	convdates <- as.character(strptime(datelist,"%a, %d %b %Y %H:%M:%S %z"))

	yyyymmdd <- substring(convdates,1,10)
	hhmmss <- substring(convdates,first=12)
	dayofweek <- substring(dates,1,3)

	formtime <- chron(yyyymmdd,hhmmss,format=c("y-m-d","h:m:s"))
	
	fromlist <- as.character(bigdftmp[,"From"])
	tolist <- as.character(bigdftmp[,"To"])
	
	ccnames <- as.character(bigdftmp[,"Cc"])
	
	monthlist <- as.integer(months(formtime))
	yearlist <- as.integer(years(formtime))
	
	for(j in 1:length(bigdftmp[,1])){
		currdat <- formtime[j]
		currmonth <- as.integer(months(currdat))
		curryear <- as.integer(as.character((years(currdat))))
		
		fromcand <- fromlist[j]		
		tocand <- tolist[j]
		
		if(nchar(fromcand)==0 || nchar(tocand)==0){
			next()
		}

			
		 #if person of interest is in the recipient list and is in the time range of interest
		 if(any(grepl(fromcand,aliases)) && any(grepl(tocand,aliases)) && curryear > 1995)
		 {

			
			
			matindex <- which(datemap[,1]==currmonth & datemap[,2]==curryear)
			
			
			
			fromname <- which(aliases[,grep(fromcand,aliases)]==fromcand)
			toname <- which(aliases[,grep(tocand,aliases)]==tocand)
			
			
			MATS[[matindex]][fromname,toname] <- MATS[[matindex]][fromname,toname] + 1
			#print("found and added")
			#MATS[[matindex]][f_index,i_index] <- MATS[[matindex]][f_index,i_index] + 1
		}
		
		
		ccarr <- strsplit(ccnames[j],",")[[1]]
		cclength <- length(ccarr)
		if(cclength == 0){
			next()
		}
		
		
		if(cclength != 0 && curryear > 1995) {
			if(any(grepl(fromcand,aliases))){
			for(k in 1:length(ccarr)){
				cccand <- ccarr[k]
				if(any(grepl(cccand,aliases))){
					cfromname <- which(aliases[,grep(fromcand,aliases)]==fromcand)
					ccname <- which(aliases[,grep(cccand,aliases)]==cccand)
					
					matindexx <- which(datemap[,1]==currmonth & datemap[,2]==curryear)
					
					CCMATS[[matindexx]][cfromname,ccname] <- CCMATS[[matindexx]][cfromname,ccname] + 1/sqrt(1+cclength)
				}
			}
			}
		
	}
	}
	
	print(paste("df t:",round(proc.time()[3]-ptm),"sec.",sep=" "))
}
print(paste("total runtime:",round(proc.time()[3]-initptm),"sec.",sep=" "))

#write out the parsed adjacency matrices, which are time-binned
for(i in 1:97){
	write.table(CCMATS[[i]],file=paste("ccmat",i,".csv",sep=""),row.names=FALSE,col.names=FALSE)
}



