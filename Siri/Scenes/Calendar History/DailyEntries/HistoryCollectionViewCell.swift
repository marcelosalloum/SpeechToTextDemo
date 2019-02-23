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
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        viewModel.updateFoodList()
    }

    func updateContent() {
        viewModel.updateFoodList()
        tableView.reloadData()
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
