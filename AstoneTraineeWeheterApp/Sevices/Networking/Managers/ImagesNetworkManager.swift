import Foundation

enum ImagesNetworkResponse: String {
    case success
    case badRequest = "Bad Request"
    case failed
    case noData
}

protocol ImagesNetworkManagerProtocol {
    func fetchRandomImage(q: String, completion: @escaping (Result<Data, Error>) -> Void)
}

final class ImagesNetworkManager {
    static let environment: ImagesNetworkEnvironment = .ImagesV1
    private let router = Router<ImagesAPI>()
}

extension ImagesNetworkManager: ImagesNetworkManagerProtocol {
    func fetchRandomImage(q: String, completion: @escaping (Result<Data, Error>) -> Void) {
        router.request(.getRandomImage(ofcity: q)) { data, response, error in
            guard error == nil, let data else {
                completion(.failure(error!))
                return
            }
            completion(.success(data))
        }
    }
}
