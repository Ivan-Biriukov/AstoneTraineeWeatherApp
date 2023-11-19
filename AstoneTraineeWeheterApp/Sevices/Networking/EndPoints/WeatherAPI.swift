// MARK: - Imports
import Foundation

enum WeatherNetworkEnvironment {
    case WeatherV2point5
}

// MARK: - WeatherAPI
enum WeatherAPI {
    case getWeatherByCityName(city: String)
    case getWeatherByLonLat(lon: Double, lat: Double)
    case getFiveDayForecastByLonLat(lon: Double, lat: Double)
    case getFiveDaysForecastByCityName(city: String)
}

// MARK: - Accepting EndPointType to WeatherAPI
extension WeatherAPI: EndPointType {
    
    // MARK: - Properties
    var apiKey: String {
        var key: String = ""
        
        guard let path = Bundle.main.path(forResource: "APIKeysList", ofType: "plist") else {
            fatalError("APIKeysList.plist not found")
        }
        
        guard let plistData = FileManager.default.contents(atPath: path) else {
            fatalError("Unable to read APIKeysList.plist")
        }
        
        var format = PropertyListSerialization.PropertyListFormat.xml
        
        do {
            let plist = try PropertyListSerialization.propertyList(from: plistData, options: .mutableContainersAndLeaves, format: &format) as? [String: Any]
            
            guard let apiKey = plist?["OpenWeatherMapAPIKey"] as? String else {
                fatalError("OpenWeatherMapAPIKey not found in APIKeysList.plist")
            }
            
            key = apiKey
        } catch {
            fatalError("Error reading APIKeysList.plist: \(error)")
        }
        
        return key
    }
    
    var environmentBaseUrl: String {
        switch WeatherNetworkManager.environment {
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
        case .getWeatherByCityName,
                .getWeatherByLonLat:
            return "weather"
        case .getFiveDayForecastByLonLat,
                .getFiveDaysForecastByCityName:
            return "forecast"
        }
    }
    
    var httpMethod: HTTPMethod {
        switch self {
        case .getWeatherByCityName,
                .getWeatherByLonLat,
                .getFiveDayForecastByLonLat,
                .getFiveDaysForecastByCityName:
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
