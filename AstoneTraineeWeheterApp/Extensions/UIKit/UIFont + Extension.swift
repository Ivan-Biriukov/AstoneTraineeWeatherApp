import UIKit.UIFont

extension UIFont {
    
    static func poppinsBold(of size: CGFloat) -> UIFont {
        guard let font = UIFont(name: "Poppins-Bold", size: size) else {
            return UIFont.systemFont(ofSize: size, weight: .bold)
        }
        return font
    }
    
    static func poppinsSemiBold(of size: CGFloat) -> UIFont {
        guard let font = UIFont(name: "Poppins-SemiBold", size: size) else {
            return UIFont.systemFont(ofSize: size, weight: .bold)
        }
        return font
    }
    
    static func poppinsMedium(of size: CGFloat) -> UIFont {
        guard let font = UIFont(name: "Poppins-Medium", size: size) else {
            return UIFont.systemFont(ofSize: size, weight: .bold)
        }
        return font
    }
    
    static func poppinsRegular(of size: CGFloat) -> UIFont {
        guard let font = UIFont(name: "Poppins-Regular", size: size) else {
            return UIFont.systemFont(ofSize: size, weight: .bold)
        }
        return font
    }
}
