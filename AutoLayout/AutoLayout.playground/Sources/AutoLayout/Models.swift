//
//  Models.swift
//  AutoLayout
//
//  Created by Stanislav Novacek on 02/10/2019.
//

import Foundation
import UIKit


/// Auto layout connection. Wraps an `NSLayoutConstraint` object.
public class Connection: LayoutConnection {
    
    /// Type of the connection.
    public let type: LayoutConnectionType
    
    /// Underlying constraint.
    public let constraint: NSLayoutConstraint
    
    /// Proxy to underlying constraint's constant.
    public var constant: CGFloat {
        get { return constraint.constant }
        set { constraint.constant = newValue }
    }
    
    /// Proxy to underlying constraint's priority.
    public var priority: UILayoutPriority {
        get { return constraint.priority }
        set { constraint.priority = newValue }
    }
    
    /// Proxy to underlying constraint's `isActive`.
    public var isActive: Bool {
        get { return constraint.isActive }
        set { constraint.isActive = newValue }
    }
    
    /// Initializes a new instance with given type and constraint.
    ///
    /// - Parameter type: type
    /// - Parameter constraint: constraint
    internal init(type: LayoutConnectionType, constraint: NSLayoutConstraint) {
        self.type = type
        self.constraint = constraint
    }
    
}

extension Connection: CustomDebugStringConvertible {
    
    public var debugDescription: String {
        return "Connection \(String(describing: type)), constant: \(constant), multiplier: \(constraint.multiplier), isActive: \(isActive), underlaying constraint: \(constraint)"
    }
    
}
