import Foundation
import CryptoKit

enum ImagesNetworkEnvironment {
    case ImagesV1
}

enum ImagesAPI {
    case getRandomImage(ofCity: String)
}

extension ImagesAPI: EndPointType {
    
    var apiSecretsKey: String {
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
            
            guard let apiKey = plist?["UnsplashAPIAccesKey"] as? String else {
                fatalError("UnsplashAPIAccesKey not found in APIKeysList.plist")
            }
            
            key = apiKey
        } catch {
            fatalError("Error reading APIKeysList.plist: \(error)")
        }
        return key
    }
    
    var environmentBaseUrl: String {
        switch ImagesNetworkManager.environment {
        case .ImagesV1:
            return "https://api.unsplash.com/"
        }
    }
    
    var baseUrl: URL {
        guard let url = URL(string: environmentBaseUrl) else { fatalError("Unknown base URL") }
        return url
    }
    
    var path: String {
        switch self {
        case .getRandomImage:
            return "search/photos"
        }
    }
    
    var httpMethod: HTTPMethod {
        switch self {
        case .getRandomImage:
            return .get
        }
    }
    
    var task: HTTPTask {
        switch self {
        case .getRandomImage(ofCity: let city):
            return .request(
                bodyParam: nil,
                urlParam: ["client_id" : "\(apiSecretsKey)", "query" : "\(city)"]
            )
        }
    }
    
    var header: HTTPHeader? {
        return nil
    }
}
