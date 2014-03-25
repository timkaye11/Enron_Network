setwd("/Users/dkhatami/MATH119/metanautixenron/")
library(sqldf)
library(ff)
library(ffbase)

filelist <- file.info(list.files("/Users/dkhatami/MATH119/metanautixenron/"),include.dirs=TRUE)
filelist["size"] <- filelist["size"]/1E6

emplist <- read.csv("employee-status-2.csv")

filenames <- rownames(filelist)

corrmatrix <- matrix(0,nrow=length(emplist[,"Email"]),ncol=length(emplist[,"Email"]))
colnames(corrmatrix) <- as.character(emplist[,"Email"])
rownames(corrmatrix) <- colnames(corrmatrix)
#f <- file("allen-p.csv")

#system.time(bigdf <- sqldf("select * from f",dbname=tempfile(),file.format=list(header=T,row.names=F)))

#system.time(bigdf <- read.csv("lay-k.csv"))

#system.time(bigdf <- read.csv.ffdf(file="kean-s.csv",header=TRUE,colClasses=rep("factor",13)))

#for(i in 61:181){
#	print(paste("run",i,filenames[i]))
#	a <- system.time(bigdf <-#read.csv.ffdf(file=filenames[i],header=TRUE,colClasses=rep("factor",13)))	
#save.ffdf(bigdf,dir=paste("./",strsplit(filenames[i],"\\.")[[1]][1],sep=""))
#	print(a)
#	}
#sum(match(bigdf22[,"From"],"felicia.doan@enron.com",nomatch=0))
dir <- filenames[!grepl(".csv",filenames)&filenames!=TRUE]	

ffwhich(bigdf,grepl("California",bigdf["Subject"][,1])==TRUE)
for(i in 31:length(dir)){
	load.ffdf(paste("./",dir[i],sep=""))
	assign(paste("bigdf",i,sep=""),bigdf)
}

names <- emplist[,"Email"]
nummatch <- 0


corrmatrix <- matrix(0,nrow=length(emplist[,"Email"]),ncol=length(emplist[,"Email"]))
colnames(corrmatrix) <- as.character(emplist[,"Email"])
rownames(corrmatrix) <- colnames(corrmatrix)
totmatch <- 0
for(db in 31:length(dir)){
	nummatch <- 0
	print(paste("now loading df",db,sep=""))
	
	bigdftmp <- get(paste("bigdf",db,sep=""))
for(i in 1:length(bigdftmp[,1])){
	
	frm <- as.character(bigdftmp[i,"From"])
	to <- as.character(bigdftmp[i,"To"])
	if(frm%in%names && to%in%names){
		#print(paste("match found for",frm,to))
		nummatch <- 1 + nummatch
		
		corrmatrix[as.character(bigdftmp[i,"From"]),as.character(bigdftmp[i,"To"])] <- 1 + corrmatrix[as.character(bigdftmp[i,"From"]),as.character(bigdftmp[i,"To"])]
	}
	
}
	print(paste("num match:",nummatch))
	totmatch <- totmatch + nummatch
}

print(paste("total match:",totmatch))
