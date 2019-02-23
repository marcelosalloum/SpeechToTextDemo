//
//  HistoryCollectionViewController.swift
//  Siri
//
//  Created by Marcelo Salloum dos Santos on 22/02/19.
//  Copyright © 2019 Sahand Edrisian. All rights reserved.
//

import UIKit

class HistoryCollectionViewController: CoordinatedViewController {

    // MARK: - Injected Dependencies
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var rightBarButtonItem: UIBarButtonItem!

    var viewModel: HistoryViewModel!

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()

        collectionView.delegate = self
        collectionView.dataSource = self
    }

    override func viewDidAppear(_ animated: Bool) {
        // Selects middle cell (Today)
        if self.isBeingPresented || self.isMovingToParent {
            let middleIndex = Int(viewModel.days.count / 2)
            let indexPath = IndexPath(row: middleIndex, section: 0)
            updateIndexPath(indexPath)
        }
        super.viewDidAppear(animated)
    }

    @IBAction func rightBarButtonItemClicked(_ sender: Any) {
        let indexPath = collectionView.indexPathsForVisibleItems[0]
        viewModel.userDidSelectAddButton(viewModel.days[indexPath.row])
    }

    @IBAction func refreshButtonClicked(_ sender: Any) {
        self.collectionView.reloadData()
    }
}

// MARK: - DataSource
extension HistoryCollectionViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.days.count
    }

    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = HistoryCollectionViewCell.dequeuedReusableCell(collectionView, indexPath: indexPath)
        cell.viewModel = viewModel.childViewModels[indexPath.row]
        cell.updateContent()
        return cell
    }
}

// MARK: - Delegate
extension HistoryCollectionViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        let viewControllerSize = self.view.frame.size
        return viewControllerSize
    }

    fileprivate func updateIndexPath(_ indexPath: IndexPath) {
        collectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
        self.title = (viewModel.days[indexPath.row]).name
    }

    // Used o the CollectionView behaves kind of like a Page view
    func scrollViewWillEndDragging(_ scrollView: UIScrollView,
                                   withVelocity velocity: CGPoint,
                                   targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        // Stop scrollView sliding:
        targetContentOffset.pointee = scrollView.contentOffset

        // Calculate where scrollView should snap to:
        let indexOfMajorCell = self.indexOfMajorCell()

        let indexPath = IndexPath(row: indexOfMajorCell, section: 0)
        updateIndexPath(indexPath)
    }

    private func indexOfMajorCell() -> Int {
        let itemWidth = self.view.frame.size.width
        let proportionalOffset = collectionView.contentOffset.x / itemWidth
        let index = Int(round(proportionalOffset))
        let safeIndex = max(0, min(viewModel.days.count - 1, index))
        return safeIndex
    }
}
