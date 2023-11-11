import UIKit
import SnapKit
import Kingfisher

class ResultViewController: BaseViewController {
    
    // MARK: - Propertyes
    
    var coordinator: AppCoordinator?
    var viewModel: ResultViewModel?
    
    private var locationName: String
    private var forecastDataArray : [ForecastCollectionViewModel] = []
        
    // MARK: - UI Elemetns
    
    private lazy var todayBubbleView: UIVisualEffectView = {
        let blureEffect = UIBlurEffect(style: .light)
        let blureView = UIVisualEffectView(effect: blureEffect)
        blureView.layer.cornerRadius = 25
        blureView.clipsToBounds = true
        
        return blureView
    }()
    
    private lazy var locationTitleLabel: UILabel = {
        return createLabel(text: "Alexandria", font: .poppinsBold(of: 28), textColor: .black, alignment: .center, numbersOfRows: 1)
    }()
    
    private lazy var currentTempLabel: UILabel = {
        return createLabel(text: "38°", font: .poppinsBold(of: 40), textColor: .black, alignment: .center, numbersOfRows: 1)
    }()
    
    private let weatherImageView: UIImageView = {
        let weather = UIImageView()
        weather.image = UIImage(systemName: "sun.dust.fill")
        weather.contentMode = .scaleAspectFit
        return weather
    }()
    
    private lazy var currentWeatherConditionStack: UIStackView = {
        return createStackView(for: weatherImageView, currentTempLabel, axis: .horizontal, spacing: 0, distribution: .equalSpacing, alignment: .center)
    }()
    
    private lazy var weatherConditionLabel: UILabel = {
        return createLabel(text: "Clouds", font: .poppinsSemiBold(of: 24), textColor: .black, alignment: .center, numbersOfRows: 1)
    }()
    
    private lazy var minTempLabel: UILabel = {
        return createLabel(text: "Min: 17°", font: .poppinsMedium(of: 24), textColor: .black, alignment: .center, numbersOfRows: 1)
    }()
    
    private lazy var maxTempLabel: UILabel = {
        return createLabel(text: "Max: 27°", font: .poppinsMedium(of: 24), textColor: .black, alignment: .center, numbersOfRows: 1)
    }()
    
    private lazy var minMaxTempStack: UIStackView = {
        return createStackView(for: minTempLabel, maxTempLabel, axis: .horizontal, spacing: 10, distribution: .fill, alignment: .center)
    }()
    
    private let sunRiseIcon: UIImageView = {
        let icon = UIImageView(image: .Alert.sunrise)
        icon.contentMode = .scaleAspectFill
        return icon
    }()
    
    private lazy var sunriseLabel: UILabel = {
        return createLabel(text: "12:12", font: .poppinsRegular(of: 20), textColor: .systemBackground, alignment: .center, numbersOfRows: 1)
    }()
    
    private lazy var sunriseStack: UIStackView = {
        return createStackView(for: sunRiseIcon, sunriseLabel, axis: .horizontal, spacing: 5, distribution: .fill, alignment: .center)
    }()
    
    private let sunsetIcon: UIImageView = {
        let icon = UIImageView(image: .Alert.sunset)
        icon.contentMode = .scaleAspectFill
        return icon
    }()
    
    private lazy var sunsetLabel: UILabel = {
        return createLabel(text: "18;00", font: .poppinsRegular(of: 20), textColor: .systemBackground, alignment: .center, numbersOfRows: 1)
    }()
    
    private lazy var sunsetStack: UIStackView = {
        return createStackView(for: sunsetIcon, sunsetLabel, axis: .horizontal, spacing: 5, distribution: .fill, alignment: .center)
    }()
    
    private lazy var sunConditionStack: UIStackView = {
        return createStackView(for: sunriseStack, sunsetStack, axis: .horizontal, spacing: 0, distribution: .equalSpacing, alignment: .center)
    }()
    
    private lazy var forecastLabel: UILabel = {
        return createLabel(text: "5-Days Forecasts", font: .poppinsBold(of: 25), textColor: .systemBackground, alignment: .left, numbersOfRows: 1)
    }()
    
    private lazy var forecstBubbleView: UIVisualEffectView = {
        let blureEffect = UIBlurEffect(style: .light)
        let blureView = UIVisualEffectView(effect: blureEffect)
        blureView.layer.cornerRadius = 25
        blureView.clipsToBounds = true
        
        return blureView
    }()
    
    private lazy var forecastDayLabel: UILabel = {
        return createLabel(text: "Today", font: .poppinsSemiBold(of: 18), textColor: .black, alignment: .left, numbersOfRows: 1)
    }()
    
    private lazy var forecastDateLabel: UILabel = {
        return createLabel(text: "July, 21", font: .poppinsSemiBold(of: 18), textColor: .black, alignment: .right, numbersOfRows: 1)
    }()
    
    private lazy var forecastTitlesStack: UIStackView = {
        return createStackView(for: forecastDayLabel, forecastDateLabel, axis: .horizontal, spacing: 0, distribution: .equalSpacing, alignment: .center)
    }()
    
    private lazy var underlineView: UIView = {
        let view = UIView()
        view.backgroundColor = .black
        view.alpha = 0.6
        return view
    }()
    
    private lazy var nextForecastsButton: UIButton = {
        let btn = UIButton(type: .system)
        btn.setImage(UIImage(systemName: "chevron.forward.circle"), for: .normal)
        btn.addTarget(self, action: #selector(nextForecastTaped), for: .touchUpInside)
        btn.tintColor = .systemRed
        
        return btn
    }()
    
    private lazy var pervousForecastButton: UIButton = {
        let btn = UIButton(type: .system)
        btn.setImage(UIImage(systemName: "chevron.left.circle"), for: .normal)
        btn.addTarget(self, action: #selector(pervousForecastTaped), for: .touchUpInside)
        btn.tintColor = .systemGray4
        
        return btn
    }()
    
    private lazy var forecastCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.itemSize = CGSize(width: 60, height: 120)
        let collection = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collection.backgroundColor = .clear
        collection.delegate = self
        collection.dataSource = self
        collection.register(ResultForecastCollectionViewCell.self, forCellWithReuseIdentifier: ResultForecastCollectionViewCell.identifier)
        collection.showsVerticalScrollIndicator = false
        collection.showsHorizontalScrollIndicator = false
        
        return collection
    }()
    
    // MARK: - LifeCycle Methods

    override func viewDidLoad() {
        super.viewDidLoad()
        addSubviews()
        setupConstraints()
        bindViewModel()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel?.getInitialData(city: locationName)
    }
    
    // MARK: - Init
    
    init(locationName: String) {
        self.locationName = locationName
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - Buttons Methods

private extension ResultViewController {
    @objc func nextForecastTaped() {
        
    }
    
    @objc func pervousForecastTaped() {
        
    }
}

// MARK: - Configure

private extension ResultViewController {
    
    func addSubviews() {
        addSubviews(views: todayBubbleView, forecastLabel, forecstBubbleView)
        [locationTitleLabel, currentWeatherConditionStack, weatherConditionLabel, minMaxTempStack, sunConditionStack].forEach({todayBubbleView.contentView.addSubview($0)})
        [forecastTitlesStack, underlineView, nextForecastsButton, pervousForecastButton, forecastCollectionView].forEach({forecstBubbleView.contentView.addSubview($0)})
    }
    
    func setupConstraints() {
        todayBubbleView.snp.makeConstraints { make in
            make.width.equalToSuperview().dividedBy(1.5)
            make.height.equalTo(300)
            make.centerX.equalToSuperview()
            make.top.equalTo(view.safeAreaLayoutGuide)
        }
        
        locationTitleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(10)
            make.centerX.equalToSuperview()
        }
        
        currentWeatherConditionStack.snp.makeConstraints { make in
            make.top.equalTo(locationTitleLabel.snp.bottom).offset(25)
            make.leading.trailing.equalToSuperview().inset(30)
        }
        
        weatherConditionLabel.snp.makeConstraints { make in
            make.top.equalTo(currentWeatherConditionStack.snp.bottom).offset(5)
            make.centerX.equalToSuperview()
        }
        
        minMaxTempStack.snp.makeConstraints { make in
            make.top.equalTo(weatherConditionLabel.snp.bottom).offset(10)
            make.centerX.equalToSuperview()
        }
        
        weatherImageView.snp.makeConstraints { make in
            make.height.width.equalTo(75)
        }
        
        forecastLabel.snp.makeConstraints { make in
            make.top.equalTo(todayBubbleView.snp.bottom).offset(40)
            make.leading.equalToSuperview().inset(20)
        }
        
        forecstBubbleView.snp.makeConstraints { make in
            make.top.equalTo(forecastLabel.snp.bottom).offset(20)
            make.height.equalTo(200)
            make.leading.trailing.equalToSuperview().inset(20)
        }
        
        forecastTitlesStack.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(15)
            make.leading.trailing.equalToSuperview().inset(50)
        }
        
        underlineView.snp.makeConstraints { make in
            make.top.equalTo(forecastTitlesStack.snp.bottom).offset(5)
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(2)
        }
        
        pervousForecastButton.snp.makeConstraints { make in
            make.centerY.equalTo(forecastCollectionView.snp.centerY)
            make.leading.equalToSuperview().inset(10)
            make.height.width.equalTo(26)
        }
        
        nextForecastsButton.snp.makeConstraints { make in
            make.centerY.equalTo(forecastCollectionView.snp.centerY)
            make.trailing.equalToSuperview().inset(10)
            make.height.width.equalTo(26)
        }
        
        forecastCollectionView.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(41)
            make.trailing.equalToSuperview().inset(41)
            make.top.equalTo(underlineView.snp.bottom).offset(10)
            make.bottom.equalToSuperview()
        }
        
        sunConditionStack.snp.makeConstraints { make in
            make.top.equalTo(minMaxTempStack.snp.bottom).offset(10)
            make.leading.trailing.equalToSuperview().inset(20)
        }
        
        [sunRiseIcon, sunsetIcon].forEach({$0.snp.makeConstraints { make in
            make.height.width.equalTo(50)
        }})
    }
}

// MARK: - CollectionViewDelegate

extension ResultViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        guard let currentWeatherInfo = forecastDataArray[indexPath.row].fullWeatherInformation else {
            return
        }
        BaseAlertView.shared.showFullWeatherAlert(with: currentWeatherInfo, on: self)
    }
}

// MARK: - CollectionViewDataSource

extension ResultViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        forecastDataArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ResultForecastCollectionViewCell.identifier, for: indexPath) as? ResultForecastCollectionViewCell else {
            return UICollectionViewCell()
        }
        
        let currentCell = forecastDataArray[indexPath.row]
        cell.fill(viewModel: currentCell)

        return cell
    }
}

// MARK: - Bindings ViewModel

private extension ResultViewController {
    func bindViewModel() {
        viewModel?.currentDayWeather.bind({ currentWeather in
            DispatchQueue.main.async { [unowned self] in
                self.locationTitleLabel.text = currentWeather.cityName
                self.currentTempLabel.text = "\(currentWeather.currentTemp)°"
                self.weatherImageView.kf.indicatorType = .activity
                self.weatherImageView.kf.setImage(with: URL(string: "https://openweathermap.org/img/wn/\(currentWeather.wetherConditionImageID)@2x.png"))
                self.weatherConditionLabel.text = currentWeather.weatherConditionName
                self.minTempLabel.text = "Min: \(currentWeather.minTemp)°"
                self.maxTempLabel.text = "Max: \(currentWeather.maxTemp)°"
                self.sunriseLabel.text = currentWeather.sunrise
                self.sunsetLabel.text = currentWeather.sunset
            }
        })
        
        viewModel?.fiveDaysWeatherForecast.bind({ forecastWeather in
            DispatchQueue.main.async { [unowned self] in
                self.forecastDataArray = forecastWeather
                self.forecastCollectionView.reloadData()
            }
        })
    }
}
