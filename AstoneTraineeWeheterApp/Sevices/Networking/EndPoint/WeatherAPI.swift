import Foundation
import CryptoKit

enum NetworkEnvironment {
    case WeatherV2point5
}

enum WeatherAPI {
    case getWeatherByCityName(city: String)
    case getWeatherByLonLat(lon: Double, lat: Double)
    case getFiveDayForecastByLonLat(lon: Double, lat: Double)
    case getFiveDaysForecastByCityName(city: String)
}

extension WeatherAPI: EndPointType {
    
    var apiKey: String {
        return "48c416dce3eb3c49c52da05f47b1c033"
    }
    
    var environmentBaseUrl: String {
        switch NetworkManager.environment {
        case .WeatherV2point5:
            return "https://api.openweathermap.org/data/2.5/"
        }
    }
    
    var baseUrl: URL {
        guard let url = URL(string: environmentBaseUrl) else { fatalError("Unknown base URL") }
        return url
    }
    
    var path: String {
        switch self {
        case .getWeatherByCityName:
            return "weather"
        case .getWeatherByLonLat:
            return "weather"
        case .getFiveDayForecastByLonLat:
            return "forecast"
        case .getFiveDaysForecastByCityName:
            return "forecast"
        }
    }
    
    var httpMethod: HTTPMethod {
        switch self {
        case .getWeatherByCityName:
            return .get
        case .getWeatherByLonLat:
            return .get
        case .getFiveDayForecastByLonLat:
            return .get
        case .getFiveDaysForecastByCityName:
            return .get
        }
    }
    
    var task: HTTPTask {
        switch self {
        case .getWeatherByCityName(city: let city), .getFiveDaysForecastByCityName(city: let city):
            return .request(
                bodyParam: nil,
                urlParam: ["q" : city, "units" : "metric", "appid" : apiKey, "lang": "en_ru"]
            )
            
        case .getWeatherByLonLat(lon: let lon, lat: let lat),
                .getFiveDayForecastByLonLat(lon: let lon, lat: let lat):
            return .request(
                bodyParam: nil,
                urlParam: ["lat" : "\(lat)", "lon" : "\(lon)", "units" : "metric", "appid" : apiKey, "lang": "en_ru"]
            )
        }
    }
    
    var header: HTTPHeader? {
        return nil
    }

}
