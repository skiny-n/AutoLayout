//
//  Enums.swift
//  AutoLayout
//
//  Created by Stanislav Novacek on 02/10/2019.
//

import Foundation
import UIKit


/// Connection type.
public enum LayoutConnectionType {
    
    case leading
    case trailing
    case left
    case right
    case top
    case bottom
    case width
    case height
    case centerX
    case centerY
    case firstBaseline
    case lastBaseline
    
}

/// Simple connection relation.
public enum LayoutConnectionSimpleRelation {
    
    case equal(to: CGFloat, priority: UILayoutPriority)
    case lessThanOrEqual(to: CGFloat, priority: UILayoutPriority)
    case greaterThanOrEqual(to: CGFloat, priority: UILayoutPriority)
    
    /// Convenience. Sama as `.equal(to: to, priority: .required)`.
    /// - Parameter to: value
    public static func equal(to: CGFloat) -> LayoutConnectionSimpleRelation {
        return .equal(to: to, priority: .required)
    }
    
    /// Convenience. Sama as `.lessThanOrEqual(to: to, priority: .required)`.
    /// - Parameter to: value
    public static func lessThanOrEqual(to: CGFloat) -> LayoutConnectionSimpleRelation {
        return .lessThanOrEqual(to: to, priority: .required)
    }
    
    /// Convenience. Sama as `.greaterThanOrEqual(to: to, priority: .required)`.
    /// - Parameter to: value
    public static func greaterThanOrEqual(to: CGFloat) -> LayoutConnectionSimpleRelation {
        return .greaterThanOrEqual(to: to, priority: .required)
    }
    
}

/// Connection relation using a multiplier.
public enum LayoutConnectionMultipliedRelation {
    
    case equal(to: NSLayoutDimension, multiplier: CGFloat, constant: CGFloat, priority: UILayoutPriority)
    case lessThanOrEqual(to: NSLayoutDimension, multiplier: CGFloat, constant: CGFloat, priority: UILayoutPriority)
    case greaterThanOrEqual(to: NSLayoutDimension, multiplier: CGFloat, constant: CGFloat, priority: UILayoutPriority)
    
    /// Convenience. Same as `.equal(to: to, multiplier: 1, constant: 0, priority: .required)`.
    /// - Parameter to: dimension
    public static func equal(to: NSLayoutDimension) -> LayoutConnectionMultipliedRelation {
        return .equal(to: to, multiplier: 1, constant: 0, priority: .required)
    }
    
    /// Convenience. Same as `.lessThanOrEqual(to: to, multiplier: 1, constant: 0, priority: .required)`.
    /// - Parameter to: dimension.
    public static func lessThanOrEqual(to: NSLayoutDimension) -> LayoutConnectionMultipliedRelation {
        return .lessThanOrEqual(to: to, multiplier: 1, constant: 0, priority: .required)
    }
    
    /// Convenience. Same as `.greaterThanOrEqual(to: to, multiplier: 1, constant: 0, priority: .required)`.
    /// - Parameter to: dimension
    public static func greaterThanOrEqual(to: NSLayoutDimension) -> LayoutConnectionMultipliedRelation {
        return .greaterThanOrEqual(to: to, multiplier: 1, constant: 0, priority: .required)
    }
    
}

extension LayoutConnectionSimpleRelation: ExpressibleByFloatLiteral {
    
    public typealias FloatLiteralType = Double
    
    public init(floatLiteral value: Self.FloatLiteralType) {
        self = .equal(to: CGFloat(value), priority: .required)
    }
    
}

extension LayoutConnectionSimpleRelation: ExpressibleByIntegerLiteral {
    
    public typealias IntegerLiteralType = Int
    
    public init(integerLiteral value: Self.IntegerLiteralType) {
        self = .equal(to: CGFloat(value), priority: .required)
    }
    
}

internal extension CGFloat {
    
    /// Returns a simple relation equal to this value.
    var simpleRelation: LayoutConnectionSimpleRelation {
        return .equal(to: self, priority: .required)
    }
    
}
