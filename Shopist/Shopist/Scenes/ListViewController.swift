/*
 * Unless explicitly stated otherwise all files in this repository are licensed under the Apache License Version 2.0.
 * This product includes software developed at Datadog (https://www.datadoghq.com/).
 * Copyright 2019-2020 Datadog, Inc.
 */

import UIKit

internal class ListViewController: UICollectionViewController {
    private let cellIdentifier = "cell"

    convenience init() {
        self.init(collectionViewLayout: UICollectionViewFlowLayout())
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.backgroundColor = .white
        collectionView.register(Cell.self, forCellWithReuseIdentifier: cellIdentifier)
        collectionView.delegate = self

        setupLayout(for: view.bounds.size)
        addDefaultNavBarButtons()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let zeroPoint = CGPoint(x: 0, y: -collectionView.safeAreaInsets.top)
        collectionView.setContentOffset(zeroPoint, animated: true)
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }

    func fetch(with api: API) {
        // to be overridden
        return
    }

    func config(cell: Cell, for index: Int) {
        // to be overridden
        return
    }

    func reload() {
        DispatchQueue.main.async {
            self.collectionView.refreshControl?.endRefreshing()
            self.collectionView.reloadData()
        }
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellIdentifier, for: indexPath)
        guard let someCell = cell as? Cell else {
            return cell
        }
        config(cell: someCell, for: indexPath.row)
        return someCell
    }

    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        setupLayout(for: size)
    }

    private func setupLayout(for size: CGSize) {
        guard let layout = collectionViewLayout as? UICollectionViewFlowLayout else {
            return
        }
        let cellHeight = size.height / 3.5
        layout.itemSize = CGSize(width: size.width - 50.0, height: cellHeight)
        layout.minimumLineSpacing = 30
        layout.sectionInset = UIEdgeInsets(top: 20, left: 10, bottom: 20, right: 10)
        layout.scrollDirection = .vertical
    }

    override func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
    }

    override func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
    }
}
