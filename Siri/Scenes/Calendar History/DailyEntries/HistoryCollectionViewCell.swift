//
//  HistoryCollectionViewCell.swift
//  Siri
//
//  Created by Marcelo Salloum dos Santos on 22/02/19.
//  Copyright © 2019 Sahand Edrisian. All rights reserved.
//

import UIKit

class HistoryCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var headerView: UIView!
    @IBOutlet weak var tableView: UITableView!

    var viewModel: EntriesViewModel!

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

extension HistoryCollectionViewCell: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.foodList.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = EntriesTableViewCell.dequeuedReusableCell(tableView, indexPath: indexPath)
        let food = viewModel.foodList[indexPath.row]
        cell.textLabel?.text = food.foodName
        return cell
    }
}

extension HistoryCollectionViewCell: UITableViewDelegate {

}
