---
author: David Schoch 
categories:
- network analysis
date: "2021-12-19"
date_end: 
draft: false
excerpt: Network Analysis in R using tidygraph
featured: true
layout: single
links:
- icon: door-open
  icon_pack: fas
  name: tidygraph
  url: https://tidygraph.data-imaginist.com/
show_post_time: false
title: "Tidy Network Analysis in R"
subtitle: "using the tidygraph package"
---



(under construction; last update 2022-02-16)

# Shortcuts

Interested in specific topics? Here are some shortcuts

# Introduction

The main focus of this tutorial is empirical analysis of networks. 

# Required libraries

To run all the code in this tutorial, you need to install and load two packages.

```r
install.packages(c("tidygraph"))
devtools::install_github("schochastics/networkdata")
```

`igraph` is used for the majority of analytic tasks and for its data structures. `netrankr` is a package
for network centrality. 


```r
library(tidygraph)
library(networkdata)
```



Make sure you have at least the version given below. Some of the examples may not be backward compatible.


```r
packageVersion("tidygraph")
```

```
## [1] '1.2.0.9000'
```

```r
packageVersion("networkdata")
```

```
## [1] '0.1.11'
```


# Further Reading
See [here](https://www.data-imaginist.com/2017/introducing-tidygraph/) for a brief introduction to `tidygraph` by its maintainer Thomas Lin Pedersen   

<!-- There is an [Rview](https://rviews.rstudio.com/2019/03/06/intro-to-graph-analysis/) post by Edgar Ruiz   -->

<!-- [Network analysis in R](https://www.jessesadler.com/post/network-analysis-with-r/) by Jesse Sadler   -->



