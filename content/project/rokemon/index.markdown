---
author:
categories:
date: "2018-07-07"
show_post_date: false
draft: false
excerpt: This package implements several themes for ggplot to bring your data into the world of Pokemon.
layout: single
links:
- icon: github
  icon_pack: fab
  name: code
  url: https://github.com/schochastics/Rokemon
subtitle: Pokemon inspired themes for ggplot2
tags:
- R-package
title: rokemon
---
<p style="text-align:center;">
<img src="featured-hex.png" width="50%">
</p>



An R package to create Pokemon inspired ggplots. It also comes with dataset of 801 Pokemon
with 41 different features (Gotta analyze'em all!). 

## Overview

For more details and examples see next sections.

Data

* `pokemon`: Data frame containing attributes and stats of 801 Pokemon.

Functions

* `gghealth()`: HP bar inspired Bar charts.
* `poke_pie()`: create pie charts from color distribution of Pokemon sprites.

Themes

* `theme_rocket()`: Team Rocket theme
* `theme_gameboy()` and `theme_gba()`: classic Gameboy and Gameboy Advanced themes
* `theme_status()`: inspired by Pokemon status bar
* `theme_mystic()`, `theme_valor()`, `theme_instinct()`: Pokemon Go teams theme; work well with
`annotate_pogo()`
* `scale_color_poketype()` and `scale_fill_poketype()`: Provides colors, if Pokemon types are mapped to color/fill 

Pokemon Palettes

* `poke_pal()`: color palettes created from Pokemon sprites
* `display_poke_pal()`: view a Pokemon color palette

## Install

The developer version can be obtained from github.

```r
#install.packages("devtools")
devtools::install_github("schochastics/Rokemon")
```


```r
library(Rokemon)
library(tidyverse)

data(pokemon)
```

## Themes

The package includes several themes for ggplot. 

### Theme Rocket

*(See what I did there...)*


```r
ggplot(pokemon,aes(attack,defense))+
  geom_point(col = "grey")+
  theme_rocket()+
  labs(x = "Jessy",y = "James",
       title = "Theme Rocket",
       subtitle = "blast off at the speed of light!",
       caption = "meowth that's right")
```

<img src="{{< blogdown/postref >}}index_files/figure-html/theme-rocket-1.png" width="100%" style="display: block; margin: auto;" />

### Gamyboy theme

If you want to get nostalgic.


```r
ggplot(pokemon,aes(attack,defense))+
  geom_point(shape = 15,col = "#006400",size=2)+
  theme_gameboy()+
  labs(title = "Classic Gameboy Theme")
```

<img src="{{< blogdown/postref >}}index_files/figure-html/theme-gameboy-1.png" width="100%" style="display: block; margin: auto;" />



```r
ggplot(pokemon,aes(attack,defense))+
  geom_point(shape = 15,col = "#27408B",size=2)+
  theme_gba()+
  labs(title = "Gameboy Advanced Theme")
```

<img src="{{< blogdown/postref >}}index_files/figure-html/theme-gba-1.png" width="100%" style="display: block; margin: auto;" />


### Status theme and HP bar chart

A theme inspired by HP bar in older Pokemon games. The theme is used in `gghealth`,
a function that plots bar charts in HP bar style.


```r
pokemon[1:10,] %>% 
  gghealth("name","base_total",init.size = 5)+
  labs(x="",y="Stats Total")
```

<img src="{{< blogdown/postref >}}index_files/figure-html/gghealth-1.png" width="100%" style="display: block; margin: auto;" />

### Pokemon Go

Annotate your plots with the logo of your favorite Pok??mon Go team.


```r

p1 <- pokemon %>%
  dplyr::filter(type1=="water") %>%
  ggplot(aes(defense,attack))+geom_point()+annotate_pogo(team = "mystic")+theme_mystic()+
  labs(title="Team Mystic",subtitle="Water Pokemon")

p2 <- pokemon %>%
  dplyr::filter(type1=="fire") %>%
  ggplot(aes(defense,attack))+geom_point()+annotate_pogo(team = "valor")+theme_valor()+
  labs(title="Team Valor",subtitle="Fire Pokemon")

p3 <- pokemon %>%
  dplyr::filter(type1=="electric") %>%
  ggplot(aes(defense,attack))+geom_point()+annotate_pogo(team = "instinct")+theme_instinct()+
  labs(title="Team Instinct",subtitle="Electric Pokemon")

gridExtra::grid.arrange(grobs=list(p1,p2,p3),ncol=3)
```

<img src="{{< blogdown/postref >}}index_files/figure-html/pogo-teams-1.png" width="100%" style="display: block; margin: auto;" />

## Poke Pie

Create pie charts of the color distribution of Pokemon sprites. Download all sprites, for
example from [here](https://github.com/PokeAPI/sprites).


```r
#basic usage
poke_pie(path_to_sprites,pokemon_name)
```

![](https://raw.githubusercontent.com/schochastics/Rokemon/master/figures/poke-pies.png)

The function is a reimplementation of [this](https://gist.github.com/need12648430/4d681c9d1b18745ce159)
code, which was posted on [reddit](https://www.reddit.com/r/pokemon/comments/2ey1pw/last_night_i_wrote_a_processing_script_that/ck45c21/) a while ago.

## Color Palettes

The package also includes color palettes, which were automatically generated from
all 801 pokemon sprites. 

```r
poke_pal(name,n)
display_poke_pal(name)
```
![](https://raw.githubusercontent.com/schochastics/Rokemon/master/figures/palettes.png)

Additionally there is also a palette Pokemon Types, used by `scale_color_poketype()` and
`scale_fill_poketype()`.
![](https://raw.githubusercontent.com/schochastics/Rokemon/master/figures/rocket-type-pal.png)

I did not check all Pokemon palettes, so there may well be
some meaningless ones. A better alternative would be to use the dedicated package `palettetown`.
See the github [repo](https://github.comt/imcdlucas/palettetown) for help. 

```r
install.packages('palettetown')
```

## Fonts

The package uses an old school gameboy font for some of its themes, which
can be download [here](https://github.com/Superpencil/pokemon-font/releases/tag/v1.8.1).

In order to use the font in R you need the `extrafont` package.

```r
#install.packages("extrafont")
extrafont::font_import() #only run ones
extrafont::loadfonts()
```

Alternatively, you can use the function `import_pokefont()`.

```r
import_pokefont()
```

## Example use of data

Using `theme_rocket()` to create an effectiveness table of Pokemon types.

```r
pokemon %>%
  distinct(type1,.keep_all=TRUE) %>%
  select(defender = type1,against_bug:against_water) %>%
  gather(attacker,effect,against_bug:against_water) %>%
  mutate(attacker = str_replace_all(attacker,"against_",""))  %>%
  ggplot(aes(y=attacker,x=defender,fill=factor(effect)))+
  geom_tile()+
  geom_text(aes(label=ifelse(effect!=1,effect,"")))+
  scale_fill_manual(values=c("#8B1A1A", "#CD2626", "#EE2C2C", "#FFFFFF", "#00CD00", "#008B00"))+
  theme_rocket(legend.position="none")+
  labs(title="Effectiveness Table")
```

<img src="{{< blogdown/postref >}}index_files/figure-html/effectiveness-1.png" width="100%" style="display: block; margin: auto;" />

Using Pokemon type colors


```r
ggplot(pokemon,aes(defense,attack))+
  geom_point(aes(col=type1))+
  scale_color_poketype()+
  theme_bw()
```

<img src="{{< blogdown/postref >}}index_files/figure-html/poketype-colors-1.png" width="100%" style="display: block; margin: auto;" />


## Addendum

* Logo created by [ZeroDawn0D](https://github.com/ZeroDawn0D)
* Pogo Logos downloaded [here](https://dribbble.com/shots/2831980-Pok-mon-GO-Team-Logos-Vector-Download)
* Pok??mon data download from [Kaggle](https://www.kaggle.com/rounakbanik/pokemon), originally
scraped from [serebii.net](http://serebii.net/)
* Sprites for `poke_pie` can be found [here](https://github.com/PokeAPI/sprites)
