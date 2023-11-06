import Foundation

enum NetworkError: String, Error {
    case paramNil = "Параметры нил"
    case encodingError = "Ошибка enoder"
    case badUrl = "URL is nil"
}
