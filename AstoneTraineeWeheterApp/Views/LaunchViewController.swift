import UIKit
import SnapKit

class LaunchViewController: BaseViewController {
    
    // MARK: - Propertyes
    
    // MARK: - UI Elements
    
    private lazy var weatherTitleLabel: UILabel = {
        return createLabel(text: "Weather", font: .poppinsBold(of: 54), textColor: .white, alignment: .center, numbersOfRows: 1)
    }()
    
    private lazy var forecastTitleLabel: UILabel = {
        return createLabel(text: "ForeCasts", font: .poppinsSemiBold(of: 54), textColor: .init(rgb: 0xDDB130), alignment: .center, numbersOfRows: 1)
    }()
    
    private lazy var cloudImageView: UIImageView = {
        let image = UIImageView(image: .Launch.clouds)
        image.contentMode = .scaleAspectFit
        
        return image
    }()
    
    private let weatherConditionImageView: UIImageView = {
        let image = UIImageView(image: .Launch.weatherCondition)
        image.contentMode = .scaleAspectFit
        image.alpha = 0
        
        return image
    }()
    
    private lazy var nextStepButton: UIButton = {
        let button = createTitleButton(title: "Get Started", titleColor: .systemBackground, font: .poppinsBold(of: 28), backgroundColor: .init(rgb: 0xDDB130), cornerRadius: 36)
        button.addTarget(self, action: #selector(nextButtonTaped), for: .touchUpInside)
        button.alpha = 0
        
        return button
    }()
    
    
    // MARK: - LifeCYcle Methods

    override func viewDidLoad() {
        super.viewDidLoad()
        addSubviews()
        setupConstraints()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        launchAnimation()
    }
}

// MARK: - Configure

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
        
        weatherConditionImageView.snp.makeConstraints { make in
            make.height.width.equalTo(150)
            make.centerY.equalToSuperview()
            make.centerX.equalToSuperview().inset(40)
        }
        
        nextStepButton.snp.makeConstraints { make in
            make.height.equalTo(72)
            make.leading.trailing.equalToSuperview().inset(62)
            make.bottom.equalTo(view.safeAreaLayoutGuide).inset(20)
        }
    }
    
    func launchAnimation() {
        UIView.animate(withDuration: 5, animations: {
            self.weatherConditionImageView.alpha = 1
            
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
        
    }
}

