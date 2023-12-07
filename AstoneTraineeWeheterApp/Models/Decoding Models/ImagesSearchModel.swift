import Foundation

struct ImagesSearchModel: Decodable {
    let results: [ImagesResult]
}

struct ImagesResult: Decodable {
    let urls: Urls
}

struct Urls: Decodable {
    let full: String
}
