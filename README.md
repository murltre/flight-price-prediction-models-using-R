# flight-price-prediction models-using-R
A predictive modeling project in R to estimate flight ticket prices using airline, stops, departure time, days left, and duration. Three models (linear regression with train-test split, cross-validation, and regression tree) were built and compared using RMSE, MAE, and other metrics to identify the best-performing approach.





# ✈️ Flight Price Prediction in R

A predictive modeling project to estimate flight ticket prices based on airline, stops, departure time, days left before travel, and flight duration. Three regression-based models were built and compared using performance metrics such as RMSE and MAE to determine the best approach.

---

## Dataset

- Source: [Kaggle Flight Fare Prediction Dataset](https://www.kaggle.com/)
- Size: 300,000+ rows
- Features include:  
  - Airline  
  - Number of stops  
  - Departure time  
  - Class (Economy only)  
  - Duration  
  - Days left before departure  
  - Ticket Price (target variable)

---

##  Data Preparation

- Removed missing values  
- Focused only on *Economy Class* to avoid price distortion from Business Class  
- Grouped departure time into:
  - `Late Night` (0–4 AM)  
  - `Not Late Night`  
- Converted categorical variables to numerical or dummy formats
- Selected variables with the strongest relationship to price:
  - Airline, Stops, Departure Time, Days Left, Duration

---

## Exploratory Analysis

- **Boxplot**: Flights with 1 stop cost more than non-stop flights  
- **Bar Plots**: Morning flights cost more than late-night ones; Vistara is the most expensive airline  
- **Grouped Bar Plot**: Departure time impacts vary across airlines  
- **Heatmap**: Checked for multicollinearity across features

---

## Models

###  Model 1 – Linear Regression (Train/Test Split)
- Split: 70% training, 30% validation (`createDataPartition()` in R)
- Variables added incrementally: Airline → +Days_Left → +Stops → +Departure → +Duration
- Best version (`model_d`) had:
  - Adjusted R²: **0.456**
  - ME: **0.096**
  - RMSE: ~2666

###  Model 2 – Linear Regression (4-Fold Cross Validation)
- Used the same variables as Model 1  
- Averaged coefficients and performance across 4 folds  
- Slightly higher Adjusted R² (**0.457**) but more bias (ME = -2.786)

###  Model 3 – Regression Tree (`rpart`)
- Captured non-linear relationships  
- Best performance in terms of:
  - Lowest **RMSE**, **MAE**, **MAPE**
  - Slight underprediction bias (ME = 8.79)

---

##  Model Comparison

| Model      | Adjusted R² | ME     | RMSE   | MAE   |
|------------|-------------|--------|--------|--------|
| Model 1    | 0.456       | 0.096  | 2666   | —      |
| Model 2    | 0.457       | -2.786 | ~       | —      |
| Model 3    | —           | 8.793  |  |

- **Model 3 (Regression Tree)** was the most accurate, despite minor underprediction bias.
- **Model 1** had the lowest prediction bias and would be preferred over Model 2.

---

##  Insights & Recommendations

- **Days Left**: Strong non-linear influence; sharp price increase around day 14  
- **Stops**: More stops = higher prices  
- **Airlines**: Pricing strategies vary significantly  
- **Duration**: Weak correlation; not a strong predictor  
- **Suggestion**: Book flights at least 16+ days in advance for lower fares

---

##  Tools & Technologies

- R  
- RStudio  
- `caret`, `rpart`, `rpart.plot`  
- ggplot2 for visualization  
- Regression & Tree-based modeling



