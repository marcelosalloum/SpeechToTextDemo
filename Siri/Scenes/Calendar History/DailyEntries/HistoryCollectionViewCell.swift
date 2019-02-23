//
//  HistoryCollectionViewCell.swift
//  Siri
//
//  Created by Marcelo Salloum dos Santos on 22/02/19.
//  Copyright © 2019 Sahand Edrisian. All rights reserved.
//

import UIKit

class HistoryCollectionViewCell: UICollectionViewCell {
    // MARK: - Injected Dependecies
    @IBOutlet weak var headerView: UIView!
    @IBOutlet weak var tableView: UITableView!

    var viewModel: EntriesViewModel!

    // MARK: - Lifecycle
    override func awakeFromNib() {
        super.awakeFromNib()

        tableView.delegate = self
        tableView.dataSource = self

        NotificationCenter.default.addObserver(self, selector: #selector(updateContent), name: DefaultNotification.updateFoodDatabase, object: nil)
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        viewModel.updateFoodList()
    }

    @objc func updateContent() {
        viewModel.updateFoodList()
        tableView.reloadData()
    }

    deinit {
        NotificationCenter.default.removeObserver(self, name: DefaultNotification.updateFoodDatabase, object: nil)
    }
}

// MARK: - DataSource
extension HistoryCollectionViewCell: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.foodList.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = EntriesTableViewCell.dequeuedReusableCell(tableView, indexPath: indexPath)
        let food = viewModel.foodList[indexPath.row]
        cell.textLabel?.text = "\(String(describing: food.foodName!))     Cal: \(food.calories)"
        return cell
    }
}

// MARK: - Delegate
extension HistoryCollectionViewCell: UITableViewDelegate {

}
