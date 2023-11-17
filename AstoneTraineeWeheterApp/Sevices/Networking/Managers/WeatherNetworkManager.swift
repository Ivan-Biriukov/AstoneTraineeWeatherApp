import Foundation

enum NetworkResponse: String {
    case success
    case badRequest = "Bad Request"
    case failed
    case noData
}

protocol WeatherNetworkManagerProtocol {
    func fetchCurrentWeatherByCityName(cityName: String, completion: @escaping (Result<Data, Error>) -> Void)
    func fetchCurrentWeatherByLonLat(lon: Double, lat: Double, completion: @escaping (Result<Data, Error>) -> Void)
    func fetchWeatherForecastByCitiName(cityName: String, completion: @escaping (Result<Data, Error>) -> Void)
    func fetchWeatherForecastByLonLat(lon: Double, lat: Double, completion: @escaping (Result<Data, Error>) -> Void)
}

final class WeatherNetworkManager {
    static let environment: WeatherNetworkEnvironment = .WeatherV2point5
    private let router = Router<WeatherAPI>()
}

extension WeatherNetworkManager: WeatherNetworkManagerProtocol {
    
    func fetchWeatherForecastByLonLat(lon: Double, lat: Double, completion: @escaping (Result<Data, Error>) -> Void) {
        router.request(.getFiveDayForecastByLonLat(lon: lon, lat: lat)) { data, response, error in
            guard error == nil, let data else {
                completion(.failure(error!))
                return
            }
            completion(.success(data))
        }
    }
    
    func fetchWeatherForecastByCitiName(cityName: String, completion: @escaping (Result<Data, Error>) -> Void) {
        router.request(.getFiveDaysForecastByCityName(city: cityName)) { data, response, error in
            guard error == nil, let data else {
                completion(.failure(error!))
                return
            }
            completion(.success(data))
        }
    }
    
    func fetchCurrentWeatherByLonLat(lon: Double, lat: Double, completion: @escaping (Result<Data, Error>) -> Void) {
        router.request(.getWeatherByLonLat(lon: lon, lat: lat)) { data, response, error in
            guard error == nil, let data else {
                completion(.failure(error!))
                return
            }
            completion(.success(data))
        }
    }
    
    func fetchCurrentWeatherByCityName(cityName: String, completion: @escaping (Result<Data, Error>) -> Void) {
        router.request(.getWeatherByCityName(city: cityName)) { data, response, error in
            guard error == nil, let data else {
                completion(.failure(error!))
                return
            }
            completion(.success(data))
        }        
    }
}

