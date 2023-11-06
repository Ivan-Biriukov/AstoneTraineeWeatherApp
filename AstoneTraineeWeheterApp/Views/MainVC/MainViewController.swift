import UIKit
import SnapKit

class MainViewController: BaseViewController {
    
    // MARK: - Propertyes
    
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

    // MARK: - LifeCycle Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addSubviews()
        setupConstraints()
        hideKeyboardWhenTappedAround()
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
}

// MARK: - Buttons Methods

private extension MainViewController {
    @objc func searchButtonTaped() {
        viewModel?.searchButtonPressed(with: searchField.text!)
        bindViewModel()
    }
}

// MARK: - UITextFieldDelegate

extension MainViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.endEditing(true)
        textField.resignFirstResponder()
        
        return true
    }
}

// MARK: - UICollectionViewDelegate

extension MainViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let current = recentsLocations[indexPath.row]
        current.action()
        coordinator?.showResultVC()
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
            DispatchQueue.main.async {
                self.searchResultsCollectionView.reloadData()
            }
        })
    }
}
