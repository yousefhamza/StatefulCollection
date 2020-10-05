//
//  ExampleTableViewController.swift
//  StatefulCollectionDemo
//
//  Created by Yousef Hamza on 10/4/20.
//  Copyright © 2020 yousefhamz. All rights reserved.
//

import UIKit
import StatefulCollection

class ExampleTableViewController: UIViewController {
    lazy var tableView = StatefulTableView()
    lazy var stateController = StateController()

    var count = 0

    override func loadView() {
        view = tableView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "TableView"

        tableView.dataSource = self
        tableView.stateDataSource = stateController
        tableView.stateDelegate = self
        tableView.register(UITableViewCell.classForCoder(), forCellReuseIdentifier: "cell")

        startLoading()
    }

    func showFinishButton() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Finish", style: .plain, target: self, action: #selector(finishedLoading))
    }

    func showLoadingButton() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Start loading", style: .plain, target: self, action: #selector(startLoading))
    }

    @objc func finishedLoading() {
        let actionSheet = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        actionSheet.addAction(UIAlertAction(title: "Error", style: .default, handler: { (_) in
            self.count = 0
            self.stateController
                .didReceive(error: StatefulCollectionError(description: "User error"))
            self.tableView.reloadData()
            self.showLoadingButton()
        }))
        actionSheet.addAction(UIAlertAction(title: "Empty", style: .default, handler: { (_) in
            self.count = 0
            self.stateController.didLoad(count: 0)
            self.tableView.reloadData()
            self.showLoadingButton()
        }))
        actionSheet.addAction(UIAlertAction(title: "Show content", style: .default, handler: { (_) in
            self.count = 5
            self.stateController.didLoad(count: 5)
            self.tableView.reloadData()
            self.showLoadingButton()
        }))
        actionSheet.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))

        present(actionSheet, animated: true, completion: nil)
    }

    @objc func startLoading() {
        count = 0
        stateController.startLoading()
        tableView.reloadData()
        showFinishButton()
    }
}

extension ExampleTableViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)

        cell.textLabel?.text = "Item \(indexPath.row)"

        return cell
    }
}

extension ExampleTableViewController: StateElementDelegate {
    func statefulElementDidTapReload() {
        startLoading()
    }
}
