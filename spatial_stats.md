# Spatial Analysis

## Quantifying space and place

- A note about [geographical distance](https://gis.stackexchange.com/questions/17638/how-to-cluster-spatial-data-in-r): unless very short, it differs from the Euclidean distance calculable from geographic coordinates alone.
- Coordinates
- Projections

## Categories of spatial analysis

- [Ch. 10: Intro to spatial point pattern analysis](http://www.columbia.edu/~cjd11/charles_dimaggio/DIRE/resources/spatialEpiBook.pdf)
    - Summary statistics
        - Ripley's K function
    - Assessments of randomness (number and location of points)
        - 'G function
        - Moran's I and Geary's I "measure the tendency of events to cluster or the extent to which points close together have similar values on average than those farther apart"; they are global autocorrelation statistics.
        - Local Moran's I and Gi*
    - Models of point processes for simulating points data

### Clusters, hotspots, heatmaps

Although both produce a smooth-ish gradient visualization from points data (darker=more dense, lighter=less), [a hotspot map is different from a heat map](https://www.gislounge.com/difference-heat-map-hot-spot-map/). For a [heat map](https://www.gislounge.com/heat-maps-in-gis/), the density surface is created using a point density or kernel density approach. In either case, the resulting map is highly subjective because it depends on your choice of (1) how many input rasters per output raster AKA density unit; (2) length of bandwidth AKA search radius; (3) how points are counted (raw count, inverse-distance weighting, etc.). Here's a [script for pretty heatmapping in Python](http://www.sethoscope.net/heatmap/).

- [POINT DENSITY](http://help.arcgis.com/en/arcgisdesktop/10.0/help/index.html#/How_Point_Density_works/009z00000013000000/): Set neighborhood size. Impute to each map raster the number or weighted number of points in its neighborhood, divided by the area of the neighborhood.
- [KERNEL DENSITY](http://help.arcgis.com/en/arcgisdesktop/10.0/help/index.html#/How_Kernel_Density_works/009z00000011000000/): By means of a kernel density function, each point is replaced by a circular surface that is centered on the point; extends some distance (the search radius); takes its maximum value at the center, and reaches zero at the border. The area of the surface may sum to one or some other value determined by the weight of the point. Finally, the value of each raster is the sum of all partial surfaces that overlap it. 

A hotspot map defines densities AND includes statistical tests for whether high densities (clusters) are nonrandom. Two primary methods: Gi* and KDE. 

Is it possible that the [Getis-Ord Gi* (G-i-star) statistic](http://desktop.arcgis.com/en/arcmap/10.3/tools/spatial-statistics-toolbox/h-how-hot-spot-analysis-getis-ord-gi-spatial-stati.htm) is a recipe for how points are counted (3, above) and that it can be calculated on a point or kernel density basis?

- Gi* is a z-score; it can be interpreted relative to a critical z score or assigned a p-value. 
- [CDC source](https://www.cdc.gov/dhdsp/maps/GISX/training/module3/files/3_hotspot_analysis_module.PDF)
- [](https://ceprofs.civil.tamu.edu/dlord/Papers/Kuo_et_al._GIS_Guidelines.pdf)
- [Worked example using spdep](http://www.bias-project.org.uk/ASDARcourse/unit6_slides.pdf): a polygon-based analysis
- [Overview of hotspot detection methods](https://www.mailman.columbia.edu/research/population-health-methods/hot-spot-detection)
- [Calculate nearest neighbor distances in R](http://mapas.mma.gov.br/i3geo/pacotes/rlib/win/spatstat/html/nndist.html)


How does this relate to clustering algorithms used outside of geography?

[Textbook on spatial points analysis](https://research.csiro.au/software/wp-content/uploads/sites/6/2015/02/Rspatialcourse_CMIS_PDF-Standard.pdf):

- All these summary statistics assume stationarity, and are used to characterize a point process by comparing it with random Poisson process:
    - F function: "cumulative distribution function of the empty space distance"
    - G function: "cumulative distribution function of the nearest-neighbour distance for a typical point in the pattern" 
    - Ripley's K: "the expected number of other points of the process within a distance r of a typical point of the process ... weighted and renormalised empirical distribution functions of the pairwise distances"
- To go beyond this, you start thinking in terms of specific point processes which give rise to different kinds of clustering
- "Exploratory techniques for investigating localised features in a point pattern include LISA (Local Indicators of Spatial Association), nearest-neighbour cleaning, and data      sharpening"


```{r}
library(spdep)



library(spatstat)

# create ppp object
my.ppp <- ppp(x.coordinates, y.coordinates, x.range, y.range)

# use plot(as.ppp(my.ppp)) to truncate plot to specified range
plot(my.ppp) 

# create a density map
plot(density(my.ppp))

# plot Ripley's K, indicates if clustering is nonrandom
plot(Kest(my.ppp))

```

### Spatial dependence

- [Tutorials by Nick Eubank](http://www.nickeubank.com/gis-in-r/): 
    - how to install spatstat when install.packages() fails
    - instructions for calculating Moran's I, "one of the most common measures of spatial dependence"
- [Moran's I](http://stats.idre.ucla.edu/r/faq/how-can-i-calculate-morans-i-in-r/)
- [Moran's I is a summary statistic; Getis Ord is for hotspots](http://pro.arcgis.com/en/pro-app/tool-reference/spatial-statistics/h-how-spatial-autocorrelation-moran-s-i-spatial-st.htm)
- [Slidedeck that covers regression and point patterns](http://scc.stat.ucla.edu/page_attachments/0000/0094/spatial_R_1_09S.pdf)
- [Tutorials by V. Gómez-Rubio](http://www.uclm.es/profesorado/vgomez/useR2014/): slightly clarifying but not enough to work from
- [Tutorials by Claudia Engel](http://www.rpubs.com/cengel248): good but doesn't touch on clustering



## Resources

- [Overview of GIS-related R packages](https://cran.r-project.org/web/views/Spatial.html)
- [A whole textbook on finding geospatial patterns in points](https://research.csiro.au/software/wp-content/uploads/sites/6/2015/02/Rspatialcourse_CMIS_PDF-Standard.pdf)
- [Vignettes for spatstat](https://cran.r-project.org/web/packages/spatstat/):
    - __[Getting started](https://cran.r-project.org/web/packages/spatstat/vignettes/getstart.pdf)__
- [James Cheshire's tutorials for mapping in R](http://spatial.ly/r/)



## Install notes

### [Tips for troubleshooting R package installation problems](https://support.rstudio.com/hc/en-us/articles/200554786-Problem-Installing-Packages)

- Package available on CRAN or other repository
    - Use a different CRAN mirror
    - Use a different default repository, maybe not CRAN
- Package name spelled correctly
- Package available for your version of R
- Connectivity issues

### spdep

- /usr/share/R/share/make/shlib.mk:6: recipe for target 'expm.so' failed
- ERROR: compilation failed for package ‘expm’ (dependency for spdep)
- installed with v. 3.3.2 (launch from command line)

### spatstat

- ```install.packages("spatstat")``` fails because polyclip dependency fails because "unable to load shared object ... undefined symbol: __cxa_throw_bad_array_new_length"
- ```conda install --channel https://conda.anaconda.org/jsignell r-spatstat``` fails because dependencies in conflict with r-modelmetrics
    - too risky to uninstall r-modelmetrics; depends on r-essentials and ```conda remove r-modelmetrics --force``` is too risky
    - try exploring dependency conflict:
        - ```conda info r-spatstat``` throws an error, so add r-spatstat channel to conda: ```conda config --append channels https://conda.anaconda.org/jsignell```
            - r-abind
            - r-base 3.3.1*
            - r-deldir >=0.0_21
            - r-goftest
            - r-matrix
            - r-mgcv
            - r-nlme
            - r-polyclip >=1.5_0
            - r-rpart
            - r-tensor
        - ```conda info r-modelmetrics```:
            - r-base 3.3.2*
            - r-rcpp
        - looks like it's a conflict between versions of r-base, no idea how to fix that
- install R through Synaptic; this version of R should open when RStudio is launched from the menu
    - r-base == v.3.2.3, super out of date :/
    - r-cran-spatstat
    - VICTORY!!!