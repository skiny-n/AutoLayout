//
//  AutoLayour+Distribution.swift
//  AutoLayout
//
//  Created by Stanislav Novacek on 02/10/2019.
//

import Foundation
import UIKit

public extension AutoLayout where Source: UIView {
    
    // MARK: Vertically
    
    /// Distributes given `UIView`s vertically inside receiver.
    /// - Parameter items: views to distribute
    func distributeVertically(_ items: [UIView]) -> [AutoLayout<UIView>] {
        return distributeVertically(items, spacing: 0)
    }
    
    /// Distributes given `UIView`s vertically inside receiver.
    /// - Parameter items: views to distribute
    /// - Parameter spacing: spacing between views
    func distributeVertically(_ items: [UIView], spacing: CGFloat) -> [AutoLayout<UIView>] {
        return distributeVertically(items, spacing: spacing, margin: .zero)
    }
    
    
    /// Distributes given `UIView`s vertically inside receiver.
    /// - Parameter items: views to distribute
    /// - Parameter spacing: spacing between views
    /// - Parameter margin: margin along the edges
    func distributeVertically(_ items: [UIView], spacing: CGFloat, margin: UIEdgeInsets) -> [AutoLayout<UIView>] {
        guard let source = source, items.isEmpty == false else { return [] }
        var layouts: [AutoLayout<UIView>] = []
        for (index, item) in items.enumerated() {
            // Leading, trailing
            item.autoLayout(in: source).leading(margin.left).trailing(margin.right).activate()
            // Top
            if index == 0 {
                item.autoLayout.top(margin.top).activate()
            } else {
                item.autoLayout.below(spacing, to: items[index - 1]).activate()
            }
            // Bottom
            if index == items.count - 1 {
                item.autoLayout.bottom(margin.bottom).activate()
            }
            layouts.append(item.autoLayout)
        }
        return layouts
    }
    
    // MARK: Horizontally
    
    /// Distributes given `UIView`s horizontally inside receiver.
    /// - Parameter items: views to distribute
    func distributeHorizontally(_ items: [UIView]) -> [AutoLayout<UIView>] {
        return distributeHorizontally(items, spacing: 0)
    }
    
    /// Distributes given `UIView`s horizontally inside receiver.
    /// - Parameter items: views to distribute
    /// - Parameter spacing: spacing between views
    func distributeHorizontally(_ items: [UIView], spacing: CGFloat) -> [AutoLayout<UIView>] {
        return distributeHorizontally(items, spacing: spacing, margin: .zero)
    }
    
    /// Distributes given `UIView`s horizontally inside receiver.
    /// - Parameter items: views to distribute
    /// - Parameter spacing: spacing between views
    /// - Parameter margin: margin along the edges
    func distributeHorizontally(_ items: [UIView], spacing: CGFloat, margin: UIEdgeInsets) -> [AutoLayout<UIView>] {
        guard let source = source, items.isEmpty == false else { return [] }
        var layouts: [AutoLayout<UIView>] = []
        for (index, item) in items.enumerated() {
            // Top, bottom
            item.autoLayout(in: source).top(margin.top).bottom(margin.bottom).activate()
            // Leading
            if index == 0 {
                item.autoLayout.leading(margin.left).activate()
            } else {
                item.autoLayout.after(spacing, to: items[index - 1]).activate()
            }
            // Trailing
            if index == items.count - 1 {
                item.autoLayout.trailing(margin.right).activate()
            }
            layouts.append(item.autoLayout)
        }
        return layouts
    }
    
}
