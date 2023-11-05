import UIKit.UIImage

final class MainViewModel {
    
    var currentSearch = Dynamic(SearchCellViewModel(cityName: "", dayTemp: 0, nightTepm: 0, wetherConditionImage: UIImage(systemName: "plus")!, currentTemp: 0, action: {}))
    
    
    
    func searchButtonPressed(with text: String) {
        currentSearch.value = SearchCellViewModel(cityName: text, dayTemp: 01, nightTepm: 02, wetherConditionImage: UIImage(systemName: "plus")!, currentTemp: 09, action: {print("123")})
    }
    
}
