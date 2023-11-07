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
    let sys: Sys // Part of the day (n - night, d - day)
    let dt_txt: String // Time of data forecasted, ISO, UTC
}

struct MainClass: Codable {
    let temp, feels_like, temp_min, temp_max: Double
    let pressure, sea_level, grnd_level, humidity: Int
    let temp_kf: Double
}

struct Clouds: Codable {
    let all: Int // Cloudiness, %
}


