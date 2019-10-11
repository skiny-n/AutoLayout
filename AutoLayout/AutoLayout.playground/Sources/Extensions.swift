import Foundation
import UIKit

public extension BaseView {
    
    static func colored(to color: UIColor) -> BaseView {
        let v = BaseView()
        v.backgroundColor = color
        v.cornerRadius = 8
        return v
    }
    
}

public extension UIColor {
    
    
    convenience init(red: Int, green: Int, blue: Int) {
        self.init(red: CGFloat(red)/255.0, green: CGFloat(green)/255.0, blue: CGFloat(blue)/255.0, alpha: 1.0)
    }
    
    static let color1: UIColor = .init(red: 239, green: 61, blue: 89)
    static let color2: UIColor = .init(red: 225, green: 122, blue: 71)
    static let color3: UIColor = .init(red: 239, green: 201, blue: 88)
    static let color4: UIColor = .init(red: 74, green: 177, blue: 157)
    static let color5: UIColor = .init(red: 52, green: 78, blue: 92)
    
}
