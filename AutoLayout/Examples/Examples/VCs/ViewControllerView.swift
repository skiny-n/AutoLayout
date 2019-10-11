//
//  ViewControllerView.swift
//  Examples
//
//  Created by Stanislav Novacek on 10/10/2019.
//  Copyright © 2019 Stanislav Novacek. All rights reserved.
//

import Foundation
import UIKit
import AutoLayout

class ViewControllerView: BaseView {
    
    // Public
    
    // Private
    
    // - outlets
    private let container = UIView()
    
    // - props
    
    // MARK: Lifecycle
    
    override func setup() {
        super.setup()
        cornerRadius = 0
        backgroundColor = UIColor.color3.withAlphaComponent(0.2)
    }
    
    override func setupConstraints() {
        super.setupConstraints()
        
        // Safe area container
        container.autoLayout(in: self).fill(in: safeAreaLayoutGuide, margin: 8).activate()
        
        let view1 = BaseView.colored(to: .color1)
        let view2 = BaseView.colored(to: .color2)
        let view3 = BaseView.colored(to: .color3)
        let view4 = BaseView.colored(to: .color4)
        let view5 = BaseView.colored(to: .color5)
        
        // Layouts
        let layouts = [
            createLayout(for: [view1, view2, view3, view4, view5], container: container),
            createLayout(for: [view4, view5, view1, view2, view3], container: container),
            createLayout(for: [view2, view3, view4, view5, view1], container: container),
            createLayout(for: [view5, view1, view2, view3, view4], container: container),
            createLayout(for: [view3, view4, view5, view1, view2], container: container)
        ]
        
        // Buttons container
        let buttonsContainer = UIView()
        buttonsContainer.autoLayout(in: container).left().bottom().right().height(40).activate()
        
        // Create a button for every layout
        var buttons: [UIButton] = []
        for (index, layout) in layouts.enumerated() {
            
            // Title and color
            let button = BaseButton()
            button.layer.cornerRadius = 8
            button.backgroundColor = UIColor.color1.withAlphaComponent(0.7)
            button.setAttributedTitle(.init(string: "\(index + 1)", attributes: [
                .font: UIFont.systemFont(ofSize: 17, weight: .medium),
                .foregroundColor: UIColor.white
            ]), for: .normal)
            
            // Assign action to activate appropriate layout
            button.onPressed = {
                UIView.animate(withDuration: 1, delay: 0, usingSpringWithDamping: 0.9, initialSpringVelocity: 10, options: [.beginFromCurrentState], animations: { [unowned self] in
                    layouts.flatMap({ $0 }).deactivate()
                    layout.activate()
                    self.container.layoutIfNeeded()
                }, completion: nil)
            }
            
            buttons.append(button)
        }
        
        // Distribute the buttons horizontally
        buttonsContainer.autoLayout.distributeHorizontally(buttons, spacing: 8).activate()
        // And make their widths equal
        AutoLayout<UIView>.equalWidths(buttons).activate()
        
        // Activate first layout
        layouts.first?.activate()
    }
    
    // MARK: Public
    
    // MARK: Private
    
    private func createLayout(for views: [UIView], container: UIView) -> [AutoLayout<UIView>] {
        guard views.count == 5 else { return [] }
        
        let (view1, view2, view3, view4, view5) = (views[0], views[1], views[2], views[3], views[4])
        let spacing: CGFloat = 8
        
        return [
            view1.autoLayout(in: container).top().left().right().height(to: container, multiplier: 0.2),
            view2.autoLayout(in: container).below(spacing, to: view1).left().widthToParent(multiplier: 1.0/3, constant: -spacing),
            view3.autoLayout(in: container).top(to: view2).right().width(to: view2).height(to: view2),
            view4.autoLayout(in: container).centerVertically(to: view2).horizontallyBetween(view2, and: view3, margin: spacing).height(to: view2, multiplier: 0.75),
            view5.autoLayout(in: container).below(spacing, to: view3).left().right().height(to: view1).bottom(48)
        ]
    }
    
}
