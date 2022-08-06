---
title: "Creating Hugo Website on Archlinux"
date: 2022-04-30T16:49:30Z
tags: ["Development","Go","fast"]
categories: ["Development","eng"]
draft: false
---

#### this is the second page i make with hugo this is my blog and my website in this short post i will show you how to create a page with hugo in linux so let's start

### Step 1 install Hugo

```
- Pacman -Sy hugo
```
### Step 2 create a new site
```
- hugo new site quickstart
```
### Step 3 Add a theme 

(you can go to themes.gohugo.io/ and search for one)

```
cd quickstart
git init
git submodule add https://github.com/theNewDynamic/gohugo-theme-ananke.git themes/ananke

```
then add theme on config.toml

```
echo theme = \"ananke\" >> config.toml

```

### Step 4 start hugo server

```
hugo server -D

```

Navigate to your new site at http://localhost:1313/.



