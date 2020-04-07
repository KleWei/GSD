##################################################################
# R Code // Content
#
# (0)   Install R packages, obtain citations
#
#######################################
# I. Simulate Group Sequential Designs
# (1) R package: gsDesign
#     (i)   Pocock
#     (ii)  O'Brien and Fleming
#     (iii) Wang and Tsiatis
# (2) R package: GroupSeq
#######################################
#
####################################################
# II. Estimate Sample Size for each Group and Stage
#     using the sample size inflation factor (IF)
# (3) R package: pwr
####################################################
#
##################################################################
# III. Transform t-value into a p value to obtain a test decision
##################################################################
#
# This R script and the corresponding data set applied in the article 
# 
# Weigl, K., & Ponocny, I. (2020). Group Sequential Designs Applied in
# Psychological Research. Methodology - European Journal of Research 
# Methods for the Behavioral and Social Sciences, 16(1), 75-91. 
# https://doi.org/10.5964/meth.2811
#
# are freely available at the GitHub repository:
# https://github.com/StatisticalPsychology/GSD 
#
# and on PsychArchives:
# [data] https://doi.org/10.23668/psycharchives.2784
# [code] https://doi.org/10.23668/psycharchives.2785
#
# Author of this R script: Klemens Weigl.
##################################################################


############################################
# (0) Install R packages, obtain citations
############################################
# install the R packages "gsDesign", "GroupSeq", "pwr" consecutively
install.packages(c("gsDesign", "GroupSeq", "pwr"))

citation("gsDesign")    # obtain citation for the R package "gsDesign"
citation("GroupSeq")    # obtain citation for the R package "GroupSeq"
citation("pwr")         # obtain citation for the R package "pwr"
RStudio.Version()       # obtain citation for RStudio (if used)


#########################################
# I. Simulate Group Sequential Designs
#########################################

##########################
# 1. R package: gsDesign
##########################

#######################################################################
# Note: 
# (1) "test.type=2" enables two-sided testing. The default value is 
# "alpha = .025" for one-sided testing (yielding alpha = .05 for 
# two-sided testing).
# However, the output in the R console only writes "2.5 % Type I Error" 
# even if "test.type=2" is chosen for the two-sided alpha = .05.
# (2) Each of the following templates for the group sequential 
# approaches is provided with the following parameters:
# "k=2" for two stages, "test.type=2" for two-sided testing, 
# "alpha=.025" for the lower and upper boundaries (yielding an 
# overall alpha=.05), "beta=.1" (for 90 % power), (Note: alpha=.025 
# and beta=.1 are the default values and are only specified for 
# didactic reasons and may be altered), "sfu" specifies 
# the group sequential approach, and "sfupar" the parameter of the 
# chosen group sequential design. If you need a different 
# group sequential design, simply alter the parameters.
# (3) gsDesign contains much more functionality than explained in the 
# following. The R documentation of gsDesign provides more details.
#######################################################################


library(gsDesign)  # loads 'gsDesign'
?gsDesign          # opens the R documentation of gsDesign

################
# 1.(i) Pocock
################

# K = 2
# beta = .1 (90% power)
#######################################################################
# Note: 'beta=.1' does not have to be specified additionally, because 
# it is a default value of the function gsDesign. However, if you need
# beta=.2 just use: gsDesign(k=2, test.type=2, sfu="Pocock", beta=.2)
#######################################################################

poc2p90 <- gsDesign(k=2, test.type=2, sfu="Pocock") # Generates
# a symmetric, two-sided interim analysis design with k=2 stages,
# alpha=.05, beta=.2 (power=80%) and Pocock boundaries.
# Note: If test.type=2 is used, sfu="..." is sufficient for the 
# upper boundaries and sfl="..." for the lower boundaries need not be 
# specified additionally, because of the symmetry.
poc2p90             # shows the group sequential Pocock design
poc2p90$n.I         # lists the sample size inflation factors (IF)
poc2p90$upper$bound # lists the upper Z boundaries of both stages
poc2p90$lower$bound # lists the lower Z boundaries of both stages
plot(poc2p90)       # plots the rejection boundaries

# In case more details of some values of a specific generated
# group sequential design are needed, apply the following commands:
poc2p90$upper    # lists all lower Z-boundaries of the chosen approach,
                 # the spent alpha and the lower probabilities of the 
                 # power at each boundary, respectively.
poc2p90$lower    # lists all lower Z-boundaries of the chosen approach,
                 # the spent alpha and the lower probabilities of the 
                 # power at each boundary, respectively. 



##############################
# 1.(ii) O'Brien and Fleming
##############################

# K = 2
# beta = .1 (90% power)
obf2p90 <- gsDesign(k=2, test.type=2, sfu="OF")
obf2p90           # shows the group sequential O'Brien and Fleming design
obf2p90$n.I         # lists the sample size inflation factors (IF)
obf2p90$upper$bound # lists the upper Z boundaries of both stages
obf2p90$lower$bound # lists the lower Z boundaries of both stages
plot(obf2p90)       # plots the rejection boundaries


##############################
# 1.(iii) Wang and Tsiatis
##############################

#######################################################################
# Note: sfupar=.5 specifies the power parameter "Delta" of the 
# Wang and Tsiatis approach. sfupar=.0 yields the approach of 
# O'Brien and Fleming and sfupar=.5 the approach of Pocock.
# Hence, sfupar=.25 yields intermediate boundaries in-between the 
# approaches of Pocock and O'Brien and Fleming and is often applied
# if Wang and Tsiatis has been chosen.
#######################################################################


# K = 2
# beta = .1 (90% power)
wt2p90 <- gsDesign(k=2, test.type=2, sfu="WT", sfupar=.25)
wt2p90             # shows the group sequential Wang and Tsiatis design
wt2p90$n.I         # lists the sample size inflation factors (IF)
wt2p90$upper$bound # lists the upper Z boundaries of both stages
wt2p90$lower$bound # lists the lower Z boundaries of both stages
plot(wt2p90)       # plots the rejection boundaries


##########################
# 2. R package: GroupSeq
##########################

#######################################################################
# Note: the options for Pocock-type and O'Brien-Fleming-type boundaries 
# do not provide the exact rejection boundaries, but the 
# boundaries approximated via the respective alpha spending function.
# Only the last option "Exact Pocock boundaries" provides the exact 
# Pocock boundaries postulated by the original definition of Pocock.
# Exact rejection boundaries of O'Brien and Fleming and 
# Wang and Tsiatis are not provided by GroupSeq.
#######################################################################

library(GroupSeq)    # loads GroupSeq
groupseq()           # loads the GroupSeq-GUI as default
# like groupseq(mode="g")
groupseq(mode="c")   # to work with the console
?groupseq            # opens the R documentation of GroupSeq



####################################################
# II. Estimate Sample Size for each Group and Stage
####################################################

######################################################################
# Note: For the a priori sample size estimation to determine the 
# sample sizes for group A and B per stage, the sample size inflation
# factor (IF) simulated by the group sequential design (also called: 
# sample size ratio (SSR) of the last stage) has to be used here to
# compute N(total,adj.,r.).
######################################################################

####################
# 3. R package: pwr
####################
library(pwr)       # to load pwr
?pwr               # to open the R documentation of gsDesign

# Illustrative Example: Sample Size Estimation
# for d = 0.5 (medium effect size; Cohen (1969), p. 38), 
# alpha = .05, power = 90 per cent, type = "two.sample" 
# for an independent two sample t-test testing H0 against 
# the "two-sided" alternative hypothesis H1
pwr.t.test(d = 0.5, sig.level = 0.05, power = 0.90,
           type = c("two.sample"), alternative = c("two.sided"))
# Result: n = 85.03126 --> per group 

# Determine exact N(total) for n1=n2
85.03126*2  # Multiply by 2 for two groups
# Result: exact N(total) = 170.0625

# Determine sample size for group sequential design
# Multiplication of the exact sample size by the 
# sample size inflation factor (IF) for the 
# Wang & Tsiatis (1987) design
1.034       # IF for delta = .25, alpha = .05 (two-sided), beta =.1
170.0625*1.034   # N(total,adj.) = 175.8446 --> N(total,adj.r.) = 176
176 / 2          # divided by 2 groups
88 / 2           # divided by 2 stages, k=1 and K=2
44               # n = 44 per stage in each group


##################################################################
# III. Transform t-value into a p value to obtain a test decision
##################################################################

#########################################################################
# Practical Note on Two-Sided p Values in SPSS
#
# Student's t-tests have been performed with IBM SPSS 25. Care must be 
# taken, because SPSS automatically provides the two-sided p value for 
# the t-statistic of Student's independent two sample t-test. However, 
# the empirically obtained t-statistic for each stage yields the 
# one-sided p value for alpha = .025 if it is not automatically 
# multiplied by the factor 2 (for two-sided testing at 
# level alpha = .05 as it is the case, for example, in SPSS). In making 
# statistical test decisions, the one-sided nominal p values 
# (significance level approach), or their corresponding rejection 
# boundaries of the Z-statistics (Z-statistic approach) can be used 
# at each stage k. If (i) the significance level approach is applied, 
# the one-sided nominal p value can be (a) multiplied by the factor 2 
# before the comparison with the empirically obtained two-sided p value 
# (from the SPSS output). Or (b), the empirically obtained two-sided 
# p value is divided by the factor 2, or (c) the t-statistic is 
# directly transformed into the empirical one-sided p value, before the 
# comparison with the one-sided nominal p value, respectively. 
# If (ii) the Z-statistic approach is applied, the t-statistic has to 
# be converted to the one-sided p value which can then be transformed 
# into a Z-statistic to be compared with the Z-boundaries of stage k.
#########################################################################

##################################
# (i) Significance level approach
##################################
# one-sided p value
df <- 86      # df from SPSS
t <- -2.709   # t value from SPSS
p1OneSided <- pt(t,df=df) # p1OneSided ... one-sided p value from Stage 1
p1OneSided    # Result: p1OneSided = .004080015 < p (nominal) = .0077 
              # --> Stopping for Efficacy

# two-sided p value
p1TwoSided <- p1*2 # p1TwoSided ... two-sided p value from Stage 1
p1TwoSided    # Result: p1TwoSided = .00816003 < p (nominal) = .01535
              # --> Stopping for Efficacy


############################
# (ii) Z-statistic approach
############################
# one-sided p value
df <- 86      # df from SPSS
t <- -2.709   # t value from SPSS
p1OneSided <- pt(t,df=df) # p1OneSided ... one-sided p value from Stage 1
qnorm(1 - (p1OneSided))   # Result: Z-statistic = 2.646 > critical Z-boundary = 2.423
              # --> empirically obtained Z-statistic lies outside the boundary
              # --> Stopping for Efficacy

# two-sided p value
p1TwoSided <- p1*2 # p1TwoSided ... two-sided p value from Stage 1
qnorm(1 - (p1TwoSided/2)) # Result: Z-statistic = 2.646 > critical Z-boundary = 2.423
              # --> empirically obtained Z-statistic lies outside the boundary
              # --> Stopping for Efficacy
