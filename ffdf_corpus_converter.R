#This file converts the enron corpus in a memory-efficient data format using the ff package inR
#Author: David Khatami
#last changes: 3/11/14
library(sqldf)
library(ff)
library(ffbase)


filelist <- file.info(list.files("./metanautixenron/"),include.dirs=TRUE)
filelist["size"] <- filelist["size"]/1E6

emplist <- read.csv("employee-status-2.csv")

filenames <- rownames(filelist)

corrmatrix <- matrix(0,nrow=length(emplist[,"Email"]),ncol=length(emplist[,"Email"]))
colnames(corrmatrix) <- as.character(emplist[,"Email"])
rownames(corrmatrix) <- colnames(corrmatrix)

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
		nummatch <- 1 + nummatch
		
		corrmatrix[as.character(bigdftmp[i,"From"]),as.character(bigdftmp[i,"To"])] <- 1 + corrmatrix[as.character(bigdftmp[i,"From"]),as.character(bigdftmp[i,"To"])]
	}
	
}
	print(paste("num match:",nummatch))
	totmatch <- totmatch + nummatch
}

print(paste("total match:",totmatch))
