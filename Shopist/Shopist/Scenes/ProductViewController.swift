/*
 * Unless explicitly stated otherwise all files in this repository are licensed under the Apache License Version 2.0.
 * This product includes software developed at Datadog (https://www.datadoghq.com/).
 * Copyright 2019-2020 Datadog, Inc.
 */

import UIKit

internal class ProductViewController: UIViewController {
    @IBOutlet private weak var imageView: UIImageView!
    @IBOutlet private weak var descriptionLabel: UILabel!
    @IBOutlet private weak var priceLabel: UILabel!
    let product: Product

    init(product: Product) {
        self.product = product
        super.init(nibName: nil, bundle: nil)
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }

    override func viewDidLoad() {
        super.viewDidLoad()
        title = product.name

        descriptionLabel.text = product.name
        priceLabel.text = "€\(product.price)"

        setupBarButtons()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        imageView.setImage(with: product.cover)
    }

    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
    }

    private func setupBarButtons() {
        let cartActionButton: UIBarButtonItem
        if cart.products.contains(product) {
            cartActionButton = UIBarButtonItem(image: UIImage(systemName: "cart.badge.minus"), style: .plain, target: self, action: #selector(removeFromCart))
            cartActionButton.accessibilityIdentifier = "removeFromCart"
        } else {
            cartActionButton = UIBarButtonItem(image: UIImage(systemName: "cart.badge.plus"), style: .plain, target: self, action: #selector(addToCart))
            cartActionButton.accessibilityIdentifier = "addToCart"
        }
        navigationItem.rightBarButtonItems = [cartActionButton]
        addDefaultNavBarButtons()
    }

    @objc
    private func addToCart() {
        cart.products.append(product)
        //fatalError()
        setupBarButtons()
    }

    @objc
    private func removeFromCart() {
        if let indexToRemove = cart.products.firstIndex(of: product) {
            cart.products.remove(at: indexToRemove)
        }
        setupBarButtons()
    }
}
