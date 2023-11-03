import UIKit.UIColor

extension UIColor {
    
    convenience init(components red: CGFloat, green: CGFloat, blue: CGFloat, alpha: CGFloat) {
        let const: CGFloat = 255.0
        self.init(red: red / const, green: green / const, blue: blue / const, alpha: alpha)
    }
    
    convenience init(rgb: UInt) {
        self.init(
            red: CGFloat((rgb & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgb & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(rgb & 0x0000FF) / 255.0,
            alpha: CGFloat(1.0)
        )
    }
}
