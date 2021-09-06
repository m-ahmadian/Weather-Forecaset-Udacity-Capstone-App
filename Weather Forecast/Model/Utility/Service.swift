//
//  Service.swift
//  Weather Forecast
//
//  Created by Mehrdad Ahmadian on 2021-09-06.
//

import Foundation

class Service {
    // Create a shared instance for Singleton design pattern - However, Dependency Injecttion is used for this app
    static let shared = Service()
    private init() {}

    // API Key
    static let apiKey = "f676b945a92af6494be8db095c6567b"

    enum Endpoints {
        static let baseURL = "https://api.openweathermap.org/data/2.5/weather"
        static let apiKeyParam = "&appid=\(apiKey)"

        case getCity(String)
        case getCityWeather(String)

        var stringValue: String {
            switch self {
            case .getCity(let query):
                // Enable adding space in the query by setting addingPercentEncoding to urlQueryAllowed
                return "http://gd.geobytes.com/AutoCompleteCity?callback=?&q=\(query.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? "")"
            case .getCityWeather(let city):
                // Enable adding space in the city name search by setting addingPercentEncoding
                return Endpoints.baseURL + "?q=\(city.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? "")" + "&units=metric" + Endpoints.apiKeyParam
            }
        }

        var url: URL {
            return URL(string: stringValue)!
        }
    }
}
