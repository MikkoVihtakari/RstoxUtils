# RstoxUtils
**Utility functions for the Stox Project. R package, updated 2021-10-11.**

This package contains utility functions for the Institute of Marine Research's (IMR) Stox Project. The package has two purposes: 1) To function as a showcase and developmental platform for functions that may be included in the future releases of the Stox Project. 2) To provide a collection of functions needed in the internal workflow of the Deep-sea species group at IMR.

## Installation

The package requires [**RstoxData**](https://github.com/StoXProject/RstoxData/releases) [Stox project](https://github.com/StoXProject) packages to function. These packages can be installed by following the links for each package or using the [**devtools**](https://cran.r-project.org/web/packages/devtools/index.html) package. The **RstoxUtils** package can be installed using **devtools** once all Stox project packages are installed correctly. 


```r
devtools::install_github("MikkoVihtakari/RstoxUtils", upgrade = "never")
```

The **RstoxUtils** uses multiple GIS packages developed for R. You may have to update these (Packages -> Update -> Select all -> Install updates in R Studio). 



If the installation of a dependency fails, try installing those packages manually (using RStudio or `install.packages`).

## Usage

Each numbered section below demonstrates a separate functionality in the **RstoxUtils** package. 

### 1. Read IMR .xml files

The IMR database data are distributed as [.xml files of a certain structure](https://confluence.imr.no/display/API/Biotic+V3+API+documentation). The `RstoxData::readXmlFile` function reads these files, but due to the data architecture, information is spread across multiple data frames in the standard format. The `RstoxUtils::processBioticFile` function combines the data in station-based (`stnall` element in the list architecture) and individual fish-based (`indall`) formats. The `RstoxUtils::processBioticFiles` function does the same for multiple .xml files.


```r
xml.example <- system.file("extdata", "example.xml", package = "RstoxUtils")

standard.format <- RstoxData::readXmlFile(xml.example)

## The data are as a list organized under multiple data.frames
names(standard.format)
#>  [1] "missions"                       "mission"                       
#>  [3] "fishstation"                    "catchsample"                   
#>  [5] "individual"                     "prey"                          
#>  [7] "agedetermination"               "preylengthfrequencytable"      
#>  [9] "copepodedevstagefrequencytable" "tag"                           
#> [11] "metadata"
## Station-based data are organized under 3 data frames
dim(standard.format$mission)
#> [1]  6 11
dim(standard.format$fishstation)
#> [1] 59 74
dim(standard.format$catchsample)
#> [1] 84 36
## Individual-based data have 2 additional data frames
dim(standard.format$individual)
#> [1] 446  56
dim(standard.format$agedetermination)
#> [1] 52 39
## The user has to merge these data frames to work with the data
## RstoxUtils addresses this issue and merges the data

library(RstoxUtils)

Utils.format <- RstoxUtils::processBioticFile(xml.example)

## Station-based data can now be found from 1 data frame

dim(Utils.format$stnall)
#> [1] 84 56
## The same applies for individual-based-data 
dim(Utils.format$indall)
#> [1] 498  64
## The uniting ID tags in the Utils format are
# missionid, startyear, serialno, catchsampleid and sometimes cruise for station based format
# The abovementioned and specimenid
```

*NOTE:* The `RstoxUtils::processBioticFile` function have not been modified to use the improvements made to the 0.6.3 version of the `RstoxData::readXmlFile` function yet. The modifications will make the `processBioticFile` quicker as some corrections from this function were implemented in the master function. Also, the ID tags have not been proofed yet. This note will disappear once the fixes have been made. 

### 2. Make strata for stock assessment

Moved to the [RstoxStrata](https://github.com/DeepWaterIMR/RstoxStrata) package. 

## 3. Read electronic logbook data

The detailed electronic logbook data can be read using the `extractLogbook()` function. These data are confidential and require a special access to the folder on the server where they are located. If you need such access (and work at IMR), take contact with the data people at your group. Those who have the access, know where the data are located. The `path` argument should point to the folder of interest on the server (*elFangstdagbok_detaljert* for all data). The path can be defined on Mac (and Linux) as `path = "/Volumes/.../elFangstdagbok_detaljert"` and as `path = Q:/.../elFangstdagbok_detaljert` on Windows, where `...` represents the entire folder path that cannot be shown here. You can copy the folder location as path to your clip-board and past it the `extractLogbook()` function. Remember to use quotes (i.e. `" "`).

The function is slow especially in Tromsø (prepare for 30 min to 1 h). It filters species out of the logbook data based on codes listed in the table under. For example, all Atlantic halibut can be extracted as follows:


```r
extractLogbook(path, species = "HAL")
```

Or as:


```r
extractLogbook(path, species = 2311) # Excluding farmed fish
```

The species name will be returned in Norwegian, English or Latin depending on the `language` argument.

<table class="table table-striped table-condensed" style="margin-left: auto; margin-right: auto;">
<caption>List of Directorate of Fisheries species codes. Use idNS or idFAO codes as species argument in the extractLogbook function.</caption>
 <thead>
  <tr>
   <th style="text-align:right;"> idNS </th>
   <th style="text-align:left;"> idFAO </th>
   <th style="text-align:left;"> norwegian </th>
   <th style="text-align:left;"> english </th>
   <th style="text-align:left;"> latin </th>
  </tr>
 </thead>
<tbody>
  <tr>
   <td style="text-align:right;"> 1 </td>
   <td style="text-align:left;"> NA </td>
   <td style="text-align:left;"> FERSKVANNSFISK </td>
   <td style="text-align:left;"> NA </td>
   <td style="text-align:left;"> OSTEICHTHYES </td>
  </tr>
  <tr>
   <td style="text-align:right;"> 101 </td>
   <td style="text-align:left;"> LAS </td>
   <td style="text-align:left;"> Niøye, uspes. </td>
   <td style="text-align:left;"> Lampreys nei </td>
   <td style="text-align:left;"> Petromyzontidae </td>
  </tr>
  <tr>
   <td style="text-align:right;"> 102 </td>
   <td style="text-align:left;"> FPI </td>
   <td style="text-align:left;"> Gjedde </td>
   <td style="text-align:left;"> Northern pike </td>
   <td style="text-align:left;"> Esox lucius </td>
  </tr>
  <tr>
   <td style="text-align:right;"> 103 </td>
   <td style="text-align:left;"> FBR </td>
   <td style="text-align:left;"> Ferskvannsbrasme, uspes. </td>
   <td style="text-align:left;"> Freshwater breams nei </td>
   <td style="text-align:left;"> Abramis spp </td>
  </tr>
  <tr>
   <td style="text-align:right;"> 104 </td>
   <td style="text-align:left;"> FCP </td>
   <td style="text-align:left;"> Karpe </td>
   <td style="text-align:left;"> Common carp </td>
   <td style="text-align:left;"> Cyprinus carpio </td>
  </tr>
  <tr>
   <td style="text-align:right;"> 105 </td>
   <td style="text-align:left;"> FTE </td>
   <td style="text-align:left;"> Suter </td>
   <td style="text-align:left;"> Tench </td>
   <td style="text-align:left;"> Tinca tinca </td>
  </tr>
  <tr>
   <td style="text-align:right;"> 106 </td>
   <td style="text-align:left;"> FCC </td>
   <td style="text-align:left;"> Karuss </td>
   <td style="text-align:left;"> Crucian carp </td>
   <td style="text-align:left;"> Carassius carassius </td>
  </tr>
  <tr>
   <td style="text-align:right;"> 107 </td>
   <td style="text-align:left;"> FRO </td>
   <td style="text-align:left;"> Mort </td>
   <td style="text-align:left;"> Roach </td>
   <td style="text-align:left;"> Rutilus rutilus </td>
  </tr>
  <tr>
   <td style="text-align:right;"> 108 </td>
   <td style="text-align:left;"> FBU </td>
   <td style="text-align:left;"> Lake </td>
   <td style="text-align:left;"> Burbot </td>
   <td style="text-align:left;"> Lota lota </td>
  </tr>
  <tr>
   <td style="text-align:right;"> 109 </td>
   <td style="text-align:left;"> FPE </td>
   <td style="text-align:left;"> Abbor </td>
   <td style="text-align:left;"> European perch </td>
   <td style="text-align:left;"> Perca fluviatilis </td>
  </tr>
  <tr>
   <td style="text-align:right;"> 111 </td>
   <td style="text-align:left;"> FPP </td>
   <td style="text-align:left;"> Gjørs </td>
   <td style="text-align:left;"> Pike perch </td>
   <td style="text-align:left;"> Stizostedion  lucioperca </td>
  </tr>
  <tr>
   <td style="text-align:right;"> 112 </td>
   <td style="text-align:left;"> STU </td>
   <td style="text-align:left;"> Stør,uspes </td>
   <td style="text-align:left;"> Sturgeons </td>
   <td style="text-align:left;"> Acipenseridae </td>
  </tr>
  <tr>
   <td style="text-align:right;"> 113 </td>
   <td style="text-align:left;"> SHD </td>
   <td style="text-align:left;"> Maisild, stamsild, uspes. </td>
   <td style="text-align:left;"> Allis and twaite shads </td>
   <td style="text-align:left;"> Alosa spp </td>
  </tr>
  <tr>
   <td style="text-align:right;"> 114 </td>
   <td style="text-align:left;"> FID </td>
   <td style="text-align:left;"> Vederbuk </td>
   <td style="text-align:left;"> Orfe(Ide) </td>
   <td style="text-align:left;"> Leuciscus idus </td>
  </tr>
  <tr>
   <td style="text-align:right;"> 115 </td>
   <td style="text-align:left;"> SME </td>
   <td style="text-align:left;"> Krøkle </td>
   <td style="text-align:left;"> European smelt </td>
   <td style="text-align:left;"> Osmerus eperlanus </td>
  </tr>
  <tr>
   <td style="text-align:right;"> 116 </td>
   <td style="text-align:left;"> FBM </td>
   <td style="text-align:left;"> Vanlig Ferskvannsbrasme </td>
   <td style="text-align:left;"> Freshwater bream </td>
   <td style="text-align:left;"> Abramis brama </td>
  </tr>
  <tr>
   <td style="text-align:right;"> 117 </td>
   <td style="text-align:left;"> APU </td>
   <td style="text-align:left;"> Stør </td>
   <td style="text-align:left;"> Sturgeon </td>
   <td style="text-align:left;"> Acipenser Sturio </td>
  </tr>
  <tr>
   <td style="text-align:right;"> 11801 </td>
   <td style="text-align:left;"> APB </td>
   <td style="text-align:left;"> Sibirsk stør (oppdrett) </td>
   <td style="text-align:left;"> Siberian sturgeon </td>
   <td style="text-align:left;"> Acipenser baerii </td>
  </tr>
  <tr>
   <td style="text-align:right;"> 11901 </td>
   <td style="text-align:left;"> APG </td>
   <td style="text-align:left;"> Russisk stør (oppdrett) </td>
   <td style="text-align:left;"> Danube sturgeon (=Osetr) </td>
   <td style="text-align:left;"> Acipenser gueldenstaedtii </td>
  </tr>
  <tr>
   <td style="text-align:right;"> 12001 </td>
   <td style="text-align:left;"> APR </td>
   <td style="text-align:left;"> Sterlet stør (oppdrett) </td>
   <td style="text-align:left;"> Sterlet sturgeon </td>
   <td style="text-align:left;"> Acipenser ruthenus </td>
  </tr>
  <tr>
   <td style="text-align:right;"> 121 </td>
   <td style="text-align:left;"> SRE </td>
   <td style="text-align:left;"> Sørv </td>
   <td style="text-align:left;"> Rudd </td>
   <td style="text-align:left;"> Scardinius erythrophthalmus </td>
  </tr>
  <tr>
   <td style="text-align:right;"> 199 </td>
   <td style="text-align:left;"> FRF </td>
   <td style="text-align:left;"> Andre ferskvannsfisker </td>
   <td style="text-align:left;"> Freshwater fishes </td>
   <td style="text-align:left;"> Osteichthyes </td>
  </tr>
  <tr>
   <td style="text-align:right;"> 2 </td>
   <td style="text-align:left;"> NA </td>
   <td style="text-align:left;"> SILDEHAIER </td>
   <td style="text-align:left;"> NA </td>
   <td style="text-align:left;"> LAMNOIDEI </td>
  </tr>
  <tr>
   <td style="text-align:right;"> 21 </td>
   <td style="text-align:left;"> NA </td>
   <td style="text-align:left;"> Håbrannfamilien </td>
   <td style="text-align:left;"> NA </td>
   <td style="text-align:left;"> Lamnidae </td>
  </tr>
  <tr>
   <td style="text-align:right;"> 211 </td>
   <td style="text-align:left;"> POR </td>
   <td style="text-align:left;"> Håbrann </td>
   <td style="text-align:left;"> Porbeagle </td>
   <td style="text-align:left;"> Lamna nasus </td>
  </tr>
  <tr>
   <td style="text-align:right;"> 212 </td>
   <td style="text-align:left;"> BSK </td>
   <td style="text-align:left;"> Brugde </td>
   <td style="text-align:left;"> Basking shark </td>
   <td style="text-align:left;"> Cetorhinus maximus </td>
  </tr>
  <tr>
   <td style="text-align:right;"> 213 </td>
   <td style="text-align:left;"> SMA </td>
   <td style="text-align:left;"> Makrellhai </td>
   <td style="text-align:left;"> Shortfin mako </td>
   <td style="text-align:left;"> Isurus oxyrinchus </td>
  </tr>
  <tr>
   <td style="text-align:right;"> 22 </td>
   <td style="text-align:left;"> NA </td>
   <td style="text-align:left;"> NA </td>
   <td style="text-align:left;"> Sand tigers </td>
   <td style="text-align:left;"> Odontaspididae </td>
  </tr>
  <tr>
   <td style="text-align:right;"> 221 </td>
   <td style="text-align:left;"> CCT </td>
   <td style="text-align:left;"> Sand tiger shark </td>
   <td style="text-align:left;"> Sand tiger shark </td>
   <td style="text-align:left;"> Carcharias taurus </td>
  </tr>
  <tr>
   <td style="text-align:right;"> 23 </td>
   <td style="text-align:left;"> NA </td>
   <td style="text-align:left;"> Revehaifamilien </td>
   <td style="text-align:left;"> Tresher sharks </td>
   <td style="text-align:left;"> Alopiidae </td>
  </tr>
  <tr>
   <td style="text-align:right;"> 231 </td>
   <td style="text-align:left;"> ALV </td>
   <td style="text-align:left;"> Revehai </td>
   <td style="text-align:left;"> Tresher </td>
   <td style="text-align:left;"> Alopias vulpinus </td>
  </tr>
  <tr>
   <td style="text-align:right;"> 3 </td>
   <td style="text-align:left;"> NA </td>
   <td style="text-align:left;"> RØDHAIER </td>
   <td style="text-align:left;"> NA </td>
   <td style="text-align:left;"> SCYLIORHINOIDEI </td>
  </tr>
  <tr>
   <td style="text-align:right;"> 311 </td>
   <td style="text-align:left;"> BSH </td>
   <td style="text-align:left;"> Blåhai </td>
   <td style="text-align:left;"> Blueshark </td>
   <td style="text-align:left;"> Prionace glauca </td>
  </tr>
  <tr>
   <td style="text-align:right;"> 312 </td>
   <td style="text-align:left;"> SHO </td>
   <td style="text-align:left;"> Hågjel </td>
   <td style="text-align:left;"> Blackmouth catshark </td>
   <td style="text-align:left;"> Galeus melastomus </td>
  </tr>
  <tr>
   <td style="text-align:right;"> 313 </td>
   <td style="text-align:left;"> SYC </td>
   <td style="text-align:left;"> Småflekket rødhai </td>
   <td style="text-align:left;"> Small-spotted catshark </td>
   <td style="text-align:left;"> Scyliorhinus canicula </td>
  </tr>
  <tr>
   <td style="text-align:right;"> 314 </td>
   <td style="text-align:left;"> API </td>
   <td style="text-align:left;"> Deep-water catsharks </td>
   <td style="text-align:left;"> Deep-water catsharks </td>
   <td style="text-align:left;"> Apristurus </td>
  </tr>
  <tr>
   <td style="text-align:right;"> 315 </td>
   <td style="text-align:left;"> PTM </td>
   <td style="text-align:left;"> False catshark </td>
   <td style="text-align:left;"> False catshark </td>
   <td style="text-align:left;"> Pseudotriakis microdon </td>
  </tr>
  <tr>
   <td style="text-align:right;"> 316 </td>
   <td style="text-align:left;"> GAU </td>
   <td style="text-align:left;"> Crest-tail catsharks nei </td>
   <td style="text-align:left;"> Crest-tail catsharks nei </td>
   <td style="text-align:left;"> Galeus spp </td>
  </tr>
  <tr>
   <td style="text-align:right;"> 317 </td>
   <td style="text-align:left;"> RHT </td>
   <td style="text-align:left;"> Atlantic sharpnose shark </td>
   <td style="text-align:left;"> Atlantic sharpnose shark </td>
   <td style="text-align:left;"> Rhizipeinodon terraenovae </td>
  </tr>
  <tr>
   <td style="text-align:right;"> 318 </td>
   <td style="text-align:left;"> GAM </td>
   <td style="text-align:left;"> Mouse catshark </td>
   <td style="text-align:left;"> Mouse catshark </td>
   <td style="text-align:left;"> Galeus murinus </td>
  </tr>
  <tr>
   <td style="text-align:right;"> 319 </td>
   <td style="text-align:left;"> SCL </td>
   <td style="text-align:left;"> Catcharks, nursehounds nei </td>
   <td style="text-align:left;"> Catcharks, nursehounds nei </td>
   <td style="text-align:left;"> Scyliorhinus spp </td>
  </tr>
  <tr>
   <td style="text-align:right;"> 321 </td>
   <td style="text-align:left;"> GAG </td>
   <td style="text-align:left;"> Gråhai </td>
   <td style="text-align:left;"> Tope shark </td>
   <td style="text-align:left;"> Galeorhinus galeus </td>
  </tr>
  <tr>
   <td style="text-align:right;"> 322 </td>
   <td style="text-align:left;"> DUS </td>
   <td style="text-align:left;"> Dusky shark </td>
   <td style="text-align:left;"> Dusky shark </td>
   <td style="text-align:left;"> Cacharinus obscurus </td>
  </tr>
  <tr>
   <td style="text-align:right;"> 323 </td>
   <td style="text-align:left;"> FAL </td>
   <td style="text-align:left;"> Silkehai </td>
   <td style="text-align:left;"> Silky shark </td>
   <td style="text-align:left;"> Cacharhinus falciformis </td>
  </tr>
  <tr>
   <td style="text-align:right;"> 4 </td>
   <td style="text-align:left;"> NA </td>
   <td style="text-align:left;"> HÅER </td>
   <td style="text-align:left;"> NA </td>
   <td style="text-align:left;"> SQUALIFORMES </td>
  </tr>
  <tr>
   <td style="text-align:right;"> 411 </td>
   <td style="text-align:left;"> GSK </td>
   <td style="text-align:left;"> Håkjerring </td>
   <td style="text-align:left;"> Greenland shark </td>
   <td style="text-align:left;"> Somniosus microcephalus </td>
  </tr>
  <tr>
   <td style="text-align:right;"> 412 </td>
   <td style="text-align:left;"> DGS </td>
   <td style="text-align:left;"> Pigghå </td>
   <td style="text-align:left;"> Picked dogfish </td>
   <td style="text-align:left;"> Squalus acanthias </td>
  </tr>
  <tr>
   <td style="text-align:right;"> 413 </td>
   <td style="text-align:left;"> DGX </td>
   <td style="text-align:left;"> Håer, uspes </td>
   <td style="text-align:left;"> Dogfish sharks nei </td>
   <td style="text-align:left;"> Squalidae </td>
  </tr>
  <tr>
   <td style="text-align:right;"> 414 </td>
   <td style="text-align:left;"> DGH </td>
   <td style="text-align:left;"> Annen hå </td>
   <td style="text-align:left;"> Dogfishes and hounds </td>
   <td style="text-align:left;"> Squalidae  Scyliorhinidae </td>
  </tr>
  <tr>
   <td style="text-align:right;"> 415 </td>
   <td style="text-align:left;"> CFB </td>
   <td style="text-align:left;"> Islandshå </td>
   <td style="text-align:left;"> Black dogfish </td>
   <td style="text-align:left;"> Centroscyllium fabricii </td>
  </tr>
  <tr>
   <td style="text-align:right;"> 416 </td>
   <td style="text-align:left;"> SOR </td>
   <td style="text-align:left;"> Little sleeper shark </td>
   <td style="text-align:left;"> Little sleeper shark </td>
   <td style="text-align:left;"> Somnius rostratus </td>
  </tr>
  <tr>
   <td style="text-align:right;"> 417 </td>
   <td style="text-align:left;"> SCK </td>
   <td style="text-align:left;"> Spansk håkjerring </td>
   <td style="text-align:left;"> Kitefin shark </td>
   <td style="text-align:left;"> Dalatias licha </td>
  </tr>
  <tr>
   <td style="text-align:right;"> 418 </td>
   <td style="text-align:left;"> SHB </td>
   <td style="text-align:left;"> Tagghai </td>
   <td style="text-align:left;"> Bramble shark </td>
   <td style="text-align:left;"> Echinorhinus brucus </td>
  </tr>
  <tr>
   <td style="text-align:right;"> 419 </td>
   <td style="text-align:left;"> DGX </td>
   <td style="text-align:left;"> Dogfishes nei </td>
   <td style="text-align:left;"> Dogfishes nei </td>
   <td style="text-align:left;"> Squalidae </td>
  </tr>
  <tr>
   <td style="text-align:right;"> 420 </td>
   <td style="text-align:left;"> GUP </td>
   <td style="text-align:left;"> Gulper shark </td>
   <td style="text-align:left;"> Gulper shark </td>
   <td style="text-align:left;"> Centrophorus granulosus </td>
  </tr>
  <tr>
   <td style="text-align:right;"> 430 </td>
   <td style="text-align:left;"> GUQ </td>
   <td style="text-align:left;"> Brunhå </td>
   <td style="text-align:left;"> Shark gulper, leafscale </td>
   <td style="text-align:left;"> Centrophorus squamosus </td>
  </tr>
  <tr>
   <td style="text-align:right;"> 431 </td>
   <td style="text-align:left;"> CYO </td>
   <td style="text-align:left;"> Dypvannshå </td>
   <td style="text-align:left;"> Portuguese dogfish </td>
   <td style="text-align:left;"> Centroscymus coelolepis </td>
  </tr>
  <tr>
   <td style="text-align:right;"> 432 </td>
   <td style="text-align:left;"> DCA </td>
   <td style="text-align:left;"> Gråhå </td>
   <td style="text-align:left;"> Birdbeak dogfish </td>
   <td style="text-align:left;"> Deania calceus </td>
  </tr>
  <tr>
   <td style="text-align:right;"> 433 </td>
   <td style="text-align:left;"> CYP </td>
   <td style="text-align:left;"> Bunnhå </td>
   <td style="text-align:left;"> Longnose velvet dogfish </td>
   <td style="text-align:left;"> Centroscymnus crepidater </td>
  </tr>
  <tr>
   <td style="text-align:right;"> 434 </td>
   <td style="text-align:left;"> SHL </td>
   <td style="text-align:left;"> Svarthå, uspes. </td>
   <td style="text-align:left;"> Lanternsharks nei </td>
   <td style="text-align:left;"> Etmopterus spp </td>
  </tr>
  <tr>
   <td style="text-align:right;"> 435 </td>
   <td style="text-align:left;"> ETX </td>
   <td style="text-align:left;"> Svarthå </td>
   <td style="text-align:left;"> Velvet belly </td>
   <td style="text-align:left;"> Etmopterus spinax </td>
  </tr>
  <tr>
   <td style="text-align:right;"> 436 </td>
   <td style="text-align:left;"> OXN </td>
   <td style="text-align:left;"> Tornhå </td>
   <td style="text-align:left;"> Sailfin roughshark </td>
   <td style="text-align:left;"> Oxynotus paradoxus </td>
  </tr>
  <tr>
   <td style="text-align:right;"> 437 </td>
   <td style="text-align:left;"> SYR </td>
   <td style="text-align:left;"> Kortpigget hå </td>
   <td style="text-align:left;"> Knifetooth dogfish </td>
   <td style="text-align:left;"> Scymnodon ringens </td>
  </tr>
  <tr>
   <td style="text-align:right;"> 438 </td>
   <td style="text-align:left;"> GUP </td>
   <td style="text-align:left;"> Gulper shark </td>
   <td style="text-align:left;"> Gulper shark </td>
   <td style="text-align:left;"> Centrophorus granulosus </td>
  </tr>
  <tr>
   <td style="text-align:right;"> 42 </td>
   <td style="text-align:left;"> NA </td>
   <td style="text-align:left;"> Havengelfamilien </td>
   <td style="text-align:left;"> NA </td>
   <td style="text-align:left;"> Squatinidae </td>
  </tr>
  <tr>
   <td style="text-align:right;"> 421 </td>
   <td style="text-align:left;"> ASK </td>
   <td style="text-align:left;"> Havengler, uspes. </td>
   <td style="text-align:left;"> Angelsharks, sand devils nei </td>
   <td style="text-align:left;"> Squatinidae </td>
  </tr>
  <tr>
   <td style="text-align:right;"> 499 </td>
   <td style="text-align:left;"> SKH </td>
   <td style="text-align:left;"> Annen hai </td>
   <td style="text-align:left;"> Various sharks nei </td>
   <td style="text-align:left;"> Selachimorpha (Pleurotremata) </td>
  </tr>
  <tr>
   <td style="text-align:right;"> 5 </td>
   <td style="text-align:left;"> NA </td>
   <td style="text-align:left;"> SKATER OG ROKKER </td>
   <td style="text-align:left;"> NA </td>
   <td style="text-align:left;"> RAJIFORMES </td>
  </tr>
  <tr>
   <td style="text-align:right;"> 51 </td>
   <td style="text-align:left;"> NA </td>
   <td style="text-align:left;"> Skatefamilien </td>
   <td style="text-align:left;"> NA </td>
   <td style="text-align:left;"> Rajidae </td>
  </tr>
  <tr>
   <td style="text-align:right;"> 511 </td>
   <td style="text-align:left;"> RJB </td>
   <td style="text-align:left;"> Storskate </td>
   <td style="text-align:left;"> Blue skate </td>
   <td style="text-align:left;"> Raja batis </td>
  </tr>
  <tr>
   <td style="text-align:right;"> 512 </td>
   <td style="text-align:left;"> RJC </td>
   <td style="text-align:left;"> Piggskate </td>
   <td style="text-align:left;"> Thornback ray </td>
   <td style="text-align:left;"> Raja clavata </td>
  </tr>
  <tr>
   <td style="text-align:right;"> 513 </td>
   <td style="text-align:left;"> RJM </td>
   <td style="text-align:left;"> Flekkskate </td>
   <td style="text-align:left;"> Spotted ray </td>
   <td style="text-align:left;"> Raja montagui </td>
  </tr>
  <tr>
   <td style="text-align:right;"> 514 </td>
   <td style="text-align:left;"> RJF </td>
   <td style="text-align:left;"> Nebbskate </td>
   <td style="text-align:left;"> Shagreen ray </td>
   <td style="text-align:left;"> Raja fullonica </td>
  </tr>
  <tr>
   <td style="text-align:right;"> 515 </td>
   <td style="text-align:left;"> RJN </td>
   <td style="text-align:left;"> Gjøkskate </td>
   <td style="text-align:left;"> Cuckoo ray </td>
   <td style="text-align:left;"> Raja naevus </td>
  </tr>
  <tr>
   <td style="text-align:right;"> 516 </td>
   <td style="text-align:left;"> RJO </td>
   <td style="text-align:left;"> Spisskate </td>
   <td style="text-align:left;"> Longnosed skate </td>
   <td style="text-align:left;"> Raja oxyrinchus </td>
  </tr>
  <tr>
   <td style="text-align:right;"> 517 </td>
   <td style="text-align:left;"> RJD </td>
   <td style="text-align:left;"> Little skate </td>
   <td style="text-align:left;"> Little skate </td>
   <td style="text-align:left;"> Raja erinacea </td>
  </tr>
  <tr>
   <td style="text-align:right;"> 518 </td>
   <td style="text-align:left;"> RJL </td>
   <td style="text-align:left;"> Barndoor skate </td>
   <td style="text-align:left;"> Barndoor skate </td>
   <td style="text-align:left;"> Raja laevis </td>
  </tr>
  <tr>
   <td style="text-align:right;"> 519 </td>
   <td style="text-align:left;"> RJT </td>
   <td style="text-align:left;"> Winter skate </td>
   <td style="text-align:left;"> Winter skate </td>
   <td style="text-align:left;"> Raja ocellata </td>
  </tr>
  <tr>
   <td style="text-align:right;"> 520 </td>
   <td style="text-align:left;"> RJR </td>
   <td style="text-align:left;"> Kloskate </td>
   <td style="text-align:left;"> Starry ray </td>
   <td style="text-align:left;"> Raja radiata </td>
  </tr>
  <tr>
   <td style="text-align:right;"> 521 </td>
   <td style="text-align:left;"> RJS </td>
   <td style="text-align:left;"> Smooth skate </td>
   <td style="text-align:left;"> Smooth skate </td>
   <td style="text-align:left;"> Malacoraja senta </td>
  </tr>
  <tr>
   <td style="text-align:right;"> 522 </td>
   <td style="text-align:left;"> RJQ </td>
   <td style="text-align:left;"> Gråskate </td>
   <td style="text-align:left;"> Spinetail ray </td>
   <td style="text-align:left;"> Bathyraja spinicauda </td>
  </tr>
  <tr>
   <td style="text-align:right;"> 523 </td>
   <td style="text-align:left;"> RJH </td>
   <td style="text-align:left;"> Blonde ray </td>
   <td style="text-align:left;"> Blonde ray </td>
   <td style="text-align:left;"> Raja brachyura </td>
  </tr>
  <tr>
   <td style="text-align:right;"> 524 </td>
   <td style="text-align:left;"> RJI </td>
   <td style="text-align:left;"> Sandskate </td>
   <td style="text-align:left;"> Sandy ray </td>
   <td style="text-align:left;"> Raja circularis </td>
  </tr>
  <tr>
   <td style="text-align:right;"> 525 </td>
   <td style="text-align:left;"> RJY </td>
   <td style="text-align:left;"> Rundskate </td>
   <td style="text-align:left;"> Round ray </td>
   <td style="text-align:left;"> Raja fyllae </td>
  </tr>
  <tr>
   <td style="text-align:right;"> 526 </td>
   <td style="text-align:left;"> RJE </td>
   <td style="text-align:left;"> Småøyet skate </td>
   <td style="text-align:left;"> Small-eyed ray </td>
   <td style="text-align:left;"> Raja microocellata </td>
  </tr>
  <tr>
   <td style="text-align:right;"> 527 </td>
   <td style="text-align:left;"> RJU </td>
   <td style="text-align:left;"> Bølgeskate </td>
   <td style="text-align:left;"> Undulate ray </td>
   <td style="text-align:left;"> Raja undulata </td>
  </tr>
  <tr>
   <td style="text-align:right;"> 528 </td>
   <td style="text-align:left;"> RJA </td>
   <td style="text-align:left;"> Burton-skate </td>
   <td style="text-align:left;"> White skate </td>
   <td style="text-align:left;"> Raja alba </td>
  </tr>
  <tr>
   <td style="text-align:right;"> 529 </td>
   <td style="text-align:left;"> SKA </td>
   <td style="text-align:left;"> Skate, uspesifisert </td>
   <td style="text-align:left;"> Raja rays nei </td>
   <td style="text-align:left;"> Raja spp </td>
  </tr>
  <tr>
   <td style="text-align:right;"> 53 </td>
   <td style="text-align:left;"> NA </td>
   <td style="text-align:left;"> Ørneskatefamilien </td>
   <td style="text-align:left;"> NA </td>
   <td style="text-align:left;"> Myliobatidae </td>
  </tr>
  <tr>
   <td style="text-align:right;"> 531 </td>
   <td style="text-align:left;"> EAG </td>
   <td style="text-align:left;"> Ørneskate, uspes. </td>
   <td style="text-align:left;"> Eagle rays nei </td>
   <td style="text-align:left;"> Myliobatidae </td>
  </tr>
  <tr>
   <td style="text-align:right;"> 54 </td>
   <td style="text-align:left;"> NA </td>
   <td style="text-align:left;"> Elrokkefamilien </td>
   <td style="text-align:left;"> NA </td>
   <td style="text-align:left;"> Torpedinidae </td>
  </tr>
  <tr>
   <td style="text-align:right;"> 541 </td>
   <td style="text-align:left;"> TOE </td>
   <td style="text-align:left;"> Elrokke </td>
   <td style="text-align:left;"> Torpedo rays </td>
   <td style="text-align:left;"> Torpedo spp </td>
  </tr>
  <tr>
   <td style="text-align:right;"> 55 </td>
   <td style="text-align:left;"> NA </td>
   <td style="text-align:left;"> Skatefamilien </td>
   <td style="text-align:left;"> NA </td>
   <td style="text-align:left;"> Rajidae </td>
  </tr>
  <tr>
   <td style="text-align:right;"> 551 </td>
   <td style="text-align:left;"> JAD </td>
   <td style="text-align:left;"> Svartskate </td>
   <td style="text-align:left;"> Norwegian skate </td>
   <td style="text-align:left;"> Raja nidarosiensis </td>
  </tr>
  <tr>
   <td style="text-align:right;"> 552 </td>
   <td style="text-align:left;"> RJG </td>
   <td style="text-align:left;"> Isskate </td>
   <td style="text-align:left;"> Arctic skate </td>
   <td style="text-align:left;"> Raja hyperborea </td>
  </tr>
  <tr>
   <td style="text-align:right;"> 553 </td>
   <td style="text-align:left;"> RJK </td>
   <td style="text-align:left;"> Hvitskate </td>
   <td style="text-align:left;"> Sailray </td>
   <td style="text-align:left;"> Raja lintea </td>
  </tr>
  <tr>
   <td style="text-align:right;"> 559 </td>
   <td style="text-align:left;"> RAJ </td>
   <td style="text-align:left;"> Skater uspes. </td>
   <td style="text-align:left;"> Rays and skates nei </td>
   <td style="text-align:left;"> Rajidae </td>
  </tr>
  <tr>
   <td style="text-align:right;"> 599 </td>
   <td style="text-align:left;"> SRX </td>
   <td style="text-align:left;"> Annen skate og rokke </td>
   <td style="text-align:left;"> Rays, stingrays, mantas nei </td>
   <td style="text-align:left;"> Rajiformes </td>
  </tr>
  <tr>
   <td style="text-align:right;"> 6 </td>
   <td style="text-align:left;"> NA </td>
   <td style="text-align:left;"> SILDEFISKER </td>
   <td style="text-align:left;"> NA </td>
   <td style="text-align:left;"> CLUPEIFORMES </td>
  </tr>
  <tr>
   <td style="text-align:right;"> 61 </td>
   <td style="text-align:left;"> NA </td>
   <td style="text-align:left;"> Sildefamilien </td>
   <td style="text-align:left;"> NA </td>
   <td style="text-align:left;"> Clupeidae </td>
  </tr>
  <tr>
   <td style="text-align:right;"> 611 </td>
   <td style="text-align:left;"> HER </td>
   <td style="text-align:left;"> Sild </td>
   <td style="text-align:left;"> Atlantic herring </td>
   <td style="text-align:left;"> Clupea harengus </td>
  </tr>
  <tr>
   <td style="text-align:right;"> 61101 </td>
   <td style="text-align:left;"> HER </td>
   <td style="text-align:left;"> Norsk vårgytende sild </td>
   <td style="text-align:left;"> Atlantic herring </td>
   <td style="text-align:left;"> Clupea harengus </td>
  </tr>
  <tr>
   <td style="text-align:right;"> 61102 </td>
   <td style="text-align:left;"> HER </td>
   <td style="text-align:left;"> Trondheimsfjordsild </td>
   <td style="text-align:left;"> Atlantic herring </td>
   <td style="text-align:left;"> Clupea harengus </td>
  </tr>
  <tr>
   <td style="text-align:right;"> 61103 </td>
   <td style="text-align:left;"> HER </td>
   <td style="text-align:left;"> Mussa </td>
   <td style="text-align:left;"> Atlantic herring </td>
   <td style="text-align:left;"> Clupea harengus </td>
  </tr>
  <tr>
   <td style="text-align:right;"> 61104 </td>
   <td style="text-align:left;"> HER </td>
   <td style="text-align:left;"> Nordsjøsild </td>
   <td style="text-align:left;"> Atlantic herring </td>
   <td style="text-align:left;"> Clupea harengus </td>
  </tr>
  <tr>
   <td style="text-align:right;"> 61105 </td>
   <td style="text-align:left;"> HER </td>
   <td style="text-align:left;"> Skagerraksild </td>
   <td style="text-align:left;"> Atlantic herring </td>
   <td style="text-align:left;"> Clupea harengus </td>
  </tr>
  <tr>
   <td style="text-align:right;"> 61106 </td>
   <td style="text-align:left;"> HER </td>
   <td style="text-align:left;"> Sild vest av 4 graden </td>
   <td style="text-align:left;"> Atlantic herring </td>
   <td style="text-align:left;"> Clupea harengus </td>
  </tr>
  <tr>
   <td style="text-align:right;"> 61107 </td>
   <td style="text-align:left;"> HER </td>
   <td style="text-align:left;"> Fjordsild </td>
   <td style="text-align:left;"> Atlantic herring </td>
   <td style="text-align:left;"> Clupea harengus </td>
  </tr>
  <tr>
   <td style="text-align:right;"> 612 </td>
   <td style="text-align:left;"> SIX </td>
   <td style="text-align:left;"> Annen sardin </td>
   <td style="text-align:left;"> Sardinellas </td>
   <td style="text-align:left;"> Sardinella spp </td>
  </tr>
  <tr>
   <td style="text-align:right;"> 613 </td>
   <td style="text-align:left;"> MHA </td>
   <td style="text-align:left;"> Atlantic menhaden </td>
   <td style="text-align:left;"> Atlantic menhaden </td>
   <td style="text-align:left;"> Brevoortia tyrannus </td>
  </tr>
  <tr>
   <td style="text-align:right;"> 614 </td>
   <td style="text-align:left;"> PIL </td>
   <td style="text-align:left;"> Sardin </td>
   <td style="text-align:left;"> European pilchard </td>
   <td style="text-align:left;"> Sardina pilchardus </td>
  </tr>
  <tr>
   <td style="text-align:right;"> 615 </td>
   <td style="text-align:left;"> SPR </td>
   <td style="text-align:left;"> Brisling </td>
   <td style="text-align:left;"> European sprat </td>
   <td style="text-align:left;"> Sprattus sprattus </td>
  </tr>
  <tr>
   <td style="text-align:right;"> 61501 </td>
   <td style="text-align:left;"> SPR </td>
   <td style="text-align:left;"> Havbrisling </td>
   <td style="text-align:left;"> European sprat </td>
   <td style="text-align:left;"> Sprattus sprattus </td>
  </tr>
  <tr>
   <td style="text-align:right;"> 61502 </td>
   <td style="text-align:left;"> SPR </td>
   <td style="text-align:left;"> Kystbrisling </td>
   <td style="text-align:left;"> European sprat </td>
   <td style="text-align:left;"> Sprattus sprattus </td>
  </tr>
  <tr>
   <td style="text-align:right;"> 616 </td>
   <td style="text-align:left;"> ALE </td>
   <td style="text-align:left;"> Alewife </td>
   <td style="text-align:left;"> Alewife </td>
   <td style="text-align:left;"> Alosa pseudoharengus </td>
  </tr>
  <tr>
   <td style="text-align:right;"> 62 </td>
   <td style="text-align:left;"> NA </td>
   <td style="text-align:left;"> Ansjosfamilien </td>
   <td style="text-align:left;"> NA </td>
   <td style="text-align:left;"> Engraulidae </td>
  </tr>
  <tr>
   <td style="text-align:right;"> 621 </td>
   <td style="text-align:left;"> ANE </td>
   <td style="text-align:left;"> Ansjos </td>
   <td style="text-align:left;"> European anchovy </td>
   <td style="text-align:left;"> Engraulis encrasicolus </td>
  </tr>
  <tr>
   <td style="text-align:right;"> 62101 </td>
   <td style="text-align:left;"> ANE </td>
   <td style="text-align:left;"> Ansjos (oppdrett) </td>
   <td style="text-align:left;"> European anchovy </td>
   <td style="text-align:left;"> Engraulis encrasicolus </td>
  </tr>
  <tr>
   <td style="text-align:right;"> 63 </td>
   <td style="text-align:left;"> NA </td>
   <td style="text-align:left;"> NA </td>
   <td style="text-align:left;"> NA </td>
   <td style="text-align:left;"> Alepocephalidae </td>
  </tr>
  <tr>
   <td style="text-align:right;"> 631 </td>
   <td style="text-align:left;"> ALC </td>
   <td style="text-align:left;"> Baird's slickhead </td>
   <td style="text-align:left;"> Baird's slickhead </td>
   <td style="text-align:left;"> Alepocephalus bairdii </td>
  </tr>
  <tr>
   <td style="text-align:right;"> 632 </td>
   <td style="text-align:left;"> PHO </td>
   <td style="text-align:left;"> Risso's smooth-head </td>
   <td style="text-align:left;"> Risso's smooth-head </td>
   <td style="text-align:left;"> Alepocephalus rostratus </td>
  </tr>
  <tr>
   <td style="text-align:right;"> 64 </td>
   <td style="text-align:left;"> HAF </td>
   <td style="text-align:left;"> Perlemorfiskfamilien </td>
   <td style="text-align:left;"> Hatchetfishes </td>
   <td style="text-align:left;"> Sternoptychidae </td>
  </tr>
  <tr>
   <td style="text-align:right;"> 641 </td>
   <td style="text-align:left;"> MAV </td>
   <td style="text-align:left;"> Laksesild </td>
   <td style="text-align:left;"> Silvery lightfish </td>
   <td style="text-align:left;"> Maurolicus muelleri </td>
  </tr>
  <tr>
   <td style="text-align:right;"> 699 </td>
   <td style="text-align:left;"> CLU </td>
   <td style="text-align:left;"> Annen sildefisk </td>
   <td style="text-align:left;"> Clupeoids </td>
   <td style="text-align:left;"> Clupeoidei </td>
  </tr>
  <tr>
   <td style="text-align:right;"> 7 </td>
   <td style="text-align:left;"> NA </td>
   <td style="text-align:left;"> LAKSEFISKER </td>
   <td style="text-align:left;"> NA </td>
   <td style="text-align:left;"> SALMONIFORMES </td>
  </tr>
  <tr>
   <td style="text-align:right;"> 711 </td>
   <td style="text-align:left;"> SAL </td>
   <td style="text-align:left;"> Laks </td>
   <td style="text-align:left;"> Atlantic salmon </td>
   <td style="text-align:left;"> Salmo salar </td>
  </tr>
  <tr>
   <td style="text-align:right;"> 71101 </td>
   <td style="text-align:left;"> SAL </td>
   <td style="text-align:left;"> Laks (oppdrett) </td>
   <td style="text-align:left;"> Atlantic salmon </td>
   <td style="text-align:left;"> Salmo salar </td>
  </tr>
  <tr>
   <td style="text-align:right;"> 712 </td>
   <td style="text-align:left;"> COH </td>
   <td style="text-align:left;"> Coho laks </td>
   <td style="text-align:left;"> Coho salmon </td>
   <td style="text-align:left;"> Oncorhynchus kisutch </td>
  </tr>
  <tr>
   <td style="text-align:right;"> 713 </td>
   <td style="text-align:left;"> TRS </td>
   <td style="text-align:left;"> Ørret </td>
   <td style="text-align:left;"> Sea trout </td>
   <td style="text-align:left;"> Salmo trutta </td>
  </tr>
  <tr>
   <td style="text-align:right;"> 71301 </td>
   <td style="text-align:left;"> TRS </td>
   <td style="text-align:left;"> Ørret (oppdrett) </td>
   <td style="text-align:left;"> Sea trout </td>
   <td style="text-align:left;"> Salmo trutta </td>
  </tr>
  <tr>
   <td style="text-align:right;"> 714 </td>
   <td style="text-align:left;"> TRR </td>
   <td style="text-align:left;"> Regnbueørret </td>
   <td style="text-align:left;"> Rainbow trout </td>
   <td style="text-align:left;"> Oncorhynchus mykiss/ Salmo gairdneri </td>
  </tr>
  <tr>
   <td style="text-align:right;"> 71401 </td>
   <td style="text-align:left;"> TRR </td>
   <td style="text-align:left;"> Regnbueørret (oppdrett) </td>
   <td style="text-align:left;"> Rainbow trout </td>
   <td style="text-align:left;"> Oncorhynchus mykiss/ Salmo gairdneri </td>
  </tr>
  <tr>
   <td style="text-align:right;"> 715 </td>
   <td style="text-align:left;"> TRO </td>
   <td style="text-align:left;"> Annen ørret </td>
   <td style="text-align:left;"> Trouts </td>
   <td style="text-align:left;"> Salmo spp </td>
  </tr>
  <tr>
   <td style="text-align:right;"> 716 </td>
   <td style="text-align:left;"> ACH </td>
   <td style="text-align:left;"> Røye </td>
   <td style="text-align:left;"> Arctic char </td>
   <td style="text-align:left;"> Salvelinus alpinus </td>
  </tr>
  <tr>
   <td style="text-align:right;"> 71601 </td>
   <td style="text-align:left;"> ACH </td>
   <td style="text-align:left;"> Røye (oppdrett) </td>
   <td style="text-align:left;"> Arctic char </td>
   <td style="text-align:left;"> Salvelinus alpinus </td>
  </tr>
  <tr>
   <td style="text-align:right;"> 717 </td>
   <td style="text-align:left;"> CHR </td>
   <td style="text-align:left;"> Annen røye </td>
   <td style="text-align:left;"> Chars </td>
   <td style="text-align:left;"> Salvelinus spp </td>
  </tr>
  <tr>
   <td style="text-align:right;"> 718 </td>
   <td style="text-align:left;"> TLA </td>
   <td style="text-align:left;"> Artic grayling </td>
   <td style="text-align:left;"> Artic grayling </td>
   <td style="text-align:left;"> Thymallus arcticus </td>
  </tr>
  <tr>
   <td style="text-align:right;"> 719 </td>
   <td style="text-align:left;"> TLV </td>
   <td style="text-align:left;"> Harr </td>
   <td style="text-align:left;"> Grayling </td>
   <td style="text-align:left;"> Thymallus thymallus </td>
  </tr>
  <tr>
   <td style="text-align:right;"> 72 </td>
   <td style="text-align:left;"> NA </td>
   <td style="text-align:left;"> NA </td>
   <td style="text-align:left;"> NA </td>
   <td style="text-align:left;"> Coregonidae </td>
  </tr>
  <tr>
   <td style="text-align:right;"> 721 </td>
   <td style="text-align:left;"> FVE </td>
   <td style="text-align:left;"> Lagesild </td>
   <td style="text-align:left;"> European whitefish </td>
   <td style="text-align:left;"> Coregonus albula </td>
  </tr>
  <tr>
   <td style="text-align:right;"> 722 </td>
   <td style="text-align:left;"> PLN </td>
   <td style="text-align:left;"> Sik </td>
   <td style="text-align:left;"> Pollan </td>
   <td style="text-align:left;"> Coregonus lavaretus </td>
  </tr>
  <tr>
   <td style="text-align:right;"> 723 </td>
   <td style="text-align:left;"> HOU </td>
   <td style="text-align:left;"> Nebbsik </td>
   <td style="text-align:left;"> Houting </td>
   <td style="text-align:left;"> Coregonus  oxyrinchus </td>
  </tr>
  <tr>
   <td style="text-align:right;"> 724 </td>
   <td style="text-align:left;"> WHF </td>
   <td style="text-align:left;"> Annen sik </td>
   <td style="text-align:left;"> Whitefish </td>
   <td style="text-align:left;"> Coregonus spp </td>
  </tr>
  <tr>
   <td style="text-align:right;"> 73 </td>
   <td style="text-align:left;"> NA </td>
   <td style="text-align:left;"> NA </td>
   <td style="text-align:left;"> NA </td>
   <td style="text-align:left;"> NA </td>
  </tr>
  <tr>
   <td style="text-align:right;"> 731 </td>
   <td style="text-align:left;"> SVF </td>
   <td style="text-align:left;"> Kanadisk bekkerøye </td>
   <td style="text-align:left;"> Brook trout </td>
   <td style="text-align:left;"> Salvelinus fontinalis </td>
  </tr>
  <tr>
   <td style="text-align:right;"> 732 </td>
   <td style="text-align:left;"> PIN </td>
   <td style="text-align:left;"> Pukkellaks </td>
   <td style="text-align:left;"> Pink(=Humpback) salmon </td>
   <td style="text-align:left;"> Oncorhynchus gorbuscha </td>
  </tr>
  <tr>
   <td style="text-align:right;"> 73201 </td>
   <td style="text-align:left;"> PIN </td>
   <td style="text-align:left;"> Pukkellaks (oppdrett) </td>
   <td style="text-align:left;"> Pink(=Humpback) salmon </td>
   <td style="text-align:left;"> Oncorhynchus gorbuscha </td>
  </tr>
  <tr>
   <td style="text-align:right;"> 74 </td>
   <td style="text-align:left;"> NA </td>
   <td style="text-align:left;"> Vassildfamilien </td>
   <td style="text-align:left;"> NA </td>
   <td style="text-align:left;"> Argentinidae </td>
  </tr>
  <tr>
   <td style="text-align:right;"> 741 </td>
   <td style="text-align:left;"> ARG </td>
   <td style="text-align:left;"> Strømsild/Vassild </td>
   <td style="text-align:left;"> Argentines </td>
   <td style="text-align:left;"> Argentina spp </td>
  </tr>
  <tr>
   <td style="text-align:right;"> 742 </td>
   <td style="text-align:left;"> ARU </td>
   <td style="text-align:left;"> Vassild </td>
   <td style="text-align:left;"> Greater argentine </td>
   <td style="text-align:left;"> Argentina silus </td>
  </tr>
  <tr>
   <td style="text-align:right;"> 743 </td>
   <td style="text-align:left;"> ARY </td>
   <td style="text-align:left;"> Strømsild </td>
   <td style="text-align:left;"> Argentine </td>
   <td style="text-align:left;"> Argentina sphyraena </td>
  </tr>
  <tr>
   <td style="text-align:right;"> 75 </td>
   <td style="text-align:left;"> NA </td>
   <td style="text-align:left;"> Loddefamilien </td>
   <td style="text-align:left;"> NA </td>
   <td style="text-align:left;"> Osmeridae </td>
  </tr>
  <tr>
   <td style="text-align:right;"> 751 </td>
   <td style="text-align:left;"> CAP </td>
   <td style="text-align:left;"> Lodde </td>
   <td style="text-align:left;"> Capelin </td>
   <td style="text-align:left;"> Mallotus villosus </td>
  </tr>
  <tr>
   <td style="text-align:right;"> 75101 </td>
   <td style="text-align:left;"> CAP </td>
   <td style="text-align:left;"> Barentshavslodde </td>
   <td style="text-align:left;"> Capelin </td>
   <td style="text-align:left;"> Mallotus villosus </td>
  </tr>
  <tr>
   <td style="text-align:right;"> 75102 </td>
   <td style="text-align:left;"> CAP </td>
   <td style="text-align:left;"> Lodde - Island/Ø Grønl./Jan M </td>
   <td style="text-align:left;"> Capelin </td>
   <td style="text-align:left;"> Mallotus villosus </td>
  </tr>
  <tr>
   <td style="text-align:right;"> 799 </td>
   <td style="text-align:left;"> SLX </td>
   <td style="text-align:left;"> Annen laksefisk </td>
   <td style="text-align:left;"> Salmonoids </td>
   <td style="text-align:left;"> Salmonoidei </td>
  </tr>
  <tr>
   <td style="text-align:right;"> 8 </td>
   <td style="text-align:left;"> NA </td>
   <td style="text-align:left;"> ÅLEFISKER </td>
   <td style="text-align:left;"> NA </td>
   <td style="text-align:left;"> ANGUILLIFORMES </td>
  </tr>
  <tr>
   <td style="text-align:right;"> 81 </td>
   <td style="text-align:left;"> NA </td>
   <td style="text-align:left;"> Ålefamilien </td>
   <td style="text-align:left;"> NA </td>
   <td style="text-align:left;"> Anguillidae </td>
  </tr>
  <tr>
   <td style="text-align:right;"> 811 </td>
   <td style="text-align:left;"> ELE </td>
   <td style="text-align:left;"> Ål </td>
   <td style="text-align:left;"> European eel </td>
   <td style="text-align:left;"> Anguilla anguilla </td>
  </tr>
  <tr>
   <td style="text-align:right;"> 81101 </td>
   <td style="text-align:left;"> ELE </td>
   <td style="text-align:left;"> Ål (oppdrett) </td>
   <td style="text-align:left;"> European eel </td>
   <td style="text-align:left;"> Anguilla anguilla </td>
  </tr>
  <tr>
   <td style="text-align:right;"> 82 </td>
   <td style="text-align:left;"> NA </td>
   <td style="text-align:left;"> Havålfamilien </td>
   <td style="text-align:left;"> NA </td>
   <td style="text-align:left;"> Congridae </td>
  </tr>
  <tr>
   <td style="text-align:right;"> 821 </td>
   <td style="text-align:left;"> COE </td>
   <td style="text-align:left;"> Havål </td>
   <td style="text-align:left;"> European conger </td>
   <td style="text-align:left;"> Conger conger </td>
  </tr>
  <tr>
   <td style="text-align:right;"> 899 </td>
   <td style="text-align:left;"> COX </td>
   <td style="text-align:left;"> Havål, uspes. </td>
   <td style="text-align:left;"> Congers  eels, etc. nei </td>
   <td style="text-align:left;"> Congridae </td>
  </tr>
  <tr>
   <td style="text-align:right;"> 9 </td>
   <td style="text-align:left;"> NA </td>
   <td style="text-align:left;"> MARULKER </td>
   <td style="text-align:left;"> NA </td>
   <td style="text-align:left;"> BELONIFORMES </td>
  </tr>
  <tr>
   <td style="text-align:right;"> 91 </td>
   <td style="text-align:left;"> NA </td>
   <td style="text-align:left;"> Horngjelfamilien </td>
   <td style="text-align:left;"> NA </td>
   <td style="text-align:left;"> Belonidae </td>
  </tr>
  <tr>
   <td style="text-align:right;"> 911 </td>
   <td style="text-align:left;"> GAR </td>
   <td style="text-align:left;"> Horngjel </td>
   <td style="text-align:left;"> Garfish </td>
   <td style="text-align:left;"> Belone belone </td>
  </tr>
  <tr>
   <td style="text-align:right;"> 92 </td>
   <td style="text-align:left;"> NA </td>
   <td style="text-align:left;"> Makrellgjeddefamilien </td>
   <td style="text-align:left;"> NA </td>
   <td style="text-align:left;"> Scomberesocidae </td>
  </tr>
  <tr>
   <td style="text-align:right;"> 921 </td>
   <td style="text-align:left;"> SAU </td>
   <td style="text-align:left;"> Makrellgjedde </td>
   <td style="text-align:left;"> Atlantic saury </td>
   <td style="text-align:left;"> Scomberesox saurus </td>
  </tr>
  <tr>
   <td style="text-align:right;"> 93 </td>
   <td style="text-align:left;"> NA </td>
   <td style="text-align:left;"> NA </td>
   <td style="text-align:left;"> NA </td>
   <td style="text-align:left;"> Pomatomidae </td>
  </tr>
  <tr>
   <td style="text-align:right;"> 931 </td>
   <td style="text-align:left;"> BLU </td>
   <td style="text-align:left;"> Bluefish </td>
   <td style="text-align:left;"> Bluefish </td>
   <td style="text-align:left;"> Pomatomus saltratix </td>
  </tr>
  <tr>
   <td style="text-align:right;"> 999 </td>
   <td style="text-align:left;"> BEN </td>
   <td style="text-align:left;"> Horngjel, uspes. </td>
   <td style="text-align:left;"> Needlefishes, etc nei </td>
   <td style="text-align:left;"> Belonidae </td>
  </tr>
  <tr>
   <td style="text-align:right;"> 10 </td>
   <td style="text-align:left;"> NA </td>
   <td style="text-align:left;"> TORSKEFISKER </td>
   <td style="text-align:left;"> NA </td>
   <td style="text-align:left;"> GADIFORMES </td>
  </tr>
  <tr>
   <td style="text-align:right;"> 1011 </td>
   <td style="text-align:left;"> MOR </td>
   <td style="text-align:left;"> Mora, uspes. </td>
   <td style="text-align:left;"> Moras nei </td>
   <td style="text-align:left;"> Moridae </td>
  </tr>
  <tr>
   <td style="text-align:right;"> 1012 </td>
   <td style="text-align:left;"> ANT </td>
   <td style="text-align:left;"> Blå antimora </td>
   <td style="text-align:left;"> Blue antimora </td>
   <td style="text-align:left;"> Antimora rostrata </td>
  </tr>
  <tr>
   <td style="text-align:right;"> 1013 </td>
   <td style="text-align:left;"> RIB </td>
   <td style="text-align:left;"> Mora </td>
   <td style="text-align:left;"> Common mora </td>
   <td style="text-align:left;"> Mora moro </td>
  </tr>
  <tr>
   <td style="text-align:right;"> 1021 </td>
   <td style="text-align:left;"> USK </td>
   <td style="text-align:left;"> Brosme </td>
   <td style="text-align:left;"> Tusk(= Cusk) </td>
   <td style="text-align:left;"> Brosme brosme </td>
  </tr>
  <tr>
   <td style="text-align:right;"> 1022 </td>
   <td style="text-align:left;"> COD </td>
   <td style="text-align:left;"> Torsk </td>
   <td style="text-align:left;"> Atlantic cod </td>
   <td style="text-align:left;"> Gadus morhua </td>
  </tr>
  <tr>
   <td style="text-align:right;"> 102201 </td>
   <td style="text-align:left;"> COD </td>
   <td style="text-align:left;"> Skrei </td>
   <td style="text-align:left;"> Atlantic cod </td>
   <td style="text-align:left;"> Gadus morhua </td>
  </tr>
  <tr>
   <td style="text-align:right;"> 102202 </td>
   <td style="text-align:left;"> COD </td>
   <td style="text-align:left;"> Nordøstarktisk torsk </td>
   <td style="text-align:left;"> Atlantic cod </td>
   <td style="text-align:left;"> Gadus morhua </td>
  </tr>
  <tr>
   <td style="text-align:right;"> 102203 </td>
   <td style="text-align:left;"> COD </td>
   <td style="text-align:left;"> Kysttorsk </td>
   <td style="text-align:left;"> Atlantic cod </td>
   <td style="text-align:left;"> Gadus morhua </td>
  </tr>
  <tr>
   <td style="text-align:right;"> 102204 </td>
   <td style="text-align:left;"> COD </td>
   <td style="text-align:left;"> Annen torsk </td>
   <td style="text-align:left;"> Atlantic cod </td>
   <td style="text-align:left;"> Gadus morhua </td>
  </tr>
  <tr>
   <td style="text-align:right;"> 102205 </td>
   <td style="text-align:left;"> COD </td>
   <td style="text-align:left;"> Torsk (oppdrett) </td>
   <td style="text-align:left;"> Atlantic cod </td>
   <td style="text-align:left;"> Gadus morhua </td>
  </tr>
  <tr>
   <td style="text-align:right;"> 1023 </td>
   <td style="text-align:left;"> LIN </td>
   <td style="text-align:left;"> Lange </td>
   <td style="text-align:left;"> Ling </td>
   <td style="text-align:left;"> Molva molva </td>
  </tr>
  <tr>
   <td style="text-align:right;"> 1024 </td>
   <td style="text-align:left;"> BLI </td>
   <td style="text-align:left;"> Blålange </td>
   <td style="text-align:left;"> Blue ling </td>
   <td style="text-align:left;"> Molva dypterygia </td>
  </tr>
  <tr>
   <td style="text-align:right;"> 1025 </td>
   <td style="text-align:left;"> GFB </td>
   <td style="text-align:left;"> Skjellbrosme </td>
   <td style="text-align:left;"> Greater forkbeard </td>
   <td style="text-align:left;"> Phycis blennoides </td>
  </tr>
  <tr>
   <td style="text-align:right;"> 1026 </td>
   <td style="text-align:left;"> FOR </td>
   <td style="text-align:left;"> Forkbeard </td>
   <td style="text-align:left;"> Forkbeard </td>
   <td style="text-align:left;"> Phycis phycis </td>
  </tr>
  <tr>
   <td style="text-align:right;"> 1027 </td>
   <td style="text-align:left;"> HAD </td>
   <td style="text-align:left;"> Hyse </td>
   <td style="text-align:left;"> Haddock </td>
   <td style="text-align:left;"> Melanogrammus aeglefinus </td>
  </tr>
  <tr>
   <td style="text-align:right;"> 102701 </td>
   <td style="text-align:left;"> HAD </td>
   <td style="text-align:left;"> Nordøstarktisk hyse </td>
   <td style="text-align:left;"> Haddock </td>
   <td style="text-align:left;"> Melanogrammus aeglefinus </td>
  </tr>
  <tr>
   <td style="text-align:right;"> 102702 </td>
   <td style="text-align:left;"> HAD </td>
   <td style="text-align:left;"> Kysthyse </td>
   <td style="text-align:left;"> Haddock </td>
   <td style="text-align:left;"> Melanogrammus aeglefinus </td>
  </tr>
  <tr>
   <td style="text-align:right;"> 102703 </td>
   <td style="text-align:left;"> HAD </td>
   <td style="text-align:left;"> Nordsjøhyse </td>
   <td style="text-align:left;"> Haddock </td>
   <td style="text-align:left;"> Melanogrammus aeglefinus </td>
  </tr>
  <tr>
   <td style="text-align:right;"> 102704 </td>
   <td style="text-align:left;"> HAD </td>
   <td style="text-align:left;"> Annen hyse </td>
   <td style="text-align:left;"> Haddock </td>
   <td style="text-align:left;"> Melanogrammus aeglefinus </td>
  </tr>
  <tr>
   <td style="text-align:right;"> 102705 </td>
   <td style="text-align:left;"> HAD </td>
   <td style="text-align:left;"> Hyse (oppdrett) </td>
   <td style="text-align:left;"> Haddock </td>
   <td style="text-align:left;"> Melanogrammus aeglefinus </td>
  </tr>
  <tr>
   <td style="text-align:right;"> 1028 </td>
   <td style="text-align:left;"> HKR </td>
   <td style="text-align:left;"> Rød lysing </td>
   <td style="text-align:left;"> Red hake </td>
   <td style="text-align:left;"> Urophycis chuss </td>
  </tr>
  <tr>
   <td style="text-align:right;"> 1029 </td>
   <td style="text-align:left;"> HKW </td>
   <td style="text-align:left;"> Hvit lysing </td>
   <td style="text-align:left;"> White hake </td>
   <td style="text-align:left;"> Urophycis tenuis </td>
  </tr>
  <tr>
   <td style="text-align:right;"> 1030 </td>
   <td style="text-align:left;"> POD </td>
   <td style="text-align:left;"> Sypike </td>
   <td style="text-align:left;"> Poor cod </td>
   <td style="text-align:left;"> Trisopterus minutus </td>
  </tr>
  <tr>
   <td style="text-align:right;"> 1031 </td>
   <td style="text-align:left;"> COW </td>
   <td style="text-align:left;"> Navagotorsk </td>
   <td style="text-align:left;"> Navaga(=Wachna cod) </td>
   <td style="text-align:left;"> Eleginus nawaga </td>
  </tr>
  <tr>
   <td style="text-align:right;"> 1032 </td>
   <td style="text-align:left;"> POK </td>
   <td style="text-align:left;"> Sei </td>
   <td style="text-align:left;"> Saithe(= Pollock) </td>
   <td style="text-align:left;"> Pollachius virens </td>
  </tr>
  <tr>
   <td style="text-align:right;"> 103201 </td>
   <td style="text-align:left;"> POK </td>
   <td style="text-align:left;"> Sei (oppdrett) </td>
   <td style="text-align:left;"> Saithe(= Pollock) </td>
   <td style="text-align:left;"> Pollachius virens </td>
  </tr>
  <tr>
   <td style="text-align:right;"> 1034 </td>
   <td style="text-align:left;"> POL </td>
   <td style="text-align:left;"> Lyr </td>
   <td style="text-align:left;"> Pollack </td>
   <td style="text-align:left;"> Pollachius pollachius </td>
  </tr>
  <tr>
   <td style="text-align:right;"> 1035 </td>
   <td style="text-align:left;"> POC </td>
   <td style="text-align:left;"> Polartorsk </td>
   <td style="text-align:left;"> Polar cod </td>
   <td style="text-align:left;"> Boreogadus saida </td>
  </tr>
  <tr>
   <td style="text-align:right;"> 1036 </td>
   <td style="text-align:left;"> NOP </td>
   <td style="text-align:left;"> Øyepål </td>
   <td style="text-align:left;"> Norway pout </td>
   <td style="text-align:left;"> Trisopterus esmarkii </td>
  </tr>
  <tr>
   <td style="text-align:right;"> 1037 </td>
   <td style="text-align:left;"> BIB </td>
   <td style="text-align:left;"> Skjeggtorsk </td>
   <td style="text-align:left;"> Pouting </td>
   <td style="text-align:left;"> Trisopterus luscus </td>
  </tr>
  <tr>
   <td style="text-align:right;"> 1038 </td>
   <td style="text-align:left;"> WHB </td>
   <td style="text-align:left;"> Kolmule </td>
   <td style="text-align:left;"> Blue whiting </td>
   <td style="text-align:left;"> Micromesistius poutassou </td>
  </tr>
  <tr>
   <td style="text-align:right;"> 1039 </td>
   <td style="text-align:left;"> WHG </td>
   <td style="text-align:left;"> Hvitting </td>
   <td style="text-align:left;"> Whiting </td>
   <td style="text-align:left;"> Merlangius merlangus </td>
  </tr>
  <tr>
   <td style="text-align:right;"> 1040 </td>
   <td style="text-align:left;"> GDG </td>
   <td style="text-align:left;"> Sølvtorsk </td>
   <td style="text-align:left;"> Silvery pout </td>
   <td style="text-align:left;"> Gadiculus argenteus </td>
  </tr>
  <tr>
   <td style="text-align:right;"> 1041 </td>
   <td style="text-align:left;"> RCR </td>
   <td style="text-align:left;"> Paddetorsk </td>
   <td style="text-align:left;"> Tadpole fish </td>
   <td style="text-align:left;"> Raniceps raninus </td>
  </tr>
  <tr>
   <td style="text-align:right;"> 1042 </td>
   <td style="text-align:left;"> GRC </td>
   <td style="text-align:left;"> Greenland cod </td>
   <td style="text-align:left;"> Greenland cod </td>
   <td style="text-align:left;"> Gadus ogac </td>
  </tr>
  <tr>
   <td style="text-align:right;"> 1043 </td>
   <td style="text-align:left;"> ATG </td>
   <td style="text-align:left;"> Istorsk </td>
   <td style="text-align:left;"> Arctic Cod </td>
   <td style="text-align:left;"> Arctogadus glacialis </td>
  </tr>
  <tr>
   <td style="text-align:right;"> 1051 </td>
   <td style="text-align:left;"> HKE </td>
   <td style="text-align:left;"> Lysing </td>
   <td style="text-align:left;"> European hake </td>
   <td style="text-align:left;"> Merluccius merluccius </td>
  </tr>
  <tr>
   <td style="text-align:right;"> 1052 </td>
   <td style="text-align:left;"> HKS </td>
   <td style="text-align:left;"> Silver hake </td>
   <td style="text-align:left;"> Silver hake </td>
   <td style="text-align:left;"> Merluccius bilinearis </td>
  </tr>
  <tr>
   <td style="text-align:right;"> 1061 </td>
   <td style="text-align:left;"> RHG </td>
   <td style="text-align:left;"> Isgalt </td>
   <td style="text-align:left;"> Roughhead grenadier </td>
   <td style="text-align:left;"> Macrourus berglax </td>
  </tr>
  <tr>
   <td style="text-align:right;"> 1062 </td>
   <td style="text-align:left;"> RNG </td>
   <td style="text-align:left;"> Skolest </td>
   <td style="text-align:left;"> Roundnose grenadier </td>
   <td style="text-align:left;"> Coryphaenoides rupestris </td>
  </tr>
  <tr>
   <td style="text-align:right;"> 1063 </td>
   <td style="text-align:left;"> CQL </td>
   <td style="text-align:left;"> Spiritist </td>
   <td style="text-align:left;"> Hollowsnout grenadier </td>
   <td style="text-align:left;"> Caelorinchus caelorhincus </td>
  </tr>
  <tr>
   <td style="text-align:right;"> 1099 </td>
   <td style="text-align:left;"> GAD </td>
   <td style="text-align:left;"> Torskefisk, uspes. </td>
   <td style="text-align:left;"> Gadiformes nei </td>
   <td style="text-align:left;"> Gadiformes </td>
  </tr>
  <tr>
   <td style="text-align:right;"> 11 </td>
   <td style="text-align:left;"> NA </td>
   <td style="text-align:left;"> STINGSILDFISKER </td>
   <td style="text-align:left;"> NA </td>
   <td style="text-align:left;"> GASTEROSTEIFORMES </td>
  </tr>
  <tr>
   <td style="text-align:right;"> 1111 </td>
   <td style="text-align:left;"> SKB </td>
   <td style="text-align:left;"> Stingsild </td>
   <td style="text-align:left;"> Sticklebacks </td>
   <td style="text-align:left;"> Gasterosteus spp </td>
  </tr>
  <tr>
   <td style="text-align:right;"> 1112 </td>
   <td style="text-align:left;"> GTA </td>
   <td style="text-align:left;"> Trepigget stingsild </td>
   <td style="text-align:left;"> Three-spined stickleback </td>
   <td style="text-align:left;"> Gasterosteus aculatus </td>
  </tr>
  <tr>
   <td style="text-align:right;"> 1115 </td>
   <td style="text-align:left;"> GPT </td>
   <td style="text-align:left;"> Nipigget stingsild </td>
   <td style="text-align:left;"> Ninespine stickleback </td>
   <td style="text-align:left;"> Pungitius pungitius </td>
  </tr>
  <tr>
   <td style="text-align:right;"> 12 </td>
   <td style="text-align:left;"> NA </td>
   <td style="text-align:left;"> NÅLEFISKER </td>
   <td style="text-align:left;"> NA </td>
   <td style="text-align:left;"> SYGNATHIFORMES </td>
  </tr>
  <tr>
   <td style="text-align:right;"> 1211 </td>
   <td style="text-align:left;"> SNS </td>
   <td style="text-align:left;"> Trompetfisk </td>
   <td style="text-align:left;"> Slender snipefish </td>
   <td style="text-align:left;"> Macroramphosus scolopax </td>
  </tr>
  <tr>
   <td style="text-align:right;"> 122 </td>
   <td style="text-align:left;"> NA </td>
   <td style="text-align:left;"> Nålefiskfamilien </td>
   <td style="text-align:left;"> Pipefishes and seahorses </td>
   <td style="text-align:left;"> Syngnathidae </td>
  </tr>
  <tr>
   <td style="text-align:right;"> 1221 </td>
   <td style="text-align:left;"> SGQ </td>
   <td style="text-align:left;"> Stor kantnål </td>
   <td style="text-align:left;"> Greater pipefish </td>
   <td style="text-align:left;"> Syngnathus acus </td>
  </tr>
  <tr>
   <td style="text-align:right;"> 1222 </td>
   <td style="text-align:left;"> SFR </td>
   <td style="text-align:left;"> Liten kantnål </td>
   <td style="text-align:left;"> Nilsson's pipefish </td>
   <td style="text-align:left;"> Syngnathus rostellatus </td>
  </tr>
  <tr>
   <td style="text-align:right;"> 1225 </td>
   <td style="text-align:left;"> HPI </td>
   <td style="text-align:left;"> Sjøhest </td>
   <td style="text-align:left;"> Long-snouted seahorse </td>
   <td style="text-align:left;"> Hippocampus guttulatus </td>
  </tr>
  <tr>
   <td style="text-align:right;"> 1226 </td>
   <td style="text-align:left;"> STQ </td>
   <td style="text-align:left;"> Tangsnelle </td>
   <td style="text-align:left;"> Broadnosed pipefish </td>
   <td style="text-align:left;"> Syngnathus typhle </td>
  </tr>
  <tr>
   <td style="text-align:right;"> 13 </td>
   <td style="text-align:left;"> NA </td>
   <td style="text-align:left;"> BERYXFISKER </td>
   <td style="text-align:left;"> NA </td>
   <td style="text-align:left;"> BERYCIFORMES </td>
  </tr>
  <tr>
   <td style="text-align:right;"> 131 </td>
   <td style="text-align:left;"> NA </td>
   <td style="text-align:left;"> Beryxfamilien </td>
   <td style="text-align:left;"> NA </td>
   <td style="text-align:left;"> Berycidae </td>
  </tr>
  <tr>
   <td style="text-align:right;"> 1311 </td>
   <td style="text-align:left;"> ALF </td>
   <td style="text-align:left;"> Alfonsinos nei </td>
   <td style="text-align:left;"> Alfonsinos nei </td>
   <td style="text-align:left;"> Beryx </td>
  </tr>
  <tr>
   <td style="text-align:right;"> 1312 </td>
   <td style="text-align:left;"> HPR </td>
   <td style="text-align:left;"> Mediterranean slimehead </td>
   <td style="text-align:left;"> Mediterranean slimehead </td>
   <td style="text-align:left;"> Hoplostethus mediterraneus </td>
  </tr>
  <tr>
   <td style="text-align:right;"> 132 </td>
   <td style="text-align:left;"> NA </td>
   <td style="text-align:left;"> NA </td>
   <td style="text-align:left;"> NA </td>
   <td style="text-align:left;"> Trachichthyidae </td>
  </tr>
  <tr>
   <td style="text-align:right;"> 1321 </td>
   <td style="text-align:left;"> ORY </td>
   <td style="text-align:left;"> Orange roughy </td>
   <td style="text-align:left;"> Orange roughy </td>
   <td style="text-align:left;"> Hoplostethus atlanticus </td>
  </tr>
  <tr>
   <td style="text-align:right;"> 14 </td>
   <td style="text-align:left;"> NA </td>
   <td style="text-align:left;"> ST. PETERS FISKER </td>
   <td style="text-align:left;"> NA </td>
   <td style="text-align:left;"> ZEIFORMES </td>
  </tr>
  <tr>
   <td style="text-align:right;"> 141 </td>
   <td style="text-align:left;"> NA </td>
   <td style="text-align:left;"> Sanktpetersfiskfamilien </td>
   <td style="text-align:left;"> NA </td>
   <td style="text-align:left;"> Zeidae </td>
  </tr>
  <tr>
   <td style="text-align:right;"> 1411 </td>
   <td style="text-align:left;"> JOD </td>
   <td style="text-align:left;"> Sanktpetersfisk </td>
   <td style="text-align:left;"> John dory </td>
   <td style="text-align:left;"> Zeus faber </td>
  </tr>
  <tr>
   <td style="text-align:right;"> 142 </td>
   <td style="text-align:left;"> NA </td>
   <td style="text-align:left;"> Villsvinfiskfamilien </td>
   <td style="text-align:left;"> NA </td>
   <td style="text-align:left;"> NA </td>
  </tr>
  <tr>
   <td style="text-align:right;"> 1421 </td>
   <td style="text-align:left;"> BOC </td>
   <td style="text-align:left;"> Villsvinfisk </td>
   <td style="text-align:left;"> Boarfish </td>
   <td style="text-align:left;"> Capros aper </td>
  </tr>
  <tr>
   <td style="text-align:right;"> 15 </td>
   <td style="text-align:left;"> NA </td>
   <td style="text-align:left;"> MULTEFISKER </td>
   <td style="text-align:left;"> NA </td>
   <td style="text-align:left;"> MUGILOIDEI </td>
  </tr>
  <tr>
   <td style="text-align:right;"> 151 </td>
   <td style="text-align:left;"> NA </td>
   <td style="text-align:left;"> Multefamilien </td>
   <td style="text-align:left;"> NA </td>
   <td style="text-align:left;"> Mugilidae </td>
  </tr>
  <tr>
   <td style="text-align:right;"> 1511 </td>
   <td style="text-align:left;"> MUL </td>
   <td style="text-align:left;"> Annen multe </td>
   <td style="text-align:left;"> Mullets </td>
   <td style="text-align:left;"> Mugilidae </td>
  </tr>
  <tr>
   <td style="text-align:right;"> 1512 </td>
   <td style="text-align:left;"> MLR </td>
   <td style="text-align:left;"> Tykkleppet multe </td>
   <td style="text-align:left;"> Thicklip grey mullet </td>
   <td style="text-align:left;"> Chelon labrosus </td>
  </tr>
  <tr>
   <td style="text-align:right;"> 152 </td>
   <td style="text-align:left;"> NA </td>
   <td style="text-align:left;"> Stripefiskfamilien </td>
   <td style="text-align:left;"> NA </td>
   <td style="text-align:left;"> Atherinidae </td>
  </tr>
  <tr>
   <td style="text-align:right;"> 1521 </td>
   <td style="text-align:left;"> SIL </td>
   <td style="text-align:left;"> Stripefisker </td>
   <td style="text-align:left;"> Silverside smelts </td>
   <td style="text-align:left;"> Atherinidae </td>
  </tr>
  <tr>
   <td style="text-align:right;"> 161 </td>
   <td style="text-align:left;"> NA </td>
   <td style="text-align:left;"> Hestmakrellfamilien </td>
   <td style="text-align:left;"> NA </td>
   <td style="text-align:left;"> Carangidae </td>
  </tr>
  <tr>
   <td style="text-align:right;"> 1611 </td>
   <td style="text-align:left;"> HOM </td>
   <td style="text-align:left;"> Hestmakrell </td>
   <td style="text-align:left;"> Atlantic horse mackerel </td>
   <td style="text-align:left;"> Trachurus trachurus </td>
  </tr>
  <tr>
   <td style="text-align:right;"> 161101 </td>
   <td style="text-align:left;"> HOM </td>
   <td style="text-align:left;"> Hestmakrell (oppdrett) </td>
   <td style="text-align:left;"> Atlantic horse mackerel </td>
   <td style="text-align:left;"> Trachurus trachurus </td>
  </tr>
  <tr>
   <td style="text-align:right;"> 1612 </td>
   <td style="text-align:left;"> LEE </td>
   <td style="text-align:left;"> Leerfish </td>
   <td style="text-align:left;"> Leerfish </td>
   <td style="text-align:left;"> Lichia amia </td>
  </tr>
  <tr>
   <td style="text-align:right;"> 1619 </td>
   <td style="text-align:left;"> JAX </td>
   <td style="text-align:left;"> Annen hestmakrell </td>
   <td style="text-align:left;"> Jack &amp; horsemackerel </td>
   <td style="text-align:left;"> Trachurus spp </td>
  </tr>
  <tr>
   <td style="text-align:right;"> 162 </td>
   <td style="text-align:left;"> NA </td>
   <td style="text-align:left;"> Havabborfamilien </td>
   <td style="text-align:left;"> NA </td>
   <td style="text-align:left;"> Serranidae </td>
  </tr>
  <tr>
   <td style="text-align:right;"> 1621 </td>
   <td style="text-align:left;"> GPD </td>
   <td style="text-align:left;"> Dusky grouper </td>
   <td style="text-align:left;"> Dusky grouper </td>
   <td style="text-align:left;"> Epinephelus marginatus </td>
  </tr>
  <tr>
   <td style="text-align:right;"> 1622 </td>
   <td style="text-align:left;"> WRF </td>
   <td style="text-align:left;"> Vrakfisk </td>
   <td style="text-align:left;"> Wreckfish </td>
   <td style="text-align:left;"> Polyprion americanus </td>
  </tr>
  <tr>
   <td style="text-align:right;"> 1623 </td>
   <td style="text-align:left;"> BSS </td>
   <td style="text-align:left;"> Havabbor </td>
   <td style="text-align:left;"> European seabass </td>
   <td style="text-align:left;"> Dicentrarchus labrax </td>
  </tr>
  <tr>
   <td style="text-align:right;"> 1624 </td>
   <td style="text-align:left;"> STB </td>
   <td style="text-align:left;"> Stripet havabbor </td>
   <td style="text-align:left;"> Striped bass </td>
   <td style="text-align:left;"> Morone saxatilis </td>
  </tr>
  <tr>
   <td style="text-align:right;"> 1625 </td>
   <td style="text-align:left;"> GRX </td>
   <td style="text-align:left;"> Grunt </td>
   <td style="text-align:left;"> Grunts, sweetlips, etc. </td>
   <td style="text-align:left;"> Haemulidae(=Pomadasyidae) </td>
  </tr>
  <tr>
   <td style="text-align:right;"> 1628 </td>
   <td style="text-align:left;"> EPI </td>
   <td style="text-align:left;"> Dyphavsabbor </td>
   <td style="text-align:left;"> Black cardinal fish </td>
   <td style="text-align:left;"> Epigonus telescopus </td>
  </tr>
  <tr>
   <td style="text-align:right;"> 163 </td>
   <td style="text-align:left;"> NA </td>
   <td style="text-align:left;"> Ørnefiskfamilien </td>
   <td style="text-align:left;"> NA </td>
   <td style="text-align:left;"> Sciaenidae </td>
  </tr>
  <tr>
   <td style="text-align:right;"> 1631 </td>
   <td style="text-align:left;"> MGR </td>
   <td style="text-align:left;"> Ørnefisk </td>
   <td style="text-align:left;"> Meagre </td>
   <td style="text-align:left;"> Argyrosomus regius </td>
  </tr>
  <tr>
   <td style="text-align:right;"> 164 </td>
   <td style="text-align:left;"> NA </td>
   <td style="text-align:left;"> Havkarussfamilien </td>
   <td style="text-align:left;"> NA </td>
   <td style="text-align:left;"> Sparidae </td>
  </tr>
  <tr>
   <td style="text-align:right;"> 1641 </td>
   <td style="text-align:left;"> SBR </td>
   <td style="text-align:left;"> Flekkpagell </td>
   <td style="text-align:left;"> Red seabream </td>
   <td style="text-align:left;"> Pagellus bogaraveo </td>
  </tr>
  <tr>
   <td style="text-align:right;"> 1642 </td>
   <td style="text-align:left;"> PAC </td>
   <td style="text-align:left;"> Rødpagell </td>
   <td style="text-align:left;"> Common pandora </td>
   <td style="text-align:left;"> Pagellus erythrinus </td>
  </tr>
  <tr>
   <td style="text-align:right;"> 1643 </td>
   <td style="text-align:left;"> SBA </td>
   <td style="text-align:left;"> Axillary seabream </td>
   <td style="text-align:left;"> Axillary seabream </td>
   <td style="text-align:left;"> Pagellus acarne </td>
  </tr>
  <tr>
   <td style="text-align:right;"> 1644 </td>
   <td style="text-align:left;"> DEL </td>
   <td style="text-align:left;"> Largeeye dentex </td>
   <td style="text-align:left;"> Largeeye dentex </td>
   <td style="text-align:left;"> Dentex macrophthalmus </td>
  </tr>
  <tr>
   <td style="text-align:right;"> 1645 </td>
   <td style="text-align:left;"> DEC </td>
   <td style="text-align:left;"> Common dentex </td>
   <td style="text-align:left;"> Common dentex </td>
   <td style="text-align:left;"> Dentex dentex </td>
  </tr>
  <tr>
   <td style="text-align:right;"> 1646 </td>
   <td style="text-align:left;"> DEX </td>
   <td style="text-align:left;"> Dentex </td>
   <td style="text-align:left;"> Dentex </td>
   <td style="text-align:left;"> Dentex spp </td>
  </tr>
  <tr>
   <td style="text-align:right;"> 1647 </td>
   <td style="text-align:left;"> SBG </td>
   <td style="text-align:left;"> Dorade </td>
   <td style="text-align:left;"> Gilthead seabream </td>
   <td style="text-align:left;"> Sparus aurata </td>
  </tr>
  <tr>
   <td style="text-align:right;"> 1648 </td>
   <td style="text-align:left;"> BOG </td>
   <td style="text-align:left;"> Oksøyefisk </td>
   <td style="text-align:left;"> Bogue </td>
   <td style="text-align:left;"> Boops boops </td>
  </tr>
  <tr>
   <td style="text-align:right;"> 1649 </td>
   <td style="text-align:left;"> SBX </td>
   <td style="text-align:left;"> Annen havkaruss </td>
   <td style="text-align:left;"> Porgies, seabreams etc. </td>
   <td style="text-align:left;"> Sparidae </td>
  </tr>
  <tr>
   <td style="text-align:right;"> 165 </td>
   <td style="text-align:left;"> NA </td>
   <td style="text-align:left;"> Mullefamilien </td>
   <td style="text-align:left;"> NA </td>
   <td style="text-align:left;"> Mullidae </td>
  </tr>
  <tr>
   <td style="text-align:right;"> 1651 </td>
   <td style="text-align:left;"> MUR </td>
   <td style="text-align:left;"> Mulle </td>
   <td style="text-align:left;"> Surmullet </td>
   <td style="text-align:left;"> Mullus surmuletus </td>
  </tr>
  <tr>
   <td style="text-align:right;"> 1652 </td>
   <td style="text-align:left;"> MUT </td>
   <td style="text-align:left;"> Red mullet </td>
   <td style="text-align:left;"> Red mullet </td>
   <td style="text-align:left;"> Mullus barbatus </td>
  </tr>
  <tr>
   <td style="text-align:right;"> 166 </td>
   <td style="text-align:left;"> NA </td>
   <td style="text-align:left;"> Fjesingfamilien </td>
   <td style="text-align:left;"> NA </td>
   <td style="text-align:left;"> Trachinidae </td>
  </tr>
  <tr>
   <td style="text-align:right;"> 1661 </td>
   <td style="text-align:left;"> WEG </td>
   <td style="text-align:left;"> Fjesing </td>
   <td style="text-align:left;"> Greater weever </td>
   <td style="text-align:left;"> Trachinus draco </td>
  </tr>
  <tr>
   <td style="text-align:right;"> 167 </td>
   <td style="text-align:left;"> NA </td>
   <td style="text-align:left;"> Havbrasmefamilien </td>
   <td style="text-align:left;"> NA </td>
   <td style="text-align:left;"> Bramidae </td>
  </tr>
  <tr>
   <td style="text-align:right;"> 1671 </td>
   <td style="text-align:left;"> POA </td>
   <td style="text-align:left;"> Havbrasme </td>
   <td style="text-align:left;"> Atlantic pomfret </td>
   <td style="text-align:left;"> Brama brama </td>
  </tr>
  <tr>
   <td style="text-align:right;"> 1672 </td>
   <td style="text-align:left;"> TAS </td>
   <td style="text-align:left;"> Høyfinnet havbrasme </td>
   <td style="text-align:left;"> Rough pomfret </td>
   <td style="text-align:left;"> Taractes asper </td>
  </tr>
  <tr>
   <td style="text-align:right;"> 1673 </td>
   <td style="text-align:left;"> BTB </td>
   <td style="text-align:left;"> Sølvbrasme </td>
   <td style="text-align:left;"> Atlantic fanfish </td>
   <td style="text-align:left;"> Pterycombus brama </td>
  </tr>
  <tr>
   <td style="text-align:right;"> 168 </td>
   <td style="text-align:left;"> NA </td>
   <td style="text-align:left;"> NA </td>
   <td style="text-align:left;"> NA </td>
   <td style="text-align:left;"> Centracanthidae </td>
  </tr>
  <tr>
   <td style="text-align:right;"> 1681 </td>
   <td style="text-align:left;"> PIC </td>
   <td style="text-align:left;"> Picarels </td>
   <td style="text-align:left;"> Picarels </td>
   <td style="text-align:left;"> Spicara spp </td>
  </tr>
  <tr>
   <td style="text-align:right;"> 169 </td>
   <td style="text-align:left;"> NA </td>
   <td style="text-align:left;"> Leppefiskfamilien </td>
   <td style="text-align:left;"> Wrasses </td>
   <td style="text-align:left;"> Labridae </td>
  </tr>
  <tr>
   <td style="text-align:right;"> 1691 </td>
   <td style="text-align:left;"> USB </td>
   <td style="text-align:left;"> Berggylt </td>
   <td style="text-align:left;"> Ballan wrasse </td>
   <td style="text-align:left;"> Labrus bergylta </td>
  </tr>
  <tr>
   <td style="text-align:right;"> 169101 </td>
   <td style="text-align:left;"> USB </td>
   <td style="text-align:left;"> Berggylt (oppdrett) </td>
   <td style="text-align:left;"> Ballan wrasse </td>
   <td style="text-align:left;"> Labrus bergylta </td>
  </tr>
  <tr>
   <td style="text-align:right;"> 1692 </td>
   <td style="text-align:left;"> WRA </td>
   <td style="text-align:left;"> Annen leppefisk </td>
   <td style="text-align:left;"> Wrasses, hogfishes, etc.nei </td>
   <td style="text-align:left;"> Labridae </td>
  </tr>
  <tr>
   <td style="text-align:right;"> 1693 </td>
   <td style="text-align:left;"> TBR </td>
   <td style="text-align:left;"> Bergnebb </td>
   <td style="text-align:left;"> Gold-sinny wrasse </td>
   <td style="text-align:left;"> Ctenolabrus rupestris </td>
  </tr>
  <tr>
   <td style="text-align:right;"> 169301 </td>
   <td style="text-align:left;"> TBR </td>
   <td style="text-align:left;"> Bergnebb (oppdrett) </td>
   <td style="text-align:left;"> Gold-sinny wrasse </td>
   <td style="text-align:left;"> Ctenolabrus rupestris </td>
  </tr>
  <tr>
   <td style="text-align:right;"> 1694 </td>
   <td style="text-align:left;"> YFM </td>
   <td style="text-align:left;"> Grøngylt </td>
   <td style="text-align:left;"> Corkwing wrasse </td>
   <td style="text-align:left;"> Symphodus melops </td>
  </tr>
  <tr>
   <td style="text-align:right;"> 169401 </td>
   <td style="text-align:left;"> YFM </td>
   <td style="text-align:left;"> Grøngylt (oppdrett) </td>
   <td style="text-align:left;"> Corkwing wrasse </td>
   <td style="text-align:left;"> Symphodus melops </td>
  </tr>
  <tr>
   <td style="text-align:right;"> 1695 </td>
   <td style="text-align:left;"> USI </td>
   <td style="text-align:left;"> Blåstål/ Rødnebb </td>
   <td style="text-align:left;"> Cuckoo wrasse </td>
   <td style="text-align:left;"> Labrus (bimaculatus) mixtus </td>
  </tr>
  <tr>
   <td style="text-align:right;"> 169501 </td>
   <td style="text-align:left;"> USI </td>
   <td style="text-align:left;"> Blåstål/ Rødnebb (oppdrett) </td>
   <td style="text-align:left;"> Cuckoo wrasse </td>
   <td style="text-align:left;"> Labrus (bimaculatus) mixtus </td>
  </tr>
  <tr>
   <td style="text-align:right;"> 169510 </td>
   <td style="text-align:left;"> USI </td>
   <td style="text-align:left;"> Blåstål </td>
   <td style="text-align:left;"> Cuckoo wrasse </td>
   <td style="text-align:left;"> Labrus (bimaculatus) mixtus </td>
  </tr>
  <tr>
   <td style="text-align:right;"> 169520 </td>
   <td style="text-align:left;"> USI </td>
   <td style="text-align:left;"> Rødnebb </td>
   <td style="text-align:left;"> Cuckoo wrasse </td>
   <td style="text-align:left;"> Labrus (bimaculatus) mixtus </td>
  </tr>
  <tr>
   <td style="text-align:right;"> 1696 </td>
   <td style="text-align:left;"> ENX </td>
   <td style="text-align:left;"> Gressgylt </td>
   <td style="text-align:left;"> Rock cook </td>
   <td style="text-align:left;"> Centrolabrus exoletus </td>
  </tr>
  <tr>
   <td style="text-align:right;"> 169601 </td>
   <td style="text-align:left;"> ENX </td>
   <td style="text-align:left;"> Gressgylt (oppdrett) </td>
   <td style="text-align:left;"> Rock cook </td>
   <td style="text-align:left;"> Centrolabrus exoletus </td>
  </tr>
  <tr>
   <td style="text-align:right;"> 1697 </td>
   <td style="text-align:left;"> AKL </td>
   <td style="text-align:left;"> Brungylt </td>
   <td style="text-align:left;"> Scale-rayed wrasse </td>
   <td style="text-align:left;"> Acantholabrus palloni </td>
  </tr>
  <tr>
   <td style="text-align:right;"> 169701 </td>
   <td style="text-align:left;"> AKL </td>
   <td style="text-align:left;"> Brungylt (oppdrett) </td>
   <td style="text-align:left;"> Scale-rayed wrasse </td>
   <td style="text-align:left;"> Acantholabrus palloni </td>
  </tr>
  <tr>
   <td style="text-align:right;"> 1699 </td>
   <td style="text-align:left;"> MZZ </td>
   <td style="text-align:left;"> Piggfinnefisk, uspes. </td>
   <td style="text-align:left;"> Demersal percomorphs nei </td>
   <td style="text-align:left;"> Perciformes </td>
  </tr>
  <tr>
   <td style="text-align:right;"> 169901 </td>
   <td style="text-align:left;"> NA </td>
   <td style="text-align:left;"> Rensefisk (oppdrett) </td>
   <td style="text-align:left;"> Cleanerfish </td>
   <td style="text-align:left;"> NA </td>
  </tr>
  <tr>
   <td style="text-align:right;"> 341 </td>
   <td style="text-align:left;"> NA </td>
   <td style="text-align:left;"> NA </td>
   <td style="text-align:left;"> Butterfishes </td>
   <td style="text-align:left;"> Stromateidae </td>
  </tr>
  <tr>
   <td style="text-align:right;"> 3411 </td>
   <td style="text-align:left;"> BUT </td>
   <td style="text-align:left;"> Atlantic (American) butterfish </td>
   <td style="text-align:left;"> Atlantic (American) butterfish </td>
   <td style="text-align:left;"> Peprilus triacanthus </td>
  </tr>
  <tr>
   <td style="text-align:right;"> 342 </td>
   <td style="text-align:left;"> NA </td>
   <td style="text-align:left;"> Fløyfiskfamilien </td>
   <td style="text-align:left;"> Dragonets </td>
   <td style="text-align:left;"> Callionymidae </td>
  </tr>
  <tr>
   <td style="text-align:right;"> 3421 </td>
   <td style="text-align:left;"> LYY </td>
   <td style="text-align:left;"> Vanlig fløyfisk </td>
   <td style="text-align:left;"> Dragonet </td>
   <td style="text-align:left;"> Callionymus lyra </td>
  </tr>
  <tr>
   <td style="text-align:right;"> 17 </td>
   <td style="text-align:left;"> NA </td>
   <td style="text-align:left;"> SLIMFISKER </td>
   <td style="text-align:left;"> NA </td>
   <td style="text-align:left;"> BLENNOIDEI </td>
  </tr>
  <tr>
   <td style="text-align:right;"> 171 </td>
   <td style="text-align:left;"> NA </td>
   <td style="text-align:left;"> Steinbitfamilien </td>
   <td style="text-align:left;"> NA </td>
   <td style="text-align:left;"> Anarhichadidae </td>
  </tr>
  <tr>
   <td style="text-align:right;"> 1711 </td>
   <td style="text-align:left;"> CAA </td>
   <td style="text-align:left;"> Gråsteinbit </td>
   <td style="text-align:left;"> Atlantic wolffish (= Catfish) </td>
   <td style="text-align:left;"> Anarhichas lupus </td>
  </tr>
  <tr>
   <td style="text-align:right;"> 171101 </td>
   <td style="text-align:left;"> CAA </td>
   <td style="text-align:left;"> Gråsteinbit (oppdrett) </td>
   <td style="text-align:left;"> Atlantic wolffish (= Catfish) </td>
   <td style="text-align:left;"> Anarhichas lupus </td>
  </tr>
  <tr>
   <td style="text-align:right;"> 1712 </td>
   <td style="text-align:left;"> CAS </td>
   <td style="text-align:left;"> Flekksteinbit </td>
   <td style="text-align:left;"> Spotted wolffish (= Catfish) </td>
   <td style="text-align:left;"> Anarhichas minor </td>
  </tr>
  <tr>
   <td style="text-align:right;"> 171201 </td>
   <td style="text-align:left;"> CAS </td>
   <td style="text-align:left;"> Flekksteinbit (oppdrett) </td>
   <td style="text-align:left;"> Spotted wolffish (= Catfish) </td>
   <td style="text-align:left;"> Anarhichas minor </td>
  </tr>
  <tr>
   <td style="text-align:right;"> 1713 </td>
   <td style="text-align:left;"> CAB </td>
   <td style="text-align:left;"> Blåsteinbit </td>
   <td style="text-align:left;"> Northern wolffish </td>
   <td style="text-align:left;"> Anarhichas denticulatus </td>
  </tr>
  <tr>
   <td style="text-align:right;"> 1719 </td>
   <td style="text-align:left;"> CAT </td>
   <td style="text-align:left;"> Steinbiter </td>
   <td style="text-align:left;"> Wolffishes (= Catfishes) nei </td>
   <td style="text-align:left;"> Anarhichas spp </td>
  </tr>
  <tr>
   <td style="text-align:right;"> 172 </td>
   <td style="text-align:left;"> NA </td>
   <td style="text-align:left;"> Ålekvabbefamilien </td>
   <td style="text-align:left;"> NA </td>
   <td style="text-align:left;"> Zoarcidae </td>
  </tr>
  <tr>
   <td style="text-align:right;"> 1721 </td>
   <td style="text-align:left;"> ELP </td>
   <td style="text-align:left;"> Ålekvabbe </td>
   <td style="text-align:left;"> Eelpout </td>
   <td style="text-align:left;"> Zoearces viviparus </td>
  </tr>
  <tr>
   <td style="text-align:right;"> 1722 </td>
   <td style="text-align:left;"> ELZ </td>
   <td style="text-align:left;"> Ulvefisk </td>
   <td style="text-align:left;"> Greater eelpout </td>
   <td style="text-align:left;"> Lycodes esmarkii </td>
  </tr>
  <tr>
   <td style="text-align:right;"> 1723 </td>
   <td style="text-align:left;"> OPT </td>
   <td style="text-align:left;"> Ocean pout </td>
   <td style="text-align:left;"> Ocean pout </td>
   <td style="text-align:left;"> Macrozoarces (Zoarces) americanus </td>
  </tr>
  <tr>
   <td style="text-align:right;"> 1799 </td>
   <td style="text-align:left;"> MZZ </td>
   <td style="text-align:left;"> Annen slimfisk </td>
   <td style="text-align:left;"> Blennoidei </td>
   <td style="text-align:left;"> Blennoidei </td>
  </tr>
  <tr>
   <td style="text-align:right;"> 18 </td>
   <td style="text-align:left;"> NA </td>
   <td style="text-align:left;"> AMMODYTOIDEI </td>
   <td style="text-align:left;"> NA </td>
   <td style="text-align:left;"> AMMODYTOIDEI </td>
  </tr>
  <tr>
   <td style="text-align:right;"> 181 </td>
   <td style="text-align:left;"> NA </td>
   <td style="text-align:left;"> Silfamilien </td>
   <td style="text-align:left;"> NA </td>
   <td style="text-align:left;"> Ammodytidae </td>
  </tr>
  <tr>
   <td style="text-align:right;"> 1811 </td>
   <td style="text-align:left;"> SAN </td>
   <td style="text-align:left;"> Tobis og annen sil </td>
   <td style="text-align:left;"> Sandeels (= Sandlances) nei </td>
   <td style="text-align:left;"> Ammodytes </td>
  </tr>
  <tr>
   <td style="text-align:right;"> 1812 </td>
   <td style="text-align:left;"> ABZ </td>
   <td style="text-align:left;"> Småsil </td>
   <td style="text-align:left;"> Small sandeel </td>
   <td style="text-align:left;"> Ammodytes tobianus </td>
  </tr>
  <tr>
   <td style="text-align:right;"> 1813 </td>
   <td style="text-align:left;"> SAN </td>
   <td style="text-align:left;"> Havsil </td>
   <td style="text-align:left;"> Lesser sandeel </td>
   <td style="text-align:left;"> Ammodytes marinus </td>
  </tr>
  <tr>
   <td style="text-align:right;"> 1815 </td>
   <td style="text-align:left;"> YEZ </td>
   <td style="text-align:left;"> Storsil </td>
   <td style="text-align:left;"> Great sandeel </td>
   <td style="text-align:left;"> Hyperoplus lanceolatus </td>
  </tr>
  <tr>
   <td style="text-align:right;"> 19 </td>
   <td style="text-align:left;"> NA </td>
   <td style="text-align:left;"> TRICHIUROIDEI </td>
   <td style="text-align:left;"> NA </td>
   <td style="text-align:left;"> TRICHIUROIDEI </td>
  </tr>
  <tr>
   <td style="text-align:right;"> 191 </td>
   <td style="text-align:left;"> NA </td>
   <td style="text-align:left;"> Trådstjertfamilien </td>
   <td style="text-align:left;"> NA </td>
   <td style="text-align:left;"> Trichiuridae </td>
  </tr>
  <tr>
   <td style="text-align:right;"> 1911 </td>
   <td style="text-align:left;"> SFS </td>
   <td style="text-align:left;"> Slirefisk </td>
   <td style="text-align:left;"> Silver scabbardfish </td>
   <td style="text-align:left;"> Lepidopus caudatus </td>
  </tr>
  <tr>
   <td style="text-align:right;"> 1912 </td>
   <td style="text-align:left;"> BSF </td>
   <td style="text-align:left;"> Dolkfisk/trådstjert </td>
   <td style="text-align:left;"> Black scabbardfish </td>
   <td style="text-align:left;"> Aphanopus carbo </td>
  </tr>
  <tr>
   <td style="text-align:right;"> 20 </td>
   <td style="text-align:left;"> NA </td>
   <td style="text-align:left;"> MAKRELLFISKER </td>
   <td style="text-align:left;"> NA </td>
   <td style="text-align:left;"> SCOMBROIDEI </td>
  </tr>
  <tr>
   <td style="text-align:right;"> 2011 </td>
   <td style="text-align:left;"> BON </td>
   <td style="text-align:left;"> Stripet pelamide </td>
   <td style="text-align:left;"> Atlantic bonito </td>
   <td style="text-align:left;"> Sarda sarda </td>
  </tr>
  <tr>
   <td style="text-align:right;"> 2012 </td>
   <td style="text-align:left;"> MAS </td>
   <td style="text-align:left;"> Spansk makrell </td>
   <td style="text-align:left;"> Chub mackerel </td>
   <td style="text-align:left;"> Scomber japonicus </td>
  </tr>
  <tr>
   <td style="text-align:right;"> 2013 </td>
   <td style="text-align:left;"> MAC </td>
   <td style="text-align:left;"> Makrell </td>
   <td style="text-align:left;"> Atlantic mackerel </td>
   <td style="text-align:left;"> Scomber scombrus </td>
  </tr>
  <tr>
   <td style="text-align:right;"> 2014 </td>
   <td style="text-align:left;"> SSM </td>
   <td style="text-align:left;"> Atl. spansk makrell </td>
   <td style="text-align:left;"> Atlantic spanish mackerel </td>
   <td style="text-align:left;"> Scomberomorus maculatus </td>
  </tr>
  <tr>
   <td style="text-align:right;"> 2015 </td>
   <td style="text-align:left;"> MAX </td>
   <td style="text-align:left;"> Annen makrell </td>
   <td style="text-align:left;"> Mackerels </td>
   <td style="text-align:left;"> Scombridae </td>
  </tr>
  <tr>
   <td style="text-align:right;"> 2016 </td>
   <td style="text-align:left;"> FRZ </td>
   <td style="text-align:left;"> Auxid </td>
   <td style="text-align:left;"> Frigate &amp; bullet tunas </td>
   <td style="text-align:left;"> Auxis thazard,A. rochei </td>
  </tr>
  <tr>
   <td style="text-align:right;"> 2017 </td>
   <td style="text-align:left;"> LTA </td>
   <td style="text-align:left;"> Tunnin </td>
   <td style="text-align:left;"> Atlantic black skipjack </td>
   <td style="text-align:left;"> Euthynnus alletteratus </td>
  </tr>
  <tr>
   <td style="text-align:right;"> 2018 </td>
   <td style="text-align:left;"> SKJ </td>
   <td style="text-align:left;"> Bukstripet pelamide </td>
   <td style="text-align:left;"> Skipjack tuna </td>
   <td style="text-align:left;"> Katsuwonus pelamis </td>
  </tr>
  <tr>
   <td style="text-align:right;"> 2019 </td>
   <td style="text-align:left;"> BFT </td>
   <td style="text-align:left;"> Makrellstørje </td>
   <td style="text-align:left;"> Atlantic bluefin tuna </td>
   <td style="text-align:left;"> Thunnus thynnus </td>
  </tr>
  <tr>
   <td style="text-align:right;"> 2021 </td>
   <td style="text-align:left;"> ALB </td>
   <td style="text-align:left;"> Albakor </td>
   <td style="text-align:left;"> Albacore </td>
   <td style="text-align:left;"> Thunnus alalunga </td>
  </tr>
  <tr>
   <td style="text-align:right;"> 2022 </td>
   <td style="text-align:left;"> YFT </td>
   <td style="text-align:left;"> Yellowfin tuna </td>
   <td style="text-align:left;"> Yellowfin tuna </td>
   <td style="text-align:left;"> Thunnus albacares </td>
  </tr>
  <tr>
   <td style="text-align:right;"> 2023 </td>
   <td style="text-align:left;"> BET </td>
   <td style="text-align:left;"> Bigeye tuna </td>
   <td style="text-align:left;"> Bigeye tuna </td>
   <td style="text-align:left;"> Thunnus obesus </td>
  </tr>
  <tr>
   <td style="text-align:right;"> 203 </td>
   <td style="text-align:left;"> NA </td>
   <td style="text-align:left;"> NA </td>
   <td style="text-align:left;"> NA </td>
   <td style="text-align:left;"> Istiophoridae </td>
  </tr>
  <tr>
   <td style="text-align:right;"> 2031 </td>
   <td style="text-align:left;"> SAI </td>
   <td style="text-align:left;"> Seilfisk </td>
   <td style="text-align:left;"> Atlantic sailfish </td>
   <td style="text-align:left;"> Istiophorus albicans </td>
  </tr>
  <tr>
   <td style="text-align:right;"> 2032 </td>
   <td style="text-align:left;"> BUM </td>
   <td style="text-align:left;"> Atlantic blue marlin </td>
   <td style="text-align:left;"> Atlantic blue marlin </td>
   <td style="text-align:left;"> Makaira nigricans </td>
  </tr>
  <tr>
   <td style="text-align:right;"> 2033 </td>
   <td style="text-align:left;"> WHM </td>
   <td style="text-align:left;"> Atlantic white marlin </td>
   <td style="text-align:left;"> Atlantic white marlin </td>
   <td style="text-align:left;"> Tetrapturus albidus </td>
  </tr>
  <tr>
   <td style="text-align:right;"> 205 </td>
   <td style="text-align:left;"> NA </td>
   <td style="text-align:left;"> Sverdfiskfamilien </td>
   <td style="text-align:left;"> NA </td>
   <td style="text-align:left;"> Xiphiidae </td>
  </tr>
  <tr>
   <td style="text-align:right;"> 2051 </td>
   <td style="text-align:left;"> SWO </td>
   <td style="text-align:left;"> Sverdfisk </td>
   <td style="text-align:left;"> Swordfish </td>
   <td style="text-align:left;"> Xiphias gladius </td>
  </tr>
  <tr>
   <td style="text-align:right;"> 2099 </td>
   <td style="text-align:left;"> TUN </td>
   <td style="text-align:left;"> Annen tunfisk </td>
   <td style="text-align:left;"> Tunas </td>
   <td style="text-align:left;"> Thunnini </td>
  </tr>
  <tr>
   <td style="text-align:right;"> 210 </td>
   <td style="text-align:left;"> NA </td>
   <td style="text-align:left;"> Kutlingfamilien </td>
   <td style="text-align:left;"> NA </td>
   <td style="text-align:left;"> Gobiidae </td>
  </tr>
  <tr>
   <td style="text-align:right;"> 2101 </td>
   <td style="text-align:left;"> GPA </td>
   <td style="text-align:left;"> Kutling </td>
   <td style="text-align:left;"> Gobies </td>
   <td style="text-align:left;"> Gobiidae </td>
  </tr>
  <tr>
   <td style="text-align:right;"> 2102 </td>
   <td style="text-align:left;"> GBF </td>
   <td style="text-align:left;"> Tangkutling </td>
   <td style="text-align:left;"> Two-spotted goby </td>
   <td style="text-align:left;"> Gobiusculus flavescens </td>
  </tr>
  <tr>
   <td style="text-align:right;"> 2105 </td>
   <td style="text-align:left;"> GBN </td>
   <td style="text-align:left;"> Svartkutling </td>
   <td style="text-align:left;"> black goby </td>
   <td style="text-align:left;"> Gobius niger </td>
  </tr>
  <tr>
   <td style="text-align:right;"> 2110 </td>
   <td style="text-align:left;"> OBD </td>
   <td style="text-align:left;"> Leirkutling </td>
   <td style="text-align:left;"> Common goby </td>
   <td style="text-align:left;"> Pomatoschistus microps </td>
  </tr>
  <tr>
   <td style="text-align:right;"> 2111 </td>
   <td style="text-align:left;"> OBZ </td>
   <td style="text-align:left;"> Sandkutling </td>
   <td style="text-align:left;"> Sand goby </td>
   <td style="text-align:left;"> Pomatoschistus minutus </td>
  </tr>
  <tr>
   <td style="text-align:right;"> 2112 </td>
   <td style="text-align:left;"> UFB </td>
   <td style="text-align:left;"> Benguela-kutling </td>
   <td style="text-align:left;"> Pelagic goby </td>
   <td style="text-align:left;"> Sufflogobius bibarbatus </td>
  </tr>
  <tr>
   <td style="text-align:right;"> 220 </td>
   <td style="text-align:left;"> NA </td>
   <td style="text-align:left;"> Uerfamilien </td>
   <td style="text-align:left;"> NA </td>
   <td style="text-align:left;"> Scorpaenidae </td>
  </tr>
  <tr>
   <td style="text-align:right;"> 2201 </td>
   <td style="text-align:left;"> RED </td>
   <td style="text-align:left;"> Uer uspes. </td>
   <td style="text-align:left;"> Atlantic redfishes </td>
   <td style="text-align:left;"> Sebastes </td>
  </tr>
  <tr>
   <td style="text-align:right;"> 2202 </td>
   <td style="text-align:left;"> REG </td>
   <td style="text-align:left;"> Uer (vanlig) </td>
   <td style="text-align:left;"> Golden redfish </td>
   <td style="text-align:left;"> Sebastes norvegicus </td>
  </tr>
  <tr>
   <td style="text-align:right;"> 2203 </td>
   <td style="text-align:left;"> REB </td>
   <td style="text-align:left;"> Snabeluer </td>
   <td style="text-align:left;"> Beaked redfish </td>
   <td style="text-align:left;"> Sebastes mentella </td>
  </tr>
  <tr>
   <td style="text-align:right;"> 220301 </td>
   <td style="text-align:left;"> REB </td>
   <td style="text-align:left;"> Snabeluer (Irmingerhavet) </td>
   <td style="text-align:left;"> Beaked redfish </td>
   <td style="text-align:left;"> Sebastes mentella </td>
  </tr>
  <tr>
   <td style="text-align:right;"> 2204 </td>
   <td style="text-align:left;"> SFV </td>
   <td style="text-align:left;"> Lusuer </td>
   <td style="text-align:left;"> Norway redfish </td>
   <td style="text-align:left;"> Sebastes viviparus </td>
  </tr>
  <tr>
   <td style="text-align:right;"> 2205 </td>
   <td style="text-align:left;"> BRF </td>
   <td style="text-align:left;"> Blåkjeft </td>
   <td style="text-align:left;"> Bluemouth </td>
   <td style="text-align:left;"> Helicolenus dactylopterus </td>
  </tr>
  <tr>
   <td style="text-align:right;"> 2206 </td>
   <td style="text-align:left;"> TJX </td>
   <td style="text-align:left;"> Atlantic thornyhead (Spiny scorpionfish) </td>
   <td style="text-align:left;"> Atlantic thornyhead (Spiny scorpionfish) </td>
   <td style="text-align:left;"> Trachyscorpia cristulata echinata </td>
  </tr>
  <tr>
   <td style="text-align:right;"> 2211 </td>
   <td style="text-align:left;"> GUX </td>
   <td style="text-align:left;"> Knurr uspes. </td>
   <td style="text-align:left;"> Gurnards, searobins </td>
   <td style="text-align:left;"> Triglidae </td>
  </tr>
  <tr>
   <td style="text-align:right;"> 2212 </td>
   <td style="text-align:left;"> GUG </td>
   <td style="text-align:left;"> Knurr </td>
   <td style="text-align:left;"> Grey gurnard </td>
   <td style="text-align:left;"> Eutrigla gurnardus </td>
  </tr>
  <tr>
   <td style="text-align:right;"> 2213 </td>
   <td style="text-align:left;"> GUR </td>
   <td style="text-align:left;"> Tverrstripet knurr </td>
   <td style="text-align:left;"> Red gurnard </td>
   <td style="text-align:left;"> Chelidonichthys cuculus </td>
  </tr>
  <tr>
   <td style="text-align:right;"> 2214 </td>
   <td style="text-align:left;"> GUU </td>
   <td style="text-align:left;"> Rødknurr </td>
   <td style="text-align:left;"> Tub gurnard </td>
   <td style="text-align:left;"> Chelidonichthys lucernus (lucerna) </td>
  </tr>
  <tr>
   <td style="text-align:right;"> 2215 </td>
   <td style="text-align:left;"> SRA </td>
   <td style="text-align:left;"> Atlantic searobins </td>
   <td style="text-align:left;"> Atlantic searobins </td>
   <td style="text-align:left;"> Prionotus spp </td>
  </tr>
  <tr>
   <td style="text-align:right;"> 222 </td>
   <td style="text-align:left;"> NA </td>
   <td style="text-align:left;"> Rognkjeksfamilien </td>
   <td style="text-align:left;"> NA </td>
   <td style="text-align:left;"> Cyclopteridae </td>
  </tr>
  <tr>
   <td style="text-align:right;"> 2221 </td>
   <td style="text-align:left;"> LUM </td>
   <td style="text-align:left;"> Rognkjeks (felles) </td>
   <td style="text-align:left;"> Lumpfish (=Lumpsucker) </td>
   <td style="text-align:left;"> Cyclopterus lumpus </td>
  </tr>
  <tr>
   <td style="text-align:right;"> 222110 </td>
   <td style="text-align:left;"> LUM </td>
   <td style="text-align:left;"> Rognkall (han) </td>
   <td style="text-align:left;"> Lumpfish (= Lumpsucker) </td>
   <td style="text-align:left;"> Cyclopterus lumpus </td>
  </tr>
  <tr>
   <td style="text-align:right;"> 222120 </td>
   <td style="text-align:left;"> LUM </td>
   <td style="text-align:left;"> Rognkjeks (hun) </td>
   <td style="text-align:left;"> Lumpfish (= Lumpsucker) </td>
   <td style="text-align:left;"> Cyclopterus lumpus </td>
  </tr>
  <tr>
   <td style="text-align:right;"> 222130 </td>
   <td style="text-align:left;"> LUM </td>
   <td style="text-align:left;"> Rognkjeks (oppdrett) </td>
   <td style="text-align:left;"> Lumpfish (= Lumpsucker) </td>
   <td style="text-align:left;"> Cyclopterus lumpus </td>
  </tr>
  <tr>
   <td style="text-align:right;"> 223 </td>
   <td style="text-align:left;"> NA </td>
   <td style="text-align:left;"> Ulkefamilien </td>
   <td style="text-align:left;"> Sculpins </td>
   <td style="text-align:left;"> Cottidae </td>
  </tr>
  <tr>
   <td style="text-align:right;"> 2231 </td>
   <td style="text-align:left;"> MXV </td>
   <td style="text-align:left;"> Vanlig ulke </td>
   <td style="text-align:left;"> Shorthorn sculpin </td>
   <td style="text-align:left;"> Myoxocephalus scorpius </td>
  </tr>
  <tr>
   <td style="text-align:right;"> 2232 </td>
   <td style="text-align:left;"> IBI </td>
   <td style="text-align:left;"> Tornulke </td>
   <td style="text-align:left;"> Twohorn sculpin </td>
   <td style="text-align:left;"> Icelus bicornis </td>
  </tr>
  <tr>
   <td style="text-align:right;"> 2233 </td>
   <td style="text-align:left;"> TGM </td>
   <td style="text-align:left;"> Nordlig knurrulke </td>
   <td style="text-align:left;"> Moustache sculpin </td>
   <td style="text-align:left;"> Triglops murrayi </td>
  </tr>
  <tr>
   <td style="text-align:right;"> 2234 </td>
   <td style="text-align:left;"> ZTG </td>
   <td style="text-align:left;"> Arktisk knurrulke </td>
   <td style="text-align:left;"> Ribbed sculpin </td>
   <td style="text-align:left;"> Tripglops pingelii </td>
  </tr>
  <tr>
   <td style="text-align:right;"> 2235 </td>
   <td style="text-align:left;"> GWY </td>
   <td style="text-align:left;"> Glattulke </td>
   <td style="text-align:left;"> Arctic staghorn sculpin </td>
   <td style="text-align:left;"> Gymnocanthus tricuspis </td>
  </tr>
  <tr>
   <td style="text-align:right;"> 2236 </td>
   <td style="text-align:left;"> ZAA </td>
   <td style="text-align:left;"> Krokulke </td>
   <td style="text-align:left;"> Atlantic hookear sculpin </td>
   <td style="text-align:left;"> Artediellus atlanticus </td>
  </tr>
  <tr>
   <td style="text-align:right;"> 2237 </td>
   <td style="text-align:left;"> XTA </td>
   <td style="text-align:left;"> Dvergulke </td>
   <td style="text-align:left;"> Longspined bullhead </td>
   <td style="text-align:left;"> Taurulus bubalis </td>
  </tr>
  <tr>
   <td style="text-align:right;"> 223701 </td>
   <td style="text-align:left;"> XTA </td>
   <td style="text-align:left;"> Dvergulke (oppdrett) </td>
   <td style="text-align:left;"> Longspined bullhead </td>
   <td style="text-align:left;"> Taurulus bubalis </td>
  </tr>
  <tr>
   <td style="text-align:right;"> 2299 </td>
   <td style="text-align:left;"> NA </td>
   <td style="text-align:left;"> Annen ulkefisk </td>
   <td style="text-align:left;"> Scorpian fishes, gurnards nei </td>
   <td style="text-align:left;"> Scorpaeniformes </td>
  </tr>
  <tr>
   <td style="text-align:right;"> 2311 </td>
   <td style="text-align:left;"> HAL </td>
   <td style="text-align:left;"> Kveite </td>
   <td style="text-align:left;"> Atlantic halibut </td>
   <td style="text-align:left;"> Hippoglossus hippoglossus </td>
  </tr>
  <tr>
   <td style="text-align:right;"> 231101 </td>
   <td style="text-align:left;"> HAL </td>
   <td style="text-align:left;"> Kveite (oppdrett) </td>
   <td style="text-align:left;"> Atlantic halibut </td>
   <td style="text-align:left;"> Hippoglossus hippoglossus </td>
  </tr>
  <tr>
   <td style="text-align:right;"> 2312 </td>
   <td style="text-align:left;"> PLE </td>
   <td style="text-align:left;"> Rødspette </td>
   <td style="text-align:left;"> European plaice </td>
   <td style="text-align:left;"> Pleuronectes platessa </td>
  </tr>
  <tr>
   <td style="text-align:right;"> 2313 </td>
   <td style="text-align:left;"> GHL </td>
   <td style="text-align:left;"> Blåkveite </td>
   <td style="text-align:left;"> Greenland halibut </td>
   <td style="text-align:left;"> Reinhardtius hippoglossoides </td>
  </tr>
  <tr>
   <td style="text-align:right;"> 2314 </td>
   <td style="text-align:left;"> WIT </td>
   <td style="text-align:left;"> Smørflyndre </td>
   <td style="text-align:left;"> Witch flounder </td>
   <td style="text-align:left;"> Glyptocephalus cynoglossus </td>
  </tr>
  <tr>
   <td style="text-align:right;"> 2315 </td>
   <td style="text-align:left;"> PLA </td>
   <td style="text-align:left;"> Gapeflyndre </td>
   <td style="text-align:left;"> Amer. Plaice(=Long rough dab) </td>
   <td style="text-align:left;"> Hippoglossoides platessoides </td>
  </tr>
  <tr>
   <td style="text-align:right;"> 2316 </td>
   <td style="text-align:left;"> YEL </td>
   <td style="text-align:left;"> Yellowtail flounder </td>
   <td style="text-align:left;"> Yellowtail flounder </td>
   <td style="text-align:left;"> Limanda ferruginea </td>
  </tr>
  <tr>
   <td style="text-align:right;"> 2317 </td>
   <td style="text-align:left;"> DAB </td>
   <td style="text-align:left;"> Sandflyndre </td>
   <td style="text-align:left;"> Common dab </td>
   <td style="text-align:left;"> Limanda limanda </td>
  </tr>
  <tr>
   <td style="text-align:right;"> 2318 </td>
   <td style="text-align:left;"> LEM </td>
   <td style="text-align:left;"> Lomre </td>
   <td style="text-align:left;"> Lemon sole </td>
   <td style="text-align:left;"> Microstomus kitt </td>
  </tr>
  <tr>
   <td style="text-align:right;"> 2319 </td>
   <td style="text-align:left;"> FLE </td>
   <td style="text-align:left;"> Skrubbe </td>
   <td style="text-align:left;"> European flounder </td>
   <td style="text-align:left;"> Platichthys flesus </td>
  </tr>
  <tr>
   <td style="text-align:right;"> 2321 </td>
   <td style="text-align:left;"> FLW </td>
   <td style="text-align:left;"> Winter flounder </td>
   <td style="text-align:left;"> Winter flounder </td>
   <td style="text-align:left;"> Pseudopleuronects americanus </td>
  </tr>
  <tr>
   <td style="text-align:right;"> 2329 </td>
   <td style="text-align:left;"> PLZ </td>
   <td style="text-align:left;"> Annen flyndre </td>
   <td style="text-align:left;"> Right eye flounders </td>
   <td style="text-align:left;"> Pleuronectidae </td>
  </tr>
  <tr>
   <td style="text-align:right;"> 234 </td>
   <td style="text-align:left;"> NA </td>
   <td style="text-align:left;"> Tungefamilien </td>
   <td style="text-align:left;"> NA </td>
   <td style="text-align:left;"> Soleidae </td>
  </tr>
  <tr>
   <td style="text-align:right;"> 2341 </td>
   <td style="text-align:left;"> SOL </td>
   <td style="text-align:left;"> Tunge </td>
   <td style="text-align:left;"> Common sole </td>
   <td style="text-align:left;"> Solea solea </td>
  </tr>
  <tr>
   <td style="text-align:right;"> 2342 </td>
   <td style="text-align:left;"> SOS </td>
   <td style="text-align:left;"> Sandtunge </td>
   <td style="text-align:left;"> Sand sole </td>
   <td style="text-align:left;"> Solea lascaris </td>
  </tr>
  <tr>
   <td style="text-align:right;"> 2343 </td>
   <td style="text-align:left;"> CET </td>
   <td style="text-align:left;"> Wedge sole (Senegal) </td>
   <td style="text-align:left;"> Wedge sole (Senegal) </td>
   <td style="text-align:left;"> Dicologlossa cuneata </td>
  </tr>
  <tr>
   <td style="text-align:right;"> 2344 </td>
   <td style="text-align:left;"> OAL </td>
   <td style="text-align:left;"> Tunge (Senegal) </td>
   <td style="text-align:left;"> Senegalese sole </td>
   <td style="text-align:left;"> Solea senegalensis </td>
  </tr>
  <tr>
   <td style="text-align:right;"> 2349 </td>
   <td style="text-align:left;"> SOX </td>
   <td style="text-align:left;"> Annen tunge </td>
   <td style="text-align:left;"> Soles </td>
   <td style="text-align:left;"> Soleidae </td>
  </tr>
  <tr>
   <td style="text-align:right;"> 235 </td>
   <td style="text-align:left;"> NA </td>
   <td style="text-align:left;"> Varfamilien </td>
   <td style="text-align:left;"> NA </td>
   <td style="text-align:left;"> Scophthalmidae </td>
  </tr>
  <tr>
   <td style="text-align:right;"> 2351 </td>
   <td style="text-align:left;"> MEG </td>
   <td style="text-align:left;"> Glassvar </td>
   <td style="text-align:left;"> Megrim </td>
   <td style="text-align:left;"> Lepidorhombus whiffiagonis </td>
  </tr>
  <tr>
   <td style="text-align:right;"> 2352 </td>
   <td style="text-align:left;"> BLL </td>
   <td style="text-align:left;"> Slettvar </td>
   <td style="text-align:left;"> Brill </td>
   <td style="text-align:left;"> Scophthalmus rhombus </td>
  </tr>
  <tr>
   <td style="text-align:right;"> 2353 </td>
   <td style="text-align:left;"> FLD </td>
   <td style="text-align:left;"> Windowpane flounder </td>
   <td style="text-align:left;"> Windowpane flounder </td>
   <td style="text-align:left;"> Scophthalmus aquosus </td>
  </tr>
  <tr>
   <td style="text-align:right;"> 2354 </td>
   <td style="text-align:left;"> TUR </td>
   <td style="text-align:left;"> Piggvar </td>
   <td style="text-align:left;"> Turbot </td>
   <td style="text-align:left;"> Scophthalmus maximus </td>
  </tr>
  <tr>
   <td style="text-align:right;"> 235401 </td>
   <td style="text-align:left;"> TUR </td>
   <td style="text-align:left;"> Piggvar (oppdrett) </td>
   <td style="text-align:left;"> Turbot </td>
   <td style="text-align:left;"> Scophthalmus maximus </td>
  </tr>
  <tr>
   <td style="text-align:right;"> 2355 </td>
   <td style="text-align:left;"> FLS </td>
   <td style="text-align:left;"> Summer flounder </td>
   <td style="text-align:left;"> Summer flounder </td>
   <td style="text-align:left;"> Paralichthys dentatus </td>
  </tr>
  <tr>
   <td style="text-align:right;"> 2356 </td>
   <td style="text-align:left;"> MSF </td>
   <td style="text-align:left;"> Tungevar </td>
   <td style="text-align:left;"> Mediterranean scaldfish </td>
   <td style="text-align:left;"> Arnoglossus laterna </td>
  </tr>
  <tr>
   <td style="text-align:right;"> 2357 </td>
   <td style="text-align:left;"> LEZ </td>
   <td style="text-align:left;"> Megrim nei </td>
   <td style="text-align:left;"> Megrim nei </td>
   <td style="text-align:left;"> Lepidorhombus </td>
  </tr>
  <tr>
   <td style="text-align:right;"> 2359 </td>
   <td style="text-align:left;"> LEF </td>
   <td style="text-align:left;"> Annen var </td>
   <td style="text-align:left;"> Left eye flounders </td>
   <td style="text-align:left;"> Bothidae </td>
  </tr>
  <tr>
   <td style="text-align:right;"> 2399 </td>
   <td style="text-align:left;"> FLX </td>
   <td style="text-align:left;"> Annen flatfisk </td>
   <td style="text-align:left;"> Flatfishes </td>
   <td style="text-align:left;"> Pleuronectiformes </td>
  </tr>
  <tr>
   <td style="text-align:right;"> 24 </td>
   <td style="text-align:left;"> NA </td>
   <td style="text-align:left;"> BREIFLABBER </td>
   <td style="text-align:left;"> NA </td>
   <td style="text-align:left;"> LOPHIIFORMES </td>
  </tr>
  <tr>
   <td style="text-align:right;"> 241 </td>
   <td style="text-align:left;"> NA </td>
   <td style="text-align:left;"> Breiflabbfamilien </td>
   <td style="text-align:left;"> NA </td>
   <td style="text-align:left;"> Lophiidae </td>
  </tr>
  <tr>
   <td style="text-align:right;"> 2411 </td>
   <td style="text-align:left;"> MON </td>
   <td style="text-align:left;"> Breiflabb </td>
   <td style="text-align:left;"> Angler (= Monk) </td>
   <td style="text-align:left;"> Lophius piscatorius </td>
  </tr>
  <tr>
   <td style="text-align:right;"> 2412 </td>
   <td style="text-align:left;"> ANG </td>
   <td style="text-align:left;"> American angler </td>
   <td style="text-align:left;"> American angler </td>
   <td style="text-align:left;"> Lophius americanus </td>
  </tr>
  <tr>
   <td style="text-align:right;"> 2499 </td>
   <td style="text-align:left;"> ANF </td>
   <td style="text-align:left;"> Andre av breiflabbfamilien </td>
   <td style="text-align:left;"> Anglerfishes </td>
   <td style="text-align:left;"> Lophiidae </td>
  </tr>
  <tr>
   <td style="text-align:right;"> 29 </td>
   <td style="text-align:left;"> NA </td>
   <td style="text-align:left;"> ANNEN FISK </td>
   <td style="text-align:left;"> NA </td>
   <td style="text-align:left;"> NA </td>
  </tr>
  <tr>
   <td style="text-align:right;"> 2919 </td>
   <td style="text-align:left;"> MZZ </td>
   <td style="text-align:left;"> Annen marin fisk </td>
   <td style="text-align:left;"> Marine fishes </td>
   <td style="text-align:left;"> Osteichthyes </td>
  </tr>
  <tr>
   <td style="text-align:right;"> 2929 </td>
   <td style="text-align:left;"> GRO </td>
   <td style="text-align:left;"> Groundfishes nei </td>
   <td style="text-align:left;"> Groundfishes nei </td>
   <td style="text-align:left;"> Osteichthyes </td>
  </tr>
  <tr>
   <td style="text-align:right;"> 2939 </td>
   <td style="text-align:left;"> PEL </td>
   <td style="text-align:left;"> Pelagic fishes nei </td>
   <td style="text-align:left;"> Pelagic fishes nei </td>
   <td style="text-align:left;"> Osteichthyes </td>
  </tr>
  <tr>
   <td style="text-align:right;"> 2949 </td>
   <td style="text-align:left;"> FIN </td>
   <td style="text-align:left;"> Finfishes nei </td>
   <td style="text-align:left;"> Finfishes nei </td>
   <td style="text-align:left;"> Osteichthyes </td>
  </tr>
  <tr>
   <td style="text-align:right;"> 2999 </td>
   <td style="text-align:left;"> MZZ </td>
   <td style="text-align:left;"> Uspesifisert fisk </td>
   <td style="text-align:left;"> Marine fishes nei </td>
   <td style="text-align:left;"> Indeterminus </td>
  </tr>
  <tr>
   <td style="text-align:right;"> 30 </td>
   <td style="text-align:left;"> NA </td>
   <td style="text-align:left;"> SLIMÅLER </td>
   <td style="text-align:left;"> HAGFISHES </td>
   <td style="text-align:left;"> MYXINIFORMES </td>
  </tr>
  <tr>
   <td style="text-align:right;"> 301 </td>
   <td style="text-align:left;"> MYX </td>
   <td style="text-align:left;"> Slimålfamilien </td>
   <td style="text-align:left;"> Hagfishes </td>
   <td style="text-align:left;"> Myxinidae </td>
  </tr>
  <tr>
   <td style="text-align:right;"> 3011 </td>
   <td style="text-align:left;"> MYG </td>
   <td style="text-align:left;"> Slimål </td>
   <td style="text-align:left;"> Hagfish </td>
   <td style="text-align:left;"> Myxine glutinosa </td>
  </tr>
  <tr>
   <td style="text-align:right;"> 31 </td>
   <td style="text-align:left;"> NA </td>
   <td style="text-align:left;"> KIMÆRER </td>
   <td style="text-align:left;"> NA </td>
   <td style="text-align:left;"> CHIMAERIFORMES </td>
  </tr>
  <tr>
   <td style="text-align:right;"> 3111 </td>
   <td style="text-align:left;"> CMO </td>
   <td style="text-align:left;"> Havmus </td>
   <td style="text-align:left;"> Rabbit fish </td>
   <td style="text-align:left;"> Chimaera monstrosa </td>
  </tr>
  <tr>
   <td style="text-align:right;"> 3112 </td>
   <td style="text-align:left;"> HYD </td>
   <td style="text-align:left;"> Ratfishes nei </td>
   <td style="text-align:left;"> Ratfishes nei </td>
   <td style="text-align:left;"> Hydrolagus spp </td>
  </tr>
  <tr>
   <td style="text-align:right;"> 3113 </td>
   <td style="text-align:left;"> RHC </td>
   <td style="text-align:left;"> Knife-nosed chimaeras </td>
   <td style="text-align:left;"> Knife-nosed chimaeras </td>
   <td style="text-align:left;"> Rhinochimaera spp </td>
  </tr>
  <tr>
   <td style="text-align:right;"> 3114 </td>
   <td style="text-align:left;"> HAR </td>
   <td style="text-align:left;"> Longnose chimaeras </td>
   <td style="text-align:left;"> Longnose chimaeras </td>
   <td style="text-align:left;"> Harriotta spp </td>
  </tr>
  <tr>
   <td style="text-align:right;"> 3115 </td>
   <td style="text-align:left;"> CYA </td>
   <td style="text-align:left;"> Brun havmus </td>
   <td style="text-align:left;"> Smalleyed ratfish </td>
   <td style="text-align:left;"> Hydrolagus affinis </td>
  </tr>
  <tr>
   <td style="text-align:right;"> 3116 </td>
   <td style="text-align:left;"> CYH </td>
   <td style="text-align:left;"> Blåvinget havmus </td>
   <td style="text-align:left;"> Large-eyed rabbitfish </td>
   <td style="text-align:left;"> Hydrolagus mirabilis </td>
  </tr>
  <tr>
   <td style="text-align:right;"> 3117 </td>
   <td style="text-align:left;"> HOL </td>
   <td style="text-align:left;"> Havmus uspes. </td>
   <td style="text-align:left;"> Chimaeras etc.nei </td>
   <td style="text-align:left;"> Chimaeriformes </td>
  </tr>
  <tr>
   <td style="text-align:right;"> 3118 </td>
   <td style="text-align:left;"> RCT </td>
   <td style="text-align:left;"> Straighnose rabbitfish </td>
   <td style="text-align:left;"> Straighnose rabbitfish </td>
   <td style="text-align:left;"> Rhinochimaera atlantica </td>
  </tr>
  <tr>
   <td style="text-align:right;"> 32 </td>
   <td style="text-align:left;"> NA </td>
   <td style="text-align:left;"> BÅNDFISKER </td>
   <td style="text-align:left;"> NA </td>
   <td style="text-align:left;"> SYNGNATHIFORMES </td>
  </tr>
  <tr>
   <td style="text-align:right;"> 3211 </td>
   <td style="text-align:left;"> LAG </td>
   <td style="text-align:left;"> Laksestørje </td>
   <td style="text-align:left;"> Opah </td>
   <td style="text-align:left;"> Lampris guttatus </td>
  </tr>
  <tr>
   <td style="text-align:right;"> 33 </td>
   <td style="text-align:left;"> HXW </td>
   <td style="text-align:left;"> SEKS- OG SYVGJELLETE HAIER </td>
   <td style="text-align:left;"> FRILL AND COW SHARKS </td>
   <td style="text-align:left;"> HEXANCHIFORMES </td>
  </tr>
  <tr>
   <td style="text-align:right;"> 331 </td>
   <td style="text-align:left;"> NA </td>
   <td style="text-align:left;"> Kamtannhaifamiliien </td>
   <td style="text-align:left;"> Cow sharks </td>
   <td style="text-align:left;"> Hexanchidae </td>
  </tr>
  <tr>
   <td style="text-align:right;"> 3311 </td>
   <td style="text-align:left;"> SBL </td>
   <td style="text-align:left;"> Kamtannhai </td>
   <td style="text-align:left;"> Bluntnose sixgill shark </td>
   <td style="text-align:left;"> Hexanchus griseus </td>
  </tr>
  <tr>
   <td style="text-align:right;"> 332 </td>
   <td style="text-align:left;"> NA </td>
   <td style="text-align:left;"> Kragehaifamilien </td>
   <td style="text-align:left;"> Frilled sharks </td>
   <td style="text-align:left;"> Chlamydoselachidae </td>
  </tr>
  <tr>
   <td style="text-align:right;"> 3321 </td>
   <td style="text-align:left;"> HXC </td>
   <td style="text-align:left;"> Kragehai </td>
   <td style="text-align:left;"> Frilled shark </td>
   <td style="text-align:left;"> Chlamydoselachus anguineus </td>
  </tr>
  <tr>
   <td style="text-align:right;"> 35 </td>
   <td style="text-align:left;"> NA </td>
   <td style="text-align:left;"> FASTKJEVEDE FISKER </td>
   <td style="text-align:left;"> PUFFERS AND FILEFISHES </td>
   <td style="text-align:left;"> TETRAODONTOFORMES </td>
  </tr>
  <tr>
   <td style="text-align:right;"> 351 </td>
   <td style="text-align:left;"> NA </td>
   <td style="text-align:left;"> Månefiskfamilien </td>
   <td style="text-align:left;"> Molas or Ocean sunfishes </td>
   <td style="text-align:left;"> Molidae </td>
  </tr>
  <tr>
   <td style="text-align:right;"> 3511 </td>
   <td style="text-align:left;"> MOX </td>
   <td style="text-align:left;"> Månefisk </td>
   <td style="text-align:left;"> Ocean sunfish </td>
   <td style="text-align:left;"> Mola mola </td>
  </tr>
  <tr>
   <td style="text-align:right;"> 36 </td>
   <td style="text-align:left;"> NA </td>
   <td style="text-align:left;"> LYSPRIKKFISKER </td>
   <td style="text-align:left;"> LANTERNFISHES </td>
   <td style="text-align:left;"> MYCTOPHIFORMES </td>
  </tr>
  <tr>
   <td style="text-align:right;"> 361 </td>
   <td style="text-align:left;"> NA </td>
   <td style="text-align:left;"> Lysprikkfiskfamilien </td>
   <td style="text-align:left;"> Lanternfishes </td>
   <td style="text-align:left;"> Myctophidae </td>
  </tr>
  <tr>
   <td style="text-align:right;"> 3611 </td>
   <td style="text-align:left;"> BHG </td>
   <td style="text-align:left;"> Nordlig lysprikkfisk </td>
   <td style="text-align:left;"> Glacier lanternfish </td>
   <td style="text-align:left;"> Benthosema glaciale </td>
  </tr>
  <tr>
   <td style="text-align:right;"> 361101 </td>
   <td style="text-align:left;"> BHG </td>
   <td style="text-align:left;"> Nordlig lysprikkfisk (oppdrett) </td>
   <td style="text-align:left;"> Glacier lanternfish </td>
   <td style="text-align:left;"> Benthosema glaciale </td>
  </tr>
  <tr>
   <td style="text-align:right;"> 3612 </td>
   <td style="text-align:left;"> MTP </td>
   <td style="text-align:left;"> Liten lysprikkfisk </td>
   <td style="text-align:left;"> Spotted lanternfish </td>
   <td style="text-align:left;"> Myctophum punctatum </td>
  </tr>
  <tr>
   <td style="text-align:right;"> 3613 </td>
   <td style="text-align:left;"> OWK </td>
   <td style="text-align:left;"> Stor lysprikkfisk </td>
   <td style="text-align:left;"> Kroyer's lanternfish </td>
   <td style="text-align:left;"> Notoscopelus kroeyeri </td>
  </tr>
  <tr>
   <td style="text-align:right;"> 37 </td>
   <td style="text-align:left;"> NA </td>
   <td style="text-align:left;"> STORKJEFTFISKER </td>
   <td style="text-align:left;"> LIGHTFISHES AND DRAGON- </td>
   <td style="text-align:left;"> STOMIIFORMES </td>
  </tr>
  <tr>
   <td style="text-align:right;"> 371 </td>
   <td style="text-align:left;"> NA </td>
   <td style="text-align:left;"> Storkjeftfamilien </td>
   <td style="text-align:left;"> Barbeled dragonfishes </td>
   <td style="text-align:left;"> Stomiidae </td>
  </tr>
  <tr>
   <td style="text-align:right;"> 3711 </td>
   <td style="text-align:left;"> SBB </td>
   <td style="text-align:left;"> Storkjeft </td>
   <td style="text-align:left;"> Boa dragonfish </td>
   <td style="text-align:left;"> Stomias boa </td>
  </tr>
  <tr>
   <td style="text-align:right;"> 39 </td>
   <td style="text-align:left;"> NA </td>
   <td style="text-align:left;"> NESLEDYR </td>
   <td style="text-align:left;"> CORALS AND JELLYFISH </td>
   <td style="text-align:left;"> CNIDARIA </td>
  </tr>
  <tr>
   <td style="text-align:right;"> 391 </td>
   <td style="text-align:left;"> NA </td>
   <td style="text-align:left;"> NA </td>
   <td style="text-align:left;"> NA </td>
   <td style="text-align:left;"> NA </td>
  </tr>
  <tr>
   <td style="text-align:right;"> 3911 </td>
   <td style="text-align:left;"> AJH </td>
   <td style="text-align:left;"> Koralldyr </td>
   <td style="text-align:left;"> Corals </td>
   <td style="text-align:left;"> Anthozoa </td>
  </tr>
  <tr>
   <td style="text-align:right;"> 3912 </td>
   <td style="text-align:left;"> MVI </td>
   <td style="text-align:left;"> Siksakkorall </td>
   <td style="text-align:left;"> Madrepora coral </td>
   <td style="text-align:left;"> Madrepora oculata </td>
  </tr>
  <tr>
   <td style="text-align:right;"> 3913 </td>
   <td style="text-align:left;"> BFU </td>
   <td style="text-align:left;"> Sjøtre </td>
   <td style="text-align:left;"> Bubble gum coral </td>
   <td style="text-align:left;"> Paragorgia arborea </td>
  </tr>
  <tr>
   <td style="text-align:right;"> 3914 </td>
   <td style="text-align:left;"> QOE </td>
   <td style="text-align:left;"> Risengrynkorall </td>
   <td style="text-align:left;"> Red trees </td>
   <td style="text-align:left;"> Primnoa resedaeformis </td>
  </tr>
  <tr>
   <td style="text-align:right;"> 3915 </td>
   <td style="text-align:left;"> LWS </td>
   <td style="text-align:left;"> Øyekorall </td>
   <td style="text-align:left;"> Lophelia pertusa </td>
   <td style="text-align:left;"> Lophelia pertusa </td>
  </tr>
  <tr>
   <td style="text-align:right;"> 3916 </td>
   <td style="text-align:left;"> PZL </td>
   <td style="text-align:left;"> Sjøbusk </td>
   <td style="text-align:left;"> Paramuricea spp </td>
   <td style="text-align:left;"> Paramuricea spp </td>
  </tr>
  <tr>
   <td style="text-align:right;"> 40 </td>
   <td style="text-align:left;"> NA </td>
   <td style="text-align:left;"> SVAMPER </td>
   <td style="text-align:left;"> SPONGES </td>
   <td style="text-align:left;"> PORIFERA </td>
  </tr>
  <tr>
   <td style="text-align:right;"> 409 </td>
   <td style="text-align:left;"> NA </td>
   <td style="text-align:left;"> NA </td>
   <td style="text-align:left;"> NA </td>
   <td style="text-align:left;"> NA </td>
  </tr>
  <tr>
   <td style="text-align:right;"> 4099 </td>
   <td style="text-align:left;"> PFR </td>
   <td style="text-align:left;"> Svamper </td>
   <td style="text-align:left;"> Sponges </td>
   <td style="text-align:left;"> Porifera </td>
  </tr>
  <tr>
   <td style="text-align:right;"> 25 </td>
   <td style="text-align:left;"> NA </td>
   <td style="text-align:left;"> KREPSDYR </td>
   <td style="text-align:left;"> NA </td>
   <td style="text-align:left;"> CRUSTACEA </td>
  </tr>
  <tr>
   <td style="text-align:right;"> 2510 </td>
   <td style="text-align:left;"> NA </td>
   <td style="text-align:left;"> Krill </td>
   <td style="text-align:left;"> Euphausiacea </td>
   <td style="text-align:left;"> Euphausiacea </td>
  </tr>
  <tr>
   <td style="text-align:right;"> 251001 </td>
   <td style="text-align:left;"> NA </td>
   <td style="text-align:left;"> Krill (oppdrett) </td>
   <td style="text-align:left;"> Euphausiacea </td>
   <td style="text-align:left;"> Euphausiacea </td>
  </tr>
  <tr>
   <td style="text-align:right;"> 2511 </td>
   <td style="text-align:left;"> NKR </td>
   <td style="text-align:left;"> Norsk storkrill </td>
   <td style="text-align:left;"> Norwegian krill </td>
   <td style="text-align:left;"> Meganyctiphanes norvegica </td>
  </tr>
  <tr>
   <td style="text-align:right;"> 2512 </td>
   <td style="text-align:left;"> JCM </td>
   <td style="text-align:left;"> Raudåte </td>
   <td style="text-align:left;"> Calanus finmarchicus </td>
   <td style="text-align:left;"> Calanus finmarchicus </td>
  </tr>
  <tr>
   <td style="text-align:right;"> 251201 </td>
   <td style="text-align:left;"> JCM </td>
   <td style="text-align:left;"> Raudåte (oppdrett) </td>
   <td style="text-align:left;"> Calanus finmarchicus </td>
   <td style="text-align:left;"> Calanus finmarchicus </td>
  </tr>
  <tr>
   <td style="text-align:right;"> 2513 </td>
   <td style="text-align:left;"> KRI </td>
   <td style="text-align:left;"> Antarktisk krill </td>
   <td style="text-align:left;"> Antarctic krill </td>
   <td style="text-align:left;"> Euphausia superba </td>
  </tr>
  <tr>
   <td style="text-align:right;"> 251401 </td>
   <td style="text-align:left;"> JCA </td>
   <td style="text-align:left;"> Acartia tonsa (oppdrett) </td>
   <td style="text-align:left;"> Acartia tonsa </td>
   <td style="text-align:left;"> Acartia tonsa </td>
  </tr>
  <tr>
   <td style="text-align:right;"> 2515 </td>
   <td style="text-align:left;"> WKT </td>
   <td style="text-align:left;"> Arctic sea ice amphipod </td>
   <td style="text-align:left;"> Arctic sea ice amphipod </td>
   <td style="text-align:left;"> Gammarus wilkitzkii </td>
  </tr>
  <tr>
   <td style="text-align:right;"> 2516 </td>
   <td style="text-align:left;"> WSE </td>
   <td style="text-align:left;"> Gammarus setosus </td>
   <td style="text-align:left;"> Gammarus setosus </td>
   <td style="text-align:left;"> Gammarus setosus </td>
  </tr>
  <tr>
   <td style="text-align:right;"> 2517 </td>
   <td style="text-align:left;"> QLT </td>
   <td style="text-align:left;"> Onisimus litoralis </td>
   <td style="text-align:left;"> Onisimus litoralis </td>
   <td style="text-align:left;"> Onisimus litoralis </td>
  </tr>
  <tr>
   <td style="text-align:right;"> 2518 </td>
   <td style="text-align:left;"> PNQ </td>
   <td style="text-align:left;"> Stripet strandreke </td>
   <td style="text-align:left;"> Rockpool prawn </td>
   <td style="text-align:left;"> Palaemon elegans </td>
  </tr>
  <tr>
   <td style="text-align:right;"> 2519 </td>
   <td style="text-align:left;"> AES </td>
   <td style="text-align:left;"> Blomsterreke </td>
   <td style="text-align:left;"> Aesop shrimp </td>
   <td style="text-align:left;"> Pandalus montagui </td>
  </tr>
  <tr>
   <td style="text-align:right;"> 2520 </td>
   <td style="text-align:left;"> HVO </td>
   <td style="text-align:left;"> Sjøgressreke </td>
   <td style="text-align:left;"> Chameleon prawn </td>
   <td style="text-align:left;"> Hippolyte varians </td>
  </tr>
  <tr>
   <td style="text-align:right;"> 2521 </td>
   <td style="text-align:left;"> UJP </td>
   <td style="text-align:left;"> Dvergreke </td>
   <td style="text-align:left;"> Doll eualid </td>
   <td style="text-align:left;"> Eualus pusiolus </td>
  </tr>
  <tr>
   <td style="text-align:right;"> 2522 </td>
   <td style="text-align:left;"> PEN </td>
   <td style="text-align:left;"> Reke av Penaeusslekten </td>
   <td style="text-align:left;"> Penaeus shrimps nei </td>
   <td style="text-align:left;"> Penaeus spp </td>
  </tr>
  <tr>
   <td style="text-align:right;"> 2523 </td>
   <td style="text-align:left;"> PAN </td>
   <td style="text-align:left;"> Reke av  Pandalusslekten </td>
   <td style="text-align:left;"> Pandalus shrimps nei </td>
   <td style="text-align:left;"> Pandalus </td>
  </tr>
  <tr>
   <td style="text-align:right;"> 2524 </td>
   <td style="text-align:left;"> PRA </td>
   <td style="text-align:left;"> Dypvannsreke </td>
   <td style="text-align:left;"> Northern prawn </td>
   <td style="text-align:left;"> Pandalus borealis </td>
  </tr>
  <tr>
   <td style="text-align:right;"> 2525 </td>
   <td style="text-align:left;"> PAL </td>
   <td style="text-align:left;"> Reke av  Palaemonidaeslekten </td>
   <td style="text-align:left;"> Palaemonid shrimps nei </td>
   <td style="text-align:left;"> Palaemonidae </td>
  </tr>
  <tr>
   <td style="text-align:right;"> 2526 </td>
   <td style="text-align:left;"> CPR </td>
   <td style="text-align:left;"> Common prawn </td>
   <td style="text-align:left;"> Common prawn </td>
   <td style="text-align:left;"> Palaemon serratus </td>
  </tr>
  <tr>
   <td style="text-align:right;"> 2527 </td>
   <td style="text-align:left;"> CRN </td>
   <td style="text-align:left;"> Reke av Crangonidaeslekten </td>
   <td style="text-align:left;"> Crangonid shrimps nei </td>
   <td style="text-align:left;"> Crangonidae </td>
  </tr>
  <tr>
   <td style="text-align:right;"> 2528 </td>
   <td style="text-align:left;"> CSH </td>
   <td style="text-align:left;"> Hestereke </td>
   <td style="text-align:left;"> Common shrimp </td>
   <td style="text-align:left;"> Crangon crangon </td>
  </tr>
  <tr>
   <td style="text-align:right;"> 2529 </td>
   <td style="text-align:left;"> IRI </td>
   <td style="text-align:left;"> Kamuflasjereke </td>
   <td style="text-align:left;"> Friendly blade shrimp </td>
   <td style="text-align:left;"> Spirontocaris liljeborgi </td>
  </tr>
  <tr>
   <td style="text-align:right;"> 2530 </td>
   <td style="text-align:left;"> PAA </td>
   <td style="text-align:left;"> Strandreke </td>
   <td style="text-align:left;"> Baltic prawn </td>
   <td style="text-align:left;"> Palaemon adspersus </td>
  </tr>
  <tr>
   <td style="text-align:right;"> 253001 </td>
   <td style="text-align:left;"> PAA </td>
   <td style="text-align:left;"> Strandreke (oppdrett) </td>
   <td style="text-align:left;"> Baltic prawn </td>
   <td style="text-align:left;"> Palaemon adspersus </td>
  </tr>
  <tr>
   <td style="text-align:right;"> 2531 </td>
   <td style="text-align:left;"> CRW </td>
   <td style="text-align:left;"> Langust, upes. </td>
   <td style="text-align:left;"> Palinurid spiny lobsters nei </td>
   <td style="text-align:left;"> Palinurus spp </td>
  </tr>
  <tr>
   <td style="text-align:right;"> 2532 </td>
   <td style="text-align:left;"> CRE </td>
   <td style="text-align:left;"> Taskekrabbe </td>
   <td style="text-align:left;"> Edible crab </td>
   <td style="text-align:left;"> Cancer pagurus </td>
  </tr>
  <tr>
   <td style="text-align:right;"> 253210 </td>
   <td style="text-align:left;"> CRE </td>
   <td style="text-align:left;"> Taskekrabbe, han- </td>
   <td style="text-align:left;"> Edible crab </td>
   <td style="text-align:left;"> Cancer pagurus </td>
  </tr>
  <tr>
   <td style="text-align:right;"> 253220 </td>
   <td style="text-align:left;"> CRE </td>
   <td style="text-align:left;"> Taskekrabbe, hun- </td>
   <td style="text-align:left;"> Edible crab </td>
   <td style="text-align:left;"> Cancer pagurus </td>
  </tr>
  <tr>
   <td style="text-align:right;"> 2533 </td>
   <td style="text-align:left;"> CRS </td>
   <td style="text-align:left;"> Svømmekrabbe, uspes. </td>
   <td style="text-align:left;"> Portunus swimcrabs nei </td>
   <td style="text-align:left;"> Portunus spp </td>
  </tr>
  <tr>
   <td style="text-align:right;"> 2534 </td>
   <td style="text-align:left;"> KCD </td>
   <td style="text-align:left;"> Kongekrabbe </td>
   <td style="text-align:left;"> Red king crab </td>
   <td style="text-align:left;"> Paralithodes camtschaticus </td>
  </tr>
  <tr>
   <td style="text-align:right;"> 253410 </td>
   <td style="text-align:left;"> KCD </td>
   <td style="text-align:left;"> Kongekrabbe, han- </td>
   <td style="text-align:left;"> Red king crab </td>
   <td style="text-align:left;"> Paralithodes camtschaticus </td>
  </tr>
  <tr>
   <td style="text-align:right;"> 253420 </td>
   <td style="text-align:left;"> KCD </td>
   <td style="text-align:left;"> Kongekrabbe, hun- </td>
   <td style="text-align:left;"> Red king crab </td>
   <td style="text-align:left;"> Paralithodes camtschaticus </td>
  </tr>
  <tr>
   <td style="text-align:right;"> 2535 </td>
   <td style="text-align:left;"> KCT </td>
   <td style="text-align:left;"> Trollkrabbe </td>
   <td style="text-align:left;"> Stone king crab </td>
   <td style="text-align:left;"> Lithodes maja </td>
  </tr>
  <tr>
   <td style="text-align:right;"> 2536 </td>
   <td style="text-align:left;"> CRQ </td>
   <td style="text-align:left;"> Snøkrabbe </td>
   <td style="text-align:left;"> Queen crab </td>
   <td style="text-align:left;"> Chionoecetes opilio </td>
  </tr>
  <tr>
   <td style="text-align:right;"> 2537 </td>
   <td style="text-align:left;"> CRG </td>
   <td style="text-align:left;"> Strandkrabbe </td>
   <td style="text-align:left;"> Green crab </td>
   <td style="text-align:left;"> Carcinus maenas </td>
  </tr>
  <tr>
   <td style="text-align:right;"> 2539 </td>
   <td style="text-align:left;"> CRA </td>
   <td style="text-align:left;"> Annen krabbe </td>
   <td style="text-align:left;"> Marine crabs </td>
   <td style="text-align:left;"> Reptantia </td>
  </tr>
  <tr>
   <td style="text-align:right;"> 2541 </td>
   <td style="text-align:left;"> NEP </td>
   <td style="text-align:left;"> Sjøkreps </td>
   <td style="text-align:left;"> Norway lobster </td>
   <td style="text-align:left;"> Nephrops norvegicus </td>
  </tr>
  <tr>
   <td style="text-align:right;"> 2542 </td>
   <td style="text-align:left;"> LBE </td>
   <td style="text-align:left;"> Hummer </td>
   <td style="text-align:left;"> European lobster </td>
   <td style="text-align:left;"> Homarus gammarus </td>
  </tr>
  <tr>
   <td style="text-align:right;"> 2543 </td>
   <td style="text-align:left;"> LBA </td>
   <td style="text-align:left;"> Amerikansk hummer </td>
   <td style="text-align:left;"> American lobster </td>
   <td style="text-align:left;"> Homarus americanus </td>
  </tr>
  <tr>
   <td style="text-align:right;"> 2544 </td>
   <td style="text-align:left;"> AAS </td>
   <td style="text-align:left;"> Edelkreps (ferskvann) </td>
   <td style="text-align:left;"> Noble crayfish </td>
   <td style="text-align:left;"> Astacus astacus </td>
  </tr>
  <tr>
   <td style="text-align:right;"> 2545 </td>
   <td style="text-align:left;"> KEF </td>
   <td style="text-align:left;"> Deep-sea red crab </td>
   <td style="text-align:left;"> Deep-sea red crab </td>
   <td style="text-align:left;"> Chaceon affinis </td>
  </tr>
  <tr>
   <td style="text-align:right;"> 2546 </td>
   <td style="text-align:left;"> LOQ </td>
   <td style="text-align:left;"> Krinakrabbe </td>
   <td style="text-align:left;"> Galathea strigosa </td>
   <td style="text-align:left;"> Galathea strigosa </td>
  </tr>
  <tr>
   <td style="text-align:right;"> 2547 </td>
   <td style="text-align:left;"> UEX </td>
   <td style="text-align:left;"> Muddertrollkreps, uspes. </td>
   <td style="text-align:left;"> Munida spp </td>
   <td style="text-align:left;"> Munida spp </td>
  </tr>
  <tr>
   <td style="text-align:right;"> 2548 </td>
   <td style="text-align:left;"> LOQ </td>
   <td style="text-align:left;"> Trollhummer </td>
   <td style="text-align:left;"> Craylets, squat lobsters nei </td>
   <td style="text-align:left;"> Galatheidae </td>
  </tr>
  <tr>
   <td style="text-align:right;"> 2549 </td>
   <td style="text-align:left;"> UEM </td>
   <td style="text-align:left;"> Muddertrollkreps </td>
   <td style="text-align:left;"> Munida sarsi </td>
   <td style="text-align:left;"> Munida sarsi </td>
  </tr>
  <tr>
   <td style="text-align:right;"> 2550 </td>
   <td style="text-align:left;"> PZW </td>
   <td style="text-align:left;"> Bernakereremittkreps </td>
   <td style="text-align:left;"> Common hermit crab </td>
   <td style="text-align:left;"> Pagurus bernhardus </td>
  </tr>
  <tr>
   <td style="text-align:right;"> 255001 </td>
   <td style="text-align:left;"> PZW </td>
   <td style="text-align:left;"> Bernakereremittkreps (oppdrett) </td>
   <td style="text-align:left;"> Common hermit crab </td>
   <td style="text-align:left;"> Pagurus bernhardus </td>
  </tr>
  <tr>
   <td style="text-align:right;"> 2551 </td>
   <td style="text-align:left;"> GXB </td>
   <td style="text-align:left;"> Dverghummer </td>
   <td style="text-align:left;"> Galathea nexa </td>
   <td style="text-align:left;"> Galathea nexa </td>
  </tr>
  <tr>
   <td style="text-align:right;"> 255201 </td>
   <td style="text-align:left;"> NA </td>
   <td style="text-align:left;"> Calanus helgolandicus (oppdrett) </td>
   <td style="text-align:left;"> Calanus helgolandicus </td>
   <td style="text-align:left;"> Calanus helgolandicus </td>
  </tr>
  <tr>
   <td style="text-align:right;"> 255301 </td>
   <td style="text-align:left;"> NA </td>
   <td style="text-align:left;"> Acartia longiremis (oppdrett) </td>
   <td style="text-align:left;"> Acartia longiremis </td>
   <td style="text-align:left;"> Acartia longiremis </td>
  </tr>
  <tr>
   <td style="text-align:right;"> 255401 </td>
   <td style="text-align:left;"> NA </td>
   <td style="text-align:left;"> Centropages hamatus (oppdrett) </td>
   <td style="text-align:left;"> Centropages hamatus </td>
   <td style="text-align:left;"> Centropages hamatus </td>
  </tr>
  <tr>
   <td style="text-align:right;"> 255501 </td>
   <td style="text-align:left;"> NA </td>
   <td style="text-align:left;"> Pseudocalanus elongatus (oppdrett) </td>
   <td style="text-align:left;"> Pseudocalanus elongatus </td>
   <td style="text-align:left;"> Pseudocalanus elongatus </td>
  </tr>
  <tr>
   <td style="text-align:right;"> 255601 </td>
   <td style="text-align:left;"> NA </td>
   <td style="text-align:left;"> Calanus glacialis </td>
   <td style="text-align:left;"> Calanus glacialis </td>
   <td style="text-align:left;"> Calanus glacialis </td>
  </tr>
  <tr>
   <td style="text-align:right;"> 255701 </td>
   <td style="text-align:left;"> NA </td>
   <td style="text-align:left;"> Calanus hyperboreus </td>
   <td style="text-align:left;"> Calanus hyperboreus </td>
   <td style="text-align:left;"> Calanus hyperboreus </td>
  </tr>
  <tr>
   <td style="text-align:right;"> 255901 </td>
   <td style="text-align:left;"> AMS </td>
   <td style="text-align:left;"> Saltsjøkreps (oppdrett) </td>
   <td style="text-align:left;"> Brine shrimp </td>
   <td style="text-align:left;"> Artemia salina </td>
  </tr>
  <tr>
   <td style="text-align:right;"> 2560 </td>
   <td style="text-align:left;"> BXL </td>
   <td style="text-align:left;"> Fjærerur </td>
   <td style="text-align:left;"> Semibalanus balanoides </td>
   <td style="text-align:left;"> Semibalanus balanoides </td>
  </tr>
  <tr>
   <td style="text-align:right;"> 256101 </td>
   <td style="text-align:left;"> NA </td>
   <td style="text-align:left;"> Vannloppe, upes.(oppdrett) </td>
   <td style="text-align:left;"> Podon spp </td>
   <td style="text-align:left;"> Podon spp </td>
  </tr>
  <tr>
   <td style="text-align:right;"> 256201 </td>
   <td style="text-align:left;"> NA </td>
   <td style="text-align:left;"> Skipsrur (oppdrett) </td>
   <td style="text-align:left;"> Balanus crenatus </td>
   <td style="text-align:left;"> Balanus crenatus </td>
  </tr>
  <tr>
   <td style="text-align:right;"> 256301 </td>
   <td style="text-align:left;"> NA </td>
   <td style="text-align:left;"> Acartia clausi (oppdrett) </td>
   <td style="text-align:left;"> Acartia clausi </td>
   <td style="text-align:left;"> Acartia clausi </td>
  </tr>
  <tr>
   <td style="text-align:right;"> 256401 </td>
   <td style="text-align:left;"> NA </td>
   <td style="text-align:left;"> Eurytemora spp (oppdrett) </td>
   <td style="text-align:left;"> Eurytemora spp </td>
   <td style="text-align:left;"> Eurytemora spp </td>
  </tr>
  <tr>
   <td style="text-align:right;"> 256501 </td>
   <td style="text-align:left;"> NA </td>
   <td style="text-align:left;"> Metridia longa (oppdrett) </td>
   <td style="text-align:left;"> Metridia longa </td>
   <td style="text-align:left;"> Metridia longa </td>
  </tr>
  <tr>
   <td style="text-align:right;"> 256601 </td>
   <td style="text-align:left;"> NA </td>
   <td style="text-align:left;"> Paraeuchaeta barbata (oppdrett) </td>
   <td style="text-align:left;"> Paraeuchaeta barbata </td>
   <td style="text-align:left;"> Paraeuchaeta barbata </td>
  </tr>
  <tr>
   <td style="text-align:right;"> 256701 </td>
   <td style="text-align:left;"> NA </td>
   <td style="text-align:left;"> Pseudocalanus minutus (oppdrett) </td>
   <td style="text-align:left;"> Pseudocalanus minutus </td>
   <td style="text-align:left;"> Pseudocalanus minutus </td>
  </tr>
  <tr>
   <td style="text-align:right;"> 256801 </td>
   <td style="text-align:left;"> NA </td>
   <td style="text-align:left;"> Pseudocalanus acuspes (oppdrett) </td>
   <td style="text-align:left;"> Pseudocalanus acuspes </td>
   <td style="text-align:left;"> Pseudocalanus acuspes </td>
  </tr>
  <tr>
   <td style="text-align:right;"> 256901 </td>
   <td style="text-align:left;"> NA </td>
   <td style="text-align:left;"> Pseudocalanus moultoni (oppdrett) </td>
   <td style="text-align:left;"> Pseudocalanus moultoni </td>
   <td style="text-align:left;"> Pseudocalanus moultoni </td>
  </tr>
  <tr>
   <td style="text-align:right;"> 257001 </td>
   <td style="text-align:left;"> NA </td>
   <td style="text-align:left;"> Temora longicornis (oppdrett) </td>
   <td style="text-align:left;"> Temora longicornis </td>
   <td style="text-align:left;"> Temora longicornis </td>
  </tr>
  <tr>
   <td style="text-align:right;"> 257101 </td>
   <td style="text-align:left;"> NA </td>
   <td style="text-align:left;"> Oithona similis (oppdrett) </td>
   <td style="text-align:left;"> Oithona similis </td>
   <td style="text-align:left;"> Oithona similis </td>
  </tr>
  <tr>
   <td style="text-align:right;"> 257201 </td>
   <td style="text-align:left;"> NA </td>
   <td style="text-align:left;"> Apherusa glacialis (oppdrett) </td>
   <td style="text-align:left;"> Apherusa glacialis </td>
   <td style="text-align:left;"> Apherusa glacialis </td>
  </tr>
  <tr>
   <td style="text-align:right;"> 257301 </td>
   <td style="text-align:left;"> NA </td>
   <td style="text-align:left;"> Eusirus holmii (oppdrett) </td>
   <td style="text-align:left;"> Eusirus holmii </td>
   <td style="text-align:left;"> Eusirus holmii </td>
  </tr>
  <tr>
   <td style="text-align:right;"> 257401 </td>
   <td style="text-align:left;"> NA </td>
   <td style="text-align:left;"> Trollistidskreps (oppdrett) </td>
   <td style="text-align:left;"> Gammaracanthus lacustris </td>
   <td style="text-align:left;"> Gammaracanthus lacustris </td>
  </tr>
  <tr>
   <td style="text-align:right;"> 257501 </td>
   <td style="text-align:left;"> NA </td>
   <td style="text-align:left;"> Onisimus glacialis (oppdrett) </td>
   <td style="text-align:left;"> Onisimus glacialis </td>
   <td style="text-align:left;"> Onisimus glacialis </td>
  </tr>
  <tr>
   <td style="text-align:right;"> 257601 </td>
   <td style="text-align:left;"> NA </td>
   <td style="text-align:left;"> Themisto libellula (oppdrett) </td>
   <td style="text-align:left;"> Themisto libellula </td>
   <td style="text-align:left;"> Themisto libellula </td>
  </tr>
  <tr>
   <td style="text-align:right;"> 257701 </td>
   <td style="text-align:left;"> NA </td>
   <td style="text-align:left;"> Vanlig tangloppe (oppdrett) </td>
   <td style="text-align:left;"> Gammarus locusta </td>
   <td style="text-align:left;"> Gammarus locusta </td>
  </tr>
  <tr>
   <td style="text-align:right;"> 2578 </td>
   <td style="text-align:left;"> FAC </td>
   <td style="text-align:left;"> Rødglassreke </td>
   <td style="text-align:left;"> Crimson pasiphaeid </td>
   <td style="text-align:left;"> Pasiphaea tarda </td>
  </tr>
  <tr>
   <td style="text-align:right;"> 257801 </td>
   <td style="text-align:left;"> FAC </td>
   <td style="text-align:left;"> Rødglassreke (oppdrett) </td>
   <td style="text-align:left;"> Crimson pasiphaeid </td>
   <td style="text-align:left;"> Pasiphaea tarda </td>
  </tr>
  <tr>
   <td style="text-align:right;"> 257901 </td>
   <td style="text-align:left;"> IOD </td>
   <td style="text-align:left;"> Vanlig svømmekrabbe (oppdrett) </td>
   <td style="text-align:left;"> Blue-leg swim crab </td>
   <td style="text-align:left;"> Liocarcinus depurator </td>
  </tr>
  <tr>
   <td style="text-align:right;"> 258001 </td>
   <td style="text-align:left;"> NA </td>
   <td style="text-align:left;"> Anemoneeremittkreps (oppdrett) </td>
   <td style="text-align:left;"> Pagurus prideaux </td>
   <td style="text-align:left;"> Pagurus prideaux </td>
  </tr>
  <tr>
   <td style="text-align:right;"> 2582 </td>
   <td style="text-align:left;"> NA </td>
   <td style="text-align:left;"> Dvergsvømmekrabbe </td>
   <td style="text-align:left;"> Liocarcinus pusillus </td>
   <td style="text-align:left;"> Liocarcinus pusillus </td>
  </tr>
  <tr>
   <td style="text-align:right;"> 2583 </td>
   <td style="text-align:left;"> LQA </td>
   <td style="text-align:left;"> Rettsnutet svømmekrabbe </td>
   <td style="text-align:left;"> Arched swimming crab </td>
   <td style="text-align:left;"> Liocarcinus arcuatus </td>
  </tr>
  <tr>
   <td style="text-align:right;"> 2584 </td>
   <td style="text-align:left;"> XPL </td>
   <td style="text-align:left;"> Marmorkrabbe </td>
   <td style="text-align:left;"> Risso's crab </td>
   <td style="text-align:left;"> Xantho pilipes </td>
  </tr>
  <tr>
   <td style="text-align:right;"> 2585 </td>
   <td style="text-align:left;"> MVD </td>
   <td style="text-align:left;"> Sandpyntekrabbe </td>
   <td style="text-align:left;"> Atlantic lyre crab </td>
   <td style="text-align:left;"> Hyas araneus </td>
  </tr>
  <tr>
   <td style="text-align:right;"> 2586 </td>
   <td style="text-align:left;"> MVH </td>
   <td style="text-align:left;"> Gitarpyntekrabbe </td>
   <td style="text-align:left;"> Arctic lyre crab </td>
   <td style="text-align:left;"> Hyas coarctatus </td>
  </tr>
  <tr>
   <td style="text-align:right;"> 2587 </td>
   <td style="text-align:left;"> IFO </td>
   <td style="text-align:left;"> Langfotkrabbe </td>
   <td style="text-align:left;"> Scorpion spider crab </td>
   <td style="text-align:left;"> Inachus dorsettensis </td>
  </tr>
  <tr>
   <td style="text-align:right;"> 2588 </td>
   <td style="text-align:left;"> IFS </td>
   <td style="text-align:left;"> Stankelbenkrabbe </td>
   <td style="text-align:left;"> Long-legged spider crab </td>
   <td style="text-align:left;"> Macropodia rostrata </td>
  </tr>
  <tr>
   <td style="text-align:right;"> 2589 </td>
   <td style="text-align:left;"> LXT </td>
   <td style="text-align:left;"> Porselenskrabbe </td>
   <td style="text-align:left;"> Long-clawed porcelain crab </td>
   <td style="text-align:left;"> Pisidia longicornis </td>
  </tr>
  <tr>
   <td style="text-align:right;"> 2590 </td>
   <td style="text-align:left;"> JET </td>
   <td style="text-align:left;"> Steinkrabbe </td>
   <td style="text-align:left;"> Bryer's nut crab </td>
   <td style="text-align:left;"> Ebalia tumefacta </td>
  </tr>
  <tr>
   <td style="text-align:right;"> 259201 </td>
   <td style="text-align:left;"> NA </td>
   <td style="text-align:left;"> Rhithropanopeus harrissi (oppdrett) </td>
   <td style="text-align:left;"> Rhithropanopeus harrissi </td>
   <td style="text-align:left;"> Rhithropanopeus harrissi </td>
  </tr>
  <tr>
   <td style="text-align:right;"> 259301 </td>
   <td style="text-align:left;"> NA </td>
   <td style="text-align:left;"> Brachynotus sexdentatus (oppdrett) </td>
   <td style="text-align:left;"> Brachynotus sexdentatus </td>
   <td style="text-align:left;"> Brachynotus sexdentatus </td>
  </tr>
  <tr>
   <td style="text-align:right;"> 259401 </td>
   <td style="text-align:left;"> NA </td>
   <td style="text-align:left;"> Lakselus (oppdrett) </td>
   <td style="text-align:left;"> Lepeophtheirus salmonis </td>
   <td style="text-align:left;"> Lepeophtheirus salmonis </td>
  </tr>
  <tr>
   <td style="text-align:right;"> 259501 </td>
   <td style="text-align:left;"> NA </td>
   <td style="text-align:left;"> Caligus elongatus </td>
   <td style="text-align:left;"> Caligus elongatus </td>
   <td style="text-align:left;"> Caligus elongatus </td>
  </tr>
  <tr>
   <td style="text-align:right;"> 2599 </td>
   <td style="text-align:left;"> CRU </td>
   <td style="text-align:left;"> Andre krepsdyr </td>
   <td style="text-align:left;"> Marine crustaceans </td>
   <td style="text-align:left;"> Crustacea </td>
  </tr>
  <tr>
   <td style="text-align:right;"> 26 </td>
   <td style="text-align:left;"> NA </td>
   <td style="text-align:left;"> BLØTDYR </td>
   <td style="text-align:left;"> NA </td>
   <td style="text-align:left;"> MOLLUSCA </td>
  </tr>
  <tr>
   <td style="text-align:right;"> 2611 </td>
   <td style="text-align:left;"> OYF </td>
   <td style="text-align:left;"> Østers </td>
   <td style="text-align:left;"> European flat oyster </td>
   <td style="text-align:left;"> Ostrea edulis </td>
  </tr>
  <tr>
   <td style="text-align:right;"> 261101 </td>
   <td style="text-align:left;"> OYF </td>
   <td style="text-align:left;"> Østers (oppdrett) </td>
   <td style="text-align:left;"> European flat oyster </td>
   <td style="text-align:left;"> Ostrea edulis </td>
  </tr>
  <tr>
   <td style="text-align:right;"> 2612 </td>
   <td style="text-align:left;"> OYC </td>
   <td style="text-align:left;"> Stillehavsøsters </td>
   <td style="text-align:left;"> Cupped oysters </td>
   <td style="text-align:left;"> Crassostrea spp </td>
  </tr>
  <tr>
   <td style="text-align:right;"> 2613 </td>
   <td style="text-align:left;"> CTG </td>
   <td style="text-align:left;"> Rutet teppeskjell </td>
   <td style="text-align:left;"> Grooved carpet shell </td>
   <td style="text-align:left;"> Ruditapes decussatus </td>
  </tr>
  <tr>
   <td style="text-align:right;"> 2614 </td>
   <td style="text-align:left;"> CLJ </td>
   <td style="text-align:left;"> Asiatisk teppeskjell (Manilaskjell) </td>
   <td style="text-align:left;"> Japanese carpet shell </td>
   <td style="text-align:left;"> Ruditapes philippinarum </td>
  </tr>
  <tr>
   <td style="text-align:right;"> 2615 </td>
   <td style="text-align:left;"> SVE </td>
   <td style="text-align:left;"> Stripet teppeskjell </td>
   <td style="text-align:left;"> Striped venus </td>
   <td style="text-align:left;"> Chamelea gallina </td>
  </tr>
  <tr>
   <td style="text-align:right;"> 2616 </td>
   <td style="text-align:left;"> QRG </td>
   <td style="text-align:left;"> Greenland smoothcockle </td>
   <td style="text-align:left;"> Greenland smoothcockle </td>
   <td style="text-align:left;"> Serripes groenlandicus </td>
  </tr>
  <tr>
   <td style="text-align:right;"> 2617 </td>
   <td style="text-align:left;"> ZCZ </td>
   <td style="text-align:left;"> Hairy cockle </td>
   <td style="text-align:left;"> Hairy cockle </td>
   <td style="text-align:left;"> Ciliatocardium ciliatum </td>
  </tr>
  <tr>
   <td style="text-align:right;"> 2618 </td>
   <td style="text-align:left;"> VSC </td>
   <td style="text-align:left;"> Urskjell </td>
   <td style="text-align:left;"> Variegated scallop </td>
   <td style="text-align:left;"> Chlamys varia </td>
  </tr>
  <tr>
   <td style="text-align:right;"> 2619 </td>
   <td style="text-align:left;"> CLQ </td>
   <td style="text-align:left;"> Kuskjell </td>
   <td style="text-align:left;"> Ocean quahog </td>
   <td style="text-align:left;"> Cyprina islandica </td>
  </tr>
  <tr>
   <td style="text-align:right;"> 2620 </td>
   <td style="text-align:left;"> CLS </td>
   <td style="text-align:left;"> Sandskjell </td>
   <td style="text-align:left;"> Sand gaper </td>
   <td style="text-align:left;"> Mya arenaria </td>
  </tr>
  <tr>
   <td style="text-align:right;"> 2621 </td>
   <td style="text-align:left;"> SCE </td>
   <td style="text-align:left;"> Stor kamskjell (Kamskjell) </td>
   <td style="text-align:left;"> Common scallop </td>
   <td style="text-align:left;"> Pecten maximus </td>
  </tr>
  <tr>
   <td style="text-align:right;"> 262101 </td>
   <td style="text-align:left;"> SCE </td>
   <td style="text-align:left;"> Stort kamskjell (oppdrett) </td>
   <td style="text-align:left;"> Great Atlantic scallop </td>
   <td style="text-align:left;"> Pecten maximus </td>
  </tr>
  <tr>
   <td style="text-align:right;"> 2622 </td>
   <td style="text-align:left;"> QSC </td>
   <td style="text-align:left;"> Harpeskjell </td>
   <td style="text-align:left;"> Queen scallop </td>
   <td style="text-align:left;"> Chlamys opercularis </td>
  </tr>
  <tr>
   <td style="text-align:right;"> 2623 </td>
   <td style="text-align:left;"> MUS </td>
   <td style="text-align:left;"> Blåskjell </td>
   <td style="text-align:left;"> Blue mussel </td>
   <td style="text-align:left;"> Mytilus edulis </td>
  </tr>
  <tr>
   <td style="text-align:right;"> 262301 </td>
   <td style="text-align:left;"> MUS </td>
   <td style="text-align:left;"> Blåskjell (oppdrett) </td>
   <td style="text-align:left;"> Blue mussel </td>
   <td style="text-align:left;"> Mytilus edulis </td>
  </tr>
  <tr>
   <td style="text-align:right;"> 2624 </td>
   <td style="text-align:left;"> DJO </td>
   <td style="text-align:left;"> O-skjell </td>
   <td style="text-align:left;"> Northern horse mussel </td>
   <td style="text-align:left;"> Modiolus modiolus </td>
  </tr>
  <tr>
   <td style="text-align:right;"> 2625 </td>
   <td style="text-align:left;"> CLB </td>
   <td style="text-align:left;"> Atlantic surf clam </td>
   <td style="text-align:left;"> Atlantic surf clam </td>
   <td style="text-align:left;"> Spisula solidissima </td>
  </tr>
  <tr>
   <td style="text-align:right;"> 2626 </td>
   <td style="text-align:left;"> ISC </td>
   <td style="text-align:left;"> Haneskjell </td>
   <td style="text-align:left;"> Islandic scallop </td>
   <td style="text-align:left;"> Chlamys islandica </td>
  </tr>
  <tr>
   <td style="text-align:right;"> 2627 </td>
   <td style="text-align:left;"> COC </td>
   <td style="text-align:left;"> Saueskjell, uspes. </td>
   <td style="text-align:left;"> Common edible cockle </td>
   <td style="text-align:left;"> Cerastoderma edule </td>
  </tr>
  <tr>
   <td style="text-align:right;"> 2628 </td>
   <td style="text-align:left;"> LPZ </td>
   <td style="text-align:left;"> Albuskjell </td>
   <td style="text-align:left;"> Limpets nei </td>
   <td style="text-align:left;"> Patella spp </td>
  </tr>
  <tr>
   <td style="text-align:right;"> 2629 </td>
   <td style="text-align:left;"> SCX </td>
   <td style="text-align:left;"> Annen kammusling </td>
   <td style="text-align:left;"> Scallops </td>
   <td style="text-align:left;"> Pectinidae </td>
  </tr>
  <tr>
   <td style="text-align:right;"> 2630 </td>
   <td style="text-align:left;"> EOI </td>
   <td style="text-align:left;"> Vanlig åttearmet blekksprut </td>
   <td style="text-align:left;"> Horned octopus </td>
   <td style="text-align:left;"> Eledone cirrhosa </td>
  </tr>
  <tr>
   <td style="text-align:right;"> 2631 </td>
   <td style="text-align:left;"> SQC </td>
   <td style="text-align:left;"> Vanlig ti-armet blekksprut uspes. </td>
   <td style="text-align:left;"> Common squids nei </td>
   <td style="text-align:left;"> Lolio spp </td>
  </tr>
  <tr>
   <td style="text-align:right;"> 2632 </td>
   <td style="text-align:left;"> SQL </td>
   <td style="text-align:left;"> Langfinnet vanlig ti-armet blekksprut </td>
   <td style="text-align:left;"> Longfinned squid </td>
   <td style="text-align:left;"> Lolio pealei </td>
  </tr>
  <tr>
   <td style="text-align:right;"> 2633 </td>
   <td style="text-align:left;"> SQI </td>
   <td style="text-align:left;"> Nordlig kortfinnet ti-armet blekksprut </td>
   <td style="text-align:left;"> Northern shortfin squid </td>
   <td style="text-align:left;"> Illex illecebrosus </td>
  </tr>
  <tr>
   <td style="text-align:right;"> 2634 </td>
   <td style="text-align:left;"> SQE </td>
   <td style="text-align:left;"> Akkar </td>
   <td style="text-align:left;"> European flying squid </td>
   <td style="text-align:left;"> Todarodes sagittatus </td>
  </tr>
  <tr>
   <td style="text-align:right;"> 2635 </td>
   <td style="text-align:left;"> OCT </td>
   <td style="text-align:left;"> Åtte-armet blekksprut uspes. </td>
   <td style="text-align:left;"> Octopuses </td>
   <td style="text-align:left;"> Octopodidae </td>
  </tr>
  <tr>
   <td style="text-align:right;"> 2636 </td>
   <td style="text-align:left;"> SQU </td>
   <td style="text-align:left;"> Annen vanlig ti-armet blekksprut </td>
   <td style="text-align:left;"> Squids </td>
   <td style="text-align:left;"> Loliginidae, Ommastrephidae </td>
  </tr>
  <tr>
   <td style="text-align:right;"> 2637 </td>
   <td style="text-align:left;"> CTL </td>
   <td style="text-align:left;"> Annen ti-armet blekksprut </td>
   <td style="text-align:left;"> Cuttlefishes </td>
   <td style="text-align:left;"> Sepiidae, Sepiolidae </td>
  </tr>
  <tr>
   <td style="text-align:right;"> 2638 </td>
   <td style="text-align:left;"> CEP </td>
   <td style="text-align:left;"> Blekksprut uspes. </td>
   <td style="text-align:left;"> Cephalopods </td>
   <td style="text-align:left;"> Cephalopoda </td>
  </tr>
  <tr>
   <td style="text-align:right;"> 2639 </td>
   <td style="text-align:left;"> SQZ </td>
   <td style="text-align:left;"> Annen blekksprut </td>
   <td style="text-align:left;"> Inshore squids nei </td>
   <td style="text-align:left;"> Loliginidae </td>
  </tr>
  <tr>
   <td style="text-align:right;"> 2640 </td>
   <td style="text-align:left;"> URC </td>
   <td style="text-align:left;"> Kråkebolle, uspes. </td>
   <td style="text-align:left;"> Sea urchins </td>
   <td style="text-align:left;"> Echinoidea </td>
  </tr>
  <tr>
   <td style="text-align:right;"> 2642 </td>
   <td style="text-align:left;"> KHG </td>
   <td style="text-align:left;"> Brunpølse </td>
   <td style="text-align:left;"> Pudding </td>
   <td style="text-align:left;"> Cucumaria frondosa </td>
  </tr>
  <tr>
   <td style="text-align:right;"> 2643 </td>
   <td style="text-align:left;"> TVK </td>
   <td style="text-align:left;"> Rødpølse </td>
   <td style="text-align:left;"> Red sea cucumber </td>
   <td style="text-align:left;"> Parastichopus tremulus </td>
  </tr>
  <tr>
   <td style="text-align:right;"> 264301 </td>
   <td style="text-align:left;"> TVK </td>
   <td style="text-align:left;"> Rødpølse (oppdrett) </td>
   <td style="text-align:left;"> Red sea cucumber </td>
   <td style="text-align:left;"> Parastichopus tremulus </td>
  </tr>
  <tr>
   <td style="text-align:right;"> 2644 </td>
   <td style="text-align:left;"> STH </td>
   <td style="text-align:left;"> Vanlig korstroll </td>
   <td style="text-align:left;"> Red starfish </td>
   <td style="text-align:left;"> Asterias rubens </td>
  </tr>
  <tr>
   <td style="text-align:right;"> 2645 </td>
   <td style="text-align:left;"> ECH </td>
   <td style="text-align:left;"> Andre pigghuder </td>
   <td style="text-align:left;"> Echinoderms </td>
   <td style="text-align:left;"> Echinodermata </td>
  </tr>
  <tr>
   <td style="text-align:right;"> 2646 </td>
   <td style="text-align:left;"> VUC </td>
   <td style="text-align:left;"> Teppeskjell </td>
   <td style="text-align:left;"> Corrugated venus/Pullet carpet shell </td>
   <td style="text-align:left;"> Venerupis corrugata </td>
  </tr>
  <tr>
   <td style="text-align:right;"> 264601 </td>
   <td style="text-align:left;"> VUC </td>
   <td style="text-align:left;"> Teppeskjell (oppdrett) </td>
   <td style="text-align:left;"> Corrugated venus/Pullet carpet shell </td>
   <td style="text-align:left;"> Venerupis corrugata </td>
  </tr>
  <tr>
   <td style="text-align:right;"> 264701 </td>
   <td style="text-align:left;"> VNR </td>
   <td style="text-align:left;"> Banded carpet shell (oppdrett) </td>
   <td style="text-align:left;"> Banded carpet shell </td>
   <td style="text-align:left;"> Polititapes virgineus (Venerupis rhomboides) </td>
  </tr>
  <tr>
   <td style="text-align:right;"> 2650 </td>
   <td style="text-align:left;"> PER </td>
   <td style="text-align:left;"> Strandsnegl, uspes. </td>
   <td style="text-align:left;"> Periwinkles </td>
   <td style="text-align:left;"> Littorinidae </td>
  </tr>
  <tr>
   <td style="text-align:right;"> 2651 </td>
   <td style="text-align:left;"> WHE </td>
   <td style="text-align:left;"> Kongsnegl (Kongesnegl) </td>
   <td style="text-align:left;"> Whelk </td>
   <td style="text-align:left;"> Buccinum undatum </td>
  </tr>
  <tr>
   <td style="text-align:right;"> 265201 </td>
   <td style="text-align:left;"> NA </td>
   <td style="text-align:left;"> Pusillina tumidula (Pseudosetia griegi) (oppdrett) </td>
   <td style="text-align:left;"> Pusillina tumidula (Pseudosetia griegi) </td>
   <td style="text-align:left;"> Pusillina tumidula (Pseudosetia griegi) </td>
  </tr>
  <tr>
   <td style="text-align:right;"> 265301 </td>
   <td style="text-align:left;"> NA </td>
   <td style="text-align:left;"> Skenea profunda (oppdrett) </td>
   <td style="text-align:left;"> Skenea profunda </td>
   <td style="text-align:left;"> Skenea profunda </td>
  </tr>
  <tr>
   <td style="text-align:right;"> 265901 </td>
   <td style="text-align:left;"> HLT </td>
   <td style="text-align:left;"> Tuberculate abalone (oppdrett) </td>
   <td style="text-align:left;"> Tuberculate abalone </td>
   <td style="text-align:left;"> Haliotis tuberculata </td>
  </tr>
  <tr>
   <td style="text-align:right;"> 2660 </td>
   <td style="text-align:left;"> UYD </td>
   <td style="text-align:left;"> Drøbaksjøpiggsvin </td>
   <td style="text-align:left;"> Strongylocentrotus droebachiensis </td>
   <td style="text-align:left;"> Strongylocentrotus droebachiensis </td>
  </tr>
  <tr>
   <td style="text-align:right;"> 2661 </td>
   <td style="text-align:left;"> USD </td>
   <td style="text-align:left;"> Langpiggsjøpiggsvin </td>
   <td style="text-align:left;"> Echinus acutus(Gracilechinus acutus) </td>
   <td style="text-align:left;"> Echinus acutus(Gracilechinus acutus) </td>
  </tr>
  <tr>
   <td style="text-align:right;"> 2662 </td>
   <td style="text-align:left;"> URS </td>
   <td style="text-align:left;"> Rød kråkebolle </td>
   <td style="text-align:left;"> European edible sea urchin </td>
   <td style="text-align:left;"> Echinus esculentus </td>
  </tr>
  <tr>
   <td style="text-align:right;"> 2663 </td>
   <td style="text-align:left;"> KIT </td>
   <td style="text-align:left;"> Grønnsjøpiggsvin </td>
   <td style="text-align:left;"> Psammechinus miliaris </td>
   <td style="text-align:left;"> Psammechinus miliaris </td>
  </tr>
  <tr>
   <td style="text-align:right;"> 266401 </td>
   <td style="text-align:left;"> NA </td>
   <td style="text-align:left;"> Leptochiton asellus (oppdrett) </td>
   <td style="text-align:left;"> Leptochiton asellus </td>
   <td style="text-align:left;"> Leptochiton asellus </td>
  </tr>
  <tr>
   <td style="text-align:right;"> 266501 </td>
   <td style="text-align:left;"> NA </td>
   <td style="text-align:left;"> Sjuarmsjøstjerne (oppdrett) </td>
   <td style="text-align:left;"> Luidia ciliaris </td>
   <td style="text-align:left;"> Luidia ciliaris </td>
  </tr>
  <tr>
   <td style="text-align:right;"> 266601 </td>
   <td style="text-align:left;"> NA </td>
   <td style="text-align:left;"> Fem-armet sjøstjerne (oppdrett) </td>
   <td style="text-align:left;"> Luidia sarsii </td>
   <td style="text-align:left;"> Luidia sarsii </td>
  </tr>
  <tr>
   <td style="text-align:right;"> 266701 </td>
   <td style="text-align:left;"> NA </td>
   <td style="text-align:left;"> Piggsolstjerne (oppdrett) </td>
   <td style="text-align:left;"> Crossaster papposus </td>
   <td style="text-align:left;"> Crossaster papposus </td>
  </tr>
  <tr>
   <td style="text-align:right;"> 266801 </td>
   <td style="text-align:left;"> NA </td>
   <td style="text-align:left;"> Piggkorstroll (oppdrett) </td>
   <td style="text-align:left;"> Marthasterias glacialis </td>
   <td style="text-align:left;"> Marthasterias glacialis </td>
  </tr>
  <tr>
   <td style="text-align:right;"> 267001 </td>
   <td style="text-align:left;"> NA </td>
   <td style="text-align:left;"> Limaria hians (oppdrett) </td>
   <td style="text-align:left;"> Limaria hians </td>
   <td style="text-align:left;"> Limaria hians </td>
  </tr>
  <tr>
   <td style="text-align:right;"> 2671 </td>
   <td style="text-align:left;"> YTK </td>
   <td style="text-align:left;"> Butt sandskjell </td>
   <td style="text-align:left;"> Blunt gaper </td>
   <td style="text-align:left;"> Mya truncata </td>
  </tr>
  <tr>
   <td style="text-align:right;"> 267201 </td>
   <td style="text-align:left;"> NA </td>
   <td style="text-align:left;"> Østersjøskjell (oppdrett) </td>
   <td style="text-align:left;"> Macoma balthica </td>
   <td style="text-align:left;"> Macoma balthica </td>
  </tr>
  <tr>
   <td style="text-align:right;"> 2673 </td>
   <td style="text-align:left;"> ZMC </td>
   <td style="text-align:left;"> Chalky macoma </td>
   <td style="text-align:left;"> Chalky macoma </td>
   <td style="text-align:left;"> Macoma calcarea </td>
  </tr>
  <tr>
   <td style="text-align:right;"> 2675 </td>
   <td style="text-align:left;"> ZHA </td>
   <td style="text-align:left;"> Steinboreskjell </td>
   <td style="text-align:left;"> Wrinkled rock borer </td>
   <td style="text-align:left;"> Hiatella arctica </td>
  </tr>
  <tr>
   <td style="text-align:right;"> 2676 </td>
   <td style="text-align:left;"> SOI </td>
   <td style="text-align:left;"> Knivskjell </td>
   <td style="text-align:left;"> Razor clams, knife clams nei </td>
   <td style="text-align:left;"> Solenidae </td>
  </tr>
  <tr>
   <td style="text-align:right;"> 2677 </td>
   <td style="text-align:left;"> COZ </td>
   <td style="text-align:left;"> Hjerteskjell </td>
   <td style="text-align:left;"> Cockles nei </td>
   <td style="text-align:left;"> Cardiidae </td>
  </tr>
  <tr>
   <td style="text-align:right;"> 2680 </td>
   <td style="text-align:left;"> SSX </td>
   <td style="text-align:left;"> Sekkdyr, uspes. </td>
   <td style="text-align:left;"> Sea squirts nei </td>
   <td style="text-align:left;"> Ascidiacea </td>
  </tr>
  <tr>
   <td style="text-align:right;"> 2681 </td>
   <td style="text-align:left;"> KOJ </td>
   <td style="text-align:left;"> Grønnsekkdyr </td>
   <td style="text-align:left;"> Ciona </td>
   <td style="text-align:left;"> Ciona intestinalis </td>
  </tr>
  <tr>
   <td style="text-align:right;"> 268201 </td>
   <td style="text-align:left;"> NA </td>
   <td style="text-align:left;"> Oikopleura (Coecaria) fusiformis (oppdrett) </td>
   <td style="text-align:left;"> Oikopleura (Coecaria) fusiformis </td>
   <td style="text-align:left;"> Oikopleura (Coecaria) fusiformis </td>
  </tr>
  <tr>
   <td style="text-align:right;"> 268301 </td>
   <td style="text-align:left;"> NA </td>
   <td style="text-align:left;"> Oikopleura (Vexillaria) gorskyi (oppdrett) </td>
   <td style="text-align:left;"> Oikopleura (Vexillaria) gorskyi </td>
   <td style="text-align:left;"> Oikopleura (Vexillaria) gorskyi </td>
  </tr>
  <tr>
   <td style="text-align:right;"> 268401 </td>
   <td style="text-align:left;"> NA </td>
   <td style="text-align:left;"> Oikopleura (Vexillaria) labradoriensis (oppdrett) </td>
   <td style="text-align:left;"> Oikopleura (Vexillaria) labradoriensis </td>
   <td style="text-align:left;"> Oikopleura (Vexillaria) labradoriensis </td>
  </tr>
  <tr>
   <td style="text-align:right;"> 268501 </td>
   <td style="text-align:left;"> NA </td>
   <td style="text-align:left;"> Oikopleura (Vexillaria) parva (oppdrett) </td>
   <td style="text-align:left;"> Oikopleura (Vexillaria) parva </td>
   <td style="text-align:left;"> Oikopleura (Vexillaria) parva </td>
  </tr>
  <tr>
   <td style="text-align:right;"> 268601 </td>
   <td style="text-align:left;"> NA </td>
   <td style="text-align:left;"> Oikopleura (Vexillaria) villafrancae (oppdrett) </td>
   <td style="text-align:left;"> Oikopleura (Vexillaria) villafrancae </td>
   <td style="text-align:left;"> Oikopleura (Vexillaria) villafrancae </td>
  </tr>
  <tr>
   <td style="text-align:right;"> 268701 </td>
   <td style="text-align:left;"> NA </td>
   <td style="text-align:left;"> Oikopleura (Vexillaria) dioica (oppdrett) </td>
   <td style="text-align:left;"> Oikopleura (Vexillaria) dioica </td>
   <td style="text-align:left;"> Oikopleura (Vexillaria) dioica </td>
  </tr>
  <tr>
   <td style="text-align:right;"> 268801 </td>
   <td style="text-align:left;"> NA </td>
   <td style="text-align:left;"> Oikopleura (Vexillaria) longocauda (oppdrett) </td>
   <td style="text-align:left;"> Oikopleura (Vexillaria) longocauda </td>
   <td style="text-align:left;"> Oikopleura (Vexillaria) longocauda </td>
  </tr>
  <tr>
   <td style="text-align:right;"> 268901 </td>
   <td style="text-align:left;"> NA </td>
   <td style="text-align:left;"> Oikopleura (Vexillaria) vanhoeffeni (oppdrett) </td>
   <td style="text-align:left;"> Oikopleura (Vexillaria) vanhoeffeni </td>
   <td style="text-align:left;"> Oikopleura (Vexillaria) vanhoeffeni </td>
  </tr>
  <tr>
   <td style="text-align:right;"> 269001 </td>
   <td style="text-align:left;"> NA </td>
   <td style="text-align:left;"> Fallossekkdyr(oppdrett) </td>
   <td style="text-align:left;"> Ascidia mentula </td>
   <td style="text-align:left;"> Ascidia mentula </td>
  </tr>
  <tr>
   <td style="text-align:right;"> 269101 </td>
   <td style="text-align:left;"> NA </td>
   <td style="text-align:left;"> Langhalssekkdyr(oppdrett) </td>
   <td style="text-align:left;"> Clavelina lepadiformis </td>
   <td style="text-align:left;"> Clavelina lepadiformis </td>
  </tr>
  <tr>
   <td style="text-align:right;"> 269201 </td>
   <td style="text-align:left;"> NA </td>
   <td style="text-align:left;"> Ciona edwardsi (oppdrett) </td>
   <td style="text-align:left;"> Ciona edwardsi </td>
   <td style="text-align:left;"> Ciona edwardsi </td>
  </tr>
  <tr>
   <td style="text-align:right;"> 269301 </td>
   <td style="text-align:left;"> NA </td>
   <td style="text-align:left;"> Ciona fascilularis (oppdrett) </td>
   <td style="text-align:left;"> Ciona fascilularis </td>
   <td style="text-align:left;"> Ciona fascilularis </td>
  </tr>
  <tr>
   <td style="text-align:right;"> 269401 </td>
   <td style="text-align:left;"> NA </td>
   <td style="text-align:left;"> Ciona gelatinosa (oppdrett) </td>
   <td style="text-align:left;"> Ciona gelatinosa </td>
   <td style="text-align:left;"> Ciona gelatinosa </td>
  </tr>
  <tr>
   <td style="text-align:right;"> 269501 </td>
   <td style="text-align:left;"> NA </td>
   <td style="text-align:left;"> Ciona imperfecta (oppdrett) </td>
   <td style="text-align:left;"> Ciona imperfecta </td>
   <td style="text-align:left;"> Ciona imperfecta </td>
  </tr>
  <tr>
   <td style="text-align:right;"> 269601 </td>
   <td style="text-align:left;"> NA </td>
   <td style="text-align:left;"> Oransjesekkdyr(oppdrett) </td>
   <td style="text-align:left;"> Polyclinum aurantium </td>
   <td style="text-align:left;"> Polyclinum aurantium </td>
  </tr>
  <tr>
   <td style="text-align:right;"> 2697 </td>
   <td style="text-align:left;"> GAS </td>
   <td style="text-align:left;"> Annen snegl </td>
   <td style="text-align:left;"> Gastropods nei </td>
   <td style="text-align:left;"> Gastropoda </td>
  </tr>
  <tr>
   <td style="text-align:right;"> 2698 </td>
   <td style="text-align:left;"> CLX </td>
   <td style="text-align:left;"> Annen skjell </td>
   <td style="text-align:left;"> Clams, etc, nei </td>
   <td style="text-align:left;"> Bivalvia </td>
  </tr>
  <tr>
   <td style="text-align:right;"> 2699 </td>
   <td style="text-align:left;"> MOL </td>
   <td style="text-align:left;"> Annet bløtdyr </td>
   <td style="text-align:left;"> Marine molluscs </td>
   <td style="text-align:left;"> Mollusca </td>
  </tr>
  <tr>
   <td style="text-align:right;"> 27 </td>
   <td style="text-align:left;"> NA </td>
   <td style="text-align:left;"> PATTEDYR </td>
   <td style="text-align:left;"> NA </td>
   <td style="text-align:left;"> MAMMALIA </td>
  </tr>
  <tr>
   <td style="text-align:right;"> 2711 </td>
   <td style="text-align:left;"> SEH </td>
   <td style="text-align:left;"> Grønlandssel </td>
   <td style="text-align:left;"> Harp seal </td>
   <td style="text-align:left;"> Pagophilus groenlandicus </td>
  </tr>
  <tr>
   <td style="text-align:right;"> 2712 </td>
   <td style="text-align:left;"> SEC </td>
   <td style="text-align:left;"> Steinkobbe </td>
   <td style="text-align:left;"> Harbour seal </td>
   <td style="text-align:left;"> Phoca vitulina </td>
  </tr>
  <tr>
   <td style="text-align:right;"> 2713 </td>
   <td style="text-align:left;"> SER </td>
   <td style="text-align:left;"> Ringsel </td>
   <td style="text-align:left;"> Ringed seal </td>
   <td style="text-align:left;"> Phoca hispida </td>
  </tr>
  <tr>
   <td style="text-align:right;"> 2714 </td>
   <td style="text-align:left;"> SEZ </td>
   <td style="text-align:left;"> Klappmyss </td>
   <td style="text-align:left;"> Hooded seal </td>
   <td style="text-align:left;"> Cystophora cristata </td>
  </tr>
  <tr>
   <td style="text-align:right;"> 2715 </td>
   <td style="text-align:left;"> SEG </td>
   <td style="text-align:left;"> Havert </td>
   <td style="text-align:left;"> Grey seal </td>
   <td style="text-align:left;"> Halichoerus grypus </td>
  </tr>
  <tr>
   <td style="text-align:right;"> 2716 </td>
   <td style="text-align:left;"> SEB </td>
   <td style="text-align:left;"> Blåsel </td>
   <td style="text-align:left;"> Bearded seal </td>
   <td style="text-align:left;"> Erignatus barbatus </td>
  </tr>
  <tr>
   <td style="text-align:right;"> 2719 </td>
   <td style="text-align:left;"> SXX </td>
   <td style="text-align:left;"> Annen sel </td>
   <td style="text-align:left;"> Seals and sea lions nei </td>
   <td style="text-align:left;"> Otariidae, Phocidae </td>
  </tr>
  <tr>
   <td style="text-align:right;"> 2720 </td>
   <td style="text-align:left;"> PHR </td>
   <td style="text-align:left;"> Nise </td>
   <td style="text-align:left;"> Harbour porpoise </td>
   <td style="text-align:left;"> Phocoena phocoena </td>
  </tr>
  <tr>
   <td style="text-align:right;"> 2721 </td>
   <td style="text-align:left;"> BOW </td>
   <td style="text-align:left;"> Tumler </td>
   <td style="text-align:left;"> Northern bottlenose whale </td>
   <td style="text-align:left;"> Hyperoodon ampullatus </td>
  </tr>
  <tr>
   <td style="text-align:right;"> 2722 </td>
   <td style="text-align:left;"> BEW </td>
   <td style="text-align:left;"> Nebbhval </td>
   <td style="text-align:left;"> Beaked whale </td>
   <td style="text-align:left;"> Berardius bairdii </td>
  </tr>
  <tr>
   <td style="text-align:right;"> 2723 </td>
   <td style="text-align:left;"> SPW </td>
   <td style="text-align:left;"> Spermhval </td>
   <td style="text-align:left;"> Sperm whale </td>
   <td style="text-align:left;"> Physeter macrocephalus </td>
  </tr>
  <tr>
   <td style="text-align:right;"> 2724 </td>
   <td style="text-align:left;"> DCO </td>
   <td style="text-align:left;"> Delfin </td>
   <td style="text-align:left;"> Common dolphin </td>
   <td style="text-align:left;"> Delphinus delphis </td>
  </tr>
  <tr>
   <td style="text-align:right;"> 2725 </td>
   <td style="text-align:left;"> PIW </td>
   <td style="text-align:left;"> Grindhval </td>
   <td style="text-align:left;"> Longfin pilot whale </td>
   <td style="text-align:left;"> Globicephala melas </td>
  </tr>
  <tr>
   <td style="text-align:right;"> 2726 </td>
   <td style="text-align:left;"> SHW </td>
   <td style="text-align:left;"> Shortfin pilot whale </td>
   <td style="text-align:left;"> Shortfin pilot whale </td>
   <td style="text-align:left;"> Globicephala macrorhynchus </td>
  </tr>
  <tr>
   <td style="text-align:right;"> 2727 </td>
   <td style="text-align:left;"> KIW </td>
   <td style="text-align:left;"> Spekkhogger </td>
   <td style="text-align:left;"> Killer whale </td>
   <td style="text-align:left;"> Orcinus orca </td>
  </tr>
  <tr>
   <td style="text-align:right;"> 2728 </td>
   <td style="text-align:left;"> BEL </td>
   <td style="text-align:left;"> Hvithval </td>
   <td style="text-align:left;"> Beluga(= White whale) </td>
   <td style="text-align:left;"> Delphinapterus leucas </td>
  </tr>
  <tr>
   <td style="text-align:right;"> 2729 </td>
   <td style="text-align:left;"> MIW </td>
   <td style="text-align:left;"> Vågehval </td>
   <td style="text-align:left;"> Minke whale </td>
   <td style="text-align:left;"> Balaenoptera acutorostrata </td>
  </tr>
  <tr>
   <td style="text-align:right;"> 2731 </td>
   <td style="text-align:left;"> BRW </td>
   <td style="text-align:left;"> Brydehval </td>
   <td style="text-align:left;"> Bryde’s whale </td>
   <td style="text-align:left;"> Balaenoptera edeni </td>
  </tr>
  <tr>
   <td style="text-align:right;"> 2732 </td>
   <td style="text-align:left;"> SIW </td>
   <td style="text-align:left;"> Seihval </td>
   <td style="text-align:left;"> Sei whale </td>
   <td style="text-align:left;"> Balaenoptera borealis </td>
  </tr>
  <tr>
   <td style="text-align:right;"> 2733 </td>
   <td style="text-align:left;"> BLW </td>
   <td style="text-align:left;"> Blåhval </td>
   <td style="text-align:left;"> Blue whale </td>
   <td style="text-align:left;"> Balaenoptera musculus </td>
  </tr>
  <tr>
   <td style="text-align:right;"> 2734 </td>
   <td style="text-align:left;"> FIW </td>
   <td style="text-align:left;"> Finnhval </td>
   <td style="text-align:left;"> Fin whale </td>
   <td style="text-align:left;"> Balaenoptera physalus </td>
  </tr>
  <tr>
   <td style="text-align:right;"> 2735 </td>
   <td style="text-align:left;"> CPM </td>
   <td style="text-align:left;"> Dvergretthval </td>
   <td style="text-align:left;"> Pigmy whale </td>
   <td style="text-align:left;"> Caperea marginata </td>
  </tr>
  <tr>
   <td style="text-align:right;"> 2736 </td>
   <td style="text-align:left;"> BWD </td>
   <td style="text-align:left;"> Kvitnos </td>
   <td style="text-align:left;"> White beaked dolphin </td>
   <td style="text-align:left;"> Lagenorhynchus albirostris </td>
  </tr>
  <tr>
   <td style="text-align:right;"> 2737 </td>
   <td style="text-align:left;"> BWW </td>
   <td style="text-align:left;"> Spisshval </td>
   <td style="text-align:left;"> Sowerby’s whale </td>
   <td style="text-align:left;"> Mesoplodon bidens </td>
  </tr>
  <tr>
   <td style="text-align:right;"> 2738 </td>
   <td style="text-align:left;"> WAL </td>
   <td style="text-align:left;"> Hvalross </td>
   <td style="text-align:left;"> Walrus </td>
   <td style="text-align:left;"> Odobenus rosmarus </td>
  </tr>
  <tr>
   <td style="text-align:right;"> 2739 </td>
   <td style="text-align:left;"> ODN </td>
   <td style="text-align:left;"> Annen tannhval </td>
   <td style="text-align:left;"> Toothed whales </td>
   <td style="text-align:left;"> Odontoceti </td>
  </tr>
  <tr>
   <td style="text-align:right;"> 2749 </td>
   <td style="text-align:left;"> MYS </td>
   <td style="text-align:left;"> Annen bardehval </td>
   <td style="text-align:left;"> Baleen whales </td>
   <td style="text-align:left;"> Mysticeti </td>
  </tr>
  <tr>
   <td style="text-align:right;"> 2759 </td>
   <td style="text-align:left;"> MAM </td>
   <td style="text-align:left;"> Annen hval </td>
   <td style="text-align:left;"> Whales </td>
   <td style="text-align:left;"> Cetacea </td>
  </tr>
  <tr>
   <td style="text-align:right;"> 2799 </td>
   <td style="text-align:left;"> MAM </td>
   <td style="text-align:left;"> Andre sjøpattedyr </td>
   <td style="text-align:left;"> Aquatic mammals nei, </td>
   <td style="text-align:left;"> Mammalia </td>
  </tr>
  <tr>
   <td style="text-align:right;"> 28 </td>
   <td style="text-align:left;"> NA </td>
   <td style="text-align:left;"> ALGER </td>
   <td style="text-align:left;"> NA </td>
   <td style="text-align:left;"> ALGAE </td>
  </tr>
  <tr>
   <td style="text-align:right;"> 2811 </td>
   <td style="text-align:left;"> SWB </td>
   <td style="text-align:left;"> Andre brunalger </td>
   <td style="text-align:left;"> Brown seaweed </td>
   <td style="text-align:left;"> Phaeophyceae </td>
  </tr>
  <tr>
   <td style="text-align:right;"> 2812 </td>
   <td style="text-align:left;"> LQX </td>
   <td style="text-align:left;"> Sukkertare </td>
   <td style="text-align:left;"> Sea belt </td>
   <td style="text-align:left;"> Saccharina latissima </td>
  </tr>
  <tr>
   <td style="text-align:right;"> 2813 </td>
   <td style="text-align:left;"> LAH </td>
   <td style="text-align:left;"> Stortare </td>
   <td style="text-align:left;"> North European kelp </td>
   <td style="text-align:left;"> Laminaria hyperborea </td>
  </tr>
  <tr>
   <td style="text-align:right;"> 2814 </td>
   <td style="text-align:left;"> LQD </td>
   <td style="text-align:left;"> Fingertare </td>
   <td style="text-align:left;"> Tangle </td>
   <td style="text-align:left;"> Laminaria digitata </td>
  </tr>
  <tr>
   <td style="text-align:right;"> 2815 </td>
   <td style="text-align:left;"> LAZ </td>
   <td style="text-align:left;"> Tare uspes. </td>
   <td style="text-align:left;"> Kelps nei </td>
   <td style="text-align:left;"> Laminariaceae </td>
  </tr>
  <tr>
   <td style="text-align:right;"> 2816 </td>
   <td style="text-align:left;"> AJC </td>
   <td style="text-align:left;"> Butare </td>
   <td style="text-align:left;"> Babberlocks </td>
   <td style="text-align:left;"> Alaria esculenta </td>
  </tr>
  <tr>
   <td style="text-align:right;"> 2817 </td>
   <td style="text-align:left;"> FUV </td>
   <td style="text-align:left;"> Blæretang </td>
   <td style="text-align:left;"> Bladder wrack </td>
   <td style="text-align:left;"> Fucus vesiculosus </td>
  </tr>
  <tr>
   <td style="text-align:right;"> 2818 </td>
   <td style="text-align:left;"> FUU </td>
   <td style="text-align:left;"> Sagtang </td>
   <td style="text-align:left;"> Toothed wrack </td>
   <td style="text-align:left;"> Fucus serratus </td>
  </tr>
  <tr>
   <td style="text-align:right;"> 2819 </td>
   <td style="text-align:left;"> UCU </td>
   <td style="text-align:left;"> Tang uspes. </td>
   <td style="text-align:left;"> Fucus spp </td>
   <td style="text-align:left;"> Fucus spp </td>
  </tr>
  <tr>
   <td style="text-align:right;"> 2820 </td>
   <td style="text-align:left;"> ASN </td>
   <td style="text-align:left;"> Grisetang </td>
   <td style="text-align:left;"> North Atlantic rockweed </td>
   <td style="text-align:left;"> Ascophyllum nodosum </td>
  </tr>
  <tr>
   <td style="text-align:right;"> 2821 </td>
   <td style="text-align:left;"> WAP </td>
   <td style="text-align:left;"> Grønlandsbutare </td>
   <td style="text-align:left;"> Alaria pylaiei </td>
   <td style="text-align:left;"> Alaria pylaiei </td>
  </tr>
  <tr>
   <td style="text-align:right;"> 2822 </td>
   <td style="text-align:left;"> ZSD </td>
   <td style="text-align:left;"> Bladtare </td>
   <td style="text-align:left;"> Saccorhiza dermatodea </td>
   <td style="text-align:left;"> Saccorhiza dermatodea </td>
  </tr>
  <tr>
   <td style="text-align:right;"> 2823 </td>
   <td style="text-align:left;"> ZSY </td>
   <td style="text-align:left;"> Draugtare </td>
   <td style="text-align:left;"> Furbellow </td>
   <td style="text-align:left;"> Saccorhiza polyschides </td>
  </tr>
  <tr>
   <td style="text-align:right;"> 2824 </td>
   <td style="text-align:left;"> ZFC </td>
   <td style="text-align:left;"> Martaum </td>
   <td style="text-align:left;"> Bootlace weed </td>
   <td style="text-align:left;"> Chorda filum </td>
  </tr>
  <tr>
   <td style="text-align:right;"> 2825 </td>
   <td style="text-align:left;"> IMS </td>
   <td style="text-align:left;"> Krusflik </td>
   <td style="text-align:left;"> Mousse perle </td>
   <td style="text-align:left;"> Chondrus crispus </td>
  </tr>
  <tr>
   <td style="text-align:right;"> 2826 </td>
   <td style="text-align:left;"> HLZ </td>
   <td style="text-align:left;"> Knapptang </td>
   <td style="text-align:left;"> Sea thong </td>
   <td style="text-align:left;"> Himanthalia elongata </td>
  </tr>
  <tr>
   <td style="text-align:right;"> 2827 </td>
   <td style="text-align:left;"> FUP </td>
   <td style="text-align:left;"> Sauetang </td>
   <td style="text-align:left;"> Channel wrack </td>
   <td style="text-align:left;"> Pelvetia canaliculata </td>
  </tr>
  <tr>
   <td style="text-align:right;"> 2828 </td>
   <td style="text-align:left;"> FDS </td>
   <td style="text-align:left;"> Kaurtang </td>
   <td style="text-align:left;"> Spiral wrack </td>
   <td style="text-align:left;"> Fucus spiralis </td>
  </tr>
  <tr>
   <td style="text-align:right;"> 282901 </td>
   <td style="text-align:left;"> NA </td>
   <td style="text-align:left;"> Japansk drivtang (oppdrett) </td>
   <td style="text-align:left;"> Sargassum muticum </td>
   <td style="text-align:left;"> Sargassum muticum </td>
  </tr>
  <tr>
   <td style="text-align:right;"> 2830 </td>
   <td style="text-align:left;"> SWR </td>
   <td style="text-align:left;"> Andre rødalger </td>
   <td style="text-align:left;"> Red seaweeds </td>
   <td style="text-align:left;"> Rhodophyceae </td>
  </tr>
  <tr>
   <td style="text-align:right;"> 2831 </td>
   <td style="text-align:left;"> FYS </td>
   <td style="text-align:left;"> Fjærehinne uspes </td>
   <td style="text-align:left;"> Nori nei </td>
   <td style="text-align:left;"> Porphyra spp </td>
  </tr>
  <tr>
   <td style="text-align:right;"> 2832 </td>
   <td style="text-align:left;"> RHP </td>
   <td style="text-align:left;"> Søl </td>
   <td style="text-align:left;"> Dulse </td>
   <td style="text-align:left;"> Palmaria palmata </td>
  </tr>
  <tr>
   <td style="text-align:right;"> 2833 </td>
   <td style="text-align:left;"> OFH </td>
   <td style="text-align:left;"> Vanlig fjærehinne </td>
   <td style="text-align:left;"> Pink laver </td>
   <td style="text-align:left;"> Porphyra umbilicalis </td>
  </tr>
  <tr>
   <td style="text-align:right;"> 2834 </td>
   <td style="text-align:left;"> MVT </td>
   <td style="text-align:left;"> Vorteflik </td>
   <td style="text-align:left;"> False Irish moss </td>
   <td style="text-align:left;"> Mastocarpus stellatus </td>
  </tr>
  <tr>
   <td style="text-align:right;"> 2835 </td>
   <td style="text-align:left;"> OFN </td>
   <td style="text-align:left;"> Smal fjærehinne </td>
   <td style="text-align:left;"> Ribboned nori </td>
   <td style="text-align:left;"> Porphyra linearis </td>
  </tr>
  <tr>
   <td style="text-align:right;"> 2836 </td>
   <td style="text-align:left;"> OFQ </td>
   <td style="text-align:left;"> Purpurfjærehinne </td>
   <td style="text-align:left;"> Purple laver </td>
   <td style="text-align:left;"> Porphyra purpurea </td>
  </tr>
  <tr>
   <td style="text-align:right;"> 2837 </td>
   <td style="text-align:left;"> GJP </td>
   <td style="text-align:left;"> Smal agaralge </td>
   <td style="text-align:left;"> Dwarf gelidium </td>
   <td style="text-align:left;"> Gelidium pusillum </td>
  </tr>
  <tr>
   <td style="text-align:right;"> 2838 </td>
   <td style="text-align:left;"> NLO </td>
   <td style="text-align:left;"> Rødsleipe </td>
   <td style="text-align:left;"> Sea spaghetti </td>
   <td style="text-align:left;"> Nemalion helminthoides </td>
  </tr>
  <tr>
   <td style="text-align:right;"> 2839 </td>
   <td style="text-align:left;"> OFK </td>
   <td style="text-align:left;"> Porphyra dioica </td>
   <td style="text-align:left;"> Porphyra dioica </td>
   <td style="text-align:left;"> Porphyra dioica </td>
  </tr>
  <tr>
   <td style="text-align:right;"> 2840 </td>
   <td style="text-align:left;"> SWG </td>
   <td style="text-align:left;"> Andre grønnalger </td>
   <td style="text-align:left;"> Green seaweeds </td>
   <td style="text-align:left;"> Chlorophyceae </td>
  </tr>
  <tr>
   <td style="text-align:right;"> 2841 </td>
   <td style="text-align:left;"> UVU </td>
   <td style="text-align:left;"> Havsalat </td>
   <td style="text-align:left;"> Sea lettuce </td>
   <td style="text-align:left;"> Ulva lactuca </td>
  </tr>
  <tr>
   <td style="text-align:right;"> 2860 </td>
   <td style="text-align:left;"> HFH </td>
   <td style="text-align:left;"> Sjøris </td>
   <td style="text-align:left;"> Landlady's Wig </td>
   <td style="text-align:left;"> Ahnfeltia plicata </td>
  </tr>
  <tr>
   <td style="text-align:right;"> 2861 </td>
   <td style="text-align:left;"> SWQ </td>
   <td style="text-align:left;"> Fagerving </td>
   <td style="text-align:left;"> Red delesseria </td>
   <td style="text-align:left;"> Delesseria sanguinea </td>
  </tr>
  <tr>
   <td style="text-align:right;"> 2862 </td>
   <td style="text-align:left;"> FKU </td>
   <td style="text-align:left;"> Svartkluft </td>
   <td style="text-align:left;"> Red forkweed </td>
   <td style="text-align:left;"> Furcellaria lumbricalis </td>
  </tr>
  <tr>
   <td style="text-align:right;"> 2863 </td>
   <td style="text-align:left;"> GZG </td>
   <td style="text-align:left;"> Pollris </td>
   <td style="text-align:left;"> Slender wart weed </td>
   <td style="text-align:left;"> Gracilaria gracilis </td>
  </tr>
  <tr>
   <td style="text-align:right;"> 286401 </td>
   <td style="text-align:left;"> NA </td>
   <td style="text-align:left;"> Vanlig rosenrør (oppdrett) </td>
   <td style="text-align:left;"> Lomentaria clavellosa </td>
   <td style="text-align:left;"> Lomentaria clavellosa </td>
  </tr>
  <tr>
   <td style="text-align:right;"> 2870 </td>
   <td style="text-align:left;"> KMY </td>
   <td style="text-align:left;"> Vanlig grønndusk </td>
   <td style="text-align:left;"> Common green branched weed </td>
   <td style="text-align:left;"> Cladophora rupestris </td>
  </tr>
  <tr>
   <td style="text-align:right;"> 2871 </td>
   <td style="text-align:left;"> UVI </td>
   <td style="text-align:left;"> Tarmgrønske </td>
   <td style="text-align:left;"> Gut weed </td>
   <td style="text-align:left;"> Ulva intestinalis </td>
  </tr>
  <tr>
   <td style="text-align:right;"> 2872 </td>
   <td style="text-align:left;"> KII </td>
   <td style="text-align:left;"> Pollpryd </td>
   <td style="text-align:left;"> Fragile codium </td>
   <td style="text-align:left;"> Codium fragile </td>
  </tr>
  <tr>
   <td style="text-align:right;"> 2890 </td>
   <td style="text-align:left;"> VLA </td>
   <td style="text-align:left;"> Grisetangdokke </td>
   <td style="text-align:left;"> Vertebrata lanosa </td>
   <td style="text-align:left;"> Vertebrata lanosa </td>
  </tr>
  <tr>
   <td style="text-align:right;"> 2899 </td>
   <td style="text-align:left;"> APL </td>
   <td style="text-align:left;"> Annen tang og tare </td>
   <td style="text-align:left;"> Aquatic plants </td>
   <td style="text-align:left;"> Plantae Aquaticae </td>
  </tr>
  <tr>
   <td style="text-align:right;"> 50 </td>
   <td style="text-align:left;"> NA </td>
   <td style="text-align:left;"> FERSKVANNSFISK </td>
   <td style="text-align:left;"> NA </td>
   <td style="text-align:left;"> OSTEICHTHYES </td>
  </tr>
  <tr>
   <td style="text-align:right;"> 501 </td>
   <td style="text-align:left;"> NA </td>
   <td style="text-align:left;"> NA </td>
   <td style="text-align:left;"> NA </td>
   <td style="text-align:left;"> NA </td>
  </tr>
  <tr>
   <td style="text-align:right;"> 5011 </td>
   <td style="text-align:left;"> CGO </td>
   <td style="text-align:left;"> Gullfisk </td>
   <td style="text-align:left;"> Goldfish </td>
   <td style="text-align:left;"> Carassius auratus </td>
  </tr>
  <tr>
   <td style="text-align:right;"> 5012 </td>
   <td style="text-align:left;"> DAI </td>
   <td style="text-align:left;"> Sebrafisk </td>
   <td style="text-align:left;"> Zebra danio </td>
   <td style="text-align:left;"> Danio rerio </td>
  </tr>
  <tr>
   <td style="text-align:right;"> 5013 </td>
   <td style="text-align:left;"> YCK </td>
   <td style="text-align:left;"> Fårehodetannkarpe </td>
   <td style="text-align:left;"> Sheepshead minnow </td>
   <td style="text-align:left;"> Cyprinodon variegatus </td>
  </tr>
  <tr>
   <td style="text-align:right;"> 5014 </td>
   <td style="text-align:left;"> PFL </td>
   <td style="text-align:left;"> Guppy </td>
   <td style="text-align:left;"> Guppy </td>
   <td style="text-align:left;"> Poecilia reticulata </td>
  </tr>
  <tr>
   <td style="text-align:right;"> 5015 </td>
   <td style="text-align:left;"> TLN </td>
   <td style="text-align:left;"> Nilmunnruger </td>
   <td style="text-align:left;"> Nile tilapia </td>
   <td style="text-align:left;"> Oreochromis niloticus </td>
  </tr>
  <tr>
   <td style="text-align:right;"> 5016 </td>
   <td style="text-align:left;"> OZS </td>
   <td style="text-align:left;"> Molly </td>
   <td style="text-align:left;"> Molly </td>
   <td style="text-align:left;"> Poecilia sphenops </td>
  </tr>
  <tr>
   <td style="text-align:right;"> 5017 </td>
   <td style="text-align:left;"> OWJ </td>
   <td style="text-align:left;"> Medaka </td>
   <td style="text-align:left;"> Japanese rice fish </td>
   <td style="text-align:left;"> Oryzias lapides </td>
  </tr>
  <tr>
   <td style="text-align:right;"> 6111 </td>
   <td style="text-align:left;"> SEM </td>
   <td style="text-align:left;"> Common (blue) warehou </td>
   <td style="text-align:left;"> Common (blue) warehou </td>
   <td style="text-align:left;"> Seriolella brama </td>
  </tr>
  <tr>
   <td style="text-align:right;"> 6112 </td>
   <td style="text-align:left;"> SEP </td>
   <td style="text-align:left;"> Silver warehou </td>
   <td style="text-align:left;"> Silver warehou </td>
   <td style="text-align:left;"> Seriollella punctata </td>
  </tr>
  <tr>
   <td style="text-align:right;"> 6121 </td>
   <td style="text-align:left;"> STZ </td>
   <td style="text-align:left;"> Giant stargazer, monkfish </td>
   <td style="text-align:left;"> Giant stargazer, monkfish </td>
   <td style="text-align:left;"> Kathetostoma giganteum </td>
  </tr>
  <tr>
   <td style="text-align:right;"> 6131 </td>
   <td style="text-align:left;"> SFS </td>
   <td style="text-align:left;"> Slirefisk </td>
   <td style="text-align:left;"> Silver scabbardfish </td>
   <td style="text-align:left;"> Lepidopus caudatus </td>
  </tr>
  <tr>
   <td style="text-align:right;"> 6141 </td>
   <td style="text-align:left;"> YTC </td>
   <td style="text-align:left;"> Kingfish, yellowtail </td>
   <td style="text-align:left;"> Kingfish, yellowtail </td>
   <td style="text-align:left;"> Seriola lalandi </td>
  </tr>
  <tr>
   <td style="text-align:right;"> 6151 </td>
   <td style="text-align:left;"> TOP </td>
   <td style="text-align:left;"> Patagonsk tannfisk </td>
   <td style="text-align:left;"> Patagonian toothfish </td>
   <td style="text-align:left;"> Dissostichus eleginoides </td>
  </tr>
  <tr>
   <td style="text-align:right;"> 6152 </td>
   <td style="text-align:left;"> TOA </td>
   <td style="text-align:left;"> Antarktisk tannfisk </td>
   <td style="text-align:left;"> Antartic toothfish </td>
   <td style="text-align:left;"> Dissostichus mawsoni </td>
  </tr>
  <tr>
   <td style="text-align:right;"> 6153 </td>
   <td style="text-align:left;"> TOT </td>
   <td style="text-align:left;"> Antarktisk tannfisk,uspes. </td>
   <td style="text-align:left;"> Antartic toothfish, nei </td>
   <td style="text-align:left;"> Dissostichus spp </td>
  </tr>
  <tr>
   <td style="text-align:right;"> 6154 </td>
   <td style="text-align:left;"> ANS </td>
   <td style="text-align:left;"> Antarctic silverfish </td>
   <td style="text-align:left;"> Antarctic silverfish </td>
   <td style="text-align:left;"> Pleuragramma antarcticum </td>
  </tr>
  <tr>
   <td style="text-align:right;"> 6155 </td>
   <td style="text-align:left;"> NOG </td>
   <td style="text-align:left;"> Humped rockcod </td>
   <td style="text-align:left;"> Humped rockcod </td>
   <td style="text-align:left;"> Notothenia gibberifrons </td>
  </tr>
  <tr>
   <td style="text-align:right;"> 6156 </td>
   <td style="text-align:left;"> NOK </td>
   <td style="text-align:left;"> Striped-eyed rockcod </td>
   <td style="text-align:left;"> Striped-eyed rockcod </td>
   <td style="text-align:left;"> Notothenia kempi </td>
  </tr>
  <tr>
   <td style="text-align:right;"> 6157 </td>
   <td style="text-align:left;"> NOR </td>
   <td style="text-align:left;"> Marbled rockcod </td>
   <td style="text-align:left;"> Marbled rockcod </td>
   <td style="text-align:left;"> Notothenia rossii </td>
  </tr>
  <tr>
   <td style="text-align:right;"> 6158 </td>
   <td style="text-align:left;"> NOS </td>
   <td style="text-align:left;"> Grey rockcod </td>
   <td style="text-align:left;"> Grey rockcod </td>
   <td style="text-align:left;"> Lepidonotothen (Notothenia) squamifrons </td>
  </tr>
  <tr>
   <td style="text-align:right;"> 6159 </td>
   <td style="text-align:left;"> NOX </td>
   <td style="text-align:left;"> Tannfisk uspes. </td>
   <td style="text-align:left;"> Antarctic rockcods, noties nei </td>
   <td style="text-align:left;"> Nototheniidae </td>
  </tr>
  <tr>
   <td style="text-align:right;"> 6171 </td>
   <td style="text-align:left;"> NOT </td>
   <td style="text-align:left;"> Patagonian rockcod </td>
   <td style="text-align:left;"> Patagonian rockcod </td>
   <td style="text-align:left;"> Patagonotothen brevicauda </td>
  </tr>
  <tr>
   <td style="text-align:right;"> 6172 </td>
   <td style="text-align:left;"> TRH </td>
   <td style="text-align:left;"> Striped rockcod </td>
   <td style="text-align:left;"> Striped rockcod </td>
   <td style="text-align:left;"> Pagothenia hansoni </td>
  </tr>
  <tr>
   <td style="text-align:right;"> 6173 </td>
   <td style="text-align:left;"> TRL </td>
   <td style="text-align:left;"> Blunt scalyhead </td>
   <td style="text-align:left;"> Blunt scalyhead </td>
   <td style="text-align:left;"> Trematomus eulepidotus </td>
  </tr>
  <tr>
   <td style="text-align:right;"> 6161 </td>
   <td style="text-align:left;"> ANI </td>
   <td style="text-align:left;"> Mackerel icefish </td>
   <td style="text-align:left;"> Mackerel icefish </td>
   <td style="text-align:left;"> Champsocephalus gunnari </td>
  </tr>
  <tr>
   <td style="text-align:right;"> 6162 </td>
   <td style="text-align:left;"> KIF </td>
   <td style="text-align:left;"> Ocellated icefish </td>
   <td style="text-align:left;"> Ocellated icefish </td>
   <td style="text-align:left;"> Chionodraco rastrospinosus </td>
  </tr>
  <tr>
   <td style="text-align:right;"> 6163 </td>
   <td style="text-align:left;"> TIC </td>
   <td style="text-align:left;"> Chionodraco hamatus </td>
   <td style="text-align:left;"> Chionodraco hamatus </td>
   <td style="text-align:left;"> Chionodraco hamatus </td>
  </tr>
  <tr>
   <td style="text-align:right;"> 6164 </td>
   <td style="text-align:left;"> WIC </td>
   <td style="text-align:left;"> Spiny icefish </td>
   <td style="text-align:left;"> Spiny icefish </td>
   <td style="text-align:left;"> Cheanodraco wilsnoni </td>
  </tr>
  <tr>
   <td style="text-align:right;"> 6165 </td>
   <td style="text-align:left;"> SGI </td>
   <td style="text-align:left;"> South Georgia icefish </td>
   <td style="text-align:left;"> South Georgia icefish </td>
   <td style="text-align:left;"> Pseudochaenichthys georgianus </td>
  </tr>
  <tr>
   <td style="text-align:right;"> 6166 </td>
   <td style="text-align:left;"> SSI </td>
   <td style="text-align:left;"> Blackfin icefish </td>
   <td style="text-align:left;"> Blackfin icefish </td>
   <td style="text-align:left;"> Chaenocephalus aceratus </td>
  </tr>
  <tr>
   <td style="text-align:right;"> 6169 </td>
   <td style="text-align:left;"> ICX </td>
   <td style="text-align:left;"> Isfisk uspes. </td>
   <td style="text-align:left;"> Crocodile icefishes nei </td>
   <td style="text-align:left;"> Channichthyidae </td>
  </tr>
  <tr>
   <td style="text-align:right;"> 6211 </td>
   <td style="text-align:left;"> BOE </td>
   <td style="text-align:left;"> Black oreo </td>
   <td style="text-align:left;"> Black oreo </td>
   <td style="text-align:left;"> Allocyttus niger </td>
  </tr>
  <tr>
   <td style="text-align:right;"> 6212 </td>
   <td style="text-align:left;"> SSO </td>
   <td style="text-align:left;"> Smooth oreo dory </td>
   <td style="text-align:left;"> Smooth oreo dory </td>
   <td style="text-align:left;"> Pseudocyttus maculatus </td>
  </tr>
  <tr>
   <td style="text-align:right;"> 6299 </td>
   <td style="text-align:left;"> ORD </td>
   <td style="text-align:left;"> Oreo dories nei </td>
   <td style="text-align:left;"> Oreo dories nei </td>
   <td style="text-align:left;"> Oreosomatidae </td>
  </tr>
  <tr>
   <td style="text-align:right;"> 6311 </td>
   <td style="text-align:left;"> GRN </td>
   <td style="text-align:left;"> Blue grenadier/ Hoki </td>
   <td style="text-align:left;"> Blue grenadier/ Hoki </td>
   <td style="text-align:left;"> Macruronus novaezelandiae </td>
  </tr>
  <tr>
   <td style="text-align:right;"> 6312 </td>
   <td style="text-align:left;"> HKN </td>
   <td style="text-align:left;"> Southern hake </td>
   <td style="text-align:left;"> Southern hake </td>
   <td style="text-align:left;"> Merluccius australis </td>
  </tr>
  <tr>
   <td style="text-align:right;"> 6399 </td>
   <td style="text-align:left;"> HKX </td>
   <td style="text-align:left;"> Hakes nei </td>
   <td style="text-align:left;"> Hakes nei </td>
   <td style="text-align:left;"> Merluccius spp </td>
  </tr>
  <tr>
   <td style="text-align:right;"> 6329 </td>
   <td style="text-align:left;"> MRL </td>
   <td style="text-align:left;"> Patagonsk torsk uspes. </td>
   <td style="text-align:left;"> Moray cods nei </td>
   <td style="text-align:left;"> Muraenolepis spp </td>
  </tr>
  <tr>
   <td style="text-align:right;"> 633 </td>
   <td style="text-align:left;"> NA </td>
   <td style="text-align:left;"> Skolestfamilien </td>
   <td style="text-align:left;"> Grenadiers (rattails) </td>
   <td style="text-align:left;"> Macrouridae </td>
  </tr>
  <tr>
   <td style="text-align:right;"> 6331 </td>
   <td style="text-align:left;"> WGR </td>
   <td style="text-align:left;"> Sørlig skolest </td>
   <td style="text-align:left;"> Whitson's grenadier </td>
   <td style="text-align:left;"> Macrourus whitsoni </td>
  </tr>
  <tr>
   <td style="text-align:right;"> 6332 </td>
   <td style="text-align:left;"> GRV </td>
   <td style="text-align:left;"> Grenadiers nei </td>
   <td style="text-align:left;"> Grenadiers nei </td>
   <td style="text-align:left;"> Macrourus spp </td>
  </tr>
  <tr>
   <td style="text-align:right;"> 634 </td>
   <td style="text-align:left;"> NA </td>
   <td style="text-align:left;"> Torskefamilien </td>
   <td style="text-align:left;"> Gadids </td>
   <td style="text-align:left;"> Gadiade </td>
  </tr>
  <tr>
   <td style="text-align:right;"> 6341 </td>
   <td style="text-align:left;"> POS </td>
   <td style="text-align:left;"> Southern blue whiting </td>
   <td style="text-align:left;"> Southern blue whiting </td>
   <td style="text-align:left;"> Micromesistius australis </td>
  </tr>
  <tr>
   <td style="text-align:right;"> 6411 </td>
   <td style="text-align:left;"> CUS </td>
   <td style="text-align:left;"> Pink cusk-eel </td>
   <td style="text-align:left;"> Pink cusk-eel </td>
   <td style="text-align:left;"> Genypterus blacodes </td>
  </tr>
  <tr>
   <td style="text-align:right;"> 65 </td>
   <td style="text-align:left;"> NA </td>
   <td style="text-align:left;"> SKATER OG ROKKER </td>
   <td style="text-align:left;"> NA </td>
   <td style="text-align:left;"> RAJIFORMES </td>
  </tr>
  <tr>
   <td style="text-align:right;"> 651 </td>
   <td style="text-align:left;"> NA </td>
   <td style="text-align:left;"> Skatefamilien </td>
   <td style="text-align:left;"> NA </td>
   <td style="text-align:left;"> Rajidae </td>
  </tr>
  <tr>
   <td style="text-align:right;"> 6511 </td>
   <td style="text-align:left;"> SRR </td>
   <td style="text-align:left;"> Antarctic starry skate </td>
   <td style="text-align:left;"> Antarctic starry skate </td>
   <td style="text-align:left;"> Raja georgiana </td>
  </tr>
  <tr>
   <td style="text-align:right;"> 66 </td>
   <td style="text-align:left;"> NA </td>
   <td style="text-align:left;"> PRIKKFISKER </td>
   <td style="text-align:left;"> LANTERNFISHES </td>
   <td style="text-align:left;"> MYCTOPHIFORMES </td>
  </tr>
  <tr>
   <td style="text-align:right;"> 661 </td>
   <td style="text-align:left;"> NA </td>
   <td style="text-align:left;"> Lysprikkfiskfamilien </td>
   <td style="text-align:left;"> Lanternfishes </td>
   <td style="text-align:left;"> Myctophidae </td>
  </tr>
  <tr>
   <td style="text-align:right;"> 6611 </td>
   <td style="text-align:left;"> ELC </td>
   <td style="text-align:left;"> Electron subantarctic </td>
   <td style="text-align:left;"> Electron subantarctic </td>
   <td style="text-align:left;"> Electrona carlsbergi </td>
  </tr>
  <tr>
   <td style="text-align:right;"> 6619 </td>
   <td style="text-align:left;"> LXX </td>
   <td style="text-align:left;"> Lanternfishes nei </td>
   <td style="text-align:left;"> Lanternfishes nei </td>
   <td style="text-align:left;"> Myctophidae </td>
  </tr>
  <tr>
   <td style="text-align:right;"> 70 </td>
   <td style="text-align:left;"> NA </td>
   <td style="text-align:left;"> NA </td>
   <td style="text-align:left;"> NA </td>
   <td style="text-align:left;"> NA </td>
  </tr>
  <tr>
   <td style="text-align:right;"> 701 </td>
   <td style="text-align:left;"> NA </td>
   <td style="text-align:left;"> NA </td>
   <td style="text-align:left;"> NA </td>
   <td style="text-align:left;"> NA </td>
  </tr>
  <tr>
   <td style="text-align:right;"> 7011 </td>
   <td style="text-align:left;"> PNV </td>
   <td style="text-align:left;"> Stillehavsreke </td>
   <td style="text-align:left;"> Whiteleg shrimp </td>
   <td style="text-align:left;"> Penaeus vannamei </td>
  </tr>
  <tr>
   <td style="text-align:right;"> 7014 </td>
   <td style="text-align:left;"> KCV </td>
   <td style="text-align:left;"> Antarctic stone crab </td>
   <td style="text-align:left;"> Antarctic stone crab </td>
   <td style="text-align:left;"> Paralomis spinosissima </td>
  </tr>
  <tr>
   <td style="text-align:right;"> 7015 </td>
   <td style="text-align:left;"> KCX </td>
   <td style="text-align:left;"> King crabs, stone crabs nei </td>
   <td style="text-align:left;"> King crabs, stone crabs nei </td>
   <td style="text-align:left;"> Lithodidae </td>
  </tr>
  <tr>
   <td style="text-align:right;"> 71 </td>
   <td style="text-align:left;"> NA </td>
   <td style="text-align:left;"> BLØTDYR </td>
   <td style="text-align:left;"> MARINE MOLLUSCS </td>
   <td style="text-align:left;"> MOLLUSCA </td>
  </tr>
  <tr>
   <td style="text-align:right;"> 7111 </td>
   <td style="text-align:left;"> SQS </td>
   <td style="text-align:left;"> Sevenstar flying squid </td>
   <td style="text-align:left;"> Sevenstar flying squid </td>
   <td style="text-align:left;"> Martialia hyadesi </td>
  </tr>
  <tr>
   <td style="text-align:right;"> 716101 </td>
   <td style="text-align:left;"> NA </td>
   <td style="text-align:left;"> Dolioletta spp (oppdrett) </td>
   <td style="text-align:left;"> Dolioletta spp </td>
   <td style="text-align:left;"> Dolioletta spp </td>
  </tr>
  <tr>
   <td style="text-align:right;"> 716201 </td>
   <td style="text-align:left;"> NA </td>
   <td style="text-align:left;"> Salpa spp (oppdrett) </td>
   <td style="text-align:left;"> Salpa spp </td>
   <td style="text-align:left;"> Salpa spp </td>
  </tr>
  <tr>
   <td style="text-align:right;"> 716301 </td>
   <td style="text-align:left;"> NA </td>
   <td style="text-align:left;"> Ciona mollis (oppdrett) </td>
   <td style="text-align:left;"> Ciona mollis </td>
   <td style="text-align:left;"> Ciona mollis </td>
  </tr>
  <tr>
   <td style="text-align:right;"> 716401 </td>
   <td style="text-align:left;"> NA </td>
   <td style="text-align:left;"> Ciona savignyi (oppdrett) </td>
   <td style="text-align:left;"> Ciona savignyi </td>
   <td style="text-align:left;"> Ciona savignyi </td>
  </tr>
</tbody>
</table>

Gear names are translated based on the table under:

<table class="table table-striped table-condensed" style="margin-left: auto; margin-right: auto;">
<caption>List of Directorate of Fisheries gear codes. The codes are automatically returned by the extractLogbook function replacing any manually reported gear information (REDSKAP column)</caption>
 <thead>
  <tr>
   <th style="text-align:right;"> idGear </th>
   <th style="text-align:left;"> gearName </th>
   <th style="text-align:left;"> gearCategory </th>
  </tr>
 </thead>
<tbody>
  <tr>
   <td style="text-align:right;"> 10 </td>
   <td style="text-align:left;"> Udefinert not </td>
   <td style="text-align:left;"> Noter </td>
  </tr>
  <tr>
   <td style="text-align:right;"> 11 </td>
   <td style="text-align:left;"> Snurpenot/ringnot </td>
   <td style="text-align:left;"> Noter </td>
  </tr>
  <tr>
   <td style="text-align:right;"> 12 </td>
   <td style="text-align:left;"> Landnot </td>
   <td style="text-align:left;"> Noter </td>
  </tr>
  <tr>
   <td style="text-align:right;"> 14 </td>
   <td style="text-align:left;"> Snurpenot med lys </td>
   <td style="text-align:left;"> Noter </td>
  </tr>
  <tr>
   <td style="text-align:right;"> 15 </td>
   <td style="text-align:left;"> Landnot med lys </td>
   <td style="text-align:left;"> Noter </td>
  </tr>
  <tr>
   <td style="text-align:right;"> 20 </td>
   <td style="text-align:left;"> Udefinert garn </td>
   <td style="text-align:left;"> Garn </td>
  </tr>
  <tr>
   <td style="text-align:right;"> 21 </td>
   <td style="text-align:left;"> Drivgarn </td>
   <td style="text-align:left;"> Garn </td>
  </tr>
  <tr>
   <td style="text-align:right;"> 22 </td>
   <td style="text-align:left;"> Settegarn </td>
   <td style="text-align:left;"> Garn </td>
  </tr>
  <tr>
   <td style="text-align:right;"> 30 </td>
   <td style="text-align:left;"> Udefinert krokredskap </td>
   <td style="text-align:left;"> Kroker </td>
  </tr>
  <tr>
   <td style="text-align:right;"> 31 </td>
   <td style="text-align:left;"> Flyteline </td>
   <td style="text-align:left;"> Kroker </td>
  </tr>
  <tr>
   <td style="text-align:right;"> 32 </td>
   <td style="text-align:left;"> Andre liner </td>
   <td style="text-align:left;"> Kroker </td>
  </tr>
  <tr>
   <td style="text-align:right;"> 33 </td>
   <td style="text-align:left;"> Juksa/pilk </td>
   <td style="text-align:left;"> Kroker </td>
  </tr>
  <tr>
   <td style="text-align:right;"> 34 </td>
   <td style="text-align:left;"> Dorg/harp/snik </td>
   <td style="text-align:left;"> Kroker </td>
  </tr>
  <tr>
   <td style="text-align:right;"> 35 </td>
   <td style="text-align:left;"> Autoline </td>
   <td style="text-align:left;"> Kroker </td>
  </tr>
  <tr>
   <td style="text-align:right;"> 40 </td>
   <td style="text-align:left;"> Udefinert bur og ruser </td>
   <td style="text-align:left;"> Ruser </td>
  </tr>
  <tr>
   <td style="text-align:right;"> 41 </td>
   <td style="text-align:left;"> Ruser </td>
   <td style="text-align:left;"> Ruser </td>
  </tr>
  <tr>
   <td style="text-align:right;"> 42 </td>
   <td style="text-align:left;"> Teiner </td>
   <td style="text-align:left;"> Ruser </td>
  </tr>
  <tr>
   <td style="text-align:right;"> 43 </td>
   <td style="text-align:left;"> Kilenot </td>
   <td style="text-align:left;"> Ruser </td>
  </tr>
  <tr>
   <td style="text-align:right;"> 44 </td>
   <td style="text-align:left;"> Havteiner </td>
   <td style="text-align:left;"> Ruser </td>
  </tr>
  <tr>
   <td style="text-align:right;"> 45 </td>
   <td style="text-align:left;"> Krokgarn </td>
   <td style="text-align:left;"> Ruser </td>
  </tr>
  <tr>
   <td style="text-align:right;"> 50 </td>
   <td style="text-align:left;"> Udefinert trål </td>
   <td style="text-align:left;"> Traal </td>
  </tr>
  <tr>
   <td style="text-align:right;"> 51 </td>
   <td style="text-align:left;"> Bunntrål </td>
   <td style="text-align:left;"> Traal </td>
  </tr>
  <tr>
   <td style="text-align:right;"> 52 </td>
   <td style="text-align:left;"> Bunntrål par </td>
   <td style="text-align:left;"> Traal </td>
  </tr>
  <tr>
   <td style="text-align:right;"> 53 </td>
   <td style="text-align:left;"> Flytetrål </td>
   <td style="text-align:left;"> Traal </td>
  </tr>
  <tr>
   <td style="text-align:right;"> 54 </td>
   <td style="text-align:left;"> Flytetrål par </td>
   <td style="text-align:left;"> Traal </td>
  </tr>
  <tr>
   <td style="text-align:right;"> 55 </td>
   <td style="text-align:left;"> Reketrål </td>
   <td style="text-align:left;"> Traal </td>
  </tr>
  <tr>
   <td style="text-align:right;"> 56 </td>
   <td style="text-align:left;"> Bomtrål </td>
   <td style="text-align:left;"> Traal </td>
  </tr>
  <tr>
   <td style="text-align:right;"> 57 </td>
   <td style="text-align:left;"> Krepsetrål </td>
   <td style="text-align:left;"> Traal </td>
  </tr>
  <tr>
   <td style="text-align:right;"> 58 </td>
   <td style="text-align:left;"> Dobbeltrål </td>
   <td style="text-align:left;"> Traal </td>
  </tr>
  <tr>
   <td style="text-align:right;"> 59 </td>
   <td style="text-align:left;"> Trippeltrål </td>
   <td style="text-align:left;"> Traal </td>
  </tr>
  <tr>
   <td style="text-align:right;"> 61 </td>
   <td style="text-align:left;"> Snurrevad </td>
   <td style="text-align:left;"> Noter </td>
  </tr>
  <tr>
   <td style="text-align:right;"> 70 </td>
   <td style="text-align:left;"> Harpun og lignende uspesifiserte typer. </td>
   <td style="text-align:left;"> Skytevaapen </td>
  </tr>
  <tr>
   <td style="text-align:right;"> 71 </td>
   <td style="text-align:left;"> Brugde /hvalkanon </td>
   <td style="text-align:left;"> Skytevaapen </td>
  </tr>
  <tr>
   <td style="text-align:right;"> 72 </td>
   <td style="text-align:left;"> Størjeharpun </td>
   <td style="text-align:left;"> Skytevaapen </td>
  </tr>
  <tr>
   <td style="text-align:right;"> 73 </td>
   <td style="text-align:left;"> Rifle </td>
   <td style="text-align:left;"> Skytevaapen </td>
  </tr>
  <tr>
   <td style="text-align:right;"> 80 </td>
   <td style="text-align:left;"> Annet </td>
   <td style="text-align:left;"> Annet </td>
  </tr>
  <tr>
   <td style="text-align:right;"> 81 </td>
   <td style="text-align:left;"> Skjellskrape </td>
   <td style="text-align:left;"> Annet </td>
  </tr>
  <tr>
   <td style="text-align:right;"> 82 </td>
   <td style="text-align:left;"> Håv </td>
   <td style="text-align:left;"> Annet </td>
  </tr>
  <tr>
   <td style="text-align:right;"> 83 </td>
   <td style="text-align:left;"> Taretrål </td>
   <td style="text-align:left;"> Annet </td>
  </tr>
  <tr>
   <td style="text-align:right;"> 84 </td>
   <td style="text-align:left;"> Tangkutter (-skjærer) </td>
   <td style="text-align:left;"> Annet </td>
  </tr>
  <tr>
   <td style="text-align:right;"> 85 </td>
   <td style="text-align:left;"> Håndplukking </td>
   <td style="text-align:left;"> Annet </td>
  </tr>
  <tr>
   <td style="text-align:right;"> 90 </td>
   <td style="text-align:left;"> Oppdrett </td>
   <td style="text-align:left;"> Annet </td>
  </tr>
  <tr>
   <td style="text-align:right;"> 99 </td>
   <td style="text-align:left;"> Uspesifisert </td>
   <td style="text-align:left;"> Annet </td>
  </tr>
</tbody>
</table>

The codes have been extracted from the [Norwegian Directorate of Fisheries website](https://www.fiskeridir.no/Yrkesfiske/Rapportering-ved-landing/Kodeliste).

## Contributions and contact information

Any contributions to the package are more than welcome. Please contact the package creator Mikko Vihtakari (<mikko.vihtakari@hi.no>) to discuss your ideas on improving the package or place a request in the issues section. 

## News

2021-10-11 Strata making scripts moved to a [separate package](https://github.com/DeepWaterIMR/RstoxStrata). 

2020-05-19 Added logbook data extraction.

2019-12-16 The first version of the package online. Bugged as life, but available. Please excuse me for not having double-checked all references to other people's work. The references will come in future releases. 
