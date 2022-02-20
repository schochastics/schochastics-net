library(netrankr)
library(igraph)
library(ggplot2)
library(ggraph)
library(gganimate)
data("dbces11")

xy <- graphlayouts::layout_with_stress(dbces11)

# closeness animation
sp <- shortest_paths(dbces11,from = "A",to = V(dbces11),output = "vpath")$vpath
el <- get.edgelist(dbces11,names = FALSE)

sp_lst <- lapply(seq_along(sp),function(l){
  x <- sp[[l]]
  if(length(x)!=1){
    unname(cbind(xy[as.integer(x),],l,0:(length(x)-1)))
  } else{
    cbind(rbind(xy[as.integer(x),],xy[as.integer(x),]),l,0:1)
  }
})

sp_df <- as.data.frame(do.call("rbind",sp_lst))
names(sp_df)[3] <- "V3"
V(dbces11)$dist <- distances(dbces11,to = "A")

d_df <- data.frame(x=seq(-3,1,length.out=12),y=-1.5)
d_df$V3 <- 1:nrow(d_df)+11
d_df$V4 <- c(sort(distances(dbces11)[1,]),5)
d_df$label <- c(sort(distances(dbces11)[1,]),sum(sort(distances(dbces11)[1,])))
d_df$label <- paste0(d_df$label,c(rep("  +",10),"  =",""))

p <- ggraph(dbces11,"stress")+
  geom_edge_link0()+
  geom_node_point(shape=21,size=10,fill="grey25")+
  geom_point(data = sp_df, aes(V1,V2,group=V3),size=8,colour="firebrick3")+
  geom_node_text(aes(label=dist),color="grey25")+
  geom_text(data = d_df,aes(x,y,group=V3,label=label),size=8)+
  transition_time(V4)+
  # shadow_wake(wake_length=0.1,wrap=FALSE,exclude_layer = c(1,2))+
  shadow_mark(exclude_layer = c(1,2))
pa <- animate(p,nframes = 100,fps=25,height=600,width=800,units="px",end_pause = 75)
anim_save("content/material/netAnaR/closeness.gif",pa)

# betweenness animation
all_shortest_paths(dbces11,"A","B")
