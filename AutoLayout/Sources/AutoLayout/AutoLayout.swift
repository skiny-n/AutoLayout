//
//  AutoLayour.swift
//  AutoLayout
//
//  Created by Stanislav Novacek on 02/10/2019.
//

import Foundation
import UIKit

internal extension Bundle {
    private class ThisBundleDummy { }
    static let current: Bundle = { return Bundle(for: ThisBundleDummy.self) }()
}

internal func log(_ msg: String) {
    #if DEBUG
    print("\(Date()) AutoLayout: \(msg)")
    #endif
}

/// AutoLayout class that manages `AutoLayout.Connection`s for a source - typically a `UIView`.
///
/// You do not create objects of this class directly, you use `UIView`'s `.autoLaoyut` or `.autoLayout(in:)` instead.
///
/// These objects are independent of each other, and it's managing item - typically a view.
/// Therefore, you have to keep a reference to it if you'll need to manipulate connections (constraints) created by this object later on.
/// Otherwise it's ok to just ignore it after calling `activate()`.
///
/// To get all connections, use the `connections` property.
/// To get connections of a specific type, use `findAll(_:)` method.
///
/// After creating all connections, call `activate()` to activate them or store the `AutoLayout` object for later use.
/// To deactivate all conection this object manages, call `deactivate()`.
///
/// To deactivate and remove all constraints from managed item, call `destroy()`.
///
///
public class AutoLayout<Source: AnchorProviding> {
    
    /// All connections created and managed by this object.
    public private(set) var connections: [Connection] = []
    
    /// Source item this layout manages.
    weak private(set) var source: Source?
    
    private var didApplyLayout: Bool = false
    private let sourceDescription: String
    
    // MARK: Lifecycle
    
    /// Initializes a new instance with given source item.
    /// - Parameter source: item to manage, usually a `UIView`
    internal init(source: Source) {
        self.source = source
        self.sourceDescription = String(describing: type(of: source))
        prepare(source: source)
    }
    
    deinit {
        // Log a warning in case this layout has not been activated, therefore it's useless.
        if connections.isEmpty == false && didApplyLayout == false && source != nil {
            log("⚠️ AutoLayout has not been activated - was this intentional? Source: \(sourceDescription)")
        }
        // Clean up
        source = nil
        connections = []
    }
    
    // MARK: Public
    
    /// Constrains top anchor to given anchor using given relation.
    /// - Parameter relation: relation
    /// - Parameter anchor: anchor
    public func top(relation: LayoutConnectionSimpleRelation, to anchor: NSLayoutYAxisAnchor) -> Self {
        guard let source = source else { return self }
        add(constraint: createConstraint(from: source.topAnchor, to: anchor, relation: relation), type: .top)
        return self
    }
    
    /// Constrains bottom anchor to given anchor using given relation.
    /// - Parameter relation: relation
    /// - Parameter anchor: anchor
    public func bottom(relation: LayoutConnectionSimpleRelation, to anchor: NSLayoutYAxisAnchor) -> Self {
        guard let source = source else { return self }
        add(constraint: createConstraint(from: source.bottomAnchor, to: anchor, relation: -relation), type: .bottom)
        return self
    }
    
    /// Constrains left anchor to given anchor using given relation.
    /// - Parameter relation: relation
    /// - Parameter anchor: anchor
    public func left(relation: LayoutConnectionSimpleRelation, to anchor: NSLayoutXAxisAnchor) -> Self {
        guard let source = source else { return self }
        add(constraint: createConstraint(from: source.leftAnchor, to: anchor, relation: relation), type: .left)
        return self
    }
    
    /// Constrains right anchor to given anchor using given relation.
    /// - Parameter relation: relation
    /// - Parameter anchor: anchor
    public func right(relation: LayoutConnectionSimpleRelation, to anchor: NSLayoutXAxisAnchor) -> Self {
        guard let source = source else { return self }
        add(constraint: createConstraint(from: source.rightAnchor, to: anchor, relation: -relation), type: .right)
        return self
    }
    
    /// Constrains leading anchor to given anchor using given relation.
    /// - Parameter relation: relation
    /// - Parameter anchor: anchor
    public func leading(relation: LayoutConnectionSimpleRelation, to anchor: NSLayoutXAxisAnchor) -> Self {
        guard let source = source else { return self }
        add(constraint: createConstraint(from: source.leadingAnchor, to: anchor, relation: relation), type: .leading)
        return self
    }
    
    /// Constrains trailing anchor to given anchor using given relation.
    /// - Parameter relation: relation
    /// - Parameter anchor: anchor
    public func trailing(relation: LayoutConnectionSimpleRelation, to anchor: NSLayoutXAxisAnchor) -> Self {
        guard let source = source else { return self }
        add(constraint: createConstraint(from: source.trailingAnchor, to: anchor, relation: -relation), type: .trailing)
        return self
    }
    
    /// Constrains centerY anchor to given anchor using given relation.
    /// - Parameter relation: relation
    /// - Parameter anchor: anchor
    public func centerVertically(relation: LayoutConnectionSimpleRelation, to anchor: NSLayoutYAxisAnchor) -> Self {
        guard let source = source else { return self }
        add(constraint: createConstraint(from: source.centerYAnchor, to: anchor, relation: relation), type: .centerY)
        return self
    }
    
    /// Constrains centerX anchor to given anchor using given relation.
    /// - Parameter relation: relation
    /// - Parameter anchor: anchor
    public func centerHorizontally(relation: LayoutConnectionSimpleRelation, to anchor: NSLayoutXAxisAnchor) -> Self {
        guard let source = source else { return self }
        add(constraint: createConstraint(from: source.centerXAnchor, to: anchor, relation: relation), type: .centerX)
        return self
    }
    
    /// Constrains width anchor with given relation.
    /// - Parameter relation: relation
    public func width(relation: LayoutConnectionSimpleRelation) -> Self {
        guard let source = source else { return self }
        add(constraint: createConstraint(constrain: source.widthAnchor, to: relation), type: .width)
        return self
    }
    
    
    /// Constrains width anchor with given relation.
    /// - Parameter relation: relation
    public func width(relation: LayoutConnectionMultipliedRelation) -> Self {
        guard let source = source else { return self }
        add(constraint: createConstraint(constrain: source.widthAnchor, to: relation), type: .width)
        return self
    }
    
    /// Constrains height anchor with given relation.
    /// - Parameter relation: relation
    public func height(relation: LayoutConnectionSimpleRelation) -> Self {
        guard let source = source else { return self }
        add(constraint: createConstraint(constrain: source.heightAnchor, to: relation), type: .height)
        return self
    }
    
    /// Constrains height anchor with given relation.
    /// - Parameter relation: relation
    public func height(relation: LayoutConnectionMultipliedRelation) -> Self {
        guard let source = source else { return self }
        add(constraint: createConstraint(constrain: source.heightAnchor, to: relation), type: .height)
        return self
    }
    
    /// Returns all connections of given type.
    /// - Parameter type: type to filter
    public func findAll(_ type: LayoutConnectionType) -> [Connection] {
        return connections.filter({ $0.type == type })
    }
    
    
    /// Activates all connections.
    @discardableResult
    public func activate() -> Self {
        connections.map({ $0.constraint }).activate()
        didApplyLayout = true
        return self
    }
    
    /// Deactivates all connections.
    @discardableResult
    public func deactivate() -> Self {
        connections.map({ $0.constraint }).deactivate()
        return self
    }
    
    // MARK: Internal
    
    /// Transforms given constraint into a connection and appends it to existing connections.
    /// - Parameter constraint: constraint
    /// - Parameter type: connection type
    internal func add(constraint: NSLayoutConstraint, type: LayoutConnectionType) {
        connections.append(.init(type: type, constraint: constraint))
    }
    
    /// Creates a constraint between given anchors using given relation.
    /// - Parameter from: first anchor
    /// - Parameter to: second anchor
    /// - Parameter relation: relation
    internal func createConstraint<T>(from: NSLayoutAnchor<T>, to: NSLayoutAnchor<T>, relation: LayoutConnectionSimpleRelation) -> NSLayoutConstraint {
        switch relation {
        case .equal(to: let constant, priority: let priority):
            return from.constraint(equalTo: to, constant: constant).priority(priority)
        case .lessThanOrEqual(to: let constant, priority: let priority):
            return from.constraint(lessThanOrEqualTo: to, constant: constant).priority(priority)
        case .greaterThanOrEqual(to: let constant, priority: let priority):
            return from.constraint(greaterThanOrEqualTo: to, constant: constant).priority(priority)
        }
    }
    
    /// Constrains given anchor using given relation.
    /// - Parameter anchor: anchor to constrain
    /// - Parameter relation: relation
    internal func createConstraint(constrain anchor: NSLayoutDimension, to relation: LayoutConnectionMultipliedRelation) -> NSLayoutConstraint {
        switch relation {
        case .equal(to: let to, multiplier: let multiplier, constant: let constant, priority: let priority):
            return anchor.constraint(equalTo: to, multiplier: multiplier, constant: constant).priority(priority)
        case .lessThanOrEqual(to: let to, multiplier: let multiplier, constant: let constant, priority: let priority):
            return anchor.constraint(lessThanOrEqualTo: to, multiplier: multiplier, constant: constant).priority(priority)
        case .greaterThanOrEqual(to: let to, multiplier: let multiplier, constant: let constant, priority: let priority):
            return anchor.constraint(greaterThanOrEqualTo: to, multiplier: multiplier, constant: constant).priority(priority)
        }
    }
    
    /// Constrains given anchor using given relation.
    /// - Parameter anchor: anchor to constrain
    /// - Parameter relation: relation
    internal func createConstraint(constrain anchor: NSLayoutDimension, to relation: LayoutConnectionSimpleRelation) -> NSLayoutConstraint {
        switch relation {
        case .equal(to: let constant, priority: let priority):
            return anchor.constraint(equalToConstant: constant).priority(priority)
        case .lessThanOrEqual(to: let constant, priority: let priority):
            return anchor.constraint(lessThanOrEqualToConstant: constant).priority(priority)
        case .greaterThanOrEqual(to: let constant, priority: let priority):
            return anchor.constraint(greaterThanOrEqualToConstant: constant).priority(priority)
        }
    }
    
    // MARK: Private
    
    /// Prepares given source for atuo layout.
    /// - Parameter source: source
    private func prepare(source: Source) {
        if let source = source as? UIView {
            source.translatesAutoresizingMaskIntoConstraints = false
        }
    }
    
}

public extension AutoLayout where Source: UIView {
    
    /// Deactivated and removes all connections (and constraints) from managing source.
    func destroy() {
        deactivate()
        source?.removeConstraints(connections.map({ $0.constraint }))
    }
    
}

public extension AutoLayout where Source: AnchorProviding {
    
    // MARK: Top
    
    /// Constrains top anchor to given item's top anchor using an offset.
    ///
    /// Example:
    /// ```
    /// view.autoLayout(in: self).top(8, to: otherView)
    /// ```
    ///
    /// - Parameter value: offset
    /// - Parameter item: item
    func top(_ value: CGFloat, to item: AnchorProviding) -> Self {
        return top(relation: value.simpleRelation, to: item)
    }
    
    
    /// Constrains top anchor to given item's top anchor.
    ///
    /// Example:
    /// ```
    /// view.autoLayout(in: self).top(to: otherView)
    /// ```
    ///
    /// - Parameter item: item
    func top(to item: AnchorProviding) -> Self {
        return top(0, to: item)
    }
    
    /// Constrans top anchor to given item's top anchor using given relation.
    ///
    /// Example:
    /// ```
    /// view.autoLayout(in: self).top(relation: >=10, to: otherView).activate()
    /// // or
    /// view.autoLayout(in: self).top(relation: .greaterThanOrEqual(to: 10, priority: .required), to: otherView).activate()
    /// ```
    ///
    /// - Parameter relation: relation
    /// - Parameter item: item
    func top(relation: LayoutConnectionSimpleRelation, to item: AnchorProviding) -> Self {
        return top(relation: relation, to: item.topAnchor)
    }
    
    // MARK: Bottom
    
    /// Constrains bottom anchor to given item's bottom anchor using an offset.
    ///
    /// Example:
    /// ```
    /// view.autoLayout(in: self).bottom(8, to: otherView)
    /// ```
    ///
    /// - Parameter value: offset
    /// - Parameter item: item
    func bottom(_ value: CGFloat, to item: AnchorProviding) -> Self {
        return bottom(relation: value.simpleRelation, to: item)
    }
    
    /// Constrains bottom anchor to given item's bottom anchor.
    ///
    /// Example:
    /// ```
    /// view.autoLayout(in: self).bottom(to: otherView)
    /// ```
    ///
    /// - Parameter item: item
    func bottom(to item: AnchorProviding) -> Self {
        return bottom(0, to: item)
    }
    
    /// Constrans bottom anchor to given item's bottom anchor using given relation.
    ///
    /// Example:
    /// ```
    /// view.autoLayout(in: self).bottom(relation: >=10, to: otherView).activate()
    /// // or
    /// view.autoLayout(in: self).bottom(relation: .greaterThanOrEqual(to: 10, priority: .required), to: otherView).activate()
    /// ```
    ///
    /// - Parameter relation: relation
    /// - Parameter item: item
    func bottom(relation: LayoutConnectionSimpleRelation, to item: AnchorProviding) -> Self {
        return bottom(relation: relation, to: item.bottomAnchor)
    }
    
    // MARK: Left
    
    /// Constrains left anchor to given item's left anchor using an offset.
    ///
    /// Example:
    /// ```
    /// view.autoLayout(in: self).left(8, to: otherView)
    /// ```
    ///
    /// - Parameter value: offset
    /// - Parameter item: item
    func left(_ value: CGFloat, to item: AnchorProviding) -> Self {
        return left(relation: value.simpleRelation, to: item)
    }
    
    /// Constrains left anchor to given item's left anchor.
    ///
    /// Example:
    /// ```
    /// view.autoLayout(in: self).left(to: otherView)
    /// ```
    ///
    /// - Parameter item: item
    func left(to item: AnchorProviding) -> Self {
        return left(0, to: item)
    }
    
    /// Constrans left anchor to given item's left anchor using given relation.
    ///
    /// Example:
    /// ```
    /// view.autoLayout(in: self).left(relation: >=10, to: otherView).activate()
    /// // or
    /// view.autoLayout(in: self).left(relation: .greaterThanOrEqual(to: 10, priority: .required), to: otherView).activate()
    /// ```
    ///
    /// - Parameter relation: relation
    /// - Parameter item: item
    func left(relation: LayoutConnectionSimpleRelation, to item: AnchorProviding) -> Self {
        return left(relation: relation, to: item.leftAnchor)
    }
    
    // MARK: Right
    
    /// Constrains right anchor to given item's right anchor using an offset.
    ///
    /// Example:
    /// ```
    /// view.autoLayout(in: self).right(8, to: otherView)
    /// ```
    ///
    /// - Parameter value: offset
    /// - Parameter item: item
    func right(_ value: CGFloat, to item: AnchorProviding) -> Self {
        return right(relation: value.simpleRelation, to: item)
    }
    
    
    /// Constrains right anchor to given item's right anchor.
    ///
    /// Example:
    /// ```
    /// view.autoLayout(in: self).right(to: otherView)
    /// ```
    ///
    /// - Parameter item: item
    func right(to item: AnchorProviding) -> Self {
        return right(0, to: item)
    }
    
    /// Constrans right anchor to given item's right anchor using given relation.
    ///
    /// Example:
    /// ```
    /// view.autoLayout(in: self).right(relation: >=10, to: otherView).activate()
    /// // or
    /// view.autoLayout(in: self).right(relation: .greaterThanOrEqual(to: 10, priority: .required), to: otherView).activate()
    /// ```
    ///
    /// - Parameter relation: relation
    /// - Parameter item: item
    func right(relation: LayoutConnectionSimpleRelation, to item: AnchorProviding) -> Self {
        return right(relation: relation, to: item.rightAnchor)
    }
    
    // MARK: Leading
    
    /// Constrains leading anchor to given item's leading anchor using an offset.
    ///
    /// Example:
    /// ```
    /// view.autoLayout(in: self).leading(8, to: otherView)
    /// ```
    ///
    /// - Parameter value: offset
    /// - Parameter item: item
    func leading(_ value: CGFloat, to item: AnchorProviding) -> Self {
        return leading(relation: value.simpleRelation, to: item)
    }
    
    /// Constrains leading anchor to given item's leading anchor.
    ///
    /// Example:
    /// ```
    /// view.autoLayout(in: self).leading(to: otherView)
    /// ```
    ///
    /// - Parameter item: item
    func leading(to item: AnchorProviding) -> Self {
        return leading(0, to: item)
    }
    
    /// Constrans leading anchor to given item's leading anchor using given relation.
    ///
    /// Example:
    /// ```
    /// view.autoLayout(in: self).leading(relation: >=10, to: otherView).activate()
    /// // or
    /// view.autoLayout(in: self).leading(relation: .greaterThanOrEqual(to: 10, priority: .required), to: otherView).activate()
    /// ```
    ///
    /// - Parameter relation: relation
    /// - Parameter item: item
    func leading(relation: LayoutConnectionSimpleRelation, to item: AnchorProviding) -> Self {
        return leading(relation: relation, to: item.leadingAnchor)
    }
    
    // MARK: Trailing
    
    /// Constrains trailing anchor to given item's trailing anchor using an offset.
    ///
    /// Example:
    /// ```
    /// view.autoLayout(in: self).trailing(8, to: otherView)
    /// ```
    ///
    /// - Parameter value: offset
    /// - Parameter item: item
    func trailing(_ value: CGFloat, to item: AnchorProviding) -> Self {
        return trailing(relation: value.simpleRelation, to: item)
    }
    
    /// Constrains trailing anchor to given item's trailing anchor.
    ///
    /// Example:
    /// ```
    /// view.autoLayout(in: self).trailing(to: otherView)
    /// ```
    ///
    /// - Parameter item: item
    func trailing(to item: AnchorProviding) -> Self {
        return trailing(0, to: item)
    }
    
    /// Constrans trailing anchor to given item's trailing anchor using given relation.
    ///
    /// Example:
    /// ```
    /// view.autoLayout(in: self).trailing(relation: >=10, to: otherView).activate()
    /// // or
    /// view.autoLayout(in: self).trailing(relation: .greaterThanOrEqual(to: 10, priority: .required), to: otherView).activate()
    /// ```
    ///
    /// - Parameter relation: relation
    /// - Parameter item: item
    func trailing(relation: LayoutConnectionSimpleRelation, to item: AnchorProviding) -> Self {
        return trailing(relation: relation, to: item.trailingAnchor)
    }
    
    // MARK: Center vertically
    
    /// Constrains centerY anchor to given item's centerY anchor using an offset.
    ///
    /// Example:
    /// ```
    /// view.autoLayout(in: self).centerVertically(8, to: otherView)
    /// ```
    ///
    /// - Parameter value: offset
    /// - Parameter item: item
    func centerVertically(_ value: CGFloat, to item: AnchorProviding) -> Self {
        return centerVertically(relation: value.simpleRelation, to: item)
    }
    
    /// Constrains centerY anchor to given item's centerY anchor.
    ///
    /// Example:
    /// ```
    /// view.autoLayout(in: self).centerVertically(to: otherView)
    /// ```
    ///
    /// - Parameter item: item
    func centerVertically(to item: AnchorProviding) -> Self {
        return centerVertically(0, to: item)
    }
    
    /// Constrans centerY anchor to given item's centerY anchor using given relation.
    ///
    /// Example:
    /// ```
    /// view.autoLayout(in: self).centerVertically(relation: >=10, to: otherView).activate()
    /// // or
    /// view.autoLayout(in: self).centerVertically(relation: .greaterThanOrEqual(to: 10, priority: .required), to: otherView).activate()
    /// ```
    ///
    /// - Parameter relation: relation
    /// - Parameter item: item
    func centerVertically(relation: LayoutConnectionSimpleRelation, to item: AnchorProviding) -> Self {
        return centerVertically(relation: relation, to: item.centerYAnchor)
    }
    
    // MARK: Center horizontally
    
    /// Constrains centerX anchor to given item's centerX anchor using an offset.
    ///
    /// Example:
    /// ```
    /// view.autoLayout(in: self).centerHorizontally(8, to: otherView)
    /// ```
    ///
    /// - Parameter value: offset
    /// - Parameter item: item
    func centerHorizontally(_ value: CGFloat, to item: AnchorProviding) -> Self {
        return centerHorizontally(relation: value.simpleRelation, to: item)
    }
    
    /// Constrains centerX anchor to given item's centerX anchor.
    ///
    /// Example:
    /// ```
    /// view.autoLayout(in: self).centerHorizontally(to: otherView)
    /// ```
    ///
    /// - Parameter item: item
    func centerHorizontally(to item: AnchorProviding) -> Self {
        return centerHorizontally(0, to: item)
    }
    
    /// Constrans centerX anchor to given item's centerX anchor using given relation.
    ///
    /// Example:
    /// ```
    /// view.autoLayout(in: self).centerHorizontally(relation: >=10, to: otherView).activate()
    /// // or
    /// view.autoLayout(in: self).centerHorizontally(relation: .greaterThanOrEqual(to: 10, priority: .required), to: otherView).activate()
    /// ```
    ///
    /// - Parameter relation: relation
    /// - Parameter item: item
    func centerHorizontally(relation: LayoutConnectionSimpleRelation, to item: AnchorProviding) -> Self {
        return centerHorizontally(relation: relation, to: item.centerXAnchor)
    }
    
    // MARK: Size
    
    /// Constrains width and height anchors to given value.
    /// - Parameter side: value
    func size(_ side: Int) -> Self {
        return size(CGFloat(side))
    }
    
    /// Constrains width and height anchors to given value.
    /// - Parameter side: value
    func size(_ side: CGFloat) -> Self {
        return size(CGSize(width: side, height: side))
    }
    
    /// Constrains width and height anchors to given `size.width` and `size.height`.
    /// - Parameter side: size
    func size(_ size: CGSize) -> Self {
        return width(size.width).height(size.height)
    }
    
    // MARK: Aspect
    
    /// Constains aspect.
    func aspect() -> Self {
        guard let source = source else { return self }
        return width(to: source.heightAnchor).height(to: source.widthAnchor)
    }
    
    // MARK: Edges
    
    /// Constrains top, leading, trailing and bottom anchors to corresponsing item's anchors using margin.
    /// - Parameter item: item
    /// - Parameter margin: margin
    func fill(in item: AnchorProviding, margin: CGFloat) -> Self {
        return fill(in: item, margins: .init(top: margin, left: margin, bottom: margin, right: margin))
    }
    
    /// Constrains top, leading, trailing and bottom anchors to corresponsing item's anchors using edge margins.
    /// - Parameter item: item
    /// - Parameter margins: margins
    func fill(in item: AnchorProviding, margins: UIEdgeInsets) -> Self {
        return top(margins.top, to: item).leading(margins.left, to: item).trailing(margins.right, to: item).bottom(margins.bottom, to: item)
    }
    
    /// Constrains top, leading, trailing and bottom anchors to corresponsing item's anchors.
    /// - Parameter item: item
    func fill(in item: AnchorProviding) -> Self {
        return fill(in: item, margin: 0)
    }
    
    /// Constrains top, leading, trailing and bottom anchors to corresponsing item's `safeAreaLayoutGuide`.
    /// - Parameter item: item
    func fill(inSafeAreaOf item: SafeAreaProviding) -> Self {
        return fill(in: item.safeAreaLayoutGuide)
    }
    
    /// Constrains top, leading, trailing and bottom anchors to corresponsing item's `layoutMarginsGuide`.
    /// - Parameter item: item
    func fill(inMarginGuideOf item: MarginGuideProviding) -> Self {
        return fill(in: item.layoutMarginsGuide)
    }
    
    /// Constrains top, leading, trailing and bottom anchors to corresponsing item's `readableContentGuide`.
    /// - Parameter item: item
    func fill(inReadableContentGuideOf item: ReadableContentGuideProviding) -> Self {
        return fill(in: item.readableContentGuide)
    }
    
    // MARK: - Relative
    
    // MARK: Above
    
    /// Constrains this source above given item, i.e. bottom anchor to item's top anchor.
    ///
    /// Example:
    /// ```
    /// view.autoLayout(in: self).above(otherView).activate()
    /// ```
    ///
    /// - Parameter item: item
    func above(_ item: AnchorProviding) -> Self {
        return above(0, to: item)
    }
    
    /// Constrains this source above given item, i.e. bottom anchor to item's top anchor, with an offset.
    ///
    /// Example:
    /// ```
    /// view.autoLayout(in: self).above(10, to: otherView).activate()
    /// ```
    ///
    /// - Parameter value: offset
    /// - Parameter item: item
    func above(_ value: CGFloat, to item: AnchorProviding) -> Self {
        return above(relation: value.simpleRelation, to: item)
    }
    
    /// Constrains this source above given item, i.e. bottom anchor to item's top anchor, using given relation.
    ///
    /// Example:
    /// ```
    /// view.autoLayout(in: self).above(relation: >=10, to: otherView).activate()
    /// ```
    ///
    /// - Parameter relation: relation
    /// - Parameter item: item
    func above(relation: LayoutConnectionSimpleRelation, to item: AnchorProviding) -> Self {
        return bottom(relation: relation, to: item.topAnchor)
    }
    
    // MARK: Below
    
    /// Constrains this source below given item, i.e. top anchor to item's bottom anchor.
    ///
    /// Example:
    /// ```
    /// view.autoLayout(in: self).below(otherView).activate()
    /// ```
    ///
    /// - Parameter item: item
    func below(_ item: AnchorProviding) -> Self {
        return below(0, to: item)
    }
    
    /// Constrains this source below given item, i.e. top anchor to item's bottom anchor, with an offset.
    ///
    /// Example:
    /// ```
    /// view.autoLayout(in: self).below(10, to: otherView).activate()
    /// ```
    ///
    /// - Parameter value: offset
    /// - Parameter item: item
    func below(_ value: CGFloat, to item: AnchorProviding) -> Self {
        return below(relation: value.simpleRelation, to: item)
    }
    
    /// Constrains this source below given item, i.e. top anchor to item's bottom anchor, using given relation.
    ///
    /// Example:
    /// ```
    /// view.autoLayout(in: self).below(relation: >=10, to: otherView).activate()
    /// ```
    ///
    /// - Parameter relation: relation
    /// - Parameter item: item
    func below(relation: LayoutConnectionSimpleRelation, to item: AnchorProviding) -> Self {
        return top(relation: relation, to: item.bottomAnchor)
    }
    
    // MARK: Before
    
    /// Constrains this source before given item, i.e. trailing anchor to item's leading anchor.
    ///
    /// Example:
    /// ```
    /// view.autoLayout(in: self).before(otherView).activate()
    /// ```
    ///
    /// - Parameter item: item
    func before(_ item: AnchorProviding) -> Self {
        return before(0, to: item)
    }
    
    /// Constrains this source before given item, i.e. trailing anchor to item's leading anchor, with an offset.
    ///
    /// Example:
    /// ```
    /// view.autoLayout(in: self).before(10, to: otherView).activate()
    /// ```
    ///
    /// - Parameter value: offset
    /// - Parameter item: item
    func before(_ value: CGFloat, to item: AnchorProviding) -> Self {
        return before(relation: value.simpleRelation, to: item)
    }
    
    /// Constrains this source before given item, i.e. trailing anchor to item's leading anchor, using given relation.
    ///
    /// Example:
    /// ```
    /// view.autoLayout(in: self).before(relation: >=10, to: otherView).activate()
    /// ```
    ///
    /// - Parameter relation: relation
    /// - Parameter item: item
    func before(relation: LayoutConnectionSimpleRelation, to item: AnchorProviding) -> Self {
        return trailing(relation: relation, to: item.leadingAnchor)
    }
    
    // MARK: After
    
    /// Constrains this source after given item, i.e. leading anchor to item's trailing anchor.
    ///
    /// Example:
    /// ```
    /// view.autoLayout(in: self).after(otherView).activate()
    /// ```
    ///
    /// - Parameter item: item
    func after(_ item: AnchorProviding) -> Self {
        return after(0, to: item)
    }
    
    /// Constrains this source after given item, i.e. leading anchor to item's trailing anchor, with an offset.
    ///
    /// Example:
    /// ```
    /// view.autoLayout(in: self).after(10, to: otherView).activate()
    /// ```
    ///
    /// - Parameter value: offset
    /// - Parameter item: item
    func after(_ value: CGFloat, to item: AnchorProviding) -> Self {
        return after(relation: value.simpleRelation, to: item)
    }
    
    /// Constrains this source after given item, i.e. leading anchor to item's trailing anchor, using given relation.
    ///
    /// Example:
    /// ```
    /// view.autoLayout(in: self).after(relation: >=10, to: otherView).activate()
    /// ```
    ///
    /// - Parameter relation: relation
    /// - Parameter item: item
    func after(relation: LayoutConnectionSimpleRelation, to item: AnchorProviding) -> Self {
        return leading(relation: relation, to: item.trailingAnchor)
    }
    
    // MARK: Horizontally between
    
    /// Constrains source horizontally betwwen two items, i.e. after first view and before second view.
    ///
    /// Example:
    /// ```
    /// middleView.autoLayout(in: self).horizontallyBetween(firstView, and: secondView).activate()
    /// ```
    ///
    /// - Parameter first: first view
    /// - Parameter second: second view
    func horizontallyBetween(_ first: AnchorProviding, and second: AnchorProviding) -> Self {
        return horizontallyBetween(first, and: second, margin: 0)
    }
    
    /// Constrains source horizontally betwwen two items, i.e. after first view and before second view, using an offset.
    ///
    /// Example:
    /// ```
    /// middleView.autoLayout(in: self).horizontallyBetween(firstView, and: secondView, margin: 10).activate()
    /// ```
    ///
    /// - Parameter first: first view
    /// - Parameter second: second view
    /// - Parameter margin: leading a trailing margin
    func horizontallyBetween(_ first: AnchorProviding, and second: AnchorProviding, margin: CGFloat) -> Self {
        return after(margin, to: first).before(margin, to: second)
    }
    
    /// Constrains source horizontally betwwen two items, i.e. after first view and before second view, using given relation.
    ///
    /// Example:
    /// ```
    /// middleView.autoLayout(in: self).horizontallyBetween(firstView, and: secondView, relation: .greaterThanOrEqual(to: 10, priority: .defaultHigh)).activate()
    /// ```
    ///
    /// - Parameter first: first view
    /// - Parameter second: second view
    /// - Parameter relation: relation
    func horizontallyBetween(_ first: AnchorProviding, and second: AnchorProviding, relation: LayoutConnectionSimpleRelation) -> Self {
        return after(relation: relation, to: first).before(relation: relation, to: second)
    }
    
    // MARK: Verically between
    
    /// Constrains source vertically betwwen two items, i.e. below first view and above second view.
    ///
    /// Example:
    /// ```
    /// middleView.autoLayout(in: self).verticallyBetween(firstView, and: secondView).activate()
    /// ```
    ///
    /// - Parameter first: first view
    /// - Parameter second: second view
    func verticallyBetween(_ first: AnchorProviding, and second: AnchorProviding) -> Self {
        return verticallyBetween(first, and: second, margin: 0)
    }
    
    /// Constrains source vertically betwwen two items, i.e. below first view and above second view, using an offset.
    ///
    /// Example:
    /// ```
    /// middleView.autoLayout(in: self).verticallyBetween(firstView, and: secondView, margin: 10).activate()
    /// ```
    ///
    /// - Parameter first: first view
    /// - Parameter second: second view
    /// - Parameter margin: leading a trailing margin
    func verticallyBetween(_ first: AnchorProviding, and second: AnchorProviding, margin: CGFloat) -> Self {
        return below(margin, to: first).above(margin, to: second)
    }
    
    /// Constrains source vertically betwwen two items, i.e. below first view and above second view, using given relation.
    ///
    /// Example:
    /// ```
    /// middleView.autoLayout(in: self).verticallyBetween(firstView, and: secondView, relation: .greaterThanOrEqual(to: 10, priority: .defaultHigh)).activate()
    /// ```
    ///
    /// - Parameter first: first view
    /// - Parameter second: second view
    /// - Parameter relation: relation
    func verticallyBetween(_ first: AnchorProviding, and second: AnchorProviding, relation: LayoutConnectionSimpleRelation) -> Self {
        return below(relation: relation, to: first).above(relation: relation, to: second)
    }
    
    // MARK: Width
    
    /// Constrains width anchor to given value.
    /// - Parameter value: value
    func width(_ value: CGFloat) -> Self {
        return width(relation: value.simpleRelation)
    }
    
    // MARK: Width to item
    
    /// Constrains width anchor to given item's width anchor.
    /// - Parameter item: item
    func width(to item: AnchorProviding) -> Self {
        return width(to: item, constant: 0)
    }
    
    /// Constrains width anchor to given item's width anchor with a constant.
    /// - Parameter item: item
    /// - Parameter constant: constant
    func width(to item: AnchorProviding, constant: CGFloat) -> Self {
        return width(to: item, multiplier: 1, constant: constant)
    }
    
    /// Constrains width anchor to given item's width anchor with a multiplier.
    /// - Parameter item: item
    /// - Parameter multiplier: multiplier
    func width(to item: AnchorProviding, multiplier: CGFloat) -> Self {
        return width(to: item, multiplier: multiplier, constant: 0)
    }
    
    /// Constrains width anchor to given item's width anchor with a multiplier and a constant
    /// - Parameter item: item
    /// - Parameter multiplier: multiplier
    /// - Parameter constant: constrant
    func width(to item: AnchorProviding, multiplier: CGFloat, constant: CGFloat) -> Self {
        return width(to: item, multiplier: multiplier, constant: constant, priority: .required)
    }
    
    /// Constrains width anchor to given item's width anchor with a multiplier, a constant and a priority.
    /// - Parameter item: item
    /// - Parameter multiplier: multiplier
    /// - Parameter constant: constant
    /// - Parameter priority: priority
    func width(to item: AnchorProviding, multiplier: CGFloat, constant: CGFloat, priority: UILayoutPriority) -> Self {
        return width(to: item.widthAnchor, multiplier: multiplier, constant: constant, priority: priority)
    }
    
    // MARK: Width to anchor
    
    /// Constrains width anchor to given anchor.
    /// - Parameter anchor: anchor
    func width(to anchor: NSLayoutDimension) -> Self {
        return width(to: anchor, constant: 0)
    }
    
    /// Constrains width anchor to given anchor with a constant.
    /// - Parameter anchor: anchor
    /// - Parameter constant: constant
    func width(to anchor: NSLayoutDimension, constant: CGFloat) -> Self {
        return width(to: anchor, multiplier: 1, constant: constant)
    }
    
    /// Constrains width anchor to given anchor with a multiplier.
    /// - Parameter anchor: anchor
    /// - Parameter multiplier: multiplier
    func width(to anchor: NSLayoutDimension, multiplier: CGFloat) -> Self {
        return width(to: anchor, multiplier: multiplier, constant: 0)
    }
    
    /// Constrains width anchor to given anchor with a multiplier and a constant.
    /// - Parameter anchor: anchor
    /// - Parameter multiplier: multiplier
    /// - Parameter constant: constant
    func width(to anchor: NSLayoutDimension, multiplier: CGFloat, constant: CGFloat) -> Self {
        return width(to: anchor, multiplier: multiplier, constant: constant, priority: .required)
    }
    
    /// Constrains width anchor to given anchor with a multiplier, a constant and a priority.
    /// - Parameter anchor: anchor
    /// - Parameter multiplier: multiplier
    /// - Parameter constant: constant
    /// - Parameter priority: priority
    func width(to anchor: NSLayoutDimension, multiplier: CGFloat, constant: CGFloat, priority: UILayoutPriority) -> Self {
        return width(relation: .equal(to: anchor, multiplier: multiplier, constant: constant, priority: priority))
    }
    
    // MARK: Height
    
    /// Constains height anchor to given value.
    /// - Parameter value: value
    func height(_ value: CGFloat) -> Self {
        return height(relation: value.simpleRelation)
    }
    
    // MARK: Height to item
    
    /// Constrains height anchor to given item's height anchor.
    /// - Parameter item: item
    func height(to item: AnchorProviding) -> Self {
        return height(to: item, constant: 0)
    }
    
    /// Constrains height anchor to given item's height anchor with a constant.
    /// - Parameter item: item
    /// - Parameter constant: constant
    func height(to item: AnchorProviding, constant: CGFloat) -> Self {
        return height(to: item, multiplier: 1, constant: constant)
    }
    
    /// Constrains height anchor to given item's height anchor with a multiplier.
    /// - Parameter item: item
    /// - Parameter multiplier: multiplier
    func height(to item: AnchorProviding, multiplier: CGFloat) -> Self {
        return height(to: item, multiplier: multiplier, constant: 0)
    }
    
    /// Constrains height anchor to given item's height anchor with a multiplier and a constant
    /// - Parameter item: item
    /// - Parameter multiplier: multiplier
    /// - Parameter constant: constrant
    func height(to item: AnchorProviding, multiplier: CGFloat, constant: CGFloat) -> Self {
        return height(to: item, multiplier: multiplier, constant: constant, priority: .required)
    }
    
    /// Constrains height anchor to given item's height anchor with a multiplier, a constant and a priority.
    /// - Parameter item: item
    /// - Parameter multiplier: multiplier
    /// - Parameter constant: constant
    /// - Parameter priority: priority
    func height(to item: AnchorProviding, multiplier: CGFloat, constant: CGFloat, priority: UILayoutPriority) -> Self {
        return height(to: item.heightAnchor, multiplier: multiplier, constant: constant, priority: priority)
    }
    
    // MARK: Height to anchor
    
    /// Constrains height anchor to given anchor.
    /// - Parameter anchor: anchor
    func height(to anchor: NSLayoutDimension) -> Self {
        return height(to: anchor, constant: 0)
    }
    
    /// Constrains height anchor to given anchor with a constant.
    /// - Parameter anchor: anchor
    /// - Parameter constant: constant
    func height(to anchor: NSLayoutDimension, constant: CGFloat) -> Self {
        return height(to: anchor, multiplier: 1, constant: constant)
    }
    
    /// Constrains height anchor to given anchor with a multiplier.
    /// - Parameter anchor: anchor
    /// - Parameter multiplier: multiplier
    func height(to anchor: NSLayoutDimension, multiplier: CGFloat) -> Self {
        return height(to: anchor, multiplier: multiplier, constant: 0)
    }
    
    /// Constrains height anchor to given anchor with a multiplier and a constant.
    /// - Parameter anchor: anchor
    /// - Parameter multiplier: multiplier
    /// - Parameter constant: constant
    func height(to anchor: NSLayoutDimension, multiplier: CGFloat, constant: CGFloat) -> Self {
        return height(to: anchor, multiplier: multiplier, constant: constant, priority: .required)
    }
    
    /// Constrains height anchor to given anchor with a multiplier, a constant and a priority.
    /// - Parameter anchor: anchor
    /// - Parameter multiplier: multiplier
    /// - Parameter constant: constant
    /// - Parameter priority: priority
    func height(to anchor: NSLayoutDimension, multiplier: CGFloat, constant: CGFloat, priority: UILayoutPriority) -> Self {
        return height(relation: .equal(to: anchor, multiplier: multiplier, constant: constant, priority: priority))
    }
    
    // MARK: Equal heights
    
    /// Constrains heights of all given views to be equal.
    /// - Parameter views: views
    static func equalHeights(_ views: [UIView]) -> [AutoLayout<UIView>] {
        var layouts: [AutoLayout<UIView>] = []
        for firstRunView in views {
            for secondRunView in views where secondRunView != firstRunView {
                layouts.append(firstRunView.autoLayout.height(to: secondRunView))
            }
        }
        return layouts
    }
    
    // MARK: Equal widths
    
    /// Constrains widths of all given views to be equal.
    /// - Parameter views: views
    static func equalWidths(_ views: [UIView]) -> [AutoLayout<UIView>] {
        var layouts: [AutoLayout<UIView>] = []
        for firstRunView in views {
            for secondRunView in views where secondRunView != firstRunView {
                layouts.append(firstRunView.autoLayout.width(to: secondRunView))
            }
        }
        return layouts
    }
    
}
