
rm(kappa.post)
rm(lambda.post)

library("ggplot2")
library("bbmle")
tmp <- readRDS("output/prior_for_third.RDS")



norm.fit <- function(mu, sigma) {
  -sum(dnorm(x, mu, sigma, log=T))
}





x <- tmp$kappa
mle.results.kappa <- mle2(norm.fit, start=list(mu=1, sigma=1), data=list(x))  

summary(mle.results.kappa)
  
  
kappa.density <- density(tmp$kappa) 

x <- seq(0, 2*1.470363e-08, by=0.0000000001)

normal <- density(rnorm(n = 10000000, mean =mle.results.kappa@coef[1], sd = mle.results.kappa@coef[2]))

df <- data.frame(normal$x, normal$y, kappa.density$x, kappa.density$y )

plot.kappa <- ggplot(df)+geom_line(aes(x=normal$x, y=normal$y), color="red") + geom_line(aes(x=kappa.density$x, y=kappa.density$y))
plot.kappa






x <- tmp$lambda
mle.results.lambda <- mle2(norm.fit, start=list(mu=mean(x), sigma=sd(x)), data=list(x), method="SANN")  

summary(mle.results.lambda)

lambda.density <- density(tmp$lambda) 
plot(lambda.density)

normal <- density(rnorm(n = 10000000, mean =mle.results.lambda@coef[1], sd = mle.results.lambda@coef[2]))

df <- data.frame(normal$x, normal$y, lambda.density$x, lambda.density$y )

plot.lambda <- ggplot(df)+geom_line(aes(x=normal$x, y=normal$y), color="red") + geom_line(aes(x=lambda.density$x, y=lambda.density$y))
plot.lambda

