 Task 1: Exploratory Data Visualization
This task focuses on visualizing different types of variables in the dataset to understand their distributions and relationships.

1. Histograms
Histograms were generated for numerical variables such as Age and Fare. These plots help identify:
Distribution shape (e.g., skewness)
Frequency of value ranges
Presence of outliers or data gaps

2. Bar Charts
Bar charts were used to visualize categorical variables like Pclass and Sex. This provides:
An easy comparison of category frequencies
Insight into population distribution across classes/genders

3. Scatter Plot
A scatter plot was drawn for Age vs. Fare to observe:
Correlation or trends between two continuous variables
Data clustering or outlier points

4. Violin Plots
Violin plots were created to show the distribution of numerical values across categories:
Age by Sex
Fare by Pclass
These give insight into how numerical variables spread within different groups, combining boxplot-style summaries with density curves.

 Task 2: Feature Selection Techniques
This task aims to evaluate the significance of features with respect to a chosen target variable using statistical and information-theoretic techniques.

1. Pearson Correlation Coefficient
Applied to numeric variables to detect linear relationships.
Useful to eliminate highly correlated features or detect multicollinearity.

2. ANOVA (Analysis of Variance)
Tests the statistical significance of numerical variables across categories.
For instance, checking if Fare significantly differs by Pclass.

3. Chi-Squared Test
Measures dependence between two categorical variables.
Applied to Pclass and Sex to test if their distributions are related.

4. Mutual Information (via FSelectorRcpp)
Quantifies the amount of information shared between the target and predictor variables.
All features were converted to categorical format before MI calculation.
Highlights nonlinear and non-obvious associations that other tests might miss.
