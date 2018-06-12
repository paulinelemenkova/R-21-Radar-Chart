# Радарная диаграмма пакетом fmsb (т.н. "паутинка") // Radar Chart (Spider Chart)
# install.packages("fmsb") - если не установлен, установить пакет для радарной диаграммы 

# ЧАСТЬ-1. готовим датафрейм. 
	# шаг-1. вчитываем таблицу с данными. делаем из нее исходный датафрейм. чистим датафрейм от NA
MDepths <- read.csv("Morphology.csv", header=TRUE, sep = ",")
MDF <- na.omit(MDepths) 
row.has.na <- apply(MDF, 1, function(x){any(is.na(x))}) 
sum(row.has.na) 
head(MDF)

# ЧАСТЬ-2. рисуем диаграмму-паутинку.
library(fmsb)

	# шаг-2. создаем мини-выборку из 2 значений. здесь: макс.глубины по 25 профилям.
radardata <- as.data.frame(matrix(MDF$Min, ncol=25))
colnames(radardata)=c(paste("Profile", seq(1:25), sep=""))
 
	# шаг-3. добавляем максимальное и минимальное значение по категориям add 2 lines to the dataframe: the max and min of each topic to show on the plot
radardata <- rbind(rep(-11000, 25) , rep(-4000, 25) , radardata)
 	# шаг-4. строим дефолтную радарную диаграммку. The default radar chart proposed by the library:
radarchart(radardata)
	# шаг-5. юстируем детали. Custom the radarChart
radarchart(radardata, axistype = 1,  
    	pcol=rgb(0.2,0.5,0.5,0.9) , pfcol=rgb(0.2,0.5,0.5,0.5) , plwd=2 , #custom polygon
 	cglcol="grey", cglty=1, axislabcol="grey", caxislabels=seq(0,20,5), cglwd=0.3, #custom the grid    
	vlcex=0.6 #custom labels
    )

