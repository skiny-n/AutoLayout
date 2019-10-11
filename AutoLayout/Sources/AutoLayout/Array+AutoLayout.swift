//
//  Array+AutoLayout.swift
//  AutoLayout
//
//  Created by Stanislav Novacek on 02/10/2019.
//

import Foundation
import UIKit

public extension Array where Element: NSLayoutConstraint {
    
    /// Activates all constraints in this array.
    func activate() {
        NSLayoutConstraint.activate(self)
    }
    
    /// Deactivates all constraints in this array.
    func deactivate() {
        NSLayoutConstraint.deactivate(self)
    }
    
}

public extension Array where Element: AutoLayout<UIView> {
    
    
    /// Activates all `AutoLayout` objects in this array.
    func activate() {
        for l in self {
            l.activate()
        }
    }
    
    /// Deactivates all `AutoLayout` objects in this array.
    func deactivate() {
        for l in self {
            l.deactivate()
        }
    }
    
    /// Destroys all `AutoLayout` objects in this array.
    func destroy() {
        for l in self {
            l.destroy()
        }
    }
    
}
