# linear-mixed-model
linear mixed model with multi-level covariates

#### Multilevel Mixed Models on Music Perfromance Anxiety Analysis

##### Introduction

###### Case Design

The study explored the emotional state of musicians before performances and factors which may affect their emotional state. The subjects here were 37 undergraduate music majors from a competitive undergraduate music program fill out diaries prior to performances over the course of an academic year. 

Factors which were examined for their potential relationships with performance anxiety included: performance type (solo, large ensemble, or small ensemble); audience (instructor, public, students, or juried); if the piece was played from memory; age; gender; instrument (voice, orchestral, or keyboard); and, years studying the instrument. In addition, the personalities of study participants were assessed at baseline through the Multidimensional Personality Questionnaire (MPQ). The MPQ provided scores for one lower-order factor (absorption) and three higher-order factors: positive emotionality (PEM—a composite of well-being, social potency, achievement, and social closeness); negative emotionality (NEM—a composite of stress reaction, alienation, and aggression); and, constraint (a composite of control, harm avoidance, and traditionalism).

###### Variables

There interested factor information were collected and described in variables as follows:

- `id` = unique musician identification number
- `diary` = cumulative total of diaries filled out by musician
- `previous`  = number of previous performances with a diary entry
- `perf_type` = type of performance (Solo, Large Ensemble, or Small Ensemble)
- `audience` = who attended (Instructor, Public, Students, or Juried)
- `memory` = performed from Memory, using Score, or Unspecified
- `na` = negative affect score from PANAS
- `gender` = musician gender
- `instrument` = Voice, Orchestral, or Piano
- `years_study` = number of previous years spent studying the instrument
- `mpqab` = absorption subscale from MPQ
- `mpqsr` = stress reaction subscale from MPQ
- `mpqpem` = positive emotionality (PEM) composite scale from MPQ
- `mpqnem` = negative emotionality (NEM) composite scale from MPQ
- `mpqcon` = constraint scale from MPQ

###### Hypotheses  

Primary scientific hypotheses of the researchers included:

- Lower music performance anxiety will be associated with lower levels of a subject’s negative emotionality.
- Lower music performance anxiety will be associated with lower levels of a subject’s stress reaction.
- Lower music performance anxiety will be associated with greater number of years of study.

##### Methodologies

###### Multilevel Model

The models we used for this study was the multilevel model. With multilevel models, exploratory analyses must eventually account for the level at which each variable is measured. In a two-level study such as this one, *Level One* will refer to variables measured at the most frequently occurring observational unit, while *Level Two* will refer to variables measured on larger observational units. For example in this study, level two factors can be  variables measure characteristics of participants that remain constant over all performances for a particular musician 

Specifically in this study, the level one and level two factors can include as the follows:

- Level One:

  - positive affect (our response variable)

  - performance characteristics (type, audience, if music was performed from memory)

  - number of previous performances with a diary entry

- Level Two:
  - demographics (age and gender of musician)
  - instrument used and number of previous years spent studying that instrument
  - baseline personality assessment (MPQ measures of positive emotionality, negative emotionality, constraint, stress reaction, and absorption)

###### Analytics Plans

- Exploratory data analysis (question a)
  - Explore the distributions of interested response, level one and level two variables, as well as their correlations with respect to response variable
- Multilevel models (question b-g)
  - Fit predicitive models with level one or level two factors, make interpreations on the models
- Model Comparison (question h)
  - Explore differences between predictive models, make comparisons on their performances
  
  
  
  ##### References

[1] Roback, P., & Legler, J. (2021). *Beyond Multiple Linear Regression: Applied Generalized Linear Models And Multilevel Models in R*. CRC Press. https://bookdown.org/roback/bookdown-BeyondMLR/ch-multilevelintro.html. 

[2] Sadler, M. E., & Miller, C. J. (2010). Performance anxiety: A longitudinal study of the roles of personality and experience in musicians. Social Psychological and Personality Science, 1(3), 280-287. 

