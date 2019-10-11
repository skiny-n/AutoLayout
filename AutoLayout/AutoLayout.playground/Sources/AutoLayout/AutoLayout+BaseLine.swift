//
//  AutoLayout+BaseLine.swift
//  AutoLayout
//
//  Created by Stanislav Novacek on 02/10/2019.
//

import Foundation
import UIKit

public extension AutoLayout where Source: BaselineAnchorProviding {
    
    // MARK: First baseline
    
    /// Constrains first baseline to given item's first baseline.
    /// - Parameter item: item
    func firstBaseline(to item: BaselineAnchorProviding) -> Self {
        firstBaseline(to: item.firstBaselineAnchor)
    }
    
    /// Constrains first baseline to given anchor.
    /// - Parameter anchor: anchor
    func firstBaseline(to anchor: NSLayoutYAxisAnchor) -> Self {
        return firstBaseline(0, to: anchor)
    }
    
    /// Constrains first baseline to given anchor with an offset.
    /// - Parameter value: offset
    /// - Parameter anchor: anchor
    func firstBaseline(_ value: CGFloat, to anchor: NSLayoutYAxisAnchor) -> Self {
        firstBaseline(relation: value.simpleRelation, to: anchor)
    }
    
    /// Constrains first baseline to given anchor using given relation.
    /// - Parameter relation: relation
    /// - Parameter anchor: anchor
    func firstBaseline(relation: LayoutConnectionSimpleRelation, to anchor: NSLayoutYAxisAnchor) -> Self {
        guard let source = source else { return self }
        add(constraint: createConstraint(from: source.firstBaselineAnchor, to: anchor, relation: relation), type: .firstBaseline)
        return self
    }
    
    // MARK: Last baseline
    
    /// Constrains last baseline to given item's last baseline.
    /// - Parameter item: item
    func lastBaseline(to item: BaselineAnchorProviding) -> Self {
        firstBaseline(to: item.lastBaselineAnchor)
    }
    
    /// Constrains last baseline to given anchor.
    /// - Parameter anchor: anchor
    func lastBaseline(to anchor: NSLayoutYAxisAnchor) -> Self {
        return lastBaseline(0, to: anchor)
    }
    
    /// Constrains last baseline to given anchor with an offset.
    /// - Parameter value: offset
    /// - Parameter anchor: anchor
    func lastBaseline(_ value: CGFloat, to anchor: NSLayoutYAxisAnchor) -> Self {
        return lastBaseline(relation: value.simpleRelation, to: anchor)
    }
    
    /// Constrains last baseline to given anchor using given relation.
    /// - Parameter relation: relation
    /// - Parameter anchor: anchor
    func lastBaseline(relation: LayoutConnectionSimpleRelation, to anchor: NSLayoutYAxisAnchor) -> Self {
        guard let source = source else { return self }
        add(constraint: createConstraint(from: source.lastBaselineAnchor, to: anchor, relation: relation), type: .lastBaseline)
        return self
    }
    
}
