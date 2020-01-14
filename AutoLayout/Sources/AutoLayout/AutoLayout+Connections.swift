//
//  AutoLayout+Connections.swift
//  AutoLayout
//
//  Created by Stanislav Novacek on 02/10/2019.
//

import Foundation
import UIKit

public extension AutoLayout {
    
    /// Returns all leading connections. Convenience, same as using `findAll(.leading)`.
    var leadingConnections: [Connection] { return findAll(.leading) }
    
    /// Returns all trailing connections. Convenience, same as using `findAll(.trailing)`.
    var trailingConnections: [Connection] { return findAll(.trailing) }
    
    /// Returns all left connections. Convenience, same as using `findAll(.left)`.
    var leftConnections: [Connection] { return findAll(.left) }
    
    /// Returns all right connections. Convenience, same as using `findAll(.right)`.
    var rightConnections: [Connection] { return findAll(.right) }
    
    /// Returns all top connections. Convenience, same as using `findAll(.top)`.
    var topConnections: [Connection] { return findAll(.top) }
    
    /// Returns all bottom connections. Convenience, same as using `findAll(.bottom)`.
    var bottomConnections: [Connection] { return findAll(.bottom) }
    
    /// Returns all width connections. Convenience, same as using `findAll(.width)`.
    var widthConnections: [Connection] { return findAll(.width) }
    
    /// Returns all height connections. Convenience, same as using `findAll(.height)`.
    var heightConnections: [Connection] { return findAll(.height) }
    
    /// Returns all centerX connections. Convenience, same as using `findAll(.centerX)`.
    var centerXConnections: [Connection] { return findAll(.centerX) }
    
    /// Returns all centerY connections. Convenience, same as using `findAll(.centerY)`.
    var centerYConnections: [Connection] { return findAll(.centerY) }
    
}

public extension AutoLayout {
    
    /// Returns the first leading connection. Convenience, same as using `findAll(.leading).first`.
    var firstLeadingConnection: Connection? { return findAll(.leading).first }
    
    /// Returns the first trailing connection. Convenience, same as using `findAll(.trailing).first`.
    var firstTrailingConnection: Connection? { return findAll(.trailing).first }
    
    /// Returns the first left connection. Convenience, same as using `findAll(.left).first`.
    var firstLeftConnection: Connection? { return findAll(.left).first }
    
    /// Returns the first right connection. Convenience, same as using `findAll(.right).first`.
    var firstRightConnection: Connection? { return findAll(.right).first }
    
    /// Returns the first top connection. Convenience, same as using `findAll(.top).first`.
    var firstTopConnection: Connection? { return findAll(.top).first }
    
    /// Returns the first bottom connection. Convenience, same as using `findAll(.bottom).first`.
    var firstBottomConnection: Connection? { return findAll(.bottom).first }
    
    /// Returns the first width connection. Convenience, same as using `findAll(.width).first`.
    var firstWidthConnection: Connection? { return findAll(.width).first }
    
    /// Returns the first height connection. Convenience, same as using `findAll(.height).first`.
    var firstHeightConnection: Connection? { return findAll(.height).first }
    
    /// Returns the first centerX connection. Convenience, same as using `findAll(.centerX).first`.
    var firstCenterXConnection: Connection? { return findAll(.centerX).first }
    
    /// Returns the first centerY connection. Convenience, same as using `findAll(.centerY).first`.
    var firstCenterYConnection: Connection? { return findAll(.centerY).first }
    
}

public extension AutoLayout where Source: UIView {
    
    /// Returns all firstBaseline connections. Convenience, same as using `findAll(.firstBaseline)`.
    var firstBaselineConnections: [Connection] { return findAll(.firstBaseline) }
    
    /// Returns all lastBaseline connections. Convenience, same as using `findAll(.lastBaseline)`.
    var lastBaselineConnections: [Connection] { return findAll(.lastBaseline) }
    
}
