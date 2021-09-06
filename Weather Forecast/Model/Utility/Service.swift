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

    // A GET request class fnc with generics and discardableResult attribute for the return type if it's not beiing used
    @discardableResult class func taskForGETRequest<ResponseType: Decodable>(url: URL, response: ResponseType.Type, completion: @escaping (ResponseType?, Error?) -> Void) -> URLSessionTask {

        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data else {
                DispatchQueue.main.async {
                    completion(nil, error)
                }
                return
            }
            let decoder = JSONDecoder()
            do {
                let response = try decoder.decode(ResponseType.self, from: data)
                DispatchQueue.main.async {
                    completion(response, nil)
                }
            } catch {
                DispatchQueue.main.async {
                    completion(nil, error)
                }
            }
        }
        task.resume()
        return task
    }
}
