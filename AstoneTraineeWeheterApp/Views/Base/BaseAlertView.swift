// MARK: - Imports

import UIKit
import SnapKit

// MARK: - BaseAlertView

final class BaseAlertView {
    
    // MARK: - Properties
    
    struct Constants {
        static let backgroundAlpha: CGFloat = 0.8
    }
    
    static let shared = BaseAlertView()
    private var myTargetView: UIView?
    private var myCloseButton: UIButton?
    private var targetViewController: UIViewController?
    
    // MARK: - UI Elements
    
    private let backgroundView: UIView = {
        let view = UIView()
        view.backgroundColor = .black
        view.alpha = 0
        return view
    }()
    
    private let alertView: UIView = {
        let view = UIView()
        view.backgroundColor = .init(white: 1, alpha: 0.8)
        view.layer.cornerRadius = 20
        view.layer.borderColor = UIColor.systemBlue.cgColor
        view.layer.borderWidth = 1
        return view
    }()
    
   private let dateLabel: UILabel = {
        let lb = UILabel()
        lb.font = .poppinsSemiBold(of: 16)
        lb.textAlignment = .center
        lb.textColor = .systemBackground
        return lb
    }()
    
    private let predictionTempIcon: UIImageView = {
        let icon = UIImageView(image: .Alert.predictTemp)
        icon.contentMode = .scaleToFill
        return icon
    }()
    
   private let predictibleTempLabel: UILabel = {
        let lb = UILabel()
        lb.font = .poppinsRegular(of: 14)
        lb.textAlignment = .center
        lb.textColor = .systemBackground
        return lb
    }()
    
    private let predictionStack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.distribution = .fill
        stack.spacing = 15
        stack.alignment = .center
        return stack
    }()
    
    private let feelsTempIcon: UIImageView = {
        let icon = UIImageView(image: .Alert.feelsTemp)
        icon.contentMode = .scaleToFill
        return icon
    }()
    
    private let feelsLikeTempLabel: UILabel = {
        let lb = UILabel()
        lb.font = .poppinsRegular(of: 14)
        lb.textAlignment = .center
        lb.textColor = .systemBackground
        return lb
    }()
    
    private let feelsLikeStack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.distribution = .fill
        stack.spacing = 15
        stack.alignment = .center
        return stack
    }()
    
    private let pressureIcon: UIImageView = {
        let icon = UIImageView(image: .Alert.airPressure)
        icon.contentMode = .scaleToFill
        return icon
    }()
    
    private let pressureLabel: UILabel = {
        let lb = UILabel()
        lb.font = .poppinsRegular(of: 14)
        lb.textAlignment = .center
        lb.textColor = .systemBackground
        return lb
    }()
    
    private let pressureStack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.distribution = .fill
        stack.spacing = 15
        stack.alignment = .center
        return stack
    }()
    
    private let humidityIcon: UIImageView = {
        let icon = UIImageView(image: .Alert.humidity)
        icon.contentMode = .scaleToFill
        return icon
    }()
    
    private let humidityLabel: UILabel = {
        let lb = UILabel()
        lb.font = .poppinsRegular(of: 14)
        lb.textAlignment = .center
        lb.textColor = .systemBackground
        return lb
    }()
    
    private let humidityStack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.distribution = .fill
        stack.spacing = 15
        stack.alignment = .center
        return stack
    }()
    
    private let windSpeedIcon: UIImageView = {
        let icon = UIImageView(image: .Alert.windSpeed)
        icon.contentMode = .scaleToFill
        return icon
    }()
    
    private let windSpeedLabel: UILabel = {
        let lb = UILabel()
        lb.font = .poppinsRegular(of: 14)
        lb.textAlignment = .center
        lb.textColor = .systemBackground
        return lb
    }()
    
    private let windSpeedStack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.distribution = .fill
        stack.spacing = 15
        stack.alignment = .center
        return stack
    }()
    
    private let windDirectionIcon: UIImageView = {
        let icon = UIImageView(image: .Alert.windDirection)
        icon.contentMode = .scaleToFill
        return icon
    }()
    
    private let windDirectionLabel: UILabel = {
        let lb = UILabel()
        lb.font = .poppinsRegular(of: 14)
        lb.textAlignment = .center
        lb.textColor = .systemBackground
        return lb
    }()
    
    private let windDirectionStack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.distribution = .fill
        stack.spacing = 15
        stack.alignment = .center
        return stack
    }()
    
    private let alertViewContentStack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.distribution = .fill
        stack.alignment = .leading
        stack.spacing = 10
        return stack
    }()
    
    // MARK: - Methods
    
    func showFullWeatherAlert(with data: List, on vc: UIViewController) {
        guard let targetView = vc.view else {
            return
        }
        
        targetViewController = vc
        myTargetView = targetView
        
        backgroundView.frame = targetView.bounds
        targetView.addSubview(backgroundView)
        
        alertView.frame = CGRect(origin: CGPoint(x: 40, y: -300), size: CGSize(width: targetView.frame.width - 60, height: 300))
        targetView.addSubview(alertView)
        
        [predictionTempIcon, feelsTempIcon, pressureIcon, humidityIcon, windSpeedIcon, windDirectionIcon].forEach({$0.snp.makeConstraints { make in
            make.height.width.equalTo(30)
        }})
        
        [predictionTempIcon, predictibleTempLabel].forEach({predictionStack.addArrangedSubview($0)})
        [feelsTempIcon, feelsLikeTempLabel].forEach({feelsLikeStack.addArrangedSubview($0)})
        [pressureIcon, pressureLabel].forEach({pressureStack.addArrangedSubview($0)})
        [humidityIcon, humidityLabel].forEach({humidityStack.addArrangedSubview($0)})
        [windSpeedIcon, windSpeedLabel].forEach({windSpeedStack.addArrangedSubview($0)})
        [windDirectionIcon, windDirectionLabel].forEach({windDirectionStack.addArrangedSubview($0)})
        
        dateLabel.text = data.dt_txt
        predictibleTempLabel.text = "Prediction temperature: \(Int(data.main.temp.rounded(.toNearestOrAwayFromZero)))°"
        feelsLikeTempLabel.text = "Feels like: \(Int(data.main.feels_like.rounded(.toNearestOrAwayFromZero)))°"
        pressureLabel.text = "Pressure: \(data.main.pressure) mm"
        humidityLabel.text = "Humidity: \(data.main.humidity) %"
        windSpeedLabel.text = "Wind speed: \(data.wind.speed) m/s."
        windDirectionLabel.text = "Wind derection: \(windDirectionStringFromDegrees(data.wind.deg))"
        [predictionStack, feelsLikeStack, pressureStack, humidityStack, windSpeedStack, windDirectionStack].forEach({alertViewContentStack.addArrangedSubview($0)})
        
        [dateLabel, alertViewContentStack].forEach({alertView.addSubview($0)})
        
        dateLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalToSuperview().inset(10)
        }
        
        alertViewContentStack.snp.makeConstraints { make in
            make.top.equalTo(dateLabel.snp.bottom).offset(20)
            make.leading.trailing.equalToSuperview().inset(15)
        }
        
        let dismissButton: UIButton = {
            let btn = UIButton(type: .system)
            btn.setImage(.Alert.closeIcon, for: .normal)
            btn.addTarget(BaseAlertView.shared.self, action: #selector(dismissButtonTaped), for: .touchUpInside)
            return btn
        }()
        myCloseButton = dismissButton
        
        alertView.addSubview(dismissButton)
        dismissButton.snp.makeConstraints { make in
            make.height.width.equalTo(35)
            make.top.equalToSuperview().inset(-10)
            make.trailing.equalToSuperview().inset(-10)
        }
        
        UIView.animate(withDuration: 0.3, animations: {
            self.backgroundView.alpha = Constants.backgroundAlpha
            self.targetViewController?.navigationController?.navigationBar.isUserInteractionEnabled = false
        }, completion: { done in
            if done {
                UIView.animate(withDuration: 0.3, animations: {
                    self.alertView.center = targetView.center
                })
            }
        })
    }
    
    @objc func dismissButtonTaped() {
        guard let targetView = myTargetView, let closeButton = myCloseButton else {
            return
        }
        
        UIView.animate(withDuration: 0.3, animations: {
            self.alertView.frame = CGRect(origin: CGPoint(x: 40, y: targetView.frame.height), size: CGSize(width: targetView.frame.width - 60, height: 300))
        }, completion: { done in
            if done {
                UIView.animate(withDuration: 0.3, animations: {
                    self.backgroundView.alpha = 0
                    self.targetViewController?.navigationController?.navigationBar.isUserInteractionEnabled = true
                }, completion: { done in
                    if done {
                        [self.backgroundView, self.alertView].forEach({$0.removeFromSuperview()})
                        closeButton.removeFromSuperview()
                    }
                })
            }
        })
    }
    
   private func windDirectionStringFromDegrees(_ degrees: Int) -> String {
        switch degrees {
        case 0...22, 338...360:
            return "North"
        case 23...67:
            return "North-East"
        case 68...112:
            return "Eastern"
        case 113...157:
            return "South-East"
        case 158...202:
            return "South"
        case 203...247:
            return "Southwest"
        case 248...292:
            return "West"
        case 293...337:
            return "North-West"
        default:
            return "Unknown direction"
        }
    }
}
