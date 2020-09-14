//
//  KeyboardNotification.swift
//  ChitChat
//
//  Created by ty foskey on 9/13/20.
//  Copyright © 2020 ty foskey. All rights reserved.
//

import UIKit

/// An object containing the key animation properties from NSNotification
 struct KeyboardNotification {
    
    // MARK: - Properties
    
    /// The event that triggered the transition
    let event: KeyboardEvent
    
    /// The animation length the keyboards transition
    let timeInterval: TimeInterval
    
    /// The animation properties of the keyboards transition
    let animationOptions: UIView.AnimationOptions
    
    /// The keyboards frame at the start of its transition
    var startFrame: CGRect
    
    /// The keyboards frame at the beginning of its transition
    var endFrame: CGRect
    
    /// Requires that the `NSNotification` is based on a `UIKeyboard...` event
    ///
    /// - Parameter notification: `KeyboardNotification`
    init?(from notification: NSNotification) {
        guard notification.event != .unknown else { return nil }
        self.event = notification.event
        self.timeInterval = notification.timeInterval ?? 0.25
        self.animationOptions = notification.animationOptions
        self.startFrame = notification.startFrame ?? .zero
        self.endFrame = notification.endFrame ?? .zero
    }
    
}
