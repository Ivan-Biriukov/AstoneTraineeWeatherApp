import UIKit.UIImage

final class MainViewModel {
    
    // MARK: - Propertyes
    
    let weatherNetwork : NetworkManagerProtocol = NetworkManager()
    var currentDayWeather = Dynamic(SearchCellViewModel(cityName: "", dayTemp: 0, nightTepm: 0, wetherConditionImageID: "", currentTemp: 0, action: {}))
    var fiveDaysWeatherForecast = Dynamic(ForecastCollectionViewModel(tempValue: Int(), weatherConditionIconId: String(), timeValue: String()))
    
    // MARK: - Methods
    
    func searchButtonPressed(with text: String) {
        weatherNetwork.fetchCurrentWeatherByCityName(cityName: text) { result in
            switch result {
            case .success(let data):
                do {
                    let weather = try JSONDecoder().decode(CurrentWeatherModel.self, from: data)
                    
                    let dayTemp = weather.main.temp_max
                    let nightTemp = weather.main.temp_min
                    
                    self.currentDayWeather.value = SearchCellViewModel(cityName: weather.name, dayTemp: Int(dayTemp.rounded(.toNearestOrAwayFromZero)), nightTepm: Int(nightTemp.rounded(.toNearestOrAwayFromZero)), wetherConditionImageID: weather.weather.first!.icon, currentTemp: Int(weather.main.temp.rounded(.toNearestOrAwayFromZero)), action: {})
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
