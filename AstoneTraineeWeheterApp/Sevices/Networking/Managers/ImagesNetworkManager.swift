// MARK: - Imports
import Foundation

enum ImagesNetworkResponse: String {
    case success
    case badRequest = "Bad Request"
    case failed
    case noData
}

// MARK: - ImagesNetworkManagerProtocol
protocol ImagesNetworkManagerProtocol {
    func fetchRandomImage(q: String, completion: @escaping (Result<Data, Error>) -> Void)
}

// MARK: - ImagesNetworkManager
final class ImagesNetworkManager {
    static let environment: ImagesNetworkEnvironment = .ImagesV1
    private let router = Router<ImagesAPI>()
}

// MARK: - Accepting ImagesNetworkManagerProtocol
extension ImagesNetworkManager: ImagesNetworkManagerProtocol {
    func fetchRandomImage(q: String, completion: @escaping (Result<Data, Error>) -> Void) {
        router.request(.getRandomImage(ofCity: q)) { data, response, error in
            guard error == nil, let data else {
                completion(.failure(error!))
                return
            }
            completion(.success(data))
        }
    }
}
