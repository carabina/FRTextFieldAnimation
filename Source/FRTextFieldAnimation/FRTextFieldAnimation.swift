//
//  FRTextFieldAnimation.swift
//  FRTextFieldAnimation
//
//  Created by Farshad Ghafari on 9/18/18.
//  Copyright © 2018 Farshad Ghafari. All rights reserved.
//

import UIKit

@objc public protocol AnimatedTextInputDelegate: class {
    @objc optional func animatedTextInputDidBeginEditing(animatedTextInput: FRTextFieldInput)
    @objc optional func animatedTextInputDidEndEditing(animatedTextInput: FRTextFieldInput)
    @objc optional func animatedTextInputDidChange(animatedTextInput: FRTextFieldInput)
    @objc optional func animatedTextInputShouldBeginEditing(animatedTextInput: FRTextFieldInput) -> Bool
    @objc optional func animatedTextInputShouldEndEditing(animatedTextInput: FRTextFieldInput) -> Bool
    @objc optional func animatedTextInputShouldReturn(animatedTextInput: FRTextFieldInput) -> Bool
}

open class FRTextFieldAnimation: UIControl {
    
    fileprivate var linePadding: CGFloat = 33
    fileprivate let screenWith: CGFloat = UIScreen.main.bounds.width
    fileprivate var placeholderToBottomConstraint: NSLayoutConstraint!
    fileprivate var lineToBottomConstraint: NSLayoutConstraint!
    fileprivate var lineView = UIView()
    fileprivate var placeHolderView = UILabel()
    fileprivate var textField = FRTextFieldInput()
    
    open  weak var delegate: AnimatedTextInputDelegate?
    
    open var keyboardType: UIKeyboardType = .default {
        didSet {
            textField.keyboardType = keyboardType
        }
    }
    
    open var text: String  {
        
        set {
            self.textField.text = text
        }
        
        get {
            return textField.text!
        }
        
        
    }
    
    open var placeHolderTitle: String = "" {
        didSet {
            placeHolderView.text = placeHolderTitle
        }
    }
    
    open var textLimit: Int = 100 {
        didSet {
            textField.characterCount = textLimit
            super.awakeFromNib()
        }
    }
    
    open var textColor: UIColor = UIColor.black {
        didSet {
            textField.textColor = textColor
        }
    }
    
    open var placeHolderColor: UIColor = UIColor.black {
        didSet {
            placeHolderView.textColor = placeHolderColor
        }
    }
    
    open var textFieldFont: UIFont = UIFont.systemFont(ofSize: 15) {
        didSet {
            textField.font = textFieldFont
        }
    }
    
    open var placeHolderFont: UIFont = UIFont.systemFont(ofSize: 15) {
        didSet {
            placeHolderView.font = placeHolderFont
        }
    }
    
    open var lineColor: UIColor = UIColor.black {
        didSet {
            lineView.backgroundColor = lineColor
        }
    }
    
    override public init(frame: CGRect) {
        super.init(frame: frame)
        setupCommonElements()
        
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupCommonElements()
    }
    
    
    fileprivate func setupCommonElements() {
        
        backgroundColor = UIColor.clear
        addLine()
        addTextInput()
        addPlaceHolder()
        addKyeboardObserver()
        
        
    }
    
    fileprivate func addLine() {
        
        
        lineView.frame.size = CGSize(width: screenWith - (linePadding * 2), height: 2)
        lineView.frame.origin = CGPoint(x: (screenWith - lineView.frame.size.width) / 2, y: frame.height - 2)
        lineView.backgroundColor = self.lineColor
        addSubview(lineView)
        
    }
    
    fileprivate func addTextInput() {
        
        textField.frame.size = CGSize(width: screenWith - (linePadding * 2), height: 40)
        textField.frame.origin = CGPoint(x: (screenWith - lineView.frame.size.width) / 2, y: frame.height - 40)
        textField.font = self.textFieldFont
        textField.textAlignment = .left
        textField.textColor = self.textColor
        textField.keyboardType = keyboardType
        textField.autocorrectionType = .no
        textField.spellCheckingType = .no
        textField.textInputDelegate = self
        addSubview(textField)
        
        
        
    }
    
    fileprivate func addPlaceHolder() {
        
        placeHolderView.frame.size = CGSize(width: screenWith - (linePadding * 2), height: 40)
        placeHolderView.frame.origin = CGPoint(x: (screenWith - lineView.frame.size.width) / 2, y: frame.height - 40)
        placeHolderView.text = placeHolderTitle
        placeHolderView.textColor = self.placeHolderColor
        placeHolderView.font = self.placeHolderFont
        addSubview(placeHolderView)
    }
    
    
    fileprivate func addKyeboardObserver() {
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(placeholderShowKeyboardAnimate),
                                               name: NSNotification.Name.UIKeyboardWillShow,
                                               object: nil)
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(placeholderHideKeyboardAnimate),
                                               name: NSNotification.Name.UIKeyboardWillHide,
                                               object: nil)
    }
    
    
    @objc fileprivate func placeholderShowKeyboardAnimate() {
        
        UIView.animate(withDuration: 0.5,
                       delay: 0,
                       usingSpringWithDamping: 0.5,
                       initialSpringVelocity: 0.6,
                       options: .curveEaseInOut, animations: {
                        
                        self.placeHolderView.frame.origin.y = 10
                        
        }, completion: nil)
    }
    
    @objc fileprivate func placeholderHideKeyboardAnimate() {
        UIView.animate(withDuration: 0.5  ,
                       delay: 0,
                       usingSpringWithDamping: 0.5,
                       initialSpringVelocity: 0.6,
                       options: .curveEaseInOut,
                       animations: {
                        
                        if self.textField.text == "" {
                            self.placeHolderView.frame.origin.y = self.frame.size.height - self.textField.frame.size.height
                        }
                        
                        
        }, completion: nil)
    }
}

extension FRTextFieldAnimation: FRTextInputDelegate {
    
    open func textInputDidBeginEditing(textInput: FRTextFieldInput) {
        delegate?.animatedTextInputDidBeginEditing?(animatedTextInput: textInput)
    }
    
    open func textInputDidEndEditing(textInput: FRTextFieldInput) {
        delegate?.animatedTextInputDidEndEditing?(animatedTextInput: textInput)
    }
    
    open func textInputDidChange(textInput: FRTextFieldInput) {
        delegate?.animatedTextInputDidChange?(animatedTextInput: textInput)
    }
    
    
    open func textInputShouldBeginEditing(textInput: FRTextFieldInput) -> Bool {
        return delegate?.animatedTextInputShouldBeginEditing?(animatedTextInput: textInput) ?? true
    }
    
    open func textInputShouldEndEditing(textInput: FRTextFieldInput) -> Bool {
        return delegate?.animatedTextInputShouldEndEditing?(animatedTextInput: textInput) ?? true
    }
    
    open func textInputShouldReturn(textInput: FRTextFieldInput) -> Bool {
        return delegate?.animatedTextInputShouldReturn?(animatedTextInput: textInput) ?? true
    }
    
}


