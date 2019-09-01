library(synapser)
synLogin()

reqs<-synRestGET("/team/3392900/openRequest") 

ids <- sapply(reqs$results, function(x){
   x$userId
})

required_teams <- c("3392680",
                    "3391263",
                    "3392971")

sapply(ids, function(x){
  print(x)
  teams_in <- synRestGET(paste0('/user/',x,'/team?limit=10000'))$results
  team_ids <- sapply(teams_in, function(y){
    y$id
  })
  a<- any(team_ids %in% required_teams[1])
  b<- any(team_ids %in% required_teams[2])
  c<- any(team_ids %in% required_teams[3])
  all <- all(c(a,b,c))
  
  if(all){
    print(paste0(x, ' in all required teams'))
    #synRestPUT(paste0('/team/3392900/member/',x))
    }else{
    print(paste0(x, ' not in all required teams'))
  }
})



