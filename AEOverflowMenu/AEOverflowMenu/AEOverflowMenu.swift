//
//  AEOverflowMenu.swift
//  AEOverflowMenu
//
//  Created by Social Local Mobile on 5/30/18.
//  Copyright © 2018 Addison Elliott. All rights reserved.
//

import UIKit


/// Type of animation to use for displaying/hiding the overflow menu
public enum AEAnimationOption {
    /// Overflow menu is faded in/out
    case Fade
    
    /// Overflow menu is expanded or collapsed from the selected anchor corner (see AEAnchorCorner)
    case Expand
    
    /// No animation when displaying or hiding the overflow menu
    case None
}

/// Anchor corner for the overflow menu and the connected button. The overflow menu will be constrained at this corner to the connected button
public enum AEAnchorCorner {
    /// Anchors overflow menu to the top-left corner of the connected button. If animation is set to expand, then the menu will be expanded/collapsed from this corner
    case TopLeft
    
    /// Anchors overflow menu to the top-right corner of the connected button. If animation is set to expand, then the menu will be expanded/collapsed from this corner
    case TopRight
    
    /// Anchors overflow menu to the bottom-left corner of the connected button. If animation is set to expand, then the menu will be expanded/collapsed from this corner
    case BottomLeft
    
    /// Anchors overflow menu to the bottom-right corner of the connected button. If animation is set to expand, then the menu will be expanded/collapsed from this corner
    case BottomRight
    
    /// Point that represents the normalized corner. X/Y values range from 0.0 to 1.0 and the origin is in the top-left hand corner
    var point: CGPoint {
        switch self {
        case .TopLeft:
            return CGPoint(x: 0.0, y: 0.0)
            
        case .TopRight:
            return CGPoint(x: 1.0, y: 0.0)
            
        case .BottomLeft:
            return CGPoint(x: 0.0, y: 1.0)
            
        case .BottomRight:
            return CGPoint(x: 1.0, y: 1.0)
        }
    }
}

struct AEOverflowItem {
    var name: String
    var callback: (() -> Void)?
}

/// Menu that displays additional options. This is connected to a button so that the menu is shown when clicked and hidden when clicked away from the menu. This type of menu is common in Android applications.
/// Overflow menu that displays additional buttons
@IBDesignable public class AEOverflowMenu: UIView, UITableViewDelegate, UITableViewDataSource, UIGestureRecognizerDelegate {
    // MARK: Private variables and constants
    
    private var tableView: UITableView!
    private var items: [AEOverflowItem] = [AEOverflowItem]()
    
    // MARK: Properties
    
    @IBInspectable public var normalBackgroundColor: UIColor? = .white {
        didSet {
            tableView.reloadData()
        }
    }
    
    @IBInspectable public var highlightedBackgroundColor: UIColor? {
        didSet {
            tableView.reloadData()
        }
    }
    
    @IBInspectable public var cornerRadius: CGFloat {
        get {
            return layer.cornerRadius
        }
        set {
            layer.cornerRadius = newValue
        }
    }
    
    @IBInspectable public var borderWidth: CGFloat {
        get {
            return layer.borderWidth
        }
        set {
            layer.borderWidth = newValue
        }
    }
    
    @IBInspectable public var borderColor: UIColor? {
        get {
            if let color = layer.borderColor {
                return UIColor(cgColor: color)
            }
            return nil
        }
        set {
            if let color = newValue {
                layer.borderColor = color.cgColor
            } else {
                layer.borderColor = nil
            }
        }
    }
    
    @IBInspectable public var shadowRadius: CGFloat {
        get {
            return layer.shadowRadius
        }
        set {
            layer.shadowRadius = newValue
        }
    }
    
    @IBInspectable public var shadowOpacity: Float {
        get {
            return layer.shadowOpacity
        }
        set {
            layer.shadowOpacity = newValue
        }
    }
    
    @IBInspectable public var shadowOffset: CGSize {
        get {
            return layer.shadowOffset
        }
        set {
            layer.shadowOffset = newValue
        }
    }
    
    @IBInspectable public var shadowColor: UIColor? {
        get {
            if let color = layer.shadowColor {
                return UIColor(cgColor: color)
            }
            return nil
        }
        set {
            if let color = newValue {
                layer.shadowColor = color.cgColor
            } else {
                layer.shadowColor = nil
            }
        }
    }
    
    @IBInspectable public var textColor: UIColor = .black {
        didSet {
            tableView.reloadData()
        }
    }
    
    @IBInspectable public var textFont: UIFont = .systemFont(ofSize: 19.0) {
        didSet {
            tableView.reloadData()
        }
    }
    
    @IBInspectable public var itemHeight: CGFloat = 50.0 {
        didSet {
            tableView.reloadData()
        }
    }
    
    public var animationShowType: AEAnimationOption = .Expand
    public var animationShowDuration: Double = 0.25
    
    public var animationHideType: AEAnimationOption = .Fade
    public var animationHideDuration: Double = 0.4
    
    public var cornerAnchor: AEAnchorCorner = .TopRight
    
    // MARK: Private functions
    
    override public init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    private func setup() {
        // Start menu hidden until toggled on and button is linked
        isHidden = true
        
        // Setup the default shadow
        shadowColor = .lightGray
        shadowRadius = 10
        shadowOffset = .zero
        shadowOpacity = 1.0
        
        tableView = UITableView(frame: .zero, style: .plain)
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "MyCell")
        tableView.isScrollEnabled = false
        tableView.delegate = self
        tableView.dataSource = self
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.separatorStyle = .none
        addSubview(tableView)
        
        // Constrain table view inside of parent view
        if #available(iOS 9.0, *) {
            tableView.leftAnchor.constraint(equalTo: leftAnchor).isActive = true
            tableView.rightAnchor.constraint(equalTo: rightAnchor).isActive = true
            tableView.topAnchor.constraint(equalTo: topAnchor).isActive = true
            tableView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        } else {
            NSLayoutConstraint(item: tableView, attribute: .left, relatedBy: .equal, toItem: self, attribute: .left, multiplier: 1, constant: 0).isActive = true
            NSLayoutConstraint(item: tableView, attribute: .right, relatedBy: .equal, toItem: self, attribute: .right, multiplier: 1, constant: 0).isActive = true
            NSLayoutConstraint(item: tableView, attribute: .top, relatedBy: .equal, toItem: self, attribute: .top, multiplier: 1, constant: 0).isActive = true
            NSLayoutConstraint(item: tableView, attribute: .bottom, relatedBy: .equal, toItem: self, attribute: .bottom, multiplier: 1, constant: 0).isActive = true
        }
    }
    
    /// Setup the overflow menu
    ///
    /// This method does two things:
    ///
    /// 1. Adds gesture recognizer to the parent view controller so that taps outside of the oveflow menu can be registered to hide the menu
    /// 2. Given a button or navigation bar button, this menu will be constrained to the button (menu will be constrained to the corner specified in cornerAnchor) and a callback will be setup for the button to toggle the menu when clicked
    ///
    /// Only button or barButton should be specified, never both. If neither buttons are set, then the menu will not be constrained and no callback will be set. Therefore, this must be done manually in the view controller.
    ///
    /// This should be called in viewDidLoad method of UIViewController
    ///
    /// - Parameters:
    ///   - viewController: Parent view controller that this view is a child of
    ///   - button: Button that should trigger the overflow menu
    ///   - barButton: Navigation bar button that should trigger the overflow menu
    public func setup(_ viewController: UIViewController, button: UIButton? = nil, barButton: UIBarButtonItem? = nil) {
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(viewTapped(sender:)))
        tapGestureRecognizer.delegate = self
        viewController.view.addGestureRecognizer(tapGestureRecognizer)
        
        var anchorView: UIView?
        
        // Either a UIButton or UIBarButton can be set, check which one is set and go from there
        // The anchor view is the view that the menu will be constrained to if specified
        // Also, a callback is set for the button (or bar button) to toggle the menu when clicked
        if let button = button {
            anchorView = button
            
            button.addTarget(self, action: #selector(buttonClicked), for: .touchUpInside)
        } else if let barButton = barButton {
            anchorView = barButton.customView
            
            barButton.target = self
            barButton.action = #selector(buttonClicked)
        }
        
        // Note: Make sure that the correct expand corner is set
        if let view = anchorView {
            if #available(iOS 9.0, *) {
                switch cornerAnchor {
                case .TopLeft:
                    topAnchor.constraint(equalTo: view.topAnchor).isActive = true
                    leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
                    
                case .TopRight:
                    topAnchor.constraint(equalTo: view.topAnchor).isActive = true
                    rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
                    
                case .BottomLeft:
                    bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
                    leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
                    
                case .BottomRight:
                    bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
                    rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
                }
            } else {
                switch cornerAnchor {
                case .TopLeft:
                    NSLayoutConstraint(item: self, attribute: .top, relatedBy: .equal, toItem: view, attribute: .top, multiplier: 1, constant: 0).isActive = true
                    NSLayoutConstraint(item: self, attribute: .left, relatedBy: .equal, toItem: view, attribute: .left, multiplier: 1, constant: 0).isActive = true
                    
                case .TopRight:
                    NSLayoutConstraint(item: self, attribute: .top, relatedBy: .equal, toItem: view, attribute: .top, multiplier: 1, constant: 0).isActive = true
                    NSLayoutConstraint(item: self, attribute: .right, relatedBy: .equal, toItem: view, attribute: .right, multiplier: 1, constant: 0).isActive = true
                    
                case .BottomLeft:
                    NSLayoutConstraint(item: self, attribute: .bottom, relatedBy: .equal, toItem: view, attribute: .bottom, multiplier: 1, constant: 0).isActive = true
                    NSLayoutConstraint(item: self, attribute: .left, relatedBy: .equal, toItem: view, attribute: .left, multiplier: 1, constant: 0).isActive = true
                    
                case .BottomRight:
                    NSLayoutConstraint(item: self, attribute: .bottom, relatedBy: .equal, toItem: view, attribute: .bottom, multiplier: 1, constant: 0).isActive = true
                    NSLayoutConstraint(item: self, attribute: .right, relatedBy: .equal, toItem: view, attribute: .right, multiplier: 1, constant: 0).isActive = true
                }
            }
        }
    }
    
    /// Setup the overflow menu.
    ///
    /// This method does two things:
    ///
    /// 1. Adds gesture recognizer to the parent view controller so that taps outside of the oveflow menu can be registered to hide the menu
    /// 2. This menu will be constrained to the button (menu will be constrained to the corner specified in cornerAnchor) and a callback will be setup for the button to toggle the menu when clicked
    ///
    /// This should be called in viewDidLoad method of UIViewController
    ///
    /// - Parameters:
    ///   - viewController: Parent view controller that this view is a child of
    ///   - button: Button that should trigger the overflow menu
    public func setup(_ viewController: UIViewController, button: UIButton) {
        setup(viewController, button: button, barButton: nil)
    }
    
    /// Setup the overflow menu.
    ///
    /// This method does two things:
    ///
    /// 1. Adds gesture recognizer to the parent view controller so that taps outside of the oveflow menu can be registered to hide the menu
    /// 2. This menu will be constrained to the button (menu will be constrained to the corner specified in cornerAnchor) and a callback will be setup for the button to toggle the menu when clicked
    ///
    /// This should be called in viewDidLoad method of UIViewController
    ///
    /// - Parameters:
    ///   - viewController: Parent view controller that this view is a child of
    ///   - barButton: Navigation bar button that should trigger the overflow menu
    public func setup(_ viewController: UIViewController, barButton: UIBarButtonItem) {
        setup(viewController, button: nil, barButton: barButton)
    }
    
    @objc func buttonClicked() {
        // Toggle menu
        toggle()
    }
    
    @objc func viewTapped(sender: UITapGestureRecognizer) {
        if !isHidden {
            hide()
        }
    }
    
    override public func prepareForInterfaceBuilder() {
        if #available(iOS 8.0, *) {
            super.prepareForInterfaceBuilder()
        }
        
        invalidateIntrinsicContentSize()
    }
    
    // MARK: Layout functions
    
    override public func layoutSubviews() {
        super.layoutSubviews()
        
        // Numerous reports that setting the shadowPath is best to increase performance
        layer.shadowPath = UIBezierPath(rect: bounds).cgPath
    }
    
    public override var intrinsicContentSize: CGSize {
        // 220 was emperically found to yield the best results
        // The width is approximately the same as the size of the overflow menu in Android
        return CGSize(width: 220, height: tableView.contentSize.height)
    }
    
    // MARK: Tap gesture recognizer delegate functions
    
    public func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        // Gesture recognizer is only used for hiding the menu when clicking outside the overflow menu
        // So do not recognize the gesture if clicking in the overflow menu
        return !(touch.view?.isDescendant(of: self) ?? false)
    }
    
    // MARK: Table view delegate functions
    
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // Call function if one is set
        if let callback = items[indexPath.row].callback {
            callback()
        }
        
        // Deselect the current row
        tableView.deselectRow(at: indexPath, animated: false)
        
        // Hide the menu
        hide()
    }
    
    public func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return itemHeight
    }
    
    public func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return itemHeight
    }
    
    // MARK: Table view data source functions
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MyCell", for: indexPath as IndexPath)
        
        cell.backgroundColor = normalBackgroundColor
        cell.selectedBackgroundView?.backgroundColor = highlightedBackgroundColor

        cell.textLabel?.textColor = textColor
        cell.textLabel?.font = textFont
        cell.textLabel?.backgroundColor = .clear
        cell.textLabel?.text = items[indexPath.row].name
        
        return cell
    }
    
    // TODO: Create a nice test/demo
    // TODO: Create README and documentation for the library
    // TODO: Forgot to doucment the properties
    
    // MARK: Item related functions
    
    /// Add an item to the menu
    ///
    /// - Parameters:
    ///   - name: text to display on the overflow menu
    ///   - callback: function that will be called when the item is clicked in the menu
    public func addItem(_ name: String, callback: (() -> Void)? = nil) {
        items.append(AEOverflowItem(name: name, callback: callback))
        
        tableView.reloadData()
        invalidateIntrinsicContentSize()
    }
    
    /// Remove menu item at given index
    ///
    /// - Parameter at: zero-based index
    public func removeItem(at: Int) {
        items.remove(at: at)
        
        tableView.reloadData()
        invalidateIntrinsicContentSize()
    }
    
    /// Remove all items from the menu
    public func removeAllItems() {
        items.removeAll()
        
        tableView.reloadData()
        invalidateIntrinsicContentSize()
    }
    
    // MARK: Showing/hiding the menu
    
    /// Show the menu
    ///
    /// Does nothing if the menu is already shown
    ///
    /// - Parameter animated: whether to animate the menu in. If true, then the animation will be performed based on the animation type selected (animationShowType)
    public func show(_ animated: Bool = true) {
        // Do nothing if already showing menu
        if !isHidden {
            return
        }
        
        if !animated {
            isHidden = false
            setNeedsLayout()
            return
        }
        
        // Whether animating or not, set isHidden to false to show the menu
        // Animation will change other properties to animate showing the menu
        isHidden = false
        
        switch animationShowType {
        case .Expand:
            // Set anchor point to be upper right corner where the button is located
            let oldFrame = frame
            layer.anchorPoint = cornerAnchor.point
            frame = oldFrame
            
            // Start by setting scale of the menu to be 0, meaning it's not displayed
            transform = CGAffineTransform.init(scaleX: 0.0, y: 0.0)
            
            UIView.animate(withDuration: animationShowDuration, delay: 0.0, options: .curveLinear, animations: {
                self.transform = .identity
            }) { (finished) in
                // Restore the anchor point to the center
                let oldFrame = self.frame
                self.layer.anchorPoint = CGPoint(x: 0.5, y: 0.5)
                self.frame = oldFrame
            }
            
        case .Fade:
            // Begin by hiding menu with alpha = 0
            alpha = 0.0
            
            UIView.animate(withDuration: animationShowDuration, delay: 0.0, options: .curveEaseIn, animations: {
                self.alpha = 1.0
            }, completion: nil)
            
        case .None:
            return
        }
    }
    
    /// Hide the menu
    ///
    /// Does nothing if the menu is already hidden
    ///
    /// - Parameter animated: whether to animate the menu out. If true, then the animation will be performed based on the animation type selected (animationHideType)
    public func hide(_ animated: Bool = true) {
        // Do nothing if menu is already hidden
        if isHidden {
            return
        }
        
        if !animated {
            isHidden = true
            setNeedsLayout()
            return
        }
        
        switch animationHideType {
        case .Expand:
            isHidden = false
            
            // Set anchor point to be upper right corner where the button is located
            let oldFrame = frame
            layer.anchorPoint = cornerAnchor.point
            frame = oldFrame
            
            // Set transform to identity, meaning menu is displayed normally
            transform = .identity
            
            UIView.animate(withDuration: animationHideDuration, delay: 0.0, options: .curveLinear, animations: {
                // Cannot scale to 0 because this effectively returns a zero matrix and causes
                // issues in the animation.
                self.transform = CGAffineTransform(scaleX: 0.001, y: 0.001)
            }) { (finished) in
                // Reset transform and set to hidden once animation is complete
                self.transform = .identity
                self.isHidden = true
                
                // Restore the anchor point to the center
                let oldFrame = self.frame
                self.layer.anchorPoint = CGPoint(x: 0.5, y: 0.5)
                self.frame = oldFrame
            }
            
        case .Fade:
            isHidden = false
            alpha = 1.0
            
            UIView.animate(withDuration: animationHideDuration, delay: 0.0, options: .curveEaseOut, animations: {
                self.alpha = 0.0
            }) { (finished) in
                // Reset alpha and set to hidden once complete
                self.alpha = 1.0
                self.isHidden = true
            }
            
        case .None:
            isHidden = true
            setNeedsLayout()
        }
    }
    
    /// Toggle the visibility of the menu
    ///
    /// - Parameter animated: whether to animate the menu in/out. If true, then the animation will be performed based on the animation type selected (animationShowType or animationHideType)
    public func toggle(_ animated: Bool = true) {
        if isHidden {
            show(animated)
        } else {
            hide(animated)
        }
    }
}
