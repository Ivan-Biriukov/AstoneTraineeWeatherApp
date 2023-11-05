import UIKit.UIImage

struct SearchCellViewModel {
    let cityName: String
    let dayTemp: Int
    let nightTepm: Int
    let wetherConditionImage: UIImage
    let currentTemp: Int
    let action: () -> ()
}
