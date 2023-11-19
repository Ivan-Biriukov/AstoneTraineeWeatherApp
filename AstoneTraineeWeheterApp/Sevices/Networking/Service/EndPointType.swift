// MARK: - Imports
import Foundation

// MARK: - EndPointType
protocol EndPointType {
    var baseUrl: URL { get }
    var path: String { get }
    var httpMethod: HTTPMethod { get }
    var task: HTTPTask { get }
    var header: HTTPHeader? { get }
}
