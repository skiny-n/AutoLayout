//
//  Operators.swift
//  AutoLayout
//
//  Created by Stanislav Novacek on 02/10/2019.
//

import Foundation
import UIKit

prefix operator <=
public prefix func <=(to: CGFloat) -> LayoutConnectionSimpleRelation {
    return .lessThanOrEqual(to: to, priority: .required)
}

public prefix func <=(to: Int) -> LayoutConnectionSimpleRelation {
    return .lessThanOrEqual(to: CGFloat(to), priority: .required)
}

prefix operator >=
public prefix func >=(to: CGFloat) -> LayoutConnectionSimpleRelation {
    return .greaterThanOrEqual(to: to, priority: .required)
}

public prefix func >=(to: Int) -> LayoutConnectionSimpleRelation {
    return .greaterThanOrEqual(to: CGFloat(to), priority: .required)
}

internal prefix func -(rhs: LayoutConnectionSimpleRelation) -> LayoutConnectionSimpleRelation {
    switch rhs {
    case .equal(to: let constant, priority: let priority):
        return .equal(to: -constant, priority: priority)
    case .lessThanOrEqual(to: let constant, priority: let priority):
        return .greaterThanOrEqual(to: -constant, priority: priority)
    case .greaterThanOrEqual(to: let constant, priority: let priority):
        return .lessThanOrEqual(to: -constant, priority: priority)
    }
}
