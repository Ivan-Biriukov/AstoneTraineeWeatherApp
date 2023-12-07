// MARK: - Imports
import Foundation

public typealias HTTPHeader = [String: String]

// MARK: - HTTPTask
enum HTTPTask {
    case request(bodyParam: Parameters? = nil, urlParam: Parameters? = nil)
}
