//
//  HistoryCollectionViewController.swift
//  Siri
//
//  Created by Marcelo Salloum dos Santos on 22/02/19.
//  Copyright © 2019 Sahand Edrisian. All rights reserved.
//

import UIKit

class HistoryCollectionViewController: CoordinatedViewController {

    @IBOutlet weak var collectionView: UICollectionView!

    var viewModel: HistoryViewModel!

    override func viewDidLoad() {
        super.viewDidLoad()

        collectionView.delegate = self
        collectionView.dataSource = self
    }
}

extension HistoryCollectionViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.days.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = HistoryCollectionViewCell.dequeuedReusableCell(collectionView, indexPath: indexPath)
        return cell
    }
}

extension HistoryCollectionViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let viewControllerSize = self.view.frame.size
        return viewControllerSize
    }

    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        // Stop scrollView sliding:
        targetContentOffset.pointee = scrollView.contentOffset

        // Calculate where scrollView should snap to:
        let indexOfMajorCell = self.indexOfMajorCell()

        let indexPath = IndexPath(row: indexOfMajorCell, section: 0)
        let collectionViewLayout = self.collectionView.collectionViewLayout
        collectionViewLayout.collectionView!.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
    }

    private func indexOfMajorCell() -> Int {
        let collectionViewLayout = self.collectionView.collectionViewLayout
        let itemWidth = self.view.frame.size.width
        let proportionalOffset = collectionViewLayout.collectionView!.contentOffset.x / itemWidth
        let index = Int(round(proportionalOffset))
        let safeIndex = max(0, min(viewModel.days.count - 1, index))
        return safeIndex
    }
}
