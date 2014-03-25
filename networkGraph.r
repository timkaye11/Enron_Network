library(plyr)
matrix <- read.csv('matrix.csv')

nodes <- colnames(matrix)
a <- laply(nodes, toj)
b <- paste(a,  collapse="")

toj <- function(string) {
  str <- paste('{"name" :', ' "', string,'"}, ', sep="")
  return (str)
}

fileConn<-file("names.txt")
writeLines(b, fileConn)  # for the nodes array for the JSON graph
close(fileConn)

makeConns <- function(netSize) {
  json <- c()
  for (i in 1:netSize) {
    row <- matrix[i,]
    for (j in 2:(netSize+1)) {
      val <- matrix[i,j]
      if (val != 0) {
        str <- paste('{"source" :', (i-1), ',"target" : ', (j-2), ',"value" : ', val, '},')
        json <- c(json, str)
      }
    }
  }
  return (json)
}

a <- makeConns(25)
b <- paste(a, sep=",", collapse="")
fileConn<-file("links.txt")
writeLines(b, fileConn)  # for the nodes array for the JSON graph
close(fileConn)

