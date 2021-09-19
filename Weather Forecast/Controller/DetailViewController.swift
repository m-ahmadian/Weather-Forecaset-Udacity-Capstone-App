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
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var cityNameLabel: UILabel!
    @IBOutlet weak var cityHighDegreeLabel: UILabel!
    @IBOutlet weak var degreeLabel: UILabel!
    @IBOutlet weak var cityLowDegreeLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var humidityLabel: UILabel!
    @IBOutlet weak var humidityDegreeLabel: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var tempLabel: UILabel!
    @IBOutlet weak var tempDegreeLabel: UILabel!

    // MARK: - View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()

        // Set the view title with the corresponding city name
        self.title = city.name

        // Call Weather API to get the selected city weather response to set its humidity and temperature attributes
        Service.taskForGETRequest(url: Service.Endpoints.getCityWeather(city.name ?? "").url, response: CityWeatherResponse.self, completion: handleCityWeatherResponse(response:error:))
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        activityIndicator.startAnimating()
        updateBackgroundImage()
    }

    // MARK: - Helper Method - Completion Handler
    func handleCityWeatherResponse(response: Decodable?, error: Error?) {
        guard let response = response as? CityWeatherResponse else {
            print(error?.localizedDescription ?? "")
            return
        }
        DispatchQueue.main.async {
            self.configureCityDetails(response: response)
            self.activityIndicator.stopAnimating()
        }
    }

    func configureCityDetails(response: CityWeatherResponse) {
        self.humidityDegreeLabel.text = "\(String(describing: response.main.humidity))%"
        self.tempDegreeLabel.text = "\(String(describing: Int(response.main.temp))) ℃"
        self.cityNameLabel.text = response.name
        self.descriptionLabel.text = response.weather[0].description
        self.degreeLabel.text = "\(String(response.main.temp)) ℃"
        self.cityHighDegreeLabel.text = "\(String(response.main.tempMax)) ℃"
        self.cityLowDegreeLabel.text = "\(String(response.main.tempMin)) ℃"
        let icon = response.weather[0].icon
        self.updateImageView(cityIcon: icon)
    }

    func updateImageView(cityIcon: String) {
        Service.downloadImage(urlString: "http://openweathermap.org/img/w/\(cityIcon).png") { image, error in
            guard error == nil else {
                return
            }
            self.imageView.image = image
        }
    }

    func updateBackgroundImage() {
        let hour = Calendar.current.component(.hour, from: Date())

        switch hour {
        case 6..<17 :
            view.backgroundColor = UIColor(patternImage: UIImage(named: "Light Mode Sky")!)
            currentTimeIs(day: true)
        case 17..<24 :
            view.backgroundColor = UIColor(patternImage: UIImage(named: "Dark Mode Sky")!)
            currentTimeIs(day: false)
        default:
            view.backgroundColor = UIColor(patternImage: UIImage(named: "Dark Mode Sky")!)
            currentTimeIs(day: false)
        }
    }

    func currentTimeIs(day: Bool) {
        switch day {
        case true:
            cityNameLabel.textColor = .black
            cityHighDegreeLabel.textColor = .black
            degreeLabel.textColor = .black
            cityLowDegreeLabel.textColor = .black
            descriptionLabel.textColor = .black
            humidityLabel.textColor = .black
            humidityDegreeLabel.textColor = .black
            tempLabel.textColor = .black
            tempDegreeLabel.textColor = .black
        case false:
            cityNameLabel.textColor = .white
            cityHighDegreeLabel.textColor = .white
            degreeLabel.textColor = .white
            cityLowDegreeLabel.textColor = .white
            descriptionLabel.textColor = .white
            humidityLabel.textColor = .white
            humidityDegreeLabel.textColor = .white
            tempLabel.textColor = .white
            tempDegreeLabel.textColor = .white
        }
    }
    
}
