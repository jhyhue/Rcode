#### Modeling time dependence ####
# Example of model estimation with t, t², and t³
# Based on "Back to the Future: Modeling Time Dependence in Binary Data"
# Carter & Signorino (2010); https://pan.oxfordjournals.org/content/18/3/271
# Use data from article in DPE (2015)
## Load data
library(foreign)
dta<-read.dta("Publications/DPE_2015/tidy_data/dpe_2015.dta")
dta<-dta[order(dta$ccode,dta$year),]

## Variables
y<-dta$anyconflict  # Conflict incidence
x1<-dta$gpcp_d      # Rainfall anomaly at t
x2<-dta$gpcp_dl     # Rainfall anomaly at t-1
time<-dta$pt8       # Time since last conflict

# Create t^2 and t^3 variables
time2 <- time^2
time3 <- time^3

# Estimate logit with cubic polynomial
m<-glm(y~x1+x2+time+time2+time3,family=binomial(link="logit"))

# To calculate fitted values, create sequence of time values over entire range
timeseq<-0:max(time)

# Create X matrix by appending 1 for constant, means of x1 & x2,
# and then time sequence, squared, and cubed.
# Note: These need to be in the same order as estimated betas.
newX<-cbind(1,mean(x1),mean(x2),timeseq,timeseq^2,timeseq^3)

# Use newX and estimated betas for XB
Bhat<-m$coefficients
XBhat<-newX%*%Bhat

# Calculate logit fitted values
prob<-1/(1+exp(-XBhat))

# Plot estimated Pr(Y=1|t)
plot(timeseq,prob,type="b",xlab="t",ylab="Pr(Y=1|t)",lty=1,lwd=2,bty="n")
