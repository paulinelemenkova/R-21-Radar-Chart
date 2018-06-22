# Radar Chart install.packages("fmsb")
# PART-1. Create dataframe 
	# step-1. Read table. Delete NA values
MDepths <- read.csv("Morphology.csv", header=TRUE, sep = ",")
MDF <- na.omit(MDepths) 
row.has.na <- apply(MDF, 1, function(x){any(is.na(x))}) 
sum(row.has.na) 
head(MDF)
	# step-2. Merge group categories by classes
MDFt = melt(setDT(MDF), measure = patterns("^plate"), value.name = c("tectonics"))
head(MDFt)
levels(MDFt$variable) = c("Philippine" , "Pacific", "Mariana", "Caroline")
Plates<- c("Philippine" , "Pacific", "Mariana", "Caroline")

# PART-2. Radar Chart.
library(fmsb)
set.seed(25) 
    # step-3. Create mini-set of 2 values.
radardataM =as.data.frame(matrix(MDFt$tectonics, ncol=25, nrow=4))
#	radardataM <- as.data.frame(MDFt$tectonics, MDFt$profile, MDFt$variable)
colnames(radardataM)<- c(paste("Profile", seq(1:25), sep=""))
rownames(radardataM)<- c("Philippine", "Pacific", "Mariana", "Caroline")
	# step-4. add 2 lines to the dataframe: max-min of each topic
radardataM <- rbind(rep(0, 25) , rep(518, 25) , radardataM)
 	# step-5. The default radar chart proposed by the library:
radarchart(radardataM)

    # step-6. Custom the radarChart
# Plot 2: Same plot with custom features 
colors_border=c(rgb(0.2,0.5,0.5,0.9), rgb(0.8,0.2,0.5,0.9), rgb(0.7,0.5,0.1,0.9), rgb(0.2,0.7,0.4,0.9))
colors_in=c(rgb(0.2,0.5,0.5,0.1), rgb(0.8,0.2,0.5,0.1), rgb(0.7,0.5,0.1,0.1), rgb(0.2,0.7,0.4,0.1))
radarchart( radardataM  , axistype=1 ,     #custom polygon
		pcol=colors_border , pfcol=colors_in , plwd=4 , plty=1,        
		cglcol="grey", cglty=1, axislabcol="grey", caxislabels=seq(0,20,5), cglwd=0.8, #custom grid	    
		vlcex=0.8 , #custom labels 
title ="Mariana Trench. \nRadar Chart: Tectonics by Profiles 1:25", cex=0.7)
legend(x=1.2, y=1.0, legend = rownames(radardataM[-c(1,2),]),
		bty = "n", pch=20 , col=colors_in , text.col = "grey", cex = 0.8, pt.cex = 2)	
		
# step-7 вариант со штриховкой
radarchart(radardataM, axistype=2, pcol=topo.colors(4), plty=1, pdensity=c(10, 10, 10, 10),   pangle=c(10, 45, 90, 120), pfcol=topo.colors(4), title ="Mariana Trench. \nRadar Chart: Tectonics by Profiles 1:25", cex=0.7)
legend(x=1.2, y=1.0, legend = rownames(radardataM[-c(1,2),]),
		bty = "n", pch=20 , col=topo.colors(4), text.col = "grey", cex = 0.8, pt.cex = 2)
