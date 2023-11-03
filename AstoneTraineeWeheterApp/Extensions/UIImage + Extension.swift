import UIKit.UIImage

extension UIImage {
    
    struct Common {
        static var baackground: UIImage? {
            return UIImage(named: "background")
        }
    }
    
    struct Launch {
        static var clouds: UIImage? {
            return UIImage(named: "Cloud")
        }
        
        static var weatherCondition: UIImage? {
            return UIImage(named: "weatherCondition")
        }
    }
}
