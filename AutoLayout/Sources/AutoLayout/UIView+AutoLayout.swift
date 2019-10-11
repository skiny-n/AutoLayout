//
//  UIView+AutoLayout.swift
//  AutoLayout
//
//  Created by Stanislav Novacek on 02/10/2019.
//

import Foundation
import UIKit

extension UIView: BaselineAnchorProviding {
    
    /// Ensure that this view already has a superview before using this helper.
    public var autoLayout: AutoLayout<UIView> { return AutoLayout(source: self) }
    
    /// Performs layout setup in given view. Receiver is added as a subview to given view.
    /// - Parameter view: view to add the receiver as a subview
    public func autoLayout(in view: UIView) -> AutoLayout<UIView> {
        let layout = autoLayout
        view.addSubview(self)
        return layout
    }
    
}

extension UIView: SafeAreaProviding {}
extension UIView: MarginGuideProviding {}
extension UIView: ReadableContentGuideProviding {}
