# Weather-Forecast-Udacity-Capstone-App

## Overview
Weather Forecast app allows users to search for cities around the world and add them to their favourite list. By tapping on the city name in table view of their favourite cities, the user would be able to see details of its weather including the temperature, humidity and a short description. Favorite cities will be stored in Core Data. Please see screenshots below for the functionality of the app

<img width="370" alt="Screen Shot 2021-10-17 at 8 25 02 PM" src="https://user-images.githubusercontent.com/56573344/137650805-27eabfcf-d4d5-487d-8c9e-e256b3307fbc.png">
<img width="383" alt="Screen Shot 2021-10-17 at 8 23 53 PM" src="https://user-images.githubusercontent.com/56573344/137650808-89544bea-d2fe-496b-ab76-402993c09f77.png">
<img width="384" alt="Screen Shot 2021-10-17 at 8 26 31 PM" src="https://user-images.githubusercontent.com/56573344/137650821-437949aa-a71f-4db3-9564-df031c89e022.png">

This app was completed as the final project for Udacity course - Become an iOS Developer - and uses fundamental princinples of iOS development such as:
 
• UIKit & Generics\
• URLSessions to interact with a public restful API\
• Network Requests\
• Core Data for local persistence of an object structure

Language: Swift  
Capstone App for: Udacity - Become an iOS Developer

## Implementation
• The main view of the app displays the list of favourite cities previously added. You have the option to delete cities individually by swiping cells to the left, or entirely by tapping on the recycle bin button and finaly add to your favourite cities by tapping on the plus button in the upper right corner. This view uses Core Data and fetchedResultsController for local persistence of an object, being handled in CityDataSource generic file.

• The second view provides the user with search feature for their city of interest. This feature of the app uses Geobytes API to receive city details. Once you have added the searched city to your favourite list, an alert pops up confirming the success of the process and returns to the main view.\
Geobytes API: <https://geobytes.com/>  

• If the user taps on any of their favourite cities, the app segues to the detailViewController where it uses Weather API to retrieve weather temperature, humidity and other details regarding the weather condition.\
Weather API: <https://openweathermap.org/api>

Network errors are being handled using Reachability framework. Reachability is created by Ashley Mills, please visit the following GitHub page for further details: \
<https://github.com/ashleymills/Reachability.swift>

## Contributing
Please feel free to contribute to **Weather-Forecast-Udacity-Capstone-App**. Fork and clone this repository, then make a pull request once you have pushed your changes.

## How to build
This project can run without any additional setup. 

## Requirements
Xcode 10 or above\
Swift 4.2 or above

## Maintainers
m-ahmadian

## License
**Weather Forecast** is available under the [GPL-3.0 License](https://github.com/m-ahmadian/Weather-Forecaset-Udacity-Capstone-App/blob/master/LICENSE).

