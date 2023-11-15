// MARK: - Imports

import UIKit
import SnapKit
import Kingfisher

// MARK: - ResultForecastCollectionViewCell

final class ResultForecastCollectionViewCell: UICollectionViewCell {
    
    // MARK: - Properties
    
    static let identifier = "ResultForecastCollectionCell"
    
    // MARK: - UI ELements
    
    private lazy var tempLabel: UILabel = {
        let lb = UILabel()
        lb.font = .poppinsRegular(of: 20)
        lb.textColor = .black
        lb.textAlignment = .center
        lb.text = "19°"
        return lb
    }()
    
    private let weatherImage: UIImageView = {
        let weather = UIImageView()
        weather.image = UIImage(systemName: "cloud.rain")
        weather.tintColor = .blue
        weather.contentMode = .scaleAspectFill
        return weather
    }()
    
    private lazy var dateLabel: UILabel = {
        let lb = UILabel()
        lb.font = .poppinsRegular(of: 15)
        lb.textColor = .black
        lb.textAlignment = .center
        lb.text = "15.00"
        lb.numberOfLines = 0
        return lb
    }()
    
    private lazy var timeLabel: UILabel = {
        let lb = UILabel()
        lb.font = .poppinsRegular(of: 15)
        lb.textColor = .black
        lb.textAlignment = .center
        lb.text = "15.00"
        lb.numberOfLines = 0
        return lb
    }()
    
    private lazy var contentStack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.distribution = .equalSpacing
        stack.alignment = .center
        return stack
    }()
    
    // MARK: - Init
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubviews()
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Prepare For Reuse
    
    override func prepareForReuse() {
        tempLabel.text = nil
        weatherImage.image = nil
        dateLabel.text = nil
    }
    
    // MARK: - Configure
    
    private func addSubviews() {
        contentView.addSubview(contentStack)
        [tempLabel, weatherImage, dateLabel, timeLabel].forEach({contentStack.addArrangedSubview($0)})
    }
    
    private func configure() {
        contentStack.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.bottom.equalToSuperview()
            make.leading.equalTo(contentView.snp.leading)
            make.trailing.equalTo(contentView.snp.trailing)
        }
        
        weatherImage.snp.makeConstraints { make in
            make.height.width.equalTo(45)
        }
    }
    
    func fill(viewModel: ForecastCollectionViewModel) {
        tempLabel.text = "\(viewModel.tempValue)°"
        weatherImage.kf.indicatorType = .activity
        weatherImage.kf.setImage(with: URL(string: "https://openweathermap.org/img/wn/\(viewModel.weatherConditionIconId)@2x.png"))
        dateLabel.text = transformUnixDateToMonthDayString(with: viewModel.fullWeatherInformation!.dt)
        timeLabel.text = transformUnixDateToTimeString(with: viewModel.fullWeatherInformation!.dt)
    }
}

// MARK: - Data transform Methods

private extension ResultForecastCollectionViewCell {
    func transformUnixDateToMonthDayString(with unixTimeStamp: Int) -> String {
        let timestamp = unixTimeStamp
        let date = Date(timeIntervalSince1970: TimeInterval(timestamp))
        
        let dateFormatter1 = DateFormatter()
        dateFormatter1.dateFormat = "dd MMM"
        let monthDayString = dateFormatter1.string(from: date)
        
        return monthDayString
    }
    
    func transformUnixDateToTimeString(with unixTimeStamp: Int) -> String {
        let timestamp = unixTimeStamp
        let date = Date(timeIntervalSince1970: TimeInterval(timestamp))
        
        let dateFormatter2 = DateFormatter()
        dateFormatter2.dateFormat = "HH:mm"
        let timeString = dateFormatter2.string(from: date)
        
        return timeString
    }
}
