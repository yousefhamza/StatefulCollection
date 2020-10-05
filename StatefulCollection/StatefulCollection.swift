//
//  StatefulList.swift
//  StatefulCollection
//
//  Created by Yousef Hamza on 12/16/17.
//  Copyright © 2017 YousefHamza. All rights reserved.
//

import UIKit

public class StatefulCollectionError: Error {
    let description: String
    let title: String?

    public init(title: String?=nil, description: String) {
        self.title = title
        self.description = description
    }
}

open class StateConfiguration {
    public var reloadButton: UIButton?
    public var loadingView: UIView?
    public var emptyImage: UIImage?
    public var errorImage: UIImage?
    public var emptyLabel: UILabel?
    public var errorLabel: UILabel?
}

public protocol StatefulElement: class {
    var backgroundView: UIView? { get set }
    var stateDataSource: StateElementDataSource? { get set }
    var stateDelegate: StateElementDelegate? { get set }
    func reloadState()
}

public protocol StateElementDataSource {
    func statefulViewIsEmpty(_ view: StatefulElement) -> Bool
    func statefulViewIsLoading(_ view: StatefulElement) -> Bool
    func statefulViewError(_ view: StatefulElement) -> StatefulCollectionError?
    func statefulViewIsCompact(_ view: StatefulElement) -> Bool
    func statefulViewConfiguration(_ view: StatefulElement) -> StateConfiguration
}

public protocol StateElementDelegate {
    func statefulElementDidTapReload()
}

extension StatefulElement {
    public func reloadState() {
        guard let dataSource = stateDataSource else {
            return
        }

        let isCompact = dataSource.statefulViewIsCompact(self)

        if dataSource.statefulViewIsEmpty(self) == false {
            showContent()
            return
        }

        if let error = dataSource.statefulViewError(self) {
            showError(error, isCompact: isCompact)
            return
        }

        if dataSource.statefulViewIsLoading(self) {
            showLoading()
            return
        }
        
        showEmpty(isCompact: isCompact)
    }

    func showLoading() {
        let config = stateDataSource!.statefulViewConfiguration(self)
        backgroundView = config.loadingView
    }

    func showError(_ error: StatefulCollectionError, isCompact: Bool) {
        let config = stateDataSource!.statefulViewConfiguration(self)
        let errorLabel = config.errorLabel
        errorLabel?.text = "\(error.title ?? "Something wrong happened"): \(error.description)"
        backgroundView = StateView(image: config.errorImage,
                                   messageLabel: config.errorLabel,
                                   reloadButton: config.reloadButton,
                                   delegate: stateDelegate,
                                   isCompact: isCompact)
    }

    func showEmpty(isCompact: Bool) {
        let config = stateDataSource!.statefulViewConfiguration(self)
        let emptyLabel = config.emptyLabel
        if emptyLabel?.text == nil {
            emptyLabel?.text = "No records to show now, Please try again later."
        }
        backgroundView = StateView(image: config.emptyImage,
                                   messageLabel: config.emptyLabel,
                                   reloadButton: config.reloadButton,
                                   delegate: stateDelegate,
                                   isCompact: isCompact)
    }
    
    func showContent() {
        backgroundView = nil
    }
}

open class StatefulTableView: UITableView {
    public var stateDataSource: StateElementDataSource?
    public var stateDelegate: StateElementDelegate?

    fileprivate func addRefreshControl() {
        let refreshControl = UIRefreshControl()
        refreshControl.attributedTitle = NSAttributedString(string: "Pull to refresh")
        refreshControl.addTarget(self, action: #selector(refresh(_:)), for: .valueChanged)
        if #available(iOS 10.0, *) {
            self.refreshControl = refreshControl
        }
    }
    
    convenience init() {
        self.init(frame: .zero, style: .grouped)
        addRefreshControl()
        contentInset = UIEdgeInsets(top: -30, left: 0, bottom: 0, right: 0)
    }

    override required public init(frame: CGRect, style: UITableView.Style) {
        super.init(frame: frame, style: style)
        addRefreshControl()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    open override func reloadData() {
        super.reloadData()
        reloadState()
    }

    @objc func refresh(_ sender: Any) {
        stateDelegate?.statefulElementDidTapReload()
        if #available(iOS 10.0, *) {
            refreshControl?.endRefreshing()
        }
    }
}

public class StatefulCollectionView: UICollectionView {
    public var stateDataSource: StateElementDataSource?
    public var stateDelegate: StateElementDelegate?

    fileprivate func addRefreshControl() {
        let refreshControl = UIRefreshControl()
        refreshControl.attributedTitle = NSAttributedString(string: "Pull to refresh")
        refreshControl.addTarget(self, action: #selector(refresh(_:)), for: .valueChanged)
        if #available(iOS 10.0, *) {
            self.refreshControl = refreshControl
        }
    }

    public override func reloadData() {
        super.reloadData()
        reloadState()
    }

    @objc func refresh(_ sender: Any) {
        stateDelegate?.statefulElementDidTapReload()
        if #available(iOS 10.0, *) {
            refreshControl?.endRefreshing()
        }
    }
}

extension StatefulTableView: StatefulElement {}
extension StatefulCollectionView: StatefulElement {}

