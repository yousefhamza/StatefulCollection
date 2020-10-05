//
//  StateView.swift
//  StatefulCollection
//
//  Created by Yousef Hamza on 12/16/17.
//  Copyright © 2017 YousefHamza. All rights reserved.
//

import UIKit

class StateView: UIView {
    var reloadButton: UIButton!

    lazy var stateImage: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.isOpaque = false
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()

    var stateMessage: UILabel!

    var mainStack: UIStackView!
    var subStack: UIStackView!

    var delegate: StateElementDelegate?
    let isCompact: Bool
    init(image: UIImage?, messageLabel: UILabel?, reloadButton: UIButton?, delegate: StateElementDelegate?, isCompact: Bool=false) {
        self.isCompact = isCompact
        super.init(frame: .zero)

        self.delegate = delegate
        stateImage.image = image
        stateMessage = messageLabel
        self.reloadButton = reloadButton
        self.reloadButton.addTarget(self, action: #selector(didTapReload), for: .touchUpInside)

        subStack = UIStackView(arrangedSubviews: [stateMessage, reloadButton ?? UIView()])
        subStack.translatesAutoresizingMaskIntoConstraints = false
        subStack.axis = .vertical
        subStack.spacing = 10
        subStack.alignment = .center

        mainStack = UIStackView(arrangedSubviews: [stateImage, subStack])
        mainStack.translatesAutoresizingMaskIntoConstraints = false
        if isCompact {
            mainStack.axis = .horizontal
        } else {
            mainStack.axis = .vertical
        }
        mainStack.spacing = 10
        mainStack.alignment = .center
        mainStack.setContentHuggingPriority(UILayoutPriority.defaultHigh, for: .vertical)
        
        addSubview(mainStack)

        if isCompact {
            stateMessage.font = .systemFont(ofSize: 14)
        }
        
        setNeedsUpdateConstraints()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func updateConstraints() {
        var selfView: Anchorable! = nil
        if #available(iOS 11.0, *) {
            selfView = safeAreaLayoutGuide
        } else {
            selfView = self
        }

        NSLayoutConstraint.activate([
            mainStack.leadingAnchor.constraint(greaterThanOrEqualTo: selfView.leadingAnchor, constant: 10),
            mainStack.trailingAnchor.constraint(lessThanOrEqualTo: selfView.trailingAnchor, constant: -10),
            mainStack.topAnchor.constraint(greaterThanOrEqualTo: selfView.topAnchor, constant: 10),
            mainStack.bottomAnchor.constraint(lessThanOrEqualTo: selfView.bottomAnchor, constant: -10),

            mainStack.centerXAnchor.constraint(equalTo: selfView.centerXAnchor),
            mainStack.centerYAnchor.constraint(equalTo: selfView.centerYAnchor),

            stateImage.heightAnchor.constraint(lessThanOrEqualToConstant: 200),
            stateImage.widthAnchor.constraint(lessThanOrEqualToConstant: 200)
        ])
        super.updateConstraints()
    }

    @objc func didTapReload() {
        delegate?.statefulElementDidTapReload()
    }
}

protocol Anchorable {
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

extension UILayoutGuide: Anchorable {}
extension UIView: Anchorable {}
