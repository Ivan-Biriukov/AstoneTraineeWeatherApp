// MARK: - Imports
import Foundation

typealias Parameters = [String: Any]

// MARK: - ParameterEncoder
protocol ParameterEncoder {
 static func encode(urlRequest: inout URLRequest, with parameters: Parameters) throws
}
