---
author:
categories:
date: "2019-07-12"
show_post_date: false
draft: false
excerpt: The package implements several new layout algorithms to visualize networks which are not provided by standarad graph packages. 
    Most are based on the concept of stress majorization by. Some more specific algorithms allow to emphasize hidden group structures in networks, focus on specific nodes or specific types of networks.
layout: single
links:
- icon: door-open
  icon_pack: fas
  name: pkgdown 
  url: http://graphlayouts.schochastics.net
- icon: github
  icon_pack: fab
  name: code
  url: https://github.com/schochastics/graphlayouts
- icon: info-circle
  icon_pack: fas
  name: tutorial
  url:
subtitle: An R package for network visualization
tags:
- R-package
title: graphlayouts

---

<p style="text-align:center;">
<img src="featured-hex.png" width="50%">
</p>




This package implements some graph layout algorithms that are not available
in `igraph`.

The package implements the following algorithms:

- Stress majorization ([Paper](https://graphviz.gitlab.io/_pages/Documentation/GKN04.pdf))
- Quadrilateral backbone layout ([Paper](https://jgaa.info/accepted/2015/NocajOrtmannBrandes2015.19.2.pdf))
- flexible radial layouts ([Paper](https://jgaa.info/accepted/2011/BrandesPich2011.15.1.pdf))
- sparse stress ([Paper](https://arxiv.org/abs/1608.08909))
- pivot MDS ([Paper](https://kops.uni-konstanz.de/bitstream/handle/123456789/5741/bp_empmdsld_06.pdf?sequence=1&isAllowed=y))
- dynamic layout for longitudinal data ([Paper](https://kops.uni-konstanz.de/bitstream/handle/123456789/20924/Brandes_209246.pdf?sequence=2))
- spectral layouts (adjacency/Laplacian)
- a simple multilevel layout

## Install

```r
# dev version
remotes::install_github("schochastics/graphlayouts")

#CRAN
install.packages("graphlayouts")
```


## Stress Majorization  

*This example is a bit of a special case since it exploits some weird issues in igraph.* 

```r
library(igraph)   
library(ggraph)   
library(graphlayouts)

set.seed(666)
pa <- sample_pa(1000,1,1,directed = F)

ggraph(pa,layout = "nicely")+
  geom_edge_link0(width=0.2,colour="grey")+
  geom_node_point(col="black",size=0.3)+
  theme_graph()
```

<img src="{{< blogdown/postref >}}index_files/figure-html/example-1.png" width="100%" style="display: block; margin: auto;" />

```r

ggraph(pa,layout="stress")+
  geom_edge_link0(width=0.2,colour="grey")+
  geom_node_point(col="black",size=0.3)+
  theme_graph()
```

<img src="{{< blogdown/postref >}}index_files/figure-html/example-2.png" width="100%" style="display: block; margin: auto;" />

Stress majorization also works for networks with several components. It relies 
on a bin packing algorithm to efficiently put the components in a rectangle, rather than a circle.


```r
set.seed(666)
g <- disjoint_union(
  sample_pa(10,directed = F),
  sample_pa(20,directed = F),
  sample_pa(30,directed = F),
  sample_pa(40,directed = F),
  sample_pa(50,directed = F),
  sample_pa(60,directed = F),
  sample_pa(80,directed = F)
)

ggraph(g,layout = "nicely") +
  geom_edge_link0() +
  geom_node_point() +
  theme_graph()
```

<img src="{{< blogdown/postref >}}index_files/figure-html/example_un-1.png" width="100%" style="display: block; margin: auto;" />

```r

ggraph(g, layout = "stress",bbox = 40) +
  geom_edge_link0() +
  geom_node_point() +
  theme_graph()
```

<img src="{{< blogdown/postref >}}index_files/figure-html/example_un-2.png" width="100%" style="display: block; margin: auto;" />

## Backbone Layout

Backbone layouts are helpful for drawing hairballs. 


```r
set.seed(665)
#create network with a group structure
g <- sample_islands(9,40,0.4,15)
g <- simplify(g)
V(g)$grp <- as.character(rep(1:9,each=40))

ggraph(g,layout = "stress")+
  geom_edge_link0(colour=rgb(0,0,0,0.5),width=0.1)+
  geom_node_point(aes(col=grp))+
  scale_color_brewer(palette = "Set1")+
  theme_graph()+
  theme(legend.position = "none")
```

<img src="{{< blogdown/postref >}}index_files/figure-html/hairball-1.png" width="100%" style="display: block; margin: auto;" />

The backbone layout helps to uncover potential group structures based on edge 
embeddedness and puts more emphasis on this structure in the layout.


```r
bb <- layout_as_backbone(g,keep=0.4)
E(g)$col <- F
E(g)$col[bb$backbone] <- T

ggraph(g,layout="manual",x=bb$xy[,1],y=bb$xy[,2])+
  geom_edge_link0(aes(col=col),width=0.1)+
  geom_node_point(aes(col=grp))+
  scale_color_brewer(palette = "Set1")+
  scale_edge_color_manual(values=c(rgb(0,0,0,0.3),rgb(0,0,0,1)))+
  theme_graph()+
  theme(legend.position = "none")
```

<img src="{{< blogdown/postref >}}index_files/figure-html/backbone-1.png" width="100%" style="display: block; margin: auto;" />

## Radial Layout with Focal Node

The function `layout_with_focus()` creates a radial layout around a focal node.
All nodes with the same distance from the focal node are on the same circle.


```r
library(igraphdata)
library(patchwork)
data("karate")

p1 <- ggraph(karate,layout = "focus",focus = 1) +
  draw_circle(use = "focus",max.circle = 3)+
  geom_edge_link0(edge_color="black",edge_width=0.3)+
  geom_node_point(aes(fill=as.factor(Faction)),size=2,shape=21)+
  scale_fill_manual(values=c("#8B2323", "#EEAD0E"))+
  theme_graph()+
  theme(legend.position = "none")+
  coord_fixed()+
  labs(title= "Focus on Mr. Hi")

p2 <- ggraph(karate,layout = "focus",focus = 34) +
  draw_circle(use = "focus",max.circle = 4)+
  geom_edge_link0(edge_color="black",edge_width=0.3)+
  geom_node_point(aes(fill=as.factor(Faction)),size=2,shape=21)+
  scale_fill_manual(values=c("#8B2323", "#EEAD0E"))+
  theme_graph()+
  theme(legend.position = "none")+
  coord_fixed()+
  labs(title= "Focus on John A.")

p1+p2
```

<img src="{{< blogdown/postref >}}index_files/figure-html/flex_focus-1.png" width="100%" style="display: block; margin: auto;" />

## Radial Centrality Layout

The function `layout_with_centrality` creates a radial layout around the node with the
highest centrality value. The further outside a node is, the more peripheral it is.


```r
library(igraphdata)
library(patchwork)
data("karate")

bc <- betweenness(karate)
p1 <- ggraph(karate,layout = "centrality", centrality = bc, tseq = seq(0,1,0.15)) +
  draw_circle(use = "cent") +
  annotate_circle(bc,format="",pos="bottom") +
  geom_edge_link0(edge_color="black",edge_width=0.3)+
  geom_node_point(aes(fill=as.factor(Faction)),size=2,shape=21)+
  scale_fill_manual(values=c("#8B2323", "#EEAD0E"))+
  theme_graph()+
  theme(legend.position = "none")+
  coord_fixed()+
  labs(title="betweenness centrality")


cc <- closeness(karate)
p2 <- ggraph(karate,layout = "centrality", centrality = cc, tseq = seq(0,1,0.2)) +
  draw_circle(use = "cent") +
  annotate_circle(cc,format="scientific",pos="bottom") +
  geom_edge_link0(edge_color="black",edge_width=0.3)+
  geom_node_point(aes(fill=as.factor(Faction)),size=2,shape=21)+
  scale_fill_manual(values=c("#8B2323", "#EEAD0E"))+
  theme_graph()+
  theme(legend.position = "none")+
  coord_fixed()+
  labs(title="closeness centrality")

p1+p2
```

<img src="{{< blogdown/postref >}}index_files/figure-html/flex_cent-1.png" width="100%" style="display: block; margin: auto;" />

## Large graphs

`graphlayouts` implements two algorithms for visualizing large networks (<100k nodes).
`layout_with_pmds()` is similar to `layout_with_mds()` but performs the multidimensional scaling
only with a small number of pivot nodes. Usually, 50-100 are enough to obtain similar results to the
full MDS.

`layout_with_sparse_stress()` performs stress majorization only with a small number of pivots (~50-100).
The runtime performance is inferior to pivotMDS but the quality is far superior. 

A comparison of runtimes and layout quality can be found in the [wiki](https://github.com/schochastics/graphlayouts/wiki/)  
**tl;dr**: both layout algorithms appear to be faster than the fastest igraph algorithm `layout_with_drl()`.

Below are two examples of layouts generated for large graphs using `layout_with_sparse_stress()`

<img src="https://raw.githubusercontent.com/schochastics/graphlayouts/master/man/figures/rt-net.png" width="80%" style="display: block; margin: auto;" />
A retweet network with 18k nodes and 61k edges

<img src="https://user-images.githubusercontent.com/17147355/62534862-ea039880-b841-11e9-87db-6ee69ebacf94.png" width="80%" style="display: block; margin: auto;" />
A co-citation network with 12k nodes and 68k edges
