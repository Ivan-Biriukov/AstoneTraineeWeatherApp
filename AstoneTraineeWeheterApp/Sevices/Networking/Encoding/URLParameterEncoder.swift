import Foundation

struct URLParameterEncoder: ParameterEncoder {
    static func encode(urlRequest: inout URLRequest, with parameters: Parameters) throws {
        guard let url = urlRequest.url else { throw NetworkError.badUrl }
        
        if var urlComponents = URLComponents(url: url, resolvingAgainstBaseURL: false),
           !parameters.isEmpty {
            urlComponents.queryItems = [URLQueryItem]()
            parameters.forEach({
                let queryItem = URLQueryItem(
                    name: $0,
                    value: "\($1)".addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)
                )
                urlComponents.queryItems?.append(queryItem)
            })
            urlRequest.url = urlComponents.url
        }
    }
}
