//
//  BaseView.swift
//  Examples
//
//  Created by Stanislav Novacek on 10/10/2019.
//  Copyright © 2019 Stanislav Novacek. All rights reserved.
//

import Foundation
import UIKit

open class BaseView: UIView {
    
    // Public
    
    public var cornerRadius: CGFloat {
        set { layer.cornerRadius = newValue }
        get { return layer.cornerRadius }
    }
    
    // Private
    
    // - outlets
    
    // - props
    
    // MARK: Lifecycle
    
    public init() {
        super.init(frame: .zero)
        setup()
    }
    
    public required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    /// Called right after init.
    open func setup() {
        setNeedsUpdateConstraints()
    }
    
    /// Called only once. Use this for initial constraints setup.
    open func setupConstraints() { }
    
    private var constraintsSetupDone = false
    open override func updateConstraints() {
        if constraintsSetupDone == false {
            setupConstraints()
            constraintsSetupDone = true
        }
        super.updateConstraints()
    }
    
    // MARK: Public
    
    // MARK: Private
    
}
