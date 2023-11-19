// MARK: - Imports
import UIKit
import SnapKit

// MARK: - Constants
extension LaunchViewController {
    struct Constants {
        
        var weatherConditionWidth: CGFloat {
            return UIScreen.main.bounds.width - 80
        }

        var weatherConditionHeight: CGFloat {
            return 150
        }

        var weatherConditionCenterX: CGFloat {
            return (UIScreen.main.bounds.width - weatherConditionWidth) / 2
        }

        var weatherConditionCenterY: CGFloat {
            return (UIScreen.main.bounds.height - weatherConditionHeight) / 2
        }
    }
}

// MARK: - LaunchViewController
final class LaunchViewController: BaseViewController {
    
    // MARK: - Properties
    private let constants: Constants
    var coordinator: AppCoordinator?
    
    // MARK: - UI Elements
    private lazy var weatherTitleLabel: UILabel = {
        return createLabel(text: "Weather", font: .systemFont(ofSize: 54, weight: .heavy), textColor: .white, alignment: .center, numbersOfRows: 1)
    }()
    
    private lazy var forecastTitleLabel: UILabel = {
        return createLabel(text: "ForeCasts", font: .systemFont(ofSize: 54, weight: .bold), textColor: .init(rgb: 0xDDB130), alignment: .center, numbersOfRows: 1)
    }()
    
    private lazy var cloudImageView: UIImageView = {
        let image = UIImageView(image: .Launch.clouds)
        image.contentMode = .scaleAspectFit
        return image
    }()
    
    private let weatherConditionImageView: UIImageView = {
        let image = UIImageView()
        image.image = .Launch.weatherCondition
        image.contentMode = .scaleAspectFit
        image.alpha = 0
        image.translatesAutoresizingMaskIntoConstraints = false
        return image
    }()
    
    private lazy var nextStepButton: UIButton = {
        let button = createTitleButton(title: "Get Started", titleColor: .systemBackground, font: .poppinsBold(of: 28), backgroundColor: .init(rgb: 0xDDB130), cornerRadius: 36)
        button.addTarget(self, action: #selector(nextButtonTaped), for: .touchUpInside)
        button.alpha = 0
        return button
    }()
    
    // MARK: - Init
    init() {
        self.constants = Constants()
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Life Cycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        addSubviews()
        setupConstraints()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        startWeatherConditionFrame()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        launchAnimation()
    }
}

// MARK: - Private configure
private extension LaunchViewController {
    
    func addSubviews() {
        addSubviews(views: weatherTitleLabel, forecastTitleLabel, weatherConditionImageView, cloudImageView, nextStepButton)
    }
    
    func setupConstraints() {
        weatherTitleLabel.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide)
            make.centerX.equalToSuperview()
        }
        
        forecastTitleLabel.snp.makeConstraints { make in
            make.top.equalTo(weatherTitleLabel.snp.bottom).offset(8)
            make.centerX.equalToSuperview()
        }
        
        cloudImageView.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.leading.trailing.equalToSuperview().inset(40)
            make.height.equalTo(200)
        }
        
        nextStepButton.snp.makeConstraints { make in
            make.height.equalTo(72)
            make.leading.trailing.equalToSuperview().inset(62)
            make.bottom.equalTo(view.safeAreaLayoutGuide).inset(20)
        }
    }
    
    func startWeatherConditionFrame() {
        weatherConditionImageView.frame = CGRect(x: constants.weatherConditionCenterX, y: constants.weatherConditionCenterY, width: constants.weatherConditionWidth, height: constants.weatherConditionHeight)
    }
    
    func launchAnimation() {
        UIView.animate(withDuration: 5, animations: {
            self.weatherConditionImageView.alpha = 1
            self.weatherConditionImageView.frame = CGRect(x: self.constants.weatherConditionCenterX + 60, y: self.constants.weatherConditionCenterY - 60, width: self.constants.weatherConditionWidth, height: self.constants.weatherConditionHeight)
        }, completion: { done in
            if done {
                UIView.animate(withDuration: 2) {
                    self.nextStepButton.alpha = 1
                }
            }
        })
    }
}

// MARK: - Button's Method's
private extension LaunchViewController {
    @objc func nextButtonTaped() {
        coordinator?.showMainVC()
    }
}

