/*
 * Unless explicitly stated otherwise all files in this repository are licensed under the Apache License Version 2.0.
 * This product includes software developed at Datadog (https://www.datadoghq.com/).
 * Copyright 2019-2020 Datadog, Inc.
 */

import Foundation

internal let cart = Cart()

extension Float {
    var moneyString: String { String(format: "€%.2f", self) }
}

internal final class Cart {
    static let taxPercentage: Float = 0.18
    static let shippingPerItem: Float = 10.0

    struct Breakdown {
        let products: [Product]
        let orderValue: Float
        let tax: Float
        let shipping: Float
        let discount: Float?
        let total: Float

        fileprivate init(products: [Product], discountRate: Float?) {
            self.products = products

            let orderValue = products.compactMap { Float($0.price) }.reduce(0, +)
            self.orderValue = orderValue

            tax = Cart.taxPercentage * orderValue
            shipping = Cart.shippingPerItem * Float(products.count)

            discount = {
                guard let someRate = discountRate else {
                    return nil
                }
                return -someRate * orderValue
            }()
            total = orderValue + tax + shipping + (discount ?? 0)
        }
    }

    var products = [Product]()
    var discountRate: Float? = nil

    func generateBreakdown(completion: @escaping (Breakdown) -> Void) {
        DispatchQueue.global().async {
            let breakdown = Breakdown(products: self.products, discountRate: self.discountRate)
            DispatchQueue.main.async {
                completion(breakdown)
            }
        }
    }
}
