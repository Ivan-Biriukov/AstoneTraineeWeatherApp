// MARK: - Imports
import UIKit
import SnapKit
import CoreLocation

// MARK: - MainViewController
final class MainViewController: BaseViewController {
    
    // MARK: - Properties
    var coordinator: AppCoordinator?
    var viewModel: MainViewModel?
    private let locationManager = CLLocationManager()
    private var recentsLocations : [SearchCellViewModel] = []
    
    // MARK: - UI Elements
    private lazy var searchField: UITextField = {
        let field = UITextField()
        field.delegate = self
        field.layer.backgroundColor = UIColor(white: 1, alpha: 0.5).cgColor
        field.layer.cornerRadius = 12
        field.setLeftPaddingPoints(20)
        field.placeholder = "Search for weather at..."
        field.returnKeyType = .search
        field.keyboardType = .alphabet
        field.autocorrectionType = .no
        let searchButton: UIButton = {
            let btn = UIButton(type: .system)
            btn.setImage(UIImage(systemName: "magnifyingglass"), for: .normal)
            btn.tintColor = .systemRed
            btn.addTarget(self, action: #selector(searchButtonTaped), for: .touchUpInside)
            return btn
        }()
        
        let separateView: UIView = {
            let view = UIView()
            view.widthAnchor.constraint(equalToConstant: 20).isActive = true
            return view
        }()
        
        field.rightView = createStackView(for: searchButton, separateView, axis: .horizontal, spacing: 0, distribution: .fill, alignment: .center)
        field.rightViewMode = .always
        field.clearButtonMode = .never
        field.addTarget(self, action: #selector(didChangeText), for: .editingChanged)
        return field
    }()
    
    private lazy var weahterForCurrentLocationTitle: UILabel = {
        return createLabel(text: "Get current location weather", font: .poppinsMedium(of: 16), textColor: .systemRed, alignment: .left, numbersOfRows: 1)
    }()
    
    private lazy var weatherLocationButton: UIButton = {
        let btn = UIButton()
        btn.setImage(.Main.currentLocation, for: .normal)
        btn.addTarget(self, action: #selector(getLocationWeatherTaped), for: .touchUpInside)
        return btn
    }()
    
    private lazy var locationStack: UIStackView = {
        return createStackView(for: weahterForCurrentLocationTitle, weatherLocationButton , axis: .horizontal, spacing: 0, distribution: .equalSpacing, alignment: .center)
    }()
    
    private lazy var searchHistoryLabel: UILabel = {
        return createLabel(text: "Last searched", font: .poppinsSemiBold(of: 40), textColor: .systemBackground, alignment: .center, numbersOfRows: 1)
    }()
    
    private lazy var searchResultsCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.itemSize = CGSize(width: UIScreen.main.bounds.width - 54, height: 100)
        let collection = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collection.backgroundColor = .clear
        collection.dataSource = self
        collection.register(SearchResultCollectionViewCell.self, forCellWithReuseIdentifier: SearchResultCollectionViewCell.identifier)
        collection.showsVerticalScrollIndicator = false
        collection.showsHorizontalScrollIndicator = false
        return collection
    }()

    // MARK: - Life Cycle Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addSubviews()
        setupConstraints()
        bindViewModel()
        setupDelegates()
        recentsLocations = viewModel?.loadSavedData() ?? []
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        locationManager.requestWhenInUseAuthorization()
    }
}

// MARK: - Configure

private extension MainViewController {
    
    func addSubviews() {
        addSubviews(views: searchField, locationStack, searchHistoryLabel, searchResultsCollectionView)
    }
    
    func setupConstraints() {
        searchField.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).inset(50)
            make.height.equalTo(50)
            make.leading.trailing.equalToSuperview().inset(25)
        }
        
        locationStack.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(25)
            make.top.equalTo(searchField.snp.bottom).offset(25)
        }
        
        searchHistoryLabel.snp.makeConstraints { make in
            make.top.equalTo(locationStack.snp.bottom).offset(40)
            make.leading.trailing.equalToSuperview().inset(40)
        }
        
        weatherLocationButton.snp.makeConstraints { make in
            make.height.width.equalTo(40)
        }
        
        searchResultsCollectionView.snp.makeConstraints { make in
            make.top.equalTo(searchHistoryLabel.snp.bottom).offset(25)
            make.leading.trailing.equalToSuperview()
            make.bottom.equalTo(view.safeAreaLayoutGuide)
        }
    }
    
    func makeWeatherSearchRequest() {
        viewModel?.searchButtonPressed(with: searchField.text!)
    }
    
    func setupDelegates() {
        viewModel?.delegate = self
        locationManager.delegate = self
    }
}

// MARK: - Methods
private extension MainViewController {
    
    @objc func searchButtonTaped() {
        makeWeatherSearchRequest()
    }
    
    @objc func didChangeText(_ sender: UITextField) {
        let textWithoutDot = sender.text?.replacingOccurrences(of: ".", with: " ", options: .literal, range: nil)
        sender.text = textWithoutDot
    }
    
    @objc func getLocationWeatherTaped() {
        locationManager.requestLocation()
    }
}

// MARK: - UITextFieldDelegate
extension MainViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.endEditing(true)
        textField.resignFirstResponder()
        makeWeatherSearchRequest()
        return true
    }
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        textField.text = ""
        return true
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if textField == searchField {
            let allowedCharacters = CharacterSet(charactersIn: "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ- ")
            let characterSet = CharacterSet(charactersIn: string)
            return allowedCharacters.isSuperset(of: characterSet)
        }
        return true
    }
}

// MARK: - UICollectionViewDataSource
extension MainViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return recentsLocations.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SearchResultCollectionViewCell.identifier, for: indexPath) as? SearchResultCollectionViewCell else {
            return UICollectionViewCell()
        }
        
        let currentCell = recentsLocations[indexPath.row]
        cell.delegate = self
        cell.fill(viewModel: currentCell)
        return cell
    }
}

// MARK: - ViewModel Bindings
private extension MainViewController {
    func bindViewModel() {
        viewModel?.currentDayWeather.bind({ searchResult in
            self.recentsLocations.append(searchResult)
            DispatchQueue.main.async { [unowned self] in
                self.searchResultsCollectionView.reloadData()
            }
        })
        
        viewModel?.isPosibleToNavigate.bind({ posible in
            if posible {
                DispatchQueue.main.async { [unowned self] in
                    var tempText = self.searchField.text!
                    while tempText.last == " " {
                        tempText.removeLast()
                    }
                    if tempText.last != " " {
                        self.coordinator?.showResultVC(with: tempText)
                    }
                }
            }
        })
        
        viewModel?.isPosibleToNavigateByLocation.bind({ resultInfo in
            if resultInfo.isPosible {
                DispatchQueue.main.async { [unowned self] in
                    self.coordinator?.showResultVC(with: resultInfo.cityName)
                }
            }
        })
    }
}

// MARK: - MainViewModelDelegate
extension MainViewController: MainViewModelDelegate {
    func showErrorAlert(_ message: String) {
        DispatchQueue.main.async { [weak self] in
            let alertController = UIAlertController(title: "Weather Search Error", message: message + " " + "Please, change search request and try aghain!", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "Got It!", style: .default, handler: nil)
            alertController.addAction(okAction)
            self?.present(alertController, animated: true, completion: nil)
        }
    }
}

// MARK: - CLLocationManagerDelegate
extension MainViewController: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.last {
            let lat = location.coordinate.latitude
            let lon = location.coordinate.longitude
            viewModel?.locationButtonPressed(lon: lon, lat: lat)
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error.localizedDescription)
    }
}

// MARK: - BaseSwipeCollectionViewCellDelegate
extension MainViewController: BaseSwipeCollectionViewCellDelegate {
    
    func visibleContainerViewTapped(inCell cell: UICollectionViewCell) {
        guard let indexPath = searchResultsCollectionView.indexPath(for: cell) else { return }
        let searchedLocation = recentsLocations[indexPath.row].cityName
        coordinator?.showResultVC(with: searchedLocation)
    }
    
    func hiddenContainerViewTapped(inCell cell: UICollectionViewCell) {
        guard let indexPath = searchResultsCollectionView.indexPath(for: cell) else { return }
        recentsLocations.remove(at: indexPath.item)
        searchResultsCollectionView.reloadData()
    }
}
