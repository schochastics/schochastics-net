---
author:
categories:
date: "2019-07-08"
show_post_date: false
draft: false
excerpt: The package contains a large collection of network dataset with different context. This includes social networks, animal networks and movie networks. All datasets are in 'igraph' format.
layout: single
links:
- icon: door-open
  icon_pack: fas
  name: pkgdown 
  url: http://networkdata.schochastics.net
- icon: github
  icon_pack: fab
  name: code
  url: https://github.com/schochastics/networkdata
subtitle: An R package with more than 2000 network datasets
tags:
- R-package
title: networkdata
---
<p style="text-align:center;">
<img src="featured-hex.png" width="50%">
</p>




The package contains a large variety of different network datasets (all in `igraph` format). So far, it includes datsets from the following repositories: 

- Freeman's datasets from http://moreno.ss.uci.edu/data
- Movie networks from https://dataverse.harvard.edu/dataset.xhtml?persistentId=doi:10.7910/DVN/T4HBA3
- Covert networks from https://sites.google.com/site/ucinetsoftware/datasets/covert-networks
- Animal networks from https://bansallab.github.io/asnr/
- Shakespeare's plays networks build with data from https://github.com/mallaham/Shakespeare-Plays
- Some networks from http://konect.uni-koblenz.de/
- Tennis networks compiled from https://github.com/JeffSackmann (please give credit to him if you use this data) 
- Star Wars Character Interactions (Episode 1-7) from https://github.com/evelinag/StarWars-social-network

The package includes 982 datasets containing 2257 networks. 

A list of all datasets can be obtained with

```r
data(package = "networkdata")
```

**Feel free to add your own dataset via a pull request**

## Installation

Due to the nature of the package (only data, no functions), the package will not go to CRAN at any point.
However, the package is available via drat (If you are looking for stable builds of the package).
With drat, you can install and upgrade non-CRAN packages directly from R using the standard `install.packages()` and `update.packages()` functions. 


```r
# install.packages("drat")
drat::addRepo("schochastics")
install.packages("networkdata")
```

The developer version can be installed with:


```r
#install.packages("remotes")
remotes::install_github("schochastics/networkdata")
```


The required space for the package is ~22MB, given that it includes a lot of data.

## Notes

- Please report any missing sources/references for datasets.
- Many datasets were automatically assembled and may thus contain errors (not all were manually checked). If you spot any, please report them. Check the original sources for any inconsistencies if you want to use the data in an academic paper.
