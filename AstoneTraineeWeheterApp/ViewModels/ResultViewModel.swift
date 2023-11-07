import Foundation

final class ResultViewModel {
    
    // MARK: - Propertyes
    
    let weatherNetwork : NetworkManagerProtocol = NetworkManager()
    
    var currentDayWeather = Dynamic(SearchCellViewModel(cityName: "", dayTemp: 0, nightTepm: 0, wetherConditionImageID: "", currentTemp: 0, action: {}))
    var fiveDaysWeatherForecast = Dynamic([ForecastCollectionViewModel(tempValue: Int(), weatherConditionIconId: String(), timeValue: String())])
    
    // MARK: - Methods
    
    func getInitialData(city: String) {
        fetchCurrentWeatherByName(cityName: city)
        getForecastWeatherByName(for: city)
    }
}

private extension ResultViewModel {
    
    func fetchCurrentWeatherByName(cityName: String) {
        weatherNetwork.fetchCurrentWeatherByCityName(cityName: cityName) { [weak self] result in
            switch result {
            case .success(let data):
                do {
                    let weather = try JSONDecoder().decode(CurrentWeatherModel.self, from: data)
                    
                    let dayTemp = weather.main.temp_max
                    let nightTemp = weather.main.temp_min
                    
                    self?.currentDayWeather.value = SearchCellViewModel(cityName: weather.name, dayTemp: Int(dayTemp.rounded(.toNearestOrAwayFromZero)), nightTepm: Int(nightTemp.rounded(.toNearestOrAwayFromZero)), wetherConditionImageID: weather.weather.first!.icon, currentTemp: Int(weather.main.temp.rounded(.toNearestOrAwayFromZero)), action: {})
                }
                catch {
                    print(error.localizedDescription)
                }
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    func getForecastWeatherByName(for city: String) {
        
        var weatherForecasts : [ForecastCollectionViewModel] = []
        
        weatherNetwork.fetchWeatherForecastByCitiName(cityName: city) { [weak self] result in
            switch result {
            case .success(let data):
                do {
                    let forecasts = try JSONDecoder().decode(FiveDaysForecastModel.self, from: data)
                    
                    for day in forecasts.list {
                        weatherForecasts.append(ForecastCollectionViewModel(tempValue: Int(day.main.temp.rounded(.toNearestOrAwayFromZero)), weatherConditionIconId: day.weather[0].icon, timeValue: day.dt_txt))
                    }
                    self?.fiveDaysWeatherForecast.value = weatherForecasts
                }
                catch {
                    print(error)
                }
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
}
