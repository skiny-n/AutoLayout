//
//  Protocols.swift
//  AutoLayout
//
//  Created by Stanislav Novacek on 02/10/2019.
//

import Foundation
import UIKit


/// Represents an object that provides anchors.
public protocol AnchorProviding: AnyObject {
    
    var leadingAnchor: NSLayoutXAxisAnchor { get }
    var trailingAnchor: NSLayoutXAxisAnchor { get }
    var leftAnchor: NSLayoutXAxisAnchor { get }
    var rightAnchor: NSLayoutXAxisAnchor { get }
    var topAnchor: NSLayoutYAxisAnchor { get }
    var bottomAnchor: NSLayoutYAxisAnchor { get }
    var widthAnchor: NSLayoutDimension { get }
    var heightAnchor: NSLayoutDimension { get }
    var centerXAnchor: NSLayoutXAxisAnchor { get }
    var centerYAnchor: NSLayoutYAxisAnchor { get }
    
}

/// Represents an object that provides baseline anchors.
public protocol BaselineAnchorProviding: AnchorProviding {
    
    var firstBaselineAnchor: NSLayoutYAxisAnchor { get }
    var lastBaselineAnchor: NSLayoutYAxisAnchor { get }
    
}

/// Auto layout connection. Wraps an `NSLayoutConstraint` object.
public protocol LayoutConnection {
    
    var type: LayoutConnectionType { get }
    var constant: CGFloat { get set }
    var priority: UILayoutPriority { get set }
    var isActive: Bool { get set }
    var constraint: NSLayoutConstraint { get }
    
}

/// Represents an object providing a safe area layout guide.
public protocol SafeAreaProviding {
    
    var safeAreaLayoutGuide: UILayoutGuide { get }
    
}

/// Represents an object providing a layout margin guide.
public protocol MarginGuideProviding {
    
    var layoutMarginsGuide: UILayoutGuide { get }
    
}

/// Represents an object providing a readable content guide.
public protocol ReadableContentGuideProviding {
    
    var readableContentGuide: UILayoutGuide { get }
    
}
