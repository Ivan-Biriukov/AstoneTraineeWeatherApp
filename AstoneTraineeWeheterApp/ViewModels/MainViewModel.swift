import UIKit.UIImage

final class MainViewModel {
    
    // MARK: - Propertyes
    
    let weatherNetwork : NetworkManagerProtocol = NetworkManager()
    var currentDayWeather = Dynamic(SearchCellViewModel(cityName: "", dayTemp: 0, nightTepm: 0, wetherConditionImage: UIImage(systemName: "plus")!, currentTemp: 0, action: {}))
    var fiveDaysWeatherForecast = Dynamic(ForecastCollectionViewModel(tempValue: Int(), weatherConditionIconId: String(), timeValue: String()))
    
    // MARK: - Methods
    
    func searchButtonPressed(with text: String) {
         getSerchedWeather(for: text)
    }
}

extension MainViewModel {
    func getSerchedWeather(for city: String) {
        weatherNetwork.fetchCurrentWeatherByCityName(cityName: city) { [weak self] result in
            switch result {
            case .success(let data):
                do {
                    let weather = try JSONDecoder().decode(CurrentWeatherModel.self, from: data)
                    
                    guard let dayTemp = weather.main.tempMax else {
                        return
                    }
                    
                    guard let nightTemp = weather.main.tempMin else {
                        return
                    }
                    
                    self?.currentDayWeather.value = SearchCellViewModel(cityName: weather.name, dayTemp: Int(dayTemp.rounded(.toNearestOrAwayFromZero)), nightTepm: Int(nightTemp.rounded(.toNearestOrAwayFromZero)), wetherConditionImage: UIImage(systemName: "plus")!, currentTemp: Int(weather.main.temp.rounded(.toNearestOrAwayFromZero)), action: {})
                }
                catch {
                    print(error.localizedDescription)
                }
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
}
