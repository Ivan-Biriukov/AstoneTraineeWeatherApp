import Foundation
import CryptoKit

enum NetworkEnvironment {
    case WeatherV2point5
}

enum WeatherAPI {
    case getWeatherByCityName(city: String)
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
        }
    }
    
    var httpMethod: HTTPMethod {
        switch self {
        case .getWeatherByCityName:
            return .get
        }
    }
    
    var task: HTTPTask {
        switch self {
        case .getWeatherByCityName(city: let city):
            return .request(
                bodyParam: nil,
                urlParam: ["q" : city, "units" : "metric"]
            )
        }
    }
    
    var header: HTTPHeader? {
        return [
            "appid": apiKey,
            "lang": "ru",
            "units": "metric",
            "version": "2.5"
        ]
    }
}
