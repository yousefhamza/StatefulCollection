//
//  StateController.swift
//  StatefulCollection
//
//  Created by Yousef Hamza on 5/7/18.
//  Copyright © 2018 YousefHamza. All rights reserved.
//

import UIKit

open class StateController: StateElementDataSource {
    
    private var isLoading = false
    private var loadingError: StatefulCollectionError?=nil
    private var isEmpty = true
    open var configuration: StateConfiguration

    public init() {
        configuration = StateConfiguration()
        let reloadButton = UIButton()
        reloadButton.setTitle("Reload", for: .normal)
        configuration.reloadButton = reloadButton
        configuration.loadingView = UIActivityIndicatorView()
        configuration.emptyLabel = defaultLabel()
        configuration.errorLabel = defaultLabel()
    }

    func defaultLabel() -> UILabel {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 20)
        label.numberOfLines = 0
        label.textAlignment = .center
        label.text = NSLocalizedString("No records to show now, Please try again later.", comment: "")
        return label
    }

    public func startLoading() {
        isLoading = true
        loadingError = nil
        isEmpty = true
    }
    
    public func didLoad(count: Int) {
        isLoading = false
        loadingError = nil
        isEmpty = count == 0
    }
    
    open func didReceive(error: StatefulCollectionError) {
        isLoading = false
        loadingError = error
        isEmpty = true
    }
    
    public func statefulViewIsEmpty(_ view: StatefulElement) -> Bool {
        return isEmpty
    }
    
    public func statefulViewIsLoading(_ view: StatefulElement) -> Bool {
        return isLoading
    }
    
    public func statefulViewError(_ view: StatefulElement) -> StatefulCollectionError? {
        return loadingError
    }
    
    public func statefulViewIsCompact(_ view: StatefulElement) -> Bool {
        return false
    }

    public func statefulViewConfiguration(_ view: StatefulElement) -> StateConfiguration {
        return configuration
    }
}
