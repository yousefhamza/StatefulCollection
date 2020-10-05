//
//  UIViewController+RootvViewController.swift
//  StatefulCollectionDemo
//
//  Created by Yousef Hamza on 10/4/20.
//  Copyright © 2020 yousefhamz. All rights reserved.
//

import UIKit

extension UIViewController {
    static var rootViewController: UIViewController {
        let tableViewController = UINavigationController(rootViewController: ExampleTableViewController())
        tableViewController.view.backgroundColor = .red
        tableViewController.tabBarItem.title = "Table View"

        let collectionViewController = UIViewController()
        collectionViewController.view.backgroundColor = .blue
        collectionViewController.tabBarItem.title = "Colleciton View"

        let tabBarController = UITabBarController()
        tabBarController.viewControllers = [tableViewController, collectionViewController]

        return tabBarController
    }
}
