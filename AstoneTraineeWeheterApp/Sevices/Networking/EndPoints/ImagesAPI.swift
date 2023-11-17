import Foundation
import CryptoKit

enum ImagesNetworkEnvironment {
    case ImagesV1
}

enum ImagesAPI {
    case getRandomImage(ofCity: String)
}

extension ImagesAPI: EndPointType {
    
    var apiKey: String {
        return "75GJGPAYJRNUG25FH4LK"
    }
    
    var apiSecret: String {
        return "GLQE8eyrL3^$sxJd7Y6mXb7MJgUKKmN2JhSfcV39"
    }
    
    var apiHeaderTime: Int {
        return Int(Date().timeIntervalSince1970)
    }
    
    var data4Hash : String {
        return apiKey + apiSecret + "\(apiHeaderTime)"
    }
    
    var inputData: Data {
        return Data(data4Hash.utf8)
    }
    
    var hashString: String {
        let hashed = Insecure.SHA1.hash(data: inputData)
        return hashed.compactMap { String(format: "%02x", $0) }.joined()
    }
    
    var environmentBaseUrl: String {
        switch ImagesNetworkManager.environment {
        case .ImagesV1:
            return "https://api.podcastindex.org/api/1.0/"
        }
    }
    
    var baseUrl: URL {
        guard let url = URL(string: environmentBaseUrl) else { fatalError("Unknown base URL") }
        return url
    }
    
    var path: String {
        switch self {
        case .getRandomImage:
            <#code#>
        }
    }
    
    var httpMethod: HTTPMethod {
        switch self {
        case .getRandomImage:
            <#code#>
        }
    }
    
    var task: HTTPTask {
        switch self {
        case .getRandomImage(ofCity: let city):
            <#code#>
        }
    }
    
    var header: HTTPHeader? {
        return [
            "X-Auth-Date": "\(apiHeaderTime)",
            "X-Auth-Key": apiKey,
            "Authorization": hashString,
            "User-Agent": "PodcastApp/1.0"
        ]
    }
}


//Key: 75GJGPAYJRNUG25FH4LK
//Secret: GLQE8eyrL3^$sxJd7Y6mXb7MJgUKKmN2JhSfcV39
