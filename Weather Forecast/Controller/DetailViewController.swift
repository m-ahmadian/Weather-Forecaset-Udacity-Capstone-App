//
//  DetailViewController.swift
//  Weather Forecast
//
//  Created by Mehrdad Ahmadian on 2021-09-05.
//

import UIKit

class DetailViewController: UIViewController {

    // MARK: - Properties
    var city: City!

    // MARK: - Outlets
    @IBOutlet weak var humidityLabel: UILabel!
    @IBOutlet weak var tempLabel: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Set the view title with the corresponding city name
        self.title = city.name

        // Call Weather API to get the selected city weather response to set its humidity and temperature attributes
        Service.taskForGETRequest(url: Service.Endpoints.getCityWeather(city.name ?? "").url, response: CityWeatherResponse.self, completion: handleCityWeatherResponse(response:error:))
    }

    // MARK: - Helper Method - Completion Handler
    func handleCityWeatherResponse(response: Decodable?, error: Error?) {
        guard let response = response as? CityWeatherResponse else {
            print(error?.localizedDescription ?? "")
            return
        }
        DispatchQueue.main.async {
            self.humidityLabel.text = "\(String(describing: response.main.humidity))"
            self.tempLabel.text = "\(String(describing: Int(response.main.temp)))"
        }
    }

}
