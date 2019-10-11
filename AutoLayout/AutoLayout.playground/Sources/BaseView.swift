import Foundation
import UIKit


open class BaseView: UIView {
    
    public var cornerRadius: CGFloat {
        set { layer.cornerRadius = newValue }
        get { return layer.cornerRadius }
    }
    
    public init() {
        super.init(frame: .zero)
        setup()
    }
    
    public required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    /// Called right after init.
    open func setup() {
        setupConstraints()
    }
    
    /// Called only once. Use this for initial constraints setup.
    open func setupConstraints() { }
    
}
