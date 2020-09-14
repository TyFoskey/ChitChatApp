//
//  KeyboardManager.swift
//  ChitChat
//
//  Created by ty foskey on 9/13/20.
//  Copyright © 2020 ty foskey. All rights reserved.
//

import UIKit
import SnapKit

protocol KeyboardDelegate: class {
    func dissmissKeyboard()
    func changingOffset(frame: CGRect)
}

class KeyboardManager: NSObject, UIGestureRecognizerDelegate {
    
    /// A callback that passes a `KeyboardNotification` as an input
    typealias EventCallback = (KeyboardNotification) -> Void
    
    // MARK: - Properties
    
    /// A weak reference to a view bounded to the top of the keyboard to act as an `InputAccessoryView`
    /// but kept within the bounds of the `UIViewController`s view
    weak var inputAccessoryView: UIView?
    
    /// A flag that indicates if a portion of the keyboard is visible on the screen
    private(set) var isKeyboardHidden = true
    
  //  var constraints: Constraints
    
    /// A weak reference to a `UICollectionView` that has been attached for interactive keyboard dismissal
    private weak var collectionView: UICollectionView?
    
    /// The `EventCallback` actions for each `KeyboardEvent`. Default value is EMPTY
    private var callbacks: [KeyboardEvent : EventCallback] = [:]
    
    /// The pan gesture that handles dragging on the `collectionView`
    private var panGesture: UIPanGestureRecognizer?
    
    /// A cached notification used as a starting point when a user dragging the `scrollView` down
    /// to interactively dismiss the keyboard
    private var cachedNotification: KeyboardNotification?
    
    /// A delegate method to informs the responder  of a `KeyboardEvent`
    weak var delegate: KeyboardDelegate?
    
    /// A bool indicating whether or not the keyboard is  currently being dragged by the user
    private var dragging = false
    
    
    // MARK: - Init
    
    /// Creates a `KeyboardManager` object an binds the view as fake `InputAccessoryView`
    ///
    /// - Parameter inputAccessoryView: The view to bind to the top of the keyboard but within its superview
    convenience init(inputAccessoryView: UIView) {
        self.init()
        self.bind(inputAccessoryView: inputAccessoryView)
    }
    
        
    /// Creates a `KeyboardManager` object that observes the state of the keyboard
    override init() {
        super.init()
        addObservers()
    }
    
    required init?(coder aDecoder: NSCoder) {
         fatalError("init(coder:) has not been implemented")
     }
    
    // MARK: - De-Initilization
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    
    // MARK: - Keyboard Observer
    
    
    /// Add an observer for each keyboard notification
    private func addObservers() {
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(keyboardWillShow(notification:)),
                                               name: UIResponder.keyboardWillShowNotification,
                                               object: nil)
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(keyboardDidShow(notification:)),
                                               name: UIResponder.keyboardDidShowNotification,
                                               object: nil)
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(keyboardWillHide(notification:)),
                                               name: UIResponder.keyboardWillHideNotification,
                                               object: nil)
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(keyboardDidHide(notification:)),
                                               name: UIResponder.keyboardDidHideNotification,
                                               object: nil)
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(keyboardWillChangeFrame(notification:)),
                                               name: UIResponder.keyboardWillChangeFrameNotification,
                                               object: nil)
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(keyboardDidChangeFrame(notification:)),
                                               name: UIResponder.keyboardDidChangeFrameNotification,
                                               object: nil)
    }
    
    
    // MARK: - Mutate Callback Dictionary
    
    /// Sets the `EventCallback` for a `KeyboardEvent`
    ///
    /// - Parameters:
    ///   - event: KeyboardEvent
    ///   - callback: EventCallback
    /// - Returns: Self
    @discardableResult
    func on(event: KeyboardEvent, do callback: EventCallback?) -> Self {
        callbacks[event] = callback
        return self
    }
    
    
    /// Constrains the `inputAccessoryView` to the bottom of its superview and sets the
    /// `.willChangeFrame` and `.willHide` event callbacks such that it mimics an `InputAccessoryView`
    /// that is bound to the top of the keyboard
    ///
    /// - Parameter inputAccessoryView: The view to bind to the top of the keyboard but within its superview
    /// - Returns: Self
    
    @discardableResult
    func bind(inputAccessoryView: UIView) -> Self {
        
        guard let superview = inputAccessoryView.superview else {
            fatalError("`inputAccessoryView` must have a superview")
        }
        
        self.inputAccessoryView = inputAccessoryView
        self.inputAccessoryView?.snp.makeConstraints { (make) in
            make.left.right.bottom.equalTo(superview)
        }
        
        let reconizer = UIPanGestureRecognizer(target: self, action: #selector(handlePanGestureRecognizer(recognizer:)))
        reconizer.delegate = self
        
        callbacks[.willShow] = {[weak self] (notification) in
            let keyboardHeight = notification.endFrame.height
            
            self?.animateAlongside(notification) {
                self?.inputAccessoryView?.snp.updateConstraints({ (make) in
                    make.bottom.equalTo(superview).offset(-keyboardHeight)
                })
                self?.inputAccessoryView?.superview?.layoutIfNeeded()
            }
        }
        
        callbacks[.willChangeFrame] = {[weak self] (notificaiton) in
            let keyboardHeight = notificaiton.endFrame.height
            guard self?.isKeyboardHidden == false else { return }
            self?.animateAlongside(notificaiton) {
                self?.inputAccessoryView?.snp.updateConstraints({ (make) in
                    make.bottom.equalTo(superview).offset(-keyboardHeight)
                })
                self?.inputAccessoryView?.superview?.layoutIfNeeded()
            }
        }
        
        callbacks[.willHide] = {[weak self] (notificaiton) in
            self?.animateAlongside(notificaiton) {
                self?.inputAccessoryView?.snp.updateConstraints({ (make) in
                    make.bottom.equalTo(0)
                })
                self?.inputAccessoryView?.superview?.layoutIfNeeded()
            }
        }
        
        return self

    }
    
    
    /// Adds a `UIPanGestureRecognizer` to the `scrollView` to enable interactive dismissal`
    ///
    /// - Parameter collectionView: UICollectionView
    /// - Returns: Self
    @discardableResult
    open func bind(to collectionView: UICollectionView) -> Self {
        self.collectionView = collectionView
        self.collectionView?.keyboardDismissMode = .interactive // allows dismissing keyboard interactively
        let recognizer = UIPanGestureRecognizer(target: self, action: #selector(handlePanGestureRecognizer))
        recognizer.delegate = self
        self.panGesture = recognizer
        self.collectionView?.addGestureRecognizer(recognizer)
        return self
    }
    

    // MARK: - Keyboard Notifications
    
    /// An observer method called last in the lifecycle of a keyboard becoming visible
    ///
    /// - Parameter notification: NSNotification
    @objc
    func keyboardDidShow(notification: NSNotification) {
        guard let keyboardNotification = KeyboardNotification(from: notification) else { return }
        callbacks[.didShow]?(keyboardNotification)
    }
    
    /// An observer method called last in the lifecycle of a keyboard becoming hidden
    ///
    /// - Parameter notification: NSNotification
    @objc
    func keyboardDidHide(notification: NSNotification) {
        isKeyboardHidden = true
        guard let keyboardNotification = KeyboardNotification(from: notification) else { return }
        callbacks[.didHide]?(keyboardNotification)
    }
    
    /// An observer method called third in the lifecycle of a keyboard becoming visible/hidden
    ///
    /// - Parameter notification: NSNotification
    @objc
    func keyboardDidChangeFrame(notification: NSNotification) {
        guard let keyboardNotification = KeyboardNotification(from: notification) else { return }
        callbacks[.didChangeFrame]?(keyboardNotification)
        cachedNotification = keyboardNotification
    }
    
    /// An observer method called first in the lifecycle of a keyboard becoming visible/hidden
    ///
    /// - Parameter notification: NSNotification
    @objc
    open func keyboardWillChangeFrame(notification: NSNotification) {
        guard let keyboardNotification = KeyboardNotification(from: notification) else { return }
        guard cachedNotification?.event != .willShow && cachedNotification?.event != .willHide else { return }
        callbacks[.willChangeFrame]?(keyboardNotification)
        cachedNotification = keyboardNotification
    }
    
    /// An observer method called second in the lifecycle of a keyboard becoming visible
    ///
    /// - Parameter notification: NSNotification
    @objc
    func keyboardWillShow(notification: NSNotification) {
        isKeyboardHidden = false
        guard let keyboardNotification = KeyboardNotification(from: notification) else { return }
        callbacks[.willShow]?(keyboardNotification)
    }
    
    /// An observer method called second in the lifecycle of a keyboard becoming hidden
    ///
    /// - Parameter notification: NSNotification
    @objc
    func keyboardWillHide(notification: NSNotification) {
        guard let keyboardNotification = KeyboardNotification(from: notification) else { return }
        callbacks[.willHide]?(keyboardNotification)
    }
    
    
    // MARK: - Helper Methods
    
    private func animateAlongside(_ notification: KeyboardNotification, animations: @escaping() -> Void) {
         UIView.animate(withDuration: notification.timeInterval, delay: 0, options: [notification.animationOptions, .allowAnimatedContent, .beginFromCurrentState], animations: animations, completion: nil)
    }
    
    
    // MARK: - UIGestureRecognizerDelegate
    
    
    /// Starts with the cached `KeyboardNotification` and calculates a new `endFrame` based
    /// on the `UIPanGestureRecognizer` then calls the `.willChangeFrame` `EventCallback` action
    ///
    /// - Parameter recognizer: UIPanGestureRecognizer
    @objc func handlePanGestureRecognizer(recognizer: UIPanGestureRecognizer) {
        
        guard
            var keyboardNotification = cachedNotification,
            let view = recognizer.view,
            let window = UIApplication.shared.windows.first
        else { return }
        
        let location = recognizer.location(in: view)
        let absoluteLocation = view.convert(location, to: view)
        
        switch recognizer.state {
            
        case .began:
            dragging = false
            
        case .changed:
            if inputAccessoryView!.frame.contains(absoluteLocation) || dragging == true {
                dragging = true
                var frame = keyboardNotification.endFrame
                frame.origin.y = max(absoluteLocation.y, window.bounds.height - frame.height)
                frame.size.height = window.bounds.height - frame.origin.y
                keyboardNotification.endFrame = frame
                delegate?.changingOffset(frame: frame)
            }
            
        case .ended:
            dragging = false
            
        default:
            break
            
        }
    }
    
    
    /// Only recieve a `UITouch` event when the `scrollView`'s keyboard dismiss mode is interactive
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        return collectionView?.keyboardDismissMode == .interactive
    }
    
    /// Only recognice simultaneous gestures when its the `panGesture`.
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return gestureRecognizer === panGesture
    }
    
}
