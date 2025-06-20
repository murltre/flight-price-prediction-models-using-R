

install.packages("caret", dependencies = c("Depends", "Suggests"))
install.packages("rpart") 
install.packages("rpart.plot") 
install.packages("forecast") 
library(caret) 
library(rpart) 
library(rpart.plot) 
library(forecast)

## packages need for the heatmap
install.packages("pheatmap") 
install.packages("corrplot")
library(pheatmap) 
library(corrplot)

# Load necessary libraries
library(readr) # For reading CSV files
library(dplyr) # For data manipulation
library(ggplot2) # For data visualization

suppressWarnings(RNGversion("4.3.2")) 

options(scipen=999) 
library(caret) 
library(rpart) 
library(rpart.plot) 
library(forecast) 
library(readxl) 


##    1&2)  Executive Summary (detailed in our proposal)

# Our project examines a detailed flight booking dataset from "Ease My Trip" on Kaggle, a key player in online flight booking. 
# As digital platforms become vital for travelers' journey planning, we aim to understand, compare, 
# and predict flight prices involving some key variables and six different airlines in this evolving digital landscape.


# Question: In our study, we will try to answer the following question:
#What are the key determinants of flight pricing, and how can those factors be used to predict price variations?

##    3)   Business Understanding
# Our project explores the digital transformation of the aviation industry, with a focus on online booking platforms.
# We aim to dissect the intricate pricing strategies of six major airlines, examining the primary factors influencing price fluctuations. 
# Our goal is to create predictive models that estimate flight prices based on various influencing variables.
# This analysis will benefit stakeholders and travelers alike by offering insights into the pros and cons of different booking options for their upcoming flights. 




##    4)   Data Understanding
       #a) Data requirement
# The original data we extracted from Kaggle came volumetric (300,154 rows) and with variables such as the Airlines, the flights number, 
#flight departures and destinations, the number of stops of the flights, the departure time and arrival time (moment of the day),
#the class of the flight (Economy or Business), duration of the flight, the days left before the flight and the price.


      #b) Describe Data
# After taking a look at the data, we can describe the variables as follow:

#Airlines Companies (SpiceJet, Vistara, Indigo, GO_FIRST, Air_India, AirAsia): Categorical variable representing different airlines,
#used to assess how each airline's services and pricing impact our study.

#Flights: Categorical variable indicating individual flight bookings.

#Flight Departure Time: Categorical variable categorizing the booking time (e.g., morning, evening), to identify patterns affecting flight prices.

#Number of Stops: Discrete numerical variable, considering only non-stop flights to focus on price impacts.

#The Class: Categorical variable, Economy or Business class seats to analyze ticket price influences.

#Duration: Continuous numerical variable, may directly influence the price of the flights.

#Days Left: Discrete numerical variable showing booking lead time, used to explore how advance booking affects prices for different airlines.

#Price: Continuous numerical variable, the dependent variable representing flight costs, crucial for understanding flight booking decisions and airline competitiveness.

# Source and destination of the flight: Categorical variable. Indicating the departure and arrival city of the flight. 

        #c) Quality
# I would say this is a good quality data because of its consistency and not having null values. Some business fight price are extremely high and I had to take
# a close look at some of those values. Apart from that, I think this data is good for an analysis.


##   5)   Data Preparation
library(readr)
Simpler_Clean_Up <- read_csv("C:/OneDrive/GRAD SCHOOL materials/FALL 2023/BUAN 6356 B. ANALYTICS with R/SEMESTER PROJECT -Personal/Draft 2/Simpler_Clean_Up.csv")
myData <- Simpler_Clean_Up
myData

# Basic overview of the data
Basic_summary <- summary(myData)
Basic_summary


        #a) Data selection
#Among all the variables we have listed above, we have inspected the variables and have chosen only those that was found be significant and helpful
# for this analysis. Here is a breakdown of what we found.

# 1) First, we consider the potential variables that could affect the price, meaning that could be useful in building our model.
# The Airlines, The Departure time, The Class, Duration, the Days left. 

# 2) We then check the relationship of each variable with the dependent variable while checking for outlier with different possible plots.
# Comment 1: "Class": We notice the the Business class has some unsually extremely high flight prices and seem to have a little or no variation in prices 
# with the number of days left. We were able to visualize those trend with a scatter plot and a histogram plot. For simplicity we decided to use only "Economy" Class
# Comment 2: The Departure time has two major changes in the averages, all the airline together and within the airlines. "Late Night" (lowder average price) and 
# and all the other moments of the day (Standard). We decided to group them into "Late Ngith" and "Not Late Night"
# Commment 3: "Stops" are majoritary either "one" and "zero". to eliminate the influence some flights too many number of stops, we focused only only "One" and "Zero"


## Before moving to data preparation, we will make some plots to visualize the variables and their relationships.

# Plot 1: Scatter plot of "Price" vs. "Days_left". We will make a scatter plots to visualize the change of the prices based on the days left

plot(myData$days_left, myData$price,  
     main = "Scatter Plot of Days Left vs Price",  
     xlab = "Days Left",  
     ylab = "Price",  
     pch = 16,  
     col = rgb(0, 0, 1, 0.5),
     cex = 0.2)
# Add the regresion line to the plot
model <- lm(price ~ days_left, data = myData)
abline(model, col = "red")
summary(model)
# plot show a negative relationship between the 'price' and the 'days_left', it is statistically significant with an R2 = 0.3175 
# and a Standard Error= 2,986. Around 31.75% of the data can be explained by this relationship using this model.


## Plot 2: Scatter of Price vs. Duration of the flight. We will make a scatter plot to see how the price changes with respect to the duration.
plot(myData$duration, myData$price,  
     main = "Scatter Plot of Price vs. Duration",  
     xlab = "Duration",  
     ylab = "Price",  
     pch = 16,  
     col = "blue",
     cex = 0.3) 
# Add a linear model trend line 
model_dur <- lm(price ~ duration, data = myData)
abline(model_dur, col = "red") 
summary(model_dur)
# The summary of this regression model shows a significant relationship with three stars (***), R2 = 0.07582 and a standard deviation of 3,475
# which mean, that a very few percentage 7.58% of the data can be explained by this relationship.

# plot 3: Boxplot comparing prices between 'zero' stops and 'one' stop.
boxplot(price ~ stops, data = myData,  
        main = "Box Plot of Price by Number of Stops",  
        xlab = "Number of Stops",  
        ylab = "Price", 
        col = c("blue", "red")) 
# the plot shows that flights with one stops have higher median and higher variation of the price. They tend to be more expensive than flights with no stops.

# Plot 4: Price variation based on Departure time. We will make bar plot to compare price variation based on the departures.
# We calculate the price average for each departure time using the aggregate() function
average_prices_by_time <- aggregate(price ~ departure_time, data = myData, mean) 

# We create a bar plot for the average prices by departure time 
barplot(average_prices_by_time$price,  
        names.arg = average_prices_by_time$departure_time,  
        main = "Average Prices by Departure Time",  
        xlab = "Departure Time",  
        ylab = "Average Price", 
        col = rainbow(length(average_prices_by_time$departure_time)), # Using a color spectrum 
        las = 2)
# As we can see from the plot, 'Late night' tend to have lower prices and 'morning' higher prices compared to other departure times.


## Plot 5: Average price Across Airlines. We will make a bar plot of the average price for each Airline
average_prices <- aggregate(price ~ airline, data = myData, mean) 
barplot(average_prices$price,  
        names.arg = average_prices$airline,  
        main = "Average Prices by Airline",  
        xlab = "Airline",  
        ylab = "Average Price", 
        las = 2, # Rotate the labels on x-axis 
        col = "lightblue") # Color of the bars 
# Vistara came to be the Airline with the highest prices and AirAsia with the lowest prices. It would be interesting to see prices for each Airline
 # based on the departure time.

## Plot 6: Price based on the departure for each Airline. We will visualize how the price changes for each airine based on the departure time.
# Using tapply to calculate average prices 
average_prices_matrix <- tapply(myData$price,  
                                list(myData$airline, myData$departure_time),  
                                mean) 
# Convert to matrix and replace NA with 0 (in case there are combinations with no data) 
average_prices_matrix[is.na(average_prices_matrix)] <- 0 
# Convert the result to a matrix 
barplot_matrix <- as.matrix(average_prices_matrix) 
# The row names of the matrix should be the airline names 
rownames(barplot_matrix) <- rownames(average_prices_matrix) 
# Names for the legend (departure times) 
legend_names <- colnames(barplot_matrix) 

# Grouped bar plot 
barplot(height = barplot_matrix,  
        beside = TRUE,  
        col = c("blue", "red", "green", "yellow", "orange", "purple"),  
        main = "Average Prices by Airline and Departure Time",  
        xlab = "Airline",  
        ylab = "Average Price", 
        las = 2, # to make the airline names horizontal 
        names.arg = rownames(barplot_matrix), # setting the x-axis labels to airline names 
        space = c(0.3, 2))
# The legend with size and more columns 
legend("bottomright",
       legend = legend_names, fill = c("blue", "red", "green", "yellow", "orange", "purple"),
       cex = 0.5, # smaller font size 
       ncol = 2) # more columns 
# As seen in the previous plot, we can see that the 'early morning' and 'late night' tend to have lower price for each Airline. However, 'Night' flights
# interestingly stand out for each individual flight.


         #b) Data Cleaning & Preparation
# Afte applying those changes to our original dataset, we now have our clean up dataset named "Simpler_Clean_Up" with 194,464 rows with five (5) entity varialbes:
# Duration, Days_left, Stops, Departure Time, and Airlines.


# To make our current new data ready for analysis, we will need to use dummy variables for Stops, Departure time, and Airlines.
# 1) For "Stops": We will use "0" or no stop flights and "1" for flights with at least one stop.
# 2) For "Departure time": We will use "0" for "Late Night" and "1" for "Not Lat Night"
# 3) For "Airlines": Since Vistara was the airline with the highest average prices, we have chosen that to be the reference. Now we have the other 5 airlines
# encoded as columns with the values either "0" or "1". We save our new data file as "Dummy_Variable_Created". with the total 9 predictor variables: 
# Duration (continuous), Daysleft (numeric), Stops (binary), AirAsia (binary), Air_India (binary), Go_FIRST (binary), Indigo (binary), SpiceJet (binary), and 
# and Not_Late_Night (binary). Now we can proceed with the analysis. 

library(readr)
Dummy_Variables_Created <- read_csv("C:/OneDrive/GRAD SCHOOL materials/FALL 2023/BUAN 6356 B. ANALYTICS with R/SEMESTER PROJECT -Personal/Dummy_Variables Created.csv")
m1Data <- Dummy_Variables_Created
m1Data

## Preliminary Check: We want to check for any potential multicolinearity between variables. 

# 1) The heatmap: We will use the heatmap to check for any correlation between the variables. 
# We calcalte the correlation matrix
correlation_matrix <- cor(m1Data)

# We then create teh heatmap with the correlation coefs using the corrplot() function
corrplot(correlation_matrix, method = "color",
         type = "full",
         tl.col = "black", number.cex = 0.5,
         tl.srt = 45, addCoef.col = "black",
         diag = TRUE, cl.cex = 0.6, cl.ratio = 0.1)


## Comments
# The heatmap indicates a moderately strong negative correlation between 'Price' and 'Days_left' (-0.56), a positive correlation for 'Duration' (0.28) 
# and 'Stops'(0.27) as expected. We can notice that 'Duration' and 'Stops' have the highest independent correlation coefficient (0.52). 
# which makes sense because the higher the stops, the longer the flight will be. We the correlation coefficient between them is not strong enough
# to be an issue for this analysis. 



##   6)    Modeling - Building Model
## Model1: Multiple Linear Regression using partition method
 
#We use the createDataPartition function to randomly allocate 70% of the data  
#into the training data set and 30% into the validation data set. 
#We then use this list of index to subset the data for training and validation
#By setting the random seed to 1, we will be able to replicate the results in  
#the future by generating the same partitions 
set.seed(1)
myIndex <- createDataPartition(m1Data$Price, p=0.7, list=FALSE) 
trainSet <- m1Data[myIndex,] 
validationSet <- m1Data[-myIndex,] 


# After checking the relationship of each predictor with the independent variable, we have decided to start with the most relevant predictors
# and then continuously add other predictors to our model to evaluate their influence.

# Experiment 1
options(scipen=999)
model_a <- lm(Price ~ AirAsia + Air_India + GO_FIRST + Indigo + SpiceJet + Days_left, data  = trainSet)
model_a
summary(model_a)

# Experiment 2
model_b <- lm(Price ~ AirAsia + Air_India + GO_FIRST + Indigo + SpiceJet + Days_left + Stops, data = trainSet)
model_b
summary(model_b)

# Experiment 3
model_c <- lm(Price ~ AirAsia + Air_India + GO_FIRST + Indigo + SpiceJet + Days_left + Stops + Not_Late_Night, data = trainSet)
model_c
summary(model_c)

# Experiment 4
model_d <- lm(Price ~ AirAsia + Air_India + GO_FIRST + Indigo + SpiceJet + Days_left + Stops + Not_Late_Night + Duration, data = trainSet)
model_d
summary(model_d)

##   Chosen model
model1 <- lm(Price ~ AirAsia + Air_India + GO_FIRST + Indigo + SpiceJet + Days_left + Stops + Duration, data = trainSet)
model1
summary(model1)


# View the summary of the model to get the coefficients
summary(model_a)
summary(model_b)
summary(model_c)
summary(model_d)




# Use the resid function to obtain the residuals of Model 1
Residuals <- resid(model1)

#Use the plot function to plot Residuals against time and then use the 
#abline function to insert a line at the x-axis. Enter:
plot(Residuals ~ trainSet$Price, xlab="t", ylab="e")
abline(h=0)





## Model2: k-fold Cross validation, k =4
# Cross Validation
Tdata1<- m1Data[48614:194453,] 
Vdata1<- m1Data[1:48613,] 

Tdata2 <- m1Data[c(1:48613,97227:194453), ] 
Vdata2 <- m1Data[48614:97226,] 

Tdata3 <- m1Data[c(1:97226,145840:194453), ] 
Vdata3 <- m1Data[97227:145839,] 

Tdata4 <- m1Data[1:145839,] 
Vdata4 <- m1Data[145840:194453,] 

# Experiment 1
model_2a <- lm(Price ~ AirAsia + Air_India + GO_FIRST + Indigo + SpiceJet + Days_left + Stops + Duration, data = Tdata1)
model_2a
summary(model_2a)

# Exprement 1 Results
predicted_value <- predict(model_2a, Vdata1)
accuracy(predicted_value, Vdata1$Price)

# Experiment 2
model_2b <- lm(Price ~ AirAsia + Air_India + GO_FIRST + Indigo + SpiceJet + Days_left + Stops + Duration, data = Tdata2)
model_2b
summary(model_2b)

# Exprement 2 Results
predicted_value <- predict(model_2b, Vdata2)
accuracy(predicted_value, Vdata2$Price)

# Experiment 3
model_2c <- lm(Price ~ AirAsia + Air_India + GO_FIRST + Indigo + SpiceJet + Days_left + Stops + Duration, data = Tdata3)
model_2c
summary(model_2c)

# Exprement 3 Results
predicted_value <- predict(model_2c, Vdata3)
accuracy(predicted_value, Vdata3$Price)

# Experiment 4
model_2d <- lm(Price ~ AirAsia + Air_India + GO_FIRST + Indigo + SpiceJet + Days_left + Stops + Duration, data = Tdata4)
model_2d
summary(model_2d)

# Exprement 4 Results
predicted_value <- predict(model_2d, Vdata4)
accuracy(predicted_value, Vdata4$Price)


## Model 3: Using Regression Tree

### The departure time wasn't found to be statistically significant on our previous model,
# We will drop that variable in the model 2 analysis.
m2tData <- trainSet[, c("Price", "Duration", "Days_left", "Stops", "AirAsia", "Air_India", "GO_FIRST", "Indigo", "SpiceJet")] 
m2tData

m2vData <- validationSet[, c("Price", "Duration", "Days_left", "Stops", "AirAsia", "Air_India", "GO_FIRST", "Indigo", "SpiceJet")] 
m2vData

# We create the default tree first
default_tree <- rpart(Price ~., data = m2tData, method = "anova") 
summary(default_tree) 

# Plot the Tree
prp(default_tree, type = 1, extra = 1, under = TRUE) 
printcp(default_tree)

# Growing the Full Tree
# Due to the number of the variables and the complexity of the data, R couldn't run with a cp = 0, so we chose a 
# minimum cp = 0.00009
set.seed(1) 
full_tree <- rpart(Price ~ ., data = m2tData, method = "anova", cp = 0.00009, minsplit = 2, minbucket = 1) 

prp(full_tree, type = 1, extra = 1, under = TRUE) 

printcp(full_tree)
summary(full_tree) 

# Pruning The Tree to the best pruned Tree
# we have found the Tree 104 to have the minimum error of 0.33878, with a cp = 0.000105892, std = 0.0035265.
# We found the minimum best pruned (withing 1 std) to have a cp = 0.000224152. We will use this cp value to prune to the Tree

pruned_tree <- prune(full_tree, cp= 0.000224154) 

prp(pruned_tree, type = 1, extra = 1, under = TRUE) 
printcp(pruned_tree)
summary(pruned_tree) 

# Results: We will use our validation set to test our best model, model_d.
predicted_value <- predict(model1, validationSet)





# We use accuracy() function to evaluate the model with the parameters such as ME, RMSE, MAE, MPE, MAPE
accuracy(predicted_value, validationSet$Price)




#  What type of decision making model(s) is appropriate for the decision‐making tasks?
# with linear regression model performed above, we can see that "model_d" shows better R2...(to be completed.)

# c. Provide rationale for choice of model(s)
# d. Detail model development and output.


##  7)    Models Evaluation 
#m Model 1: Regression model with partition method
predicted_value <- predict(model1, validationSet)
accuracy(predicted_value, validationSet$Price)


# Model 2: Model 2: Regression model using k-fold cross validation method
# the average of the 4 performance metrics will be used.

# Experiment 1
predicted_value <- predict(model_2a, Vdata1)
accuracy(predicted_value, Vdata1$Price)

# Experiment 2
predicted_value <- predict(model_2b, Vdata2)
accuracy(predicted_value, Vdata2$Price)

# Experiemtn 3
predicted_value <- predict(model_2c, Vdata3)
accuracy(predicted_value, Vdata3$Price)

# Experiemtn 4
predicted_value <- predict(model_2d, Vdata4)
accuracy(predicted_value, Vdata4$Price)




## Model 3: Regression Tree Model.
# We will use our validation set to test the pruned model
predicted_value <- predict(pruned_tree, m2vData) 
accuracy(predicted_value, m2vData$Price)



