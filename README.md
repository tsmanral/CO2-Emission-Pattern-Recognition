<h1 align="center"> CO2 Emission Pattern Recognition: Interactive Analysis and Graphical Visualization </h1>

<p align="center">
<a href="https://tsmanral.github.io/" target="_blank"><img alt="Website" src="https://img.shields.io/badge/-Portfolio-informational"></a>
<a href="https://twitter.com/tribhuwan50" target="_blank"><img alt="Twitter" src="https://img.shields.io/twitter/follow/tribhuwan50.svg?style=social&label=Follow"></a>
<a href="https://www.linkedin.com/in/tribhuwan-singh-9411a175/" target="_blank"><img alt="LinkedIn" src="https://img.shields.io/badge/-Connect-blue?style=flat&logo=linkedin"></a>
<a href="https://github.com/tsmanral" target="_blank"><img alt="Github" src="https://img.shields.io/github/followers/tsmanral.svg?style=social"></a>
</p>


Climatic changes and global warming is a defining issue at this time. With these emerging problems, many cities are moving towards a cleaner goal - carbon neutrality. 

The project involves two main components we considered necessary for this study. The first part of this study revolves around doing interactive analysis and inferring properties of the world from carbon emission data. However, the second part of this study focuses more on applying Deep learning concepts to those aspects in order to get some insightful
information and patterns.
A defining part of our data is to use feature engineering to better represent the underlying problem. The purpose of this step is to develop a foundation and explore features for
Interactive Data Visualization. This includes tidying data, creating function/algorithms, and data processing using R libraries.

The second part of our project focuses on developing a structure to identify the CO2 emission pattern recognition on featured data. In order to implement this concept, we plan
to make use of Deep Learning principles in our knowledge base. We will be identifying different patterns by utilizing different algorithms like Feedforward Neural Network , Simple Recurrent Neural Network, and LSTM Recurrent Neural Network. The better optimal solution will be selected from the most effective recognition algorithm and will be
visualized on our web application along with other graphical visualizations.


The project applies deep learning methodologies. 

In total, three different models are created: Feedforward Neural Network , Simple Recurrent Neural Network, and LSTM Recurrent Neural Network. The performance accuracies of the training and test sets are compared for all six models. The models are built using open-source deep learning frameworks namely, Tensorflow and Keras.


Recurrent Neural Networks outperforms the Feedforward Neural network. Moreover, the final Simple RNN model has significantly lower MSE scores compared to LSTM model and Feed Forward model.

### Dataset Details
The data we used comes from two different publications made available by PANGAEA and ACS Publications. In particular dataset contains the following data:

● This dataset presents information from three sources - CDP (187 cities, few in developing countries), the Bonn Center for Local Climate Action and Reporting (73 cities, mainly in developing countries), and data collected by Peking University (83 cities in China).

● We have taken this data set to visualize the over all world Co2 emission in 2014 in which united states stood in top 10 countries.

● This has drawn us to focus more on the United States Co2 emissions and define its patterns using different Supervised Algorithms.

● The second dataset tells us about the demand for energy, transportation, food, goods, and services that were used to derive average household carbon footprints (HCF) for U.S. zip codes, cities, counties, and metropolitan areas.


### Results

Metrics for models trained:

| Model     | Training MSE      | Training MAE  | Testing MSE         | Testing MAE |
|-----------|-------------------|---------------|---------------------|-------------|
| FNN       | 0.0004752876      | 0.01630895    | 0.0004054813        | 0.01647654  |
| RNN       | 0.0002532685      | 0.01403717    | 0.0002513804        | 0.01404257  |
| RNN(LSTM) | 0.0002906162      | 0.01455674    | 0.0002513804        | 0.01404257  |


All accuracy and Loss graphs can be found in the **Accuracy_and_Loss_graphs** folder.

**Note:** This project was created as my Spring 2020 project during my MS degree at Northeastern University. The Demo Shiny App can be found here: [ShinyApp](https://charita-madduri.shinyapps.io/myapp/).
