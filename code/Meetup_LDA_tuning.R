library(ldatuning)
library(topicmodels)
library(tm)

filtered_groups <- read.csv(file = "filtered_groups.csv", stringsAsFactors = F)
filtered_events <- read.csv(file = "filtered_events.csv", stringsAsFactors = F)


#Removing tags & escape characters
filtered_groups$description <- gsub("<.*?>","", filtered_groups$description)
filtered_groups <- filtered_groups[filtered_groups$description != "",]

#Creating Corpus
group_docs <- Corpus(VectorSource(filtered_groups$description))
group_docs <- tm_map(group_docs, content_transformer(tolower))

#remove Punctuation
group_docs <- tm_map(group_docs, removePunctuation)

#Remove Numbers
group_docs <- tm_map(group_docs, removeNumbers)

#Removing Stop Words
group_docs <- tm_map(group_docs, removeWords, stopwords("english"))

#Removing white spaces
group_docs <- tm_map(group_docs, stripWhitespace)

#Stemming words
group_docs_stemmed <- tm_map(group_docs, stemDocument)

dtm <- DocumentTermMatrix(group_docs_stemmed)


result <- FindTopicsNumber(
   dtm,
   topics = seq(from = 2, to = 15, by = 1),
   metrics = c("Griffiths2004", "CaoJuan2009", "Arun2010", "Deveaud2014"),
   method = "Gibbs",
   control = list(seed = 77),
   mc.cores = 2L,
   verbose = TRUE
)
write.csv(result, file = "topicsNumber _filtered_groups.csv",row.names = F)
FindTopicsNumber_plot(result)


#Set parameters for Gibbs Sampling
burnin <- 4000
iter <- 2000
thin <- 500
seed <- sample(1:400, 5)
nstart <- 5
best <- T

#Number of topics
k <- 11

ldaOut <-LDA(dtm,k, method='Gibbs', control=list(nstart=nstart, seed = seed, best=best, burnin = burnin, iter = iter, thin=thin))

#Docs to topics
ldaOut.topics <- as.matrix(topics(ldaOut))

#Top 10 terms in each topic 
ldaOut.terms <- as.matrix(terms(ldaOut,10))

#Probabilities associated with each topic assignment
topicProbabilities <- as.data.frame(ldaOut@gamma)
colnames(topicProbabilities) <- apply(terms(ldaOut,10),2,paste,collapse=",")

filtered_groups$topic_no <- ldaOut.topics[,1]

#Attaching topics into the groups dataframe
for(i in 1:nrow(filtered_groups)){
   filtered_groups$topics[i] <- paste(stemCompletion(terms(ldaOut,10)[,filtered_groups$topic_no[i]],dictionary = group_docs,type = "prevalent" ) ,collapse = ", ")
}
write.csv(filtered_groups, file = "filtered_groups_tm_updated.csv", row.names = F)


filtered_events$description <- gsub("<.*?>","", filtered_events$description)
filtered_events <- filtered_events[filtered_events$description != "",]


#Creating corpus for event descriptions
event_docs <- Corpus(VectorSource(filtered_events$description))
event_docs <- tm_map(event_docs, content_transformer(tolower))

#Remove Punctuation, Numbers, Stopwords, White Space & Stemming
event_docs <- tm_map(event_docs, removePunctuation)
event_docs <- tm_map(event_docs, removeNumbers)
event_docs <- tm_map(event_docs, removeWords, stopwords("english"))
event_docs <- tm_map(event_docs, stripWhitespace)
event_docs_stemmed <- tm_map(event_docs, stemDocument)

dtm <- DocumentTermMatrix(event_docs_stemmed)


result_events <- FindTopicsNumber(
   dtm,
   topics = seq(from = 2, to = 15, by = 1),
   metrics = c("Griffiths2004", "CaoJuan2009", "Arun2010", "Deveaud2014"),
   method = "Gibbs",
   control = list(seed = 77),
   mc.cores = 2L,
   verbose = TRUE
)
write.csv(result_events, file = "topicsNumber _filtered_events.csv",row.names = F)
FindTopicsNumber_plot(result_events)


#Setting parameters for Gibbs Sampling
burnin <- 4000
iter <- 2000
thin <- 500
seed <- sample(1:400, 5)
nstart <- 5
best <- T

#Setting number of topics
k <- 7

ldaOut <-LDA(dtm,k, method='Gibbs', control=list(nstart=nstart, seed = seed, best=best, burnin = burnin, iter = iter, thin=thin))

ldaOut.topics <- as.matrix(topics(ldaOut))

ldaOut.terms <- as.matrix(terms(ldaOut,10))

topicProbabilities <- as.data.frame(ldaOut@gamma)
colnames(topicProbabilities) <- apply(terms(ldaOut,10),2,paste,collapse=",")

filtered_events$topic_no <- ldaOut.topics[,1]

for(i in 1:nrow(filtered_events)){
   filtered_events$topics[i] <- paste(stemCompletion(terms(ldaOut,10)[,filtered_events$topic_no[i]],dictionary = event_docs,type = c("prevalent")) ,collapse = ", ")
}
write.csv(filtered_events, file = "filtered_events_tm_updated.csv", row.names = F)

