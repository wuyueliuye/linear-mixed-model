df <- read.csv('musicdata.csv')
head(df)
# Packages required for Chapter 8
library(MASS)
library(gridExtra)  
library(mnormt) 
library(lme4) 
library(knitr) 
library(kableExtra)
library(tidyverse)
library(ggplot2)
library(ggpubr)

#### ------------------------ Data Prepare --------------------- ####
df$ia <- ifelse(df$audience=='Instructor', 1, 0)
df$sa <- ifelse(df$audience=='Student(s)', 1, 0)
df$male <- ifelse(df$gender=='Male', 1, 0)
model.a <- lmer(pa ~ 1+(1|id),REML=T, data = df)
summary(model.a)
summary(df$pa)
# model.b <- lmer(pa ~ ia+sa+(ia|id)+(sa|id), data=df)
model.b <- lmer(pa ~ ia+sa+(ia+sa|id),REML=T,data=df)
summary(model.b)
# model.c <- lmer(pa ~ ia+sa+mpqab+(ia|id)+(sa|id), REML=T, data=df )
model.c <- lmer(pa ~ ia+sa+mpqab+mpqab:ia+mpqab:sa+(ia+sa|id), REML=T, data=df )
summary(model.c)
# model.d <- lmer(pa ~ ia+sa+mpqab+male+(ia|id)+(sa|id), REML = T, data=df )
model.d <- lmer(pa ~ ia+sa+mpqab+male+mpqab:ia+mpqab:sa+male:ia+male:sa+(ia+sa|id), REML = T, data=df )
summary(model.d)

####  --------------------- EDA ----------------------- ####
df1 <- df%>%group_by(id)%>%summarise(mean_pa=mean(pa))
# hist(df$pa)
# hist(df1$mean_pa)

h1 <- ggplot(df, aes(pa))+
  geom_histogram(bins = 15, col='red', fill='pink', alpha=0.5)+
  coord_cartesian(xlim = c(min(c(df$pa, df1$mean_pa)), max(c(df$pa,df1$mean_pa))))
h2 <- ggplot(df1, aes(mean_pa))+
  geom_histogram(bins = 15, col='red', fill='pink', alpha=0.5)+
  coord_cartesian(xlim = c(min(c(df$pa, df1$mean_pa)), max(c(df$pa,df1$mean_pa))))
ggpubr::ggarrange(h1, h2, ncol=1)

# boxplot(df$pa ~ df$audience)

ggplot(df, aes(audience, pa))+
  geom_boxplot(col='red', fill='pink', alpha=0.5)+
  coord_flip()

# plot(pa~mpqab, df)
# abline(lm(pa~mpqab, df))

ggplot(df, aes(pa, ia))+
  geom_point()+
  geom_smooth(method = 'lm', col='pink')
ggplot(df, aes(pa, sa))+
  geom_point()+
  geom_smooth(method = 'lm')

ggplot(df, aes(ia, pa))+
  geom_point()+
  geom_smooth(method = 'lm')+
  facet_wrap(~id)

ggplot(df, aes(sa, pa))+
  geom_point()+
  geom_smooth(method = 'lm')+
  facet_wrap(~id)

# ggplot(df, aes(mpqab, pa))+
#   geom_point()+
#   geom_smooth(method = 'lm')+
#   facet_wrap(~id)
# 
# ggplot(df, aes(male, pa))+
#   geom_point()+
#   geom_smooth(method = 'lm')+
#   facet_wrap(~id)

pairs(df[,c('pa', 'ia', 'sa', 'mpqab', 'male')])

## Level 1 - pa; audience, memory, perform_type; diary

## histogram for positive affect distributions
p.pa <- ggplot(df, aes(x=pa))+
  geom_histogram(bins = 15, col='red', fill='pink', alpha=0.5)+
  coord_cartesian(xlim = c(min(df$pa),max(df$pa)))+
  labs(title = 'positive affect among 497 performances', 
        x = 'positive affect', y = 'frequency')
p.pa_mean <- df%>%group_by(id)%>%summarise(mean_pa=mean(pa))%>%
  ggplot(aes(x=mean_pa))+
  geom_histogram(bins=15,col='red', fill='pink', alpha=0.5)+
  coord_cartesian(xlim = c(min(df$pa),max(df$pa)))+
  labs(title = 'performance averaged positive affect among 37 subjects', 
        x = 'positive affect', y = 'frequency')
ggarrange(p.pa, p.pa_mean, ncol = 1)

## categorical factors: audience, memory, perform_type
table(df$perform_type)
table(df$audience)
table(df$memory)
p.type <- ggplot(df, aes(x=perform_type))+
  geom_bar(col='red', fill='pink', alpha=0.5)+
  theme(text = element_text(size = 6))
p.ad <- ggplot(df, aes(x=audience))+
  geom_bar(col='red', fill='pink', alpha=0.5)+
  theme(text = element_text(size = 6))
p.memory <- ggplot(df, aes(x=memory))+
  geom_bar(col='red', fill='pink', alpha=0.5)+
  theme(text = element_text(size = 6))
ggarrange(p.type, p.ad, p.memory, ncol=3)

p.type2 <- ggplot(df, aes(x=perform_type, y=pa))+geom_boxplot(col='red', fill='pink', alpha=0.5)+coord_flip()
p.ad2 <- ggplot(df, aes(x=audience, y=pa))+geom_boxplot(col='red', fill='pink', alpha=0.5)+coord_flip()
p.memory2 <- ggplot(df, aes(x=memory, y=pa))+geom_boxplot(col='red', fill='pink', alpha=0.5)+coord_flip()
ggarrange(p.type2, p.ad2, p.memory2, ncol=1)

ggplot(df, aes(x=perform_type, y=pa))+
  geom_boxplot()+coord_flip()+
  facet_wrap(~id)

ggplot(df, aes(x=audience, y=pa))+
  geom_boxplot()+coord_flip()+
  facet_wrap(~id)

ggplot(df, aes(x=memory, y=pa))+
  geom_boxplot()+coord_flip()+
  facet_wrap(~id)

## numerical factors: previous (# previous performance with a diary entry)
summary(df$previous)
ggplot(df, aes(x=previous, y=pa))+geom_point()+geom_smooth(method = 'lm')
ggplot(df, aes(x=previous, y=pa))+geom_point()+geom_smooth(method = 'lm')+
  facet_wrap(~id)


## Level 2 - demographics (age, gender); instrument, years_study; MPQ (ab, sr, pem, nem, con)
df1 <- df%>%group_by(id)%>%summarise(age, gender, instrument, years_study, 
                                     mpqab, mpqsr, mpqpem, mpqnem, mpqcon,
                                     mean_pa=mean(pa))
df1 <- unique(df1)

## l2 categorical: genderm instrument
table(df1$gender)
table(df1$instrument)

p.g <- ggplot(df1, aes(x=gender))+
  geom_bar(col='red', fill='pink', alpha=0.5)
p.i <- ggplot(df1, aes(x=instrument))+
  geom_bar(col='red', fill='pink', alpha=0.5)
ggarrange(p.g, p.i, ncol = 2)

# p.g2 <- ggplot(df1, aes(x=gender, y=mean_pa))+
#   geom_boxplot(col='red', fill='pink', alpha=0.5)
# p.i2 <- ggplot(df1, aes(x=instrument, y=mean_pa))+
#   geom_boxplot(col='red', fill='pink', alpha=0.5)
# ggarrange(p.g2, p.i2, ncol = 2)
# 

## demographics
# summary(df1$age)
# table(df1$gender)
# p.age <- ggplot(df1, aes(x=age))+
#   geom_bar(col='red', fill='pink', alpha=0.5)
# p.gender <- ggplot(df1, aes(x=gender))+
#   geom_bar(col='red', fill='pink', alpha=0.5)
# ggarrange(p.age, p.gender, ncol=2)

## instrument & years_study
table(df1$instrument)
ggplot(df1, aes(x=years_study))+
  geom_bar(col='red', fill='pink', alpha=0.5)

## MPQ
summary(df1$mpqab)
ggplot(df1, aes(x=mpqab))+
  geom_bar()
ggplot(df1, aes(x=mpqsr))+
  geom_bar()
ggplot(df1, aes(x=mpqpem))+
  geom_bar()
ggplot(df1, aes(x=mpqnem))+
  geom_histogram()
ggplot(df1, aes(x=mpqcon))+
  geom_histogram()

## factors vs pa
## L2 categorical factors: gender, instrument
p.g1 <- ggplot(df, aes(x=gender, y=pa))+geom_boxplot(col='red', fill='pink', alpha=0.5)+coord_flip()
p.g2 <- ggplot(df1, aes(x=gender, y=mean_pa))+geom_boxplot(col='red', fill='pink', alpha=0.5)+coord_flip()
ggarrange(p.g1, p.g2, ncol = 1)
p.i1 <- ggplot(df, aes(x=instrument, y=pa))+geom_boxplot(col='red', fill='pink', alpha=0.5)+coord_flip()
p.i2 <- ggplot(df1, aes(x=instrument, y=mean_pa))+geom_boxplot(col='red', fill='pink', alpha=0.5)+coord_flip()
ggarrange(p.i1, p.i2, ncol = 1)
## L2 numerical: age, years_study, mpq
p.a1 <- ggplot(df, aes(x=age, y=pa))+geom_point()+geom_smooth(method = 'lm')
p.a2 <- ggplot(df1, aes(x=age, y=mean_pa))+geom_point()+geom_smooth(method = 'lm')
ggarrange(p.a1, p.a2, ncol=1)

p.ys1 <- ggplot(df, aes(x=years_study, y=pa))+geom_point()+geom_smooth(method = 'lm')
p.ys2 <- ggplot(df1, aes(x=years_study, y=mean_pa))+geom_point()+geom_smooth(method = 'lm')
ggarrange(p.ys1, p.ys2, ncol=1)

p.ab1 <- ggplot(df, aes(x=mpqab, y=pa))+geom_point()+geom_smooth(method = 'lm')
p.ab2 <- ggplot(df1, aes(x=mpqab, y=mean_pa))+geom_point()+geom_smooth(method = 'lm')
ggarrange(p.ab1, p.ab2, ncol=1)

p.pem1 <- ggplot(df, aes(x=mpqpem, y=pa))+geom_point()+geom_smooth(method = 'lm')
p.pem2 <- ggplot(df1, aes(x=mpqpem, y=mean_pa))+geom_point()+geom_smooth(method = 'lm')
ggarrange(p.pem1, p.pem2, ncol=1)

p.nem1 <- ggplot(df, aes(x=mpqnem, y=pa))+geom_point()+geom_smooth(method = 'lm')
p.nem2 <- ggplot(df1, aes(x=mpqnem, y=mean_pa))+geom_point()+geom_smooth(method = 'lm')
ggarrange(p.nem1, p.nem2, ncol=1)

ggarrange(p.a1, p.ys1, p.ab1, p.pem1, p.nem1, 
          p.a2, p.ys2, p.ab2, p.pem2, p.nem2, ncol = 5, nrow = 2)
#### ------------------- Statistical Analysis ---------------------- ####

df$ia <- ifelse(df$audience=='Instructor', 1, 0)
df$sa <- ifelse(df$audience=='Student(s)', 1, 0)
df$male <- ifelse(df$gender=='Male', 1, 0)
model.a <- lmer(pa ~ 1+(1|id),REML=T, data = df)
summary(model.a)

# model.b <- lmer(pa ~ ia+sa+(ia|id)+(sa|id), data=df)
model.b <- lmer(pa ~ ia+sa+(ia+sa|id),data=df)
summary(model.b)
# model.c <- lmer(pa ~ ia+sa+mpqab+(ia|id)+(sa|id), REML=T, data=df )
mean(df$mpqab)
mean(df$male)
model.c <- lmer(pa ~ ia+sa+mpqab+mpqab:ia+mpqab:sa+(ia+sa|id), REML=T, data=df )
summary(model.c)
# model.d <- lmer(pa ~ ia+sa+mpqab+male+(ia|id)+(sa|id), REML = T, data=df )
model.d <- lmer(pa ~ ia+sa+mpqab+male+mpqab:ia+male:ia+mpqab:sa+male:sa+(ia+sa|id), REML = T, data=df )
summary(model.d)

# anova() automatically uses ML for LRT tests
# model.c <- lmer(pa ~ ia+sa+mpqab+mpqab:ia+mpqab:sa+(ia+sa|id), data=df )
# model.d <- lmer(pa ~ ia+sa+mpqab+male+mpqab:ia+male:ia+mpqab:sa+male:sa+(ia+sa|id), data=df )
drop_in_dev <- anova(model.d, model.c, test = "Chisq")
drop_in_dev
