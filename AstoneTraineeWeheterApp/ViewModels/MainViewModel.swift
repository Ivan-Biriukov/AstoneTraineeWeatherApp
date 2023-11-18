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
    var isPosibleToNavigateByLocation = Dynamic((isPosible: false, cityName: ""))
    
    weak var delegate: MainViewModelDelegate?
    
    // MARK: - Methods
    
    func searchButtonPressed(with text: String) {
        getCurrentWeatherByName(for: text)
    }
    
    func locationButtonPressed(lon: Double, lat: Double) {
        getCurrentLocationWeather(lon: lon, lat: lat)
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
                        
                        self?.currentDayWeather.value = SearchCellViewModel(cityName: tempSearchText, dayTemp: Int(dayTemp.rounded(.toNearestOrAwayFromZero)), nightTepm: Int(nightTemp.rounded(.toNearestOrAwayFromZero)), wetherConditionImageID: weather.weather.first!.icon, currentTemp: Int(weather.main.temp.rounded(.toNearestOrAwayFromZero)), action: {})
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
    
    func getCurrentLocationWeather(lon: Double, lat: Double) {
        weatherNetwork.fetchCurrentWeatherByLonLat(lon: lon, lat: lat) { [weak self] result in
            switch result {
            case .success(let data):
                do {
                    let locationWeather = try JSONDecoder().decode(CurrentWeatherModel.self, from: data)
                    
                    let dayTemp = locationWeather.main.temp_max
                    let nightTemp = locationWeather.main.temp_min
                    
                    self?.currentDayWeather.value = SearchCellViewModel(cityName: locationWeather.name, dayTemp: Int(dayTemp.rounded(.toNearestOrAwayFromZero)), nightTepm: Int(nightTemp.rounded(.toNearestOrAwayFromZero)), wetherConditionImageID: locationWeather.weather.first!.icon, currentTemp: Int(locationWeather.main.temp.rounded(.toNearestOrAwayFromZero)), action: {})
                    self?.isPosibleToNavigateByLocation.value = (isPosible: true, cityName: locationWeather.name)
                }
                catch {
                    self?.delegate?.showErrorAlert(error.localizedDescription)
                    self?.isPosibleToNavigateByLocation.value = (isPosible: false, cityName: "")
                }
            case .failure(let error):
                self?.delegate?.showErrorAlert(error.localizedDescription)
                self?.isPosibleToNavigateByLocation.value = (isPosible: false, cityName: "")
            }
        }
    }
}
