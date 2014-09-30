# load libraries
require(sna)

# load CM (only needed for first run)
# CM=read.table("sparsematrix.csv", header=T, row.names=1, sep=",")

centralstandard <- sortedcentrality(CM)              # generate a sorted centarlity vector
# write.csv(centralstandard, file="centralstandard") # write sorted vector as a .csv

sortedcentrality <- function(CM){
  # inputs: CM, a square matrix whose i,j element is the number of emails sent
  #             from sender i to recipient j
  # output: a sorted version of the central eigenvector
  # remark: too many zero entries can result in NaN values. 
  
  central <- data.frame(evcent(CM))                  # stores centrality vector
  rownames(central) <- rownames(CM)                  # names each row with email addresses
  colnames(central) <- "col1"                        # names the only column to "col1"
  indexorder <- order(central$col1, decreasing=TRUE) 
  sortedcentral <- data.frame(central[indexorder,1])
  rownames(sortedcentral) <- rownames(CM)[indexorder]
  colnames(sortedcentral) <- "relative rank"
  return(sortedcentral)  
}
