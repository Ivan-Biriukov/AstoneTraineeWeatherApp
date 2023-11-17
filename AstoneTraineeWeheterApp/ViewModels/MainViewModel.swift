// MARK: - Imports

import Foundation

// MARK: - MainViewModelDelegate

protocol MainViewModelDelegate: AnyObject {
    func showErrorAlert(_ message: String)
}

// MARK: - MainViewModel

final class MainViewModel {
    
    // MARK: - Propertyes
    
    let weatherNetwork : WeatherNetworkManagerProtocol = WeatherNetworkManager()
    var currentDayWeather = Dynamic(SearchCellViewModel(cityName: "", dayTemp: 0, nightTepm: 0, wetherConditionImageID: "", currentTemp: 0, action: {}))
    var isPosibleToNavigate = Dynamic(false)
    
    weak var delegate: MainViewModelDelegate?
    
    // MARK: - Methods
    
    func searchButtonPressed(with text: String) {
        getCurrentWeatherByName(for: text)
    }
}

// MARK: - Functionality Methods Extension

private extension MainViewModel {
    func getCurrentWeatherByName(for city: String) {
        var tempSearchText = city
        
        while tempSearchText.last == " " {
            tempSearchText.removeLast()
        }
        
        if tempSearchText.last != " " {
            weatherNetwork.fetchCurrentWeatherByCityName(cityName: tempSearchText) { [weak self] result in
                switch result {
                case .success(let data):
                    do {
                        let weather = try JSONDecoder().decode(CurrentWeatherModel.self, from: data)
                        
                        let dayTemp = weather.main.temp_max
                        let nightTemp = weather.main.temp_min
                        
                        self?.currentDayWeather.value = SearchCellViewModel(cityName: weather.name, dayTemp: Int(dayTemp.rounded(.toNearestOrAwayFromZero)), nightTepm: Int(nightTemp.rounded(.toNearestOrAwayFromZero)), wetherConditionImageID: weather.weather.first!.icon, currentTemp: Int(weather.main.temp.rounded(.toNearestOrAwayFromZero)), action: {})
                        self?.isPosibleToNavigate.value = true
                    }
                    catch {
                        self?.delegate?.showErrorAlert(error.localizedDescription)
                        self?.isPosibleToNavigate.value = false
                    }
                case .failure(let error):
                    self?.delegate?.showErrorAlert(error.localizedDescription)
                    self?.isPosibleToNavigate.value = false
                }
            }
        }
    }
}
