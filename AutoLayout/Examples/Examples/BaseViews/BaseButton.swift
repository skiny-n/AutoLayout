//
//  BaseButton.swift
//  Examples
//
//  Created by Stanislav Novacek on 10/10/2019.
//  Copyright © 2019 Stanislav Novacek. All rights reserved.
//

import Foundation
import UIKit

open class BaseButton: UIButton {
    
    // Public
    
    public var onPressed: (() -> Void)?
    
    // Private
    
    // - outlets
    
    // - props
    
    // MARK: Lifecycle
    
    public init() {
        super.init(frame: .zero)
        setup()
    }
    
    required public init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        removeTarget(self, action: #selector(self.onTouchUpInside), for: .touchUpInside)
    }
    
    /// Called right after init.
    open func setup() {
        addTarget(self, action: #selector(self.onTouchUpInside), for: .touchUpInside)
    }
    
    // MARK: Public
    
    // MARK: Private
    
    @objc private func onTouchUpInside() {
        onPressed?()
    }
    
}
