//
//  NSLayoutConstraint+AutoLayout.swift
//  AutoLayout
//
//  Created by Stanislav Novacek on 02/10/2019.
//

import Foundation
import UIKit


extension NSLayoutConstraint {
    
    /// Sets given priority.
    /// - Parameter priority: priority
    public func priority(_ priority: UILayoutPriority) -> NSLayoutConstraint {
        self.priority = priority
        return self
    }
    
    /// Activated this constraint.
    @discardableResult
    public func activate() -> Self {
        isActive = true
        return self
    }
    
    /// Deactivate this constraint.
    @discardableResult
    public func deactivate() -> Self {
        isActive = false
        return self
    }
    
}
