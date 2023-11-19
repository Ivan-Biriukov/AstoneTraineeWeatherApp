// MARK: - Imports
import Foundation

// MARK: - NetworkError
enum NetworkError: String, Error {
    case paramNil = "Параметры нил"
    case encodingError = "Ошибка encoder"
    case badUrl = "URL is nil"
}
