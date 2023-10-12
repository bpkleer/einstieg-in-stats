# An optional custom script to run before Hugo builds your site.
# You can delete it if you do not need it.

# Skript zum Download Gitlab-Commits (Kenntlichmachung der Arbeit)
# Für Github siehe template in ghcontributors in hugo-learner-theme
# Autor: B. Philipp Kleer

# Libraries ----
library("httr")
library("jsonlite")

# your private token (read_api only) ----
token <- ""

# get group members ----
group <-  GET(
  paste0(
    "https://gitlab.ub.uni-giessen.de/api/v4/groups/193/members?private_token=",
    token
  )
)

dfGroup <-  fromJSON(rawToChar(group$content))
dfGroup

# get commits per repository
main <- GET(
  paste0(
    "https://gitlab.ub.uni-giessen.de/api/v4/projects/824/repository/contributors?private_token=",
    token
  )
)

main <-  fromJSON(rawToChar(main$content))

main$name[main$name=="B. Philipp Kleer"] <- "Philipp Kleer"
main$web_url <- NA_character_
main$avatar_url <- NA_character_

for (i in 1:dim(main)[1]){
  for (j in 1:dim(dfGroup)[1]) {
    if (main$name[i] == dfGroup$name[j]) {
      main$web_url[i] <- dfGroup$web_url[j]
      main$avatar_url[i] <- dfGroup$avatar_url[j]
    }
  }
}

mainjson <- toJSON(
  main, 
  pretty = TRUE
)

# save file into data-folder
write(
  mainjson, 
  "./data/statsplus.json"
)
