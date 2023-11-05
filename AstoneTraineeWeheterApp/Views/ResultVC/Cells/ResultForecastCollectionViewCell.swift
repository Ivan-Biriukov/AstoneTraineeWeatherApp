import UIKit
import SnapKit

class ResultForecastCollectionViewCell: UICollectionViewCell {
    
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
        weather.contentMode = .scaleToFill
        
        return weather
    }()
    
    private lazy var timeLabel: UILabel = {
        let lb = UILabel()
        lb.font = .poppinsRegular(of: 15)
        lb.textColor = .black
        lb.textAlignment = .center
        lb.text = "15.00"
        
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
    
    override func prepareForReuse() {

    }
    
    // MARK: - Configure
    
    private func addSubviews() {
        contentView.addSubview(contentStack)
        [tempLabel, weatherImage, timeLabel].forEach({contentStack.addArrangedSubview($0)})
    }
    
    private func configure() {
        contentStack.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.bottom.equalToSuperview()
            make.leading.equalTo(contentView.snp.leading).inset(5)
            make.trailing.equalTo(contentView.snp.trailing).inset(5)
        }
        
        weatherImage.snp.makeConstraints { make in
            make.height.width.equalTo(45)
        }
        
    }
}
