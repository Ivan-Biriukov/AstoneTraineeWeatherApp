import Foundation

struct SearchCellViewModel {
    let cityName: String
    let dayTemp: Int
    let nightTepm: Int
    let wetherConditionImageID: String
    let currentTemp: Int
    let action: () -> ()
}
