//
//  LDOptionButton.swift
//  LDOptionButton
//
//  Created by Lajos Deme on 2021. 04. 03..
//

import UIKit

//MARK: - Side button config
/**
 Struct for configuring the look of the side buttons.
 */
public struct SideButtonConfig {
    var backgroundColor: UIColor
    var normalIcon: String?
    public init(backgroundColor: UIColor, normalIcon: String?) {
        self.backgroundColor = backgroundColor
        self.normalIcon = normalIcon
    }
}

//MARK: - Option Button Delegate
/**
 Option Button Delegate protocol
 */
public protocol LDOptionButtonDelegate {
    
    /**
     Tells the delegate that a button at a particular index will be selected.
     
     - parameter optionButton: The OptionButton object whose side button will be selected.
     - parameter button: The side button object that will be selected.
     - parameter atIndex: The index of the button that will be selected.
     */
    func optionButton(optionButton: LDOptionButton, willSelect button: UIButton, atIndex: Int)
    
    /**
     Tells the delegate that a button at a particular index was selected.
     
     - parameter optionButton: The OptionButton object whose side button was selected.
     - parameter button: The side button object that was selected.
     - parameter atIndex: The index pf the button that was selected.
     */
    func optionButton(optionButton: LDOptionButton, didSelect button: UIButton, atIndex: Int)
    
    /**
     Tells the delegate that the OptionButton was selected and the options are displayed.
     - parameter options: The OptionButton whose options were opened.
     */
    func optionButton(didOpen options: LDOptionButton)
    /**
     Tells the delegate that the OptionButton was deselected and the options are now hidden.
     - parameter options: The OptionButton whose options were closed.
     */
    func optionButton(didClose options: LDOptionButton)
}

public class LDOptionButton: UIButton {
    
    ///Count of the side buttons
    @IBInspectable
    open var buttonsCount: Int = 0
    
    ///The duration it takes for a button to move from behind the previous button to its actual position.
    @IBInspectable
    open var duration: Double = 0.2
    
    ///The side button's distance from the option button.
    @IBInspectable
    open var distance: CGFloat = 50
    
    
    ///The angle at which the first button should appear.
    @IBInspectable
    open var startAngle: CGFloat = 0 {
        didSet {
            startAngle -= 180
        }
    }
    
    ///The angle at which the last button should appear.
    @IBInspectable
    open var endAngle: CGFloat = 360 {
        didSet {
            endAngle -= 180
        }
    }
    
    ///The icon to show in the button when it is not selected.
    @IBInspectable
    open var normalIcon: String? {
        didSet {
            setImage(UIImage(named: normalIcon ?? ""), for: .normal)
        }
    }
    
    ///The icon to show in the button when it is selected.
    @IBInspectable
    open var selectedIcon: String?
    
    ///The size of the side buttons.
    @IBInspectable
    open var sideButtonSize: CGSize = CGSize(width: 20, height: 20)
    
    ///The config options for the side buttons.
    open var sideButtonConfigs: [SideButtonConfig]!
    
    ///Returns whether the button is selected.
    private(set) public var buttonSelected: Bool = false
    private(set) public var buttons: [UIButton]?
    private var buttonsContainer: ButtonsContainer?

    open var delegate: LDOptionButtonDelegate?
    
    //MARK: - Init
    /**
     Creates and returns a new OptionButton object.
     - parameter frame: The button's size and location in its superview's coordinate space.
     - parameter normalIcon: The name of the image to be displayed in the button when it is not selected.
     - parameter selectedIcon: The name of the image to be displayed in the button when it is selected.
     - parameter buttonsCount: The number of side buttons to display.
     - parameter sideButtonConfigs: An array of SideButtonConfig objects. These will be used to format the side buttons at the corresponding indexes.
     - parameter duration: The duration it takes for a button to move from behind the previous button to its actual position.
     */
    public init(frame: CGRect, normalIcon: String?, selectedIcon: String?, buttonsCount: Int = 3, sideButtonConfigs: [SideButtonConfig], duration: Double = 0.2) {
        super.init(frame: frame)
        self.buttonsCount = buttonsCount
        self.sideButtonConfigs = sideButtonConfigs
        self.duration = duration
        self.normalIcon = normalIcon
        self.selectedIcon = selectedIcon
        
        if let normal = normalIcon {
            setImage(UIImage(named: normal), for: .normal)
        }
        
        sideButtonSize = CGSize(width: self.bounds.width / 1.3, height: self.bounds.height / 1.3)
        commonInit()
    }
    
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    private func commonInit() {
        layer.cornerRadius = bounds.width / 2
        addTap()
    }
    
    //MARK: - Hide/show buttons
    /**
     Hides the side buttons programatically.
     - parameter triggerDelegate: Specifies whether the delegate method should be triggered. Defaults to true.
     */
    public func hideButtons(triggerDelegate: Bool = true) {
        guard buttons != nil && !buttons!.isEmpty else {return}
        buttonSelected = !buttonSelected
        animateCenterButton(self)
        
        buttons!.forEach({ (button) in
            self.hideSideButtons(button)
        })
        if triggerDelegate {
            delegate?.optionButton(didClose: self)
        }
    }
    
    /**
     Shows the side buttons programatically.
     - parameter triggerDelegate: Specifies whether the delegate method should be triggered. Defaults to true.
     */
    public func showButtons(triggerDelegate: Bool = true) {
        guard !buttonSelected else {return}
        buttonSelected = !buttonSelected
        animateCenterButton(self)
        
        createButtonsContainer()
        createButtons()
        if triggerDelegate {
            delegate?.optionButton(didOpen: self)
        }
    }
    
    //MARK: - Create buttons container
    //Creates the container that will hold all the side buttons.
    private func createButtonsContainer() {
        guard buttonsContainer == nil else {return}
        
        buttonsContainer = ButtonsContainer()
        buttonsContainer!.translatesAutoresizingMaskIntoConstraints = false
        superview?.insertSubview(buttonsContainer!, belowSubview: self)
        
        buttonsContainer?.heightAnchor.constraint(equalToConstant: (distance * 2) + bounds.height + sideButtonSize.height).isActive = true
        buttonsContainer?.widthAnchor.constraint(equalToConstant: (distance * 2) + bounds.width + sideButtonSize.width).isActive = true
        buttonsContainer?.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        buttonsContainer?.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        
        buttonsContainer?.backgroundColor = .clear
        buttonsContainer!.layer.cornerRadius = ((distance * 2) + bounds.width + sideButtonSize.width) / 2
    }
    
    //MARK: - Create buttons
    //Creates, configures and animates every side button.
    private func createButtons() {
        guard buttonsContainer != nil, buttons == nil || buttons!.isEmpty else {return}

        let step = getArcStep()

        for i in 0..<buttonsCount {
            let angle: CGFloat = startAngle + CGFloat(i) * step
            let xy = getPoint(for: Int(angle))

            let button = UIButton(frame: CGRect(x: xy.x - (sideButtonSize.width / 2), y: xy.y - (sideButtonSize.height / 2), width: sideButtonSize.width, height: sideButtonSize.height))
            button.layer.cornerRadius = sideButtonSize.width / 2
            button.layer.opacity = 0
            button.tag = i
            button.addTarget(self, action: #selector(sideButtonTapAction(_:)), for: .touchUpInside)
            
            if sideButtonConfigs != nil && sideButtonConfigs.count > i {
                let config = sideButtonConfigs[i]
                button.backgroundColor = config.backgroundColor
                button.setImage(UIImage(named: config.normalIcon ?? ""), for: .normal)
            } else {
                button.backgroundColor = backgroundColor
            }
            
            buttonsContainer!.addSubview(button)
            if buttons == nil {
                buttons = [button]
            } else {
                buttons!.append(button)
            }
            
            if i == 0 {
                button.transform = CGAffineTransform(translationX: buttonsContainer!.bounds.width / 2, y: 0)
                animateSideButtons(button, idx: i, start: 0, end: angle)
            }
            else {
                let start = startAngle + CGFloat(i-1) * step
                animateSideButtons(button, idx: i, start: start, end: angle)
            }
        }
    }
    
    //MARK: - Button taps
    private func addTap() {
        addTarget(self, action: #selector(tapAction(_:)), for: .touchUpInside)
    }
    //Handles taps on the center button.
    @objc private func tapAction( _ sender: UIButton) {
        buttonSelected = !buttonSelected
        animateCenterButton(sender)
        if buttonSelected {
            createButtonsContainer()
            createButtons()
            delegate?.optionButton(didOpen: self)

        } else {
            buttons!.forEach({ (button) in
                self.hideSideButtons(button)
            })
            delegate?.optionButton(didClose: self)
        }
    }
    
    //Handles taps on the side buttons.
    @objc private func sideButtonTapAction( _ sender: UIButton) {
        delegate?.optionButton(optionButton: self, willSelect: sender, atIndex: sender.tag)
        UIView.animate(withDuration: 0.2, delay: 0, options: .curveEaseInOut) {
            sender.transform = CGAffineTransform.identity.scaledBy(x: 1.3, y: 1.3)
        } completion: { _ in
            sender.transform = .identity
            self.delegate?.optionButton(optionButton: self, didSelect: sender, atIndex: sender.tag)
        }
    }
    
    //MARK: - Animate center buton
    //Tap animation when the center button is interacted with.
    private func animateCenterButton( _ sender: UIButton) {
        UIView.animate(withDuration: 0.2, delay: 0, options: .curveEaseInOut) {
            self.transform = CGAffineTransform.identity.scaledBy(x: 1.2, y: 1.2)
        } completion: { _ in
            self.transform = .identity
        }

        UIView.transition(with: sender, duration: 0.1, options: .transitionCrossDissolve, animations: {
            sender.setImage(UIImage(named: self.buttonSelected ? self.selectedIcon! : self.normalIcon!), for: .normal)
            }, completion: nil)
    }
    
    //MARK: - Animate side buttons
    //Starts the animation process for the side buttons.
    private func animateSideButtons( _ button: UIButton, idx: Int, start: CGFloat, end: CGFloat) {
        if idx == 0 {
            UIView.animate(withDuration: duration, delay: 0.1, usingSpringWithDamping: 0.6, initialSpringVelocity: 3, options: .curveEaseOut) {
                button.alpha = 1
                button.transform = .identity
            }
        }
        else {
            let delay = (Double(idx)*duration)
            self.startAnimation(button, start: start, end: end, delay: delay)
        }
    }
    
    //MARK: - Hide side buttons
    //Animates the side buttons and removes them from superview on completion.
    private func hideSideButtons(_ button: UIButton) {
        
        let point = CGPoint(x: button.bounds.midX, y: button.bounds.midY)
        let mainBtnCenter = self.center
        let conv = button.convert(point, to: superview)
        
        let distanceX = conv.x - mainBtnCenter.x
        let distanceY = conv.y - mainBtnCenter.y
        
        UIView.animate(withDuration: 0.1, delay: 0, options: .curveEaseIn) {
            button.transform = CGAffineTransform(translationX: -distanceX, y: -distanceY)
            button.layer.opacity = 0
        } completion: { _ in
            button.layer.removeAllAnimations()
            button.removeFromSuperview()
            if let idx = self.buttons?.firstIndex(of: button) {
                self.buttons?.remove(at: idx)
            }
        }
    }
    
    //MARK: - Start animation
    //Draws the circular bezier path and calls the animation method.
    @objc private func startAnimation( _ animView: UIView, start: CGFloat, end: CGFloat, delay: Double) {
        let path = UIBezierPath()
        
        let initialPoint = getPoint(for: Int(start))
        path.move(to: initialPoint)
        
        for angle in Int(start+1)...Int(end) {
            path.addLine(to: getPoint(for: angle))
        }
        path.close()
        
        animate(view: animView, path: path, withDelay: delay)
    }
    
    //MARK: - Animate
    //Creates opacity and position animations, groups them and adds to the views layer.
    private func animate(view: UIView, path: UIBezierPath, withDelay: Double = 0) {
        
        let opacityAnimation = CABasicAnimation(keyPath: "opacity")
        opacityAnimation.fromValue = 0.0
        opacityAnimation.toValue = 1.0

        let animation = CAKeyframeAnimation(keyPath: "position")
        animation.path = path.cgPath
        animation.calculationMode = .discrete
        
        let group = CAAnimationGroup()
        group.duration = duration
        group.beginTime = CACurrentMediaTime() + withDelay
        group.repeatCount = 1
        group.animations = [opacityAnimation, animation]
        view.layer.add(group, forKey: "animation")
        
        UIView.animate(withDuration: 0, delay: withDelay) {
            view.layer.opacity = 1
        }
    }
    
    //MARK: - Get point
    //Gets the x,y coordinates from the angle on the circle.
    private func getPoint(for angle: Int) -> CGPoint {
        let radius = Double(self.buttonsContainer!.layer.cornerRadius)
      
        let radian = Double(angle) * Double.pi / Double(180)
        
        let newCenterX = radius + radius * cos(radian)
        let newCenterY = radius + radius * sin(radian)

        return CGPoint(x: newCenterX, y: newCenterY)
    }
    
    //MARK: - Get arc step
    //Used to calculate the incremental lengths between the buttons.
    private func getArcStep() -> CGFloat {
        var arcLength = endAngle - startAngle
        var stepCount = buttonsCount

        if arcLength < 360 {
            stepCount -= 1
        } else if arcLength > 360 {
            arcLength = 360
        }

        return arcLength / CGFloat(stepCount)
    }
}

//MARK: - Buttons container
/**
 Some parts of the side buttons can fall outside the bounds of its superview, the buttons container.
 So we create a new UIView subclass for it and set it up to recognize subview touches events even if it happened outside its bounds
 */
private class ButtonsContainer: UIView {
    override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        guard !clipsToBounds && !isHidden && alpha > 0 else { return nil }
        for member in subviews.reversed() {
            let subPoint = member.convert(point, from: self)
            guard let result = member.hitTest(subPoint, with: event) else { continue }
            return result
        }
        return nil
    }
}

