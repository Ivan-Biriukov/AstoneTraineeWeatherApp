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

struct Weather: Codable {
    let id: Int
    let main, icon: String // main - common weather condition description - rain;
    let weatherDescription: String? //  weatherDescription - full weather condition description - light rain
}

struct Main: Codable {
    let temp: Double
    let temp_min, temp_max: Double
    let pressure, humidity, seaLevel, grndLevel: Int?
}

struct Wind: Codable {
    let speed: Double // m/s
    let deg: Int // Wind direction, degrees (meteorological)
    let gust: Double?
}

struct Sys: Codable {
    let id: Int?
    let country: String?
    let sunrise, sunset: Int?
}
