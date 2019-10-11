import Foundation
import UIKit


open class BaseButton: UIButton {
    
    public var onPressed: (() -> Void)?
    
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
    
    open func setup() {
        addTarget(self, action: #selector(self.onTouchUpInside), for: .touchUpInside)
    }
    
    @objc private func onTouchUpInside() {
        onPressed?()
    }
    
}
