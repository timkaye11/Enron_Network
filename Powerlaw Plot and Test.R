# assumes data is imported as 'dat'

require(MASS)                                                  # used for fitdistr()

nRec <- apply(dat, 2, sum)                                     # calculate number messages received
lambda <- fitdistr(nRec, 'exponential')$estimate               # find best exp parameter

hist(nRec, prob=T, col='grey', breaks=20,                      # plot data       
     ylab="Probability",
     xlab="Number of Messages Received", 
     main="Email Volume Distribution")
curve(dexp(x, rate = lambda), col = "red", add = TRUE)         # add on best exp

p.val <- ks.test(jitter(nRec), "pexp", lambda)$p.value         # p-value to determine
                                                               # goodness-of-fit for powerlaw


