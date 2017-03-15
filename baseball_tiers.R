library(ggplot2)
library(dplyr)

ranks <- as.data.frame(read.csv("hitters.csv", header = TRUE))

catchers <- ranks



adj.catchers <- apply(catchers[,c("ATC.Score", "Avg")], MARGIN = 2, FUN = function(X) (X - min(X))/diff(range(X)))

catcherCluster <- kmeans(adj.catchers, 12, nstart = 10000)

catchers$cluster <- catcherCluster$cluster


ggplot(catchers[1:50,], aes(x = ATC.Score, y = FG.Rank, label = Name)) +
  geom_label(aes(fill = as.factor(cluster)), colour = "white", fontface = "bold") +
  scale_y_reverse()

sort.catcher <- catchers[order(catchers$Avg),c("Name", "cluster")]

sort.catcher
