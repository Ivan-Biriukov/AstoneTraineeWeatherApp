// MARK: - Imports

import UIKit
import SnapKit

// MARK: - BaseViewController

class BaseViewController: UIViewController {
    
    // MARK: - UI Elements
    
    lazy var backgroundImageView: UIImageView = {
        let image = UIImageView()
        image.image = .Common.baackground
        image.clipsToBounds = true
        return image
    }()
    
    // MARK: - Life Cycle Methods

    override func viewDidLoad() {
        super.viewDidLoad()
        addBackground()
        hideKeyboardWhenTappedAround()
    }
    
    // MARK: - Configure Methods
    
    private func addBackground() {
        view.addSubview(backgroundImageView)
        backgroundImageView.snp.makeConstraints { make in
            make.top.leading.trailing.bottom.equalToSuperview()
        }
    }
    
    func addSubviews(views: UIView...) {
        views.forEach({ view.addSubview($0) })
    }
    
    func createStackView(
        for views: UIView..., axis: NSLayoutConstraint.Axis,
        spacing: CGFloat,
        distribution: UIStackView.Distribution,
        alignment: UIStackView.Alignment
    ) -> UIStackView {
        let stack = UIStackView(arrangedSubviews: views)
        stack.axis = axis
        stack.spacing = spacing
        stack.distribution = distribution
        stack.alignment = alignment
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }
    
    func createLabel(
        text: String, font: UIFont, textColor: UIColor,
        alignment: NSTextAlignment, numbersOfRows : Int
    ) -> UILabel {
        let label = UILabel()
        label.text = text
        label.font = font
        label.textColor = textColor
        label.textAlignment = alignment
        label.numberOfLines = numbersOfRows
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }
    
    func createTitleButton(title: String, titleColor: UIColor, font: UIFont, backgroundColor: UIColor, cornerRadius: CGFloat) -> UIButton {
        let button = UIButton(type: .system)
        button.setTitle(title, for: .normal)
        button.setTitleColor(titleColor, for: .normal)
        button.backgroundColor = backgroundColor
        button.layer.cornerRadius = cornerRadius
        button.titleLabel?.font = font
        return button
    }
    
    func hideKeyboardWhenTappedAround() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(hideKeyboard))
        tapGesture.cancelsTouchesInView = false
        view.addGestureRecognizer(tapGesture)
    }
    
    // MARK: - Methods
    @objc private func hideKeyboard() {
        view.endEditing(true)
    }
}

