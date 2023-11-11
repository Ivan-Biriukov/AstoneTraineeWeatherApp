import Foundation

final class ResultViewModel {
    
    // MARK: - Propertyes
    
    let weatherNetwork : NetworkManagerProtocol = NetworkManager()
    
    var currentDayWeather = Dynamic(ResultCurrentLocationModel(cityName: "", minTemp: 0, maxTemp: 0, wetherConditionImageID: "", currentTemp: 0, weatherConditionName: "", sunrise: "", sunset: ""))
    
    var fiveDaysWeatherForecast = Dynamic([ForecastCollectionViewModel(tempValue: Int(), weatherConditionIconId: String(), timeValue: String(), fullWeatherInformation: nil)])
    
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
                    
                    let maxTemp = weather.main.temp_max
                    let minTemp = weather.main.temp_min
                    let currentTemp = weather.main.temp
                    
                    let sunrise = self?.transformUnixDateToTimeString(with: weather.sys.sunrise ?? 0)
                    let sunset = self?.transformUnixDateToTimeString(with: weather.sys.sunset ?? 0)
            
                    self?.currentDayWeather.value = .init(cityName: weather.name, minTemp: Int(minTemp.rounded(.toNearestOrAwayFromZero)), maxTemp: Int(maxTemp.rounded(.toNearestOrAwayFromZero)), wetherConditionImageID: weather.weather[0].icon, currentTemp: Int(currentTemp.rounded(.toNearestOrAwayFromZero)), weatherConditionName: weather.weather[0].weatherDescription ?? weather.weather[0].main, sunrise: sunrise ?? "?", sunset: sunset ?? "?")
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
                        weatherForecasts.append(ForecastCollectionViewModel(tempValue: Int(day.main.temp.rounded(.toNearestOrAwayFromZero)), weatherConditionIconId: day.weather[0].icon, timeValue: day.dt_txt, fullWeatherInformation: day))
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
    
    func transformUnixDateToTimeString(with unixTimeStamp: Int) -> String {
        let timestamp = unixTimeStamp
        let date = Date(timeIntervalSince1970: TimeInterval(timestamp))
        
        let dateFormatter2 = DateFormatter()
        dateFormatter2.dateFormat = "HH:mm"
        let timeString = dateFormatter2.string(from: date)
        
        return timeString
    }
}
