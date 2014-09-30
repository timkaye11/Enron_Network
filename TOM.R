require(WGCNA)

symScaledCM <- CM + t(CM)                           # makes symmetric
symScaledCM <- symScaledCM/max(symScaledCM)         # makes entries in [0,1]
symScaledCM <- matrix(unlist(symScaledCM),nrow=156) # convert from type "list" to matrix
rownames(symScaledCM) <- rownames(CM)               # assign names
colnames(symScaledCM) <- rownames(CM)               # assign names
              
TOM <- TOMsimilarity(symScaledCM)                   # make TOM
rownames(TOM) <- rownames(CM)                       # assign names
colnames(TOM) <- rownames(CM)                       # assign names
              
TOMcent <- sortedcentrality(TOM)                    # centrality

