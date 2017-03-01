group_results <- read.csv(file = "group_results.csv", stringsAsFactors = F)
events_results <- read.csv(file = "events_results.csv", stringsAsFactors = F)
based_on_relevant_score <- read.csv(file = "based_on_relevant_score.csv", stringsAsFactors = F)

tags <- sort(based_on_relevant_score$tag)
flag = 0

for(i in 1:nrow(group_results)){
   group_tags <- sort(c(unlist(strsplit(x = group_results$tags[i], split = ", ")),group_results$category[i]))
   if(sum(group_tags %in% tags) >= 1){
      entry <- group_results[group_results$group_id == group_results$group_id[i],]
      
      if(flag == 0){
         filtered_groups <- entry
         flag = 1
      }
      else{
         filtered_groups <- rbind(filtered_groups, entry)
      }
   }
}
filtered_groups <- filtered_groups[!duplicated(filtered_groups),]

write.csv(filtered_groups, file = "filtered_groups.csv", row.names = F)

filtered_events <- events_results[events_results$group_id %in% unique(filtered_groups$group_id),]
write.csv(filtered_events, file = "filtered_events.csv", row.names = F)
