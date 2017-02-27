MeetUp Data and Data Analysis Scripts
======
Myeong Lee (University of Maryland iSchool)
------

This repository consists of (1) MeetUp data collection scripts (PHP); (2) 8-month MeetUp data; and (3) MeetUp analysis scripts in R and Python.

Analysis scripts will be continuously updated as the project develops.
The "Results" folder is empty, and this folder is for storing outputs that are generated from R and Python scripts.

## Data Analysis Plan
0. Before starting the processing, the main data files are available at this Google Drive link (because of the file size, they cannot be uploaded to Github). You need to access this folder using your UMD account, but not other Gmail accounts: https://drive.google.com/open?id=0B-ByxmArDTSuVW52LW1ybDV6N0E
1. There is the "based_on_relevant_score.csv" file in the "results" folder. This file contains a list of tags that will be used for selecting MeetUp groups. From the "group_results.csv" file that contains all the group information from the 8-month period, select all the groups that have at least one of the tags from the "based_on_relevant_score.csv" file. Save the result in a "filtered_groups.csv" file. 
2. Each group has a unique "group_id" in the filtered group table. Use the "group_id" to filter events from the "events_results.csv" file. Save the result as "filtered_events.csv".
3. GID is unique for both time and group (while group_id is unique only a group). For each record in the "filtered_groups.csv", provide topics by running topic modeling for the "description" field, and add the topics in a new column called "topics". (for now, you can set the parameters for the topic modeling arbitrarily, let's say 10 for the number of topics)
4. For each GID in the "filtered_events.csv" file (which may have more than one event records), provide another set of topics by running topic modeling for the "description" field. You need to clean up and escape special characters and tags before running the topic modeling. Note that this topic modeling is not for each event description, but for a same GID that may have one or more events' descriptions (again, you can set the parameters for the topic modeling arbitrarily, let's say 10 for the number of topics).


