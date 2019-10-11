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

public extension AutoLayout where Source: UIView {
    
    /// Returns all firstBaseline connections. Convenience, same as using `findAll(.firstBaseline)`.
    var firstBaselineConnections: [Connection] { return findAll(.firstBaseline) }
    
    /// Returns all lastBaseline connections. Convenience, same as using `findAll(.lastBaseline)`.
    var lastBaselineConnections: [Connection] { return findAll(.lastBaseline) }
    
}
