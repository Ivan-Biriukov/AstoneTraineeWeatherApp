import Foundation

struct FiveDaysForecastModel: Codable {
    let list: [List]
    let city: City
}

struct City: Codable {
    let id: Int
    let name: String
    let coord: Coord
    let country: String
    let population, timezone, sunrise, sunset: Int
}

struct List: Codable {
    let dt: Int // Time of data forecasted, unix, UTC
    let main: MainClass
    let weather: [Weather]
    let clouds: Clouds
    let wind: Wind
    let visibility: Int // Average visibility, metres
    let pop: Double // Probability of precipitation, values between 0 = 0% and 1 = 100%
    let rain: Rain?
    let sys: Sys // Part of the day (n - night, d - day)
    let dtTxt: String // Time of data forecasted, ISO, UTC
}

struct MainClass: Codable {
    let temp, feelsLike, tempMin, tempMax: Double
    let pressure, seaLevel, grndLevel, humidity: Int
    let tempKf: Double
}

struct Rain: Codable {
    let the3H: Double // Rain or Snow volume for last 3 hours, mm
}

struct Clouds: Codable {
    let all: Int // Cloudiness, %
}

enum MainEnum {
    case clear
    case clouds
    case rain
}

enum Description {
    case brokenClouds
    case clearSky
    case fewClouds
    case lightRain
    case overcastClouds
    case scatteredClouds
}
