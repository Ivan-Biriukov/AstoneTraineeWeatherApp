import UIKit
import SnapKit
import Kingfisher

class SearchResultCollectionViewCell: UICollectionViewCell {
    
    static let identifier = "SearchResultCollectionCell"
    
    // MARK: - UI Elements
    
    private lazy var cityLabel: UILabel = {
        let lb = UILabel()
        lb.font = .poppinsBold(of: 24)
        lb.textColor = .systemBackground
        lb.textAlignment = .left
        
        return lb
    }()
    
    private lazy var dayNightTitleLabel: UILabel = {
        let lb = UILabel()
        lb.font = .poppinsBold(of: 16)
        lb.textColor = .systemBackground
        lb.textAlignment = .left
        lb.text = "day/night"
        return lb
    }()
    
    private lazy var dayNightValueLabel: UILabel = {
        let lb = UILabel()
        lb.font = .poppinsSemiBold(of: 14)
        lb.textColor = .systemBackground
        lb.textAlignment = .center
        
        return lb
    }()
    
    private lazy var dayNightStack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.alignment = .center
        stack.distribution = .fill
        stack.spacing = 10
        return stack
    }()
    
    private lazy var weatherImageView: UIImageView = {
        let weather = UIImageView()
        weather.contentMode = .scaleAspectFit
        return weather
    }()
    
    private lazy var temperatureLabel: UILabel = {
        let lb = UILabel()
        lb.font = .poppinsBold(of: 40)
        lb.textColor = .systemBackground

        return lb
    }()
    
    // MARK: - Init
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        cityLabel.text = nil
        dayNightValueLabel.text = nil
        weatherImageView.image = nil
        temperatureLabel.text = nil
    }
    
    
    // MARK: - Configure
    
    private func configure() {
        contentView.backgroundColor = UIColor.init(white: 1, alpha: 0.5)
        contentView.layer.cornerRadius = 15
        
        [dayNightTitleLabel, dayNightValueLabel].forEach({dayNightStack.addArrangedSubview($0)})
        [cityLabel, dayNightStack, weatherImageView, temperatureLabel].forEach({contentView.addSubview($0)})
        
        cityLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(15)
            make.leading.equalToSuperview().inset(12)
        }
        
        dayNightStack.snp.makeConstraints { make in
            make.top.equalTo(cityLabel.snp.bottom).offset(10)
            make.leading.equalToSuperview().inset(8)
        }
        
        weatherImageView.snp.makeConstraints { make in
            make.height.width.equalTo(75)
            make.centerY.equalToSuperview()
            make.trailing.equalTo(temperatureLabel.snp.leading).inset(-20)
        }
        
        temperatureLabel.snp.makeConstraints { make in
            make.trailing.equalToSuperview().inset(15)
            make.centerY.equalToSuperview()
        }
    }
    
    func fill(viewModel: SearchCellViewModel) {
        cityLabel.text = viewModel.cityName
        dayNightValueLabel.text = "\(viewModel.dayTemp)° / \(viewModel.nightTepm)°"
        weatherImageView.kf.indicatorType = .activity
        weatherImageView.kf.setImage(with: URL(string: "https://openweathermap.org/img/wn/\(viewModel.wetherConditionImageID)@2x.png"))
        temperatureLabel.text = "\(viewModel.currentTemp)°"
    }
    
}
