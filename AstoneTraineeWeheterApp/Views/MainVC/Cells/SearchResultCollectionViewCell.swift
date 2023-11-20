// MARK: - Imports
import UIKit
import SnapKit
import Kingfisher

// MARK: - SearchResultCollectionViewCell
final class SearchResultCollectionViewCell: BaseSwipeCollectionViewCell {
    
    // MARK: - Properties
    static let identifier = "SearchResultCollectionCell"
    
    // MARK: - UI Elements
    private lazy var cityLabel: UILabel = {
        let lb = UILabel()
        lb.font = .poppinsBold(of: 24)
        lb.textColor = .systemBackground
        lb.textAlignment = .left
        return lb
    }()
    
    private lazy var minMaxTitleLabel: UILabel = {
        let lb = UILabel()
        lb.font = .poppinsBold(of: 16)
        lb.textColor = .systemBackground
        lb.textAlignment = .left
        lb.text = "Min/Max"
        return lb
    }()
    
    private lazy var minMaxValueLabel: UILabel = {
        let lb = UILabel()
        lb.font = .poppinsSemiBold(of: 14)
        lb.textColor = .systemBackground
        lb.textAlignment = .center
        return lb
    }()
    
    private lazy var minMaxStack: UIStackView = {
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
    
    let deleteImageView: UIImageView = {
        let image = UIImage(systemName: "trash")?.withRenderingMode(.alwaysTemplate)
        let imageView = UIImageView(image: image)
        imageView.tintColor = .white
        return imageView
    }()
    
    // MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Prepare For Reuse
    override func prepareForReuse() {
        cityLabel.text = nil
        minMaxValueLabel.text = nil
        weatherImageView.image = nil
        temperatureLabel.text = nil
    }
        
    // MARK: - Configure Methods
    private func configure() {
        visibleContainerView.backgroundColor = UIColor.init(white: 1, alpha: 0.5)
        visibleContainerView.layer.cornerRadius = 15
        
        [minMaxTitleLabel, minMaxValueLabel].forEach({minMaxStack.addArrangedSubview($0)})
        [cityLabel, minMaxStack, weatherImageView, temperatureLabel].forEach({visibleContainerView.addSubview($0)})
        
        cityLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(15)
            make.leading.equalToSuperview().inset(12)
        }
        
        minMaxStack.snp.makeConstraints { make in
            make.top.equalTo(cityLabel.snp.bottom).offset(10)
            make.leading.equalToSuperview().inset(8)
        }
        
        weatherImageView.snp.makeConstraints { make in
            make.height.width.equalTo(75)
            make.centerY.equalToSuperview()
            make.trailing.equalToSuperview().inset(UIScreen.main.bounds.width / 4.5)
        }
        
        temperatureLabel.snp.makeConstraints { make in
            make.trailing.equalToSuperview().inset(15)
            make.centerY.equalToSuperview()
        }
        
        hiddenContainerView.backgroundColor = UIColor(red: 231.0 / 255.0, green: 76.0 / 255.0, blue: 60.0 / 255.0, alpha: 1)
        hiddenContainerView.layer.cornerRadius = 15
        
        hiddenContainerView.addSubview(deleteImageView)
        
        deleteImageView.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.height.width.equalTo(45)
        }
    }
    
    func fill(viewModel: SearchCellViewModel) {
        cityLabel.text = viewModel.cityName
        minMaxValueLabel.text = "\(viewModel.dayTemp)° / \(viewModel.nightTepm)°"
        weatherImageView.kf.indicatorType = .activity
        weatherImageView.kf.setImage(with: URL(string: "https://openweathermap.org/img/wn/\(viewModel.wetherConditionImageID)@2x.png"))
        temperatureLabel.text = "\(viewModel.currentTemp)°"
    }
}
