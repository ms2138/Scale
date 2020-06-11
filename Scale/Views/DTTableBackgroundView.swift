//
//  DTTableBackgroundView.swift
//  Scale
//
//  Created by mani on 2020-05-02.
//  Copyright © 2020 mani. All rights reserved.
//

import UIKit

class DTTableBackgroundView: UIView {
    let messageLabel: UILabel
    let button: UIButton
    let activityIndicator: UIActivityIndicatorView
    var buttonTitle: String {
        willSet {
            button.setTitle(newValue, for: .normal)
        }
    }
    var messageTitle: String {
        willSet {
            messageLabel.text = newValue
        }
    }
    var handler: (() -> Void)?
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override init(frame: CGRect) {
        self.messageLabel = UILabel(frame: .zero)
        self.messageLabel.textColor = UIColor.darkGray
        self.messageLabel.font = UIFont.systemFont(ofSize: 20.0)
        self.messageLabel.numberOfLines = 0
        self.messageLabel.textAlignment = .center
        
        self.button = UIButton(type: .roundedRect)
        
        self.activityIndicator = UIActivityIndicatorView(style: .large)
        self.activityIndicator.color = .darkGray
        
        self.buttonTitle = "Button"
        self.messageTitle = "Label"
        
        let stackView = UIStackView(arrangedSubviews: [self.messageLabel, self.button, self.activityIndicator])
        stackView.axis = .vertical
        stackView.alignment = .fill
        stackView.distribution = .equalSpacing
        
        super.init(frame: frame)
        
        button.addTarget(self, action: #selector(buttonPressed), for: .touchUpInside)
        
        addSubview(stackView)
        
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
        stackView.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true
        stackView.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
    }
}

extension DTTableBackgroundView {
    func hideMessageLabel(animated: Bool = true) {
        toggleMessageLabel(alpha: 0.0, animated: animated)
    }
    
    func showMessageLabel(animated: Bool = true) {
        toggleMessageLabel(alpha: 1.0, animated: animated)
    }
    
    func hideButton(animated: Bool = true) {
        toggleButton(alpha: 0.0, animated: animated)
    }
    
    func showButton(animated: Bool = true) {
        toggleButton(alpha: 1.0, animated: animated)
    }
    
    func startLoadingOperation() {
        messageTitle = messageLabel.text ?? "Label"
        messageLabel.text = "Loading"
        hideButton(animated: false)
        activityIndicator.startAnimating()
    }
    
    func stopLoadingOperation() {
        messageLabel.text = messageTitle
        showButton(animated: false)
        activityIndicator.stopAnimating()
    }
    
    fileprivate func toggleMessageLabel(alpha: CGFloat, animated: Bool) {
        let messageLabelAlpha = { self.messageLabel.alpha = alpha }
        if (animated == true) {
            UIView.animate(withDuration: 1.0, animations: messageLabelAlpha)
        } else {
            messageLabelAlpha()
        }
    }
    
    fileprivate func toggleButton(alpha: CGFloat, animated: Bool) {
        let buttonAlpha = { self.button.alpha = alpha }
        if (animated == true) {
            UIView.animate(withDuration: 1.0, animations: buttonAlpha)
        } else {
            buttonAlpha()
        }
    }
}

extension DTTableBackgroundView {
    @objc fileprivate func buttonPressed() {
        if (handler != nil) {
            handler!()
        }
    }
}
