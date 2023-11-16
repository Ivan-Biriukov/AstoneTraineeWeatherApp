// MARK: - Imports

import UIKit
import SnapKit

// MARK: - MainViewController

final class MainViewController: BaseViewController {
    
    // MARK: - Properties
    
    var coordinator: AppCoordinator?
    var viewModel: MainViewModel?
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
    
    private lazy var searchHistoryLabel: UILabel = {
        return createLabel(text: "Last searched", font: .poppinsSemiBold(of: 40), textColor: .systemBackground, alignment: .center, numbersOfRows: 1)
    }()
    
    private lazy var searchResultsCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.itemSize = CGSize(width: UIScreen.main.bounds.width - 54, height: 100)
        let collection = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collection.backgroundColor = .clear
        collection.delegate = self
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
    }
}

// MARK: - Configure

private extension MainViewController {
    
    func addSubviews() {
        addSubviews(views: searchField, searchHistoryLabel, searchResultsCollectionView)
    }
    
    func setupConstraints() {
        searchField.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).inset(50)
            make.height.equalTo(50)
            make.leading.trailing.equalToSuperview().inset(25)
        }
        
        searchHistoryLabel.snp.makeConstraints { make in
            make.top.equalTo(searchField.snp.bottom).offset(40)
            make.leading.trailing.equalToSuperview().inset(40)
        }
        
        searchResultsCollectionView.snp.makeConstraints { make in
            make.top.equalTo(searchHistoryLabel.snp.bottom).offset(25)
            make.leading.trailing.equalToSuperview()
            make.bottom.equalTo(view.safeAreaLayoutGuide)
        }
    }
    
    func makeWeatherSearchRequest() {
        viewModel?.delegate = self
        viewModel?.searchButtonPressed(with: searchField.text!)
    }
}

// MARK: - Methods
//TODO: -Добавить переход после поиска
private extension MainViewController {
    
    @objc func searchButtonTaped() {
        makeWeatherSearchRequest()
    }
    
    @objc func didChangeText(_ sender: UITextField) {
        let textWithoutDot = sender.text?.replacingOccurrences(of: ".", with: " ", options: .literal, range: nil)
        sender.text = textWithoutDot
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
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if textField == searchField {
            let allowedCharacters = CharacterSet(charactersIn: "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ- ")
            let characterSet = CharacterSet(charactersIn: string)
            return allowedCharacters.isSuperset(of: characterSet)
        }
        return true
    }
}

// MARK: - UICollectionViewDelegate

extension MainViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let searchedLocation = recentsLocations[indexPath.row].cityName
        coordinator?.showResultVC(with: searchedLocation)
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
                    self.coordinator?.showResultVC(with: self.searchField.text!)
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
