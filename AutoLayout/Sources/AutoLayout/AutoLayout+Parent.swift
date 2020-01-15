//
//  AutoLayout+Parent.swift
//  AutoLayout
//
//  Created by Stanislav Novacek on 02/10/2019.
//

import Foundation
import UIKit


public extension AutoLayout where Source: UIView {
    
    // MARK: Top
    
    /// Constrains top anchor to superview's top anchor. Same as using `.top(0)`.
    func top() -> Self {
        return top(0)
    }
    
    /// Constrains top anchor to superview's top anchor with given offset.
    /// - Parameter value: offset
    func top(_ value: CGFloat) -> Self {
        return top(relation: value.simpleRelation)
    }
    
    /// Constrains top anchor to superview's top anchor with given relation.
    /// - Parameter relation: relation
    func top(relation: LayoutConnectionSimpleRelation) -> Self {
        guard let view = source?.superview else {
            log("⚠️ trying to constrain top to nil parent of \(String(describing: source))")
            return self
        }
        return top(relation: relation, to: view)
    }
    
    // MARK: Bottom
    
    /// Constrains bottom anchor to superview's bottom anchor. Same as using `.bottom(0)`.
    func bottom() -> Self {
        return bottom(0)
    }
    
    /// Constrains bottom anchor to superview's bottom anchor with given offset.
    /// - Parameter value: offset
    func bottom(_ value: CGFloat) -> Self {
        return bottom(relation: value.simpleRelation)
    }
    
    /// Constrains bottom anchor to superview's bottom anchor with given relation.
    /// - Parameter relation: relation
    func bottom(relation: LayoutConnectionSimpleRelation) -> Self {
        guard let view = source?.superview else {
            log("⚠️ trying to constrain bottom to nil parent of \(String(describing: source))")
            return self
        }
        return bottom(relation: relation, to: view)
    }
    
    // MARK: Left
    
    /// Constrains left anchor to superview's left anchor. Same as using `.left(0)`.
    func left() -> Self {
        return left(0)
    }
    
    /// Constrains left anchor to superview's left anchor with given offset.
    /// - Parameter value: offset
    func left(_ value: CGFloat) -> Self {
        return left(relation: value.simpleRelation)
    }
    
    /// Constrains left anchor to superview's left anchor with given relation.
    /// - Parameter relation: relation
    func left(relation: LayoutConnectionSimpleRelation) -> Self {
        guard let view = source?.superview else {
            log("⚠️ trying to constrain left to nil parent of \(String(describing: source))")
            return self
        }
        return left(relation: relation, to: view)
    }
    
    // MARK: Right
    
    /// Constrains right anchor to superview's right anchor. Same as using `.right(0)`.
    func right() -> Self {
        return right(0)
    }
    
    /// Constrains right anchor to superview's right anchor with given offset.
    /// - Parameter value: offset
    func right(_ value: CGFloat) -> Self {
        return right(relation: value.simpleRelation)
    }
    
    /// Constrains right anchor to superview's right anchor with given relation.
    /// - Parameter relation: relation
    func right(relation: LayoutConnectionSimpleRelation) -> Self {
        guard let view = source?.superview else {
            log("⚠️ trying to constrain right to nil parent of \(String(describing: source))")
            return self
        }
        return right(relation: relation, to: view)
    }
    
    // MARK: Leading
    
    /// Constrains leading anchor to superview's leading anchor. Same as using `.leading(0)`.
    func leading() -> Self {
        return leading(0)
    }
    
    /// Constrains leading anchor to superview's leading anchor with given offset.
    /// - Parameter value: offset
    func leading(_ value: CGFloat) -> Self {
        return leading(relation: value.simpleRelation)
    }
    
    /// Constrains leading anchor to superview's leading anchor with given relation.
    /// - Parameter relation: relation
    func leading(relation: LayoutConnectionSimpleRelation) -> Self {
        guard let view = source?.superview else {
            log("⚠️ trying to constrain leading to nil parent of \(String(describing: source))")
            return self
        }
        return leading(relation: relation, to: view)
    }
    
    // MARK: Trailing
    
    /// Constrains trailing anchor to superview's trailing anchor. Same as using `.trailing(0)`.
    func trailing() -> Self {
        return trailing(0)
    }
    
    /// Constrains trailing anchor to superview's trailing anchor with given offset.
    /// - Parameter value: offset
    func trailing(_ value: CGFloat) -> Self {
        return trailing(relation: value.simpleRelation)
    }
    
    /// Constrains trailing anchor to superview's trailing anchor with given relation.
    /// - Parameter relation: relation
    func trailing(relation: LayoutConnectionSimpleRelation) -> Self {
        guard let view = source?.superview else {
            log("⚠️ trying to constrain trailing to nil parent of \(String(describing: source))")
            return self
        }
        return trailing(relation: relation, to: view)
    }
    
    // MARK: Center vertically
    
    /// Constrains centerY anchor to superview's centerY anchor. Same as using `.centerVertically(0)`.
    func centerVertically() -> Self {
        return centerVertically(0)
    }
    
    /// Constrains centerY anchor to superview's centerY anchor with given offset.
    /// - Parameter value: offset
    func centerVertically(_ value: CGFloat) -> Self {
        return centerVertically(relation: value.simpleRelation)
    }
    
    /// Constrains centerY anchor to superview's centerY anchor with given relation.
    /// - Parameter relation: relation
    func centerVertically(relation: LayoutConnectionSimpleRelation) -> Self {
        guard let view = source?.superview else {
            log("⚠️ trying to constrain vertical center to nil parent of \(String(describing: source))")
            return self
        }
        return centerVertically(relation: relation, to: view)
    }
    
    // MARK: Center horizontally
    
    /// Constrains centerX anchor to superview's centerX anchor. Same as using `.centerHorizontally(0)`.
    func centerHorizontally() -> Self {
        return centerHorizontally(0)
    }
    
    /// Constrains centerX anchor to superview's centerX anchor with given offset.
    /// - Parameter value: offset
    func centerHorizontally(_ value: CGFloat) -> Self {
        return centerHorizontally(relation: value.simpleRelation)
    }
    
    /// Constrains centerX anchor to superview's centerX anchor with given relation.
    /// - Parameter relation: relation
    func centerHorizontally(relation: LayoutConnectionSimpleRelation) -> Self {
        guard let view = source?.superview else {
            log("⚠️ trying to constrain horizontal center to nil parent of \(String(describing: source))")
            return self
        }
        return centerHorizontally(relation: relation, to: view)
    }
    
    // MARK: Width
    
    /// Constrains width anchor to superview's width anchor. Same as using `.widthToParent(constant: 0)`.
    func widthToParent() -> Self {
        return widthToParent(constant: 0)
    }
    
    /// Constrains width anchor to superview's width anchor with given multiplier.
    /// - Parameter multiplier: mzltiplier
    func widthToParent(multiplier: CGFloat) -> Self {
        return widthToParent(multiplier: multiplier, constant: 0)
    }
    
    /// Constrains width anchor to superview's width anchor with given constant.
    /// - Parameter constant: constant
    func widthToParent(constant: CGFloat) -> Self {
        return widthToParent(multiplier: 1, constant: constant)
    }
    
    /// Constrains width anchor to superview's width anchor with given multiplier and constant.
    /// - Parameter multiplier: multiplier
    /// - Parameter constant: constant
    func widthToParent(multiplier: CGFloat, constant: CGFloat) -> Self {
        guard let view = source?.superview else {
            log("⚠️ trying to constrain width to nil parent of \(String(describing: source))")
            return self
        }
        return width(to: view, multiplier: multiplier, constant: constant)
    }
    
    // MARK: Height
    
    /// Constrains height anchor to superview's height anchor. Same as using `.heightToParent(constant: 0)`.
    func heightToParent() -> Self {
        return heightToParent(constant: 0)
    }
    
    /// Constrains height anchor to superview's height anchor with given multiplier.
    /// - Parameter multiplier: mzltiplier
    func heightToParent(multiplier: CGFloat) -> Self {
        return heightToParent(multiplier: multiplier, constant: 0)
    }
    
    /// Constrains height anchor to superview's height anchor with given constant.
    /// - Parameter constant: constant
    func heightToParent(constant: CGFloat) -> Self {
        return heightToParent(multiplier: 1, constant: constant)
    }
    
    /// Constrains height anchor to superview's height anchor with given multiplier and constant.
    /// - Parameter multiplier: multiplier
    /// - Parameter constant: constant
    func heightToParent(multiplier: CGFloat, constant: CGFloat) -> Self {
        guard let view = source?.superview else {
            log("⚠️ trying to constrain height to nil parent of \(String(describing: source))")
            return self
        }
        return height(to: view, multiplier: multiplier, constant: constant)
    }
    
    // MARK: Edges
    
    /// Constrains top, leading, trailing and bottom to superview. Same as using `.fillParent(0)`.
    func fillParent() -> Self {
        return fillParent(0)
    }
    
    /// Constrains top, leading, trailing and bottom to superview with given margin.
    /// - Parameter margin: margin
    func fillParent(_ margin: CGFloat) -> Self {
        return fillParent(relation: margin.simpleRelation)
    }
    
    /// Constrains top, leading, trailing and bottom to superview with given margins.
    /// - Parameter margins: margins
    func fillParent(_ margins: UIEdgeInsets) -> Self {
        return top(margins.top).leading(margins.left).trailing(margins.right).bottom(margins.bottom)
    }
    
    ///  Constrains top, leading, trailing and bottom to superview with given relation.
    /// - Parameter relation: relation
    func fillParent(relation: LayoutConnectionSimpleRelation) -> Self {
        return top(relation: relation).leading(relation: relation).trailing(relation: relation).bottom(relation: relation)
    }
    
}
