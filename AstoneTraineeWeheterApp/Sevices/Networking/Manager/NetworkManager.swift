import Foundation

enum NetworkResponse: String {
    case success
    case badRequest = "Bad Request"
    case failed
    case noData
}

protocol NetworkManagerProtocol {
    func fetchCurrentWeatherByCityName(cityName: String, completion: @escaping (Result<Data, Error>) -> Void)
    
}

final class NetworkManager {
    static let environment: NetworkEnvironment = .WeatherV2point5
    private let router = Router<WeatherAPI>()
}

extension NetworkManager: NetworkManagerProtocol {
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

