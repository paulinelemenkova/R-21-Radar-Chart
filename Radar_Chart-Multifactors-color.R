# Радарная диаграмма пакетом fmsb (т.н. "паутинка") // Radar Chart (Spider Chart)
# install.packages("fmsb") - если не установлен, установить пакет для радарной диаграммы 

# ЧАСТЬ-1. готовим датафрейм. 
	# шаг-1. вчитываем таблицу с данными. делаем из нее исходный датафрейм. чистим датафрейм от NA
MDepths <- read.csv("Morphology.csv", header=TRUE, sep = ",")
MDF <- na.omit(MDepths) 
row.has.na <- apply(MDF, 1, function(x){any(is.na(x))}) 
sum(row.has.na) 
head(MDF)
	# шаг-2. сшиваем группы категорий по классам (здесь: тектоника, глубины, углы)
MDFt = melt(setDT(MDF), measure = patterns("^plate"), value.name = c("tectonics"))
head(MDFt)
levels(MDFt$variable) = c("Philippine" , "Pacific", "Mariana", "Caroline")
Plates<- c("Philippine" , "Pacific", "Mariana", "Caroline")

# ЧАСТЬ-2. рисуем диаграмму-паутинку.
library(fmsb)
set.seed(25) 

	# шаг-2. создаем мини-выборку из 2 значений. здесь: макс.глубины по 25 профилям.
	radardataM =as.data.frame(matrix(MDFt$tectonics, ncol=25, nrow=4))
#	radardataM <- as.data.frame(MDFt$tectonics, MDFt$profile, MDFt$variable)
	colnames(radardataM)<- c(paste("Profile", seq(1:25), sep=""))
	rownames(radardataM)<- c("Philippine", "Pacific", "Mariana", "Caroline")
#	rownames(radardataM) = paste("Philippine" , "Pacific", "Mariana", "Caroline")
	# шаг-3. добавляем макс-мин значения по категориям add 2 lines to the dataframe: max-min of each topic
	radardataM <- rbind(rep(0, 25) , rep(518, 25) , radardataM)
 	# шаг-4. строим дефолтную радарную диаграммку. The default radar chart proposed by the library:
	radarchart(radardataM)

	# шаг-5. юстируем детали. Custom the radarChart
# Plot 2: Same plot with custom features 
	colors_border=c(rgb(0.2,0.5,0.5,0.9), rgb(0.8,0.2,0.5,0.9), rgb(0.7,0.5,0.1,0.9), rgb(0.2,0.3,0.4,0.1))
	colors_in=c(rgb(0.2,0.5,0.5,0.4), rgb(0.8,0.2,0.5,0.4), rgb(0.7,0.5,0.1,0.4), rgb(0.2,0.3,0.4,0.1)) 
	radarchart( radardataM  , axistype=1 ,     #custom polygon    
		pcol=colors_border , pfcol=colors_in , plwd=4 , plty=1,        
		cglcol="grey", cglty=1, axislabcol="grey", caxislabels=seq(0,20,5), cglwd=0.8,  #custom the grid   	    
		vlcex=0.8 , #custom labels 
	title ="Mariana Trench. Radar Chart: Tectonics by Profiles 1:25", cex=0.7) 
	
	legend(x=1.2, y=1.0, legend = rownames(radardataM[-c(1,2),]), 
		bty = "n", pch=20 , col=colors_in , text.col = "grey", cex = 0.8, pt.cex = 2)
