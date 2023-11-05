import Foundation
import CryptoKit

enum NetworkEnvironment {
    case PocastsV1
}

enum WeatherAPI {
    case getTrendingsCategoryes(safe: Bool)
    case getResultFromSelectedTrending(categoryName: String, resultsCount: Int)
    case getPodcastsByFeedID(id: Int)
    case getSearched(q: String, max: Int)
    case getEpisodDetail(id: String, resultsCount: Int)
}

extension WeatherAPI: EndPointType {
    
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
        switch NetworkManager.environment {
        case .PocastsV1:
            return "https://api.podcastindex.org/api/1.0/"
        }
    }
    
    var baseUrl: URL {
        guard let url = URL(string: environmentBaseUrl) else { fatalError("Unknown base URL") }
        return url
    }
    
    var path: String {
        switch self {
        case .getTrendingsCategoryes:
            return "categories/list"
        case .getResultFromSelectedTrending:
            return "search/bytitle"
        case .getPodcastsByFeedID:
            return "podcasts/byfeedid"
        case .getSearched:
            return "search/byterm"
        case .getEpisodDetail:
            return "episodes/byfeedid"
        }
    }
    
    var httpMethod: HTTPMethod {
        switch self {
        case .getTrendingsCategoryes:
            return .get
        case .getResultFromSelectedTrending:
            return .get
        case .getPodcastsByFeedID:
            return .get
        case .getSearched:
            return .get
        case .getEpisodDetail:
            return .get
        }
    }
    
    var task: HTTPTask {
        switch self {
        case .getTrendingsCategoryes(safe: let safe):
            return .request(
                bodyParam: nil,
                urlParam: ["pretty" : "\(safe)"]
            )
            
        case .getResultFromSelectedTrending(categoryName: let categoryName, resultsCount: let resultsCount):
            return .request(
                bodyParam: nil,
                urlParam: ["q" : categoryName , "max": "\(resultsCount)"]
            )
        case .getPodcastsByFeedID(id: let id):
            return .request(
                bodyParam: nil,
                urlParam: ["id" : "\(id)"]
            )
        case .getSearched(q: let q, max: let max):
            return .request(
                bodyParam: nil,
                urlParam: ["q" : q, "max" : "\(max)"]
            )
        case .getEpisodDetail(id: let id, resultsCount: let resultsCount):
            return .request(
                bodyParam: nil,
                urlParam: ["id" : id, "max" : "\(resultsCount)"]
            )
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
