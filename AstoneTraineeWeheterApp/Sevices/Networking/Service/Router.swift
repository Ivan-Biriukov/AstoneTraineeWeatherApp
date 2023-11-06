import Foundation

final class Router<EndPoint: EndPointType>: NetworkRouter {
    
    private var task: URLSessionTask?
    
    func request(_ route: EndPoint, completion: @escaping NetworkRouterCompletion) {
        let session = URLSession.shared
        
        do {
            let request = try self.buildRequest(from: route)
            task = session.dataTask(with: request, completionHandler: { data, response, error in
                completion(data, response, error)
            })
            print(request.cURL(pretty: true))
        } catch {
            completion(nil, nil, error)
        }
        self.task?.resume()
    }
    
    func cancel() {
        self.task?.cancel()
    }
}

fileprivate extension Router {
    func buildRequest(from route: EndPoint) throws -> URLRequest {
        var request = URLRequest(
            url: route.baseUrl.appendingPathComponent(route.path),
            cachePolicy: .reloadIgnoringLocalAndRemoteCacheData,
            timeoutInterval: 10.0
        )
        route.header?.forEach({ request.setValue($1, forHTTPHeaderField: $0) })
        request.httpMethod = route.httpMethod.rawValue
        do {
            switch route.task {
            case .request(bodyParam: let body, urlParam: let urlParam):
                try self.configureParameters(bodyParam: body, urlParam: urlParam, request: &request)
            }
            return request
        } catch {
            throw error
        }
    }
    
    func configureParameters(bodyParam: Parameters?, urlParam: Parameters?,
                             request: inout URLRequest) throws {
        do {
            if let bodyParam {
                try JSONParameterEncoder.encode(urlRequest: &request, with: bodyParam)
            }
            if let urlParam {
                try URLParameterEncoder.encode(urlRequest: &request, with: urlParam)
            }
        } catch {
            throw error
        }
    }
    
//    func addHeader(_ header: HTTPHeader?, request: inout URLRequest) {
//        guard let header else { return }
//        header.forEach({ request.setValue($1, forHTTPHeaderField: $0) })
//    }
}
