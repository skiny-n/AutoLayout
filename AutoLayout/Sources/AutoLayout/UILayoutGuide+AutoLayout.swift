//
//  UILayoutGuide+AutoLayout.swift
//  AutoLayout
//
//  Created by Stanislav Novacek on 02/10/2019.
//

import Foundation
import UIKit

extension UILayoutGuide: AnchorProviding {
    
    /// Ensure that this layout guide already has an owner before using this helper.
    public var autoLayout: AutoLayout<UILayoutGuide> { return AutoLayout(source: self) }
    
    /// Performs layout setup in given view. Receiver is added as a layout guide to given view.
    /// - Parameter view: view to add the receiver as a layout guide
    public func autoLayout(in view: UIView) -> AutoLayout<UILayoutGuide> {
        let layout = autoLayout
        view.addLayoutGuide(self)
        return layout
    }
    
}
