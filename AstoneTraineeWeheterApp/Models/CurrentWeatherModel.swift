import Foundation

struct CurrentWeatherModel: Codable {
    let coord: Coord
    let weather: [Weather]
    let main: Main
    let wind: Wind
    let dt: Int
    let sys: Sys
    let id: Int
    let name: String
}

struct Coord: Codable {
    let lon, lat: Double
}

// main - common weather condition description - rain; weatherDescription - full weather condition description - light rain
struct Weather: Codable {
    let id: Int
    let main, icon: String
    let weatherDescription: String?
}

struct Main: Codable {
    let temp, tempMin, tempMax: Double?
    let pressure, humidity, seaLevel, grndLevel: Int?
}

struct Wind: Codable {
    let speed: Double
    let deg: Int
    let gust: Double?
}

struct Sys: Codable {
    let type, id: Int
    let country: String
    let sunrise, sunset: Int
}
