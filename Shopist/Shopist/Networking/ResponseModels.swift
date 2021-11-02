/*
 * Unless explicitly stated otherwise all files in this repository are licensed under the Apache License Version 2.0.
 * This product includes software developed at Datadog (https://www.datadoghq.com/).
 * Copyright 2019-2020 Datadog, Inc.
 */

import Foundation

internal struct Category: Decodable {
    let id: String
    let title: String
    let cover: URL
}

internal struct Product: Decodable, Equatable {
    let name: String
    let price: String
    let cover: URL
    let id: Int
    let isInStock: Bool
}

internal struct Payment: Encodable {
    struct Checkout: Encodable {
        let cardNumber: String
        let cvc: Int
        let exp: String

        init() {
            cardNumber = "\(Self.random(length: 16))"
            cvc = Self.random(length: 3)
            exp = "\(Int.random(in: 1...12))/\(Int.random(in: 21...30))"
        }

        private static func random(length: UInt8) -> Int {
            let max = Int(pow(10.0, Double(length)))
            let min = max / 10
            let output = Int.random(in: min..<max)
            return output
        }
    }
    let checkout = Checkout()

    struct Response: Decodable {
        let id: String?
        let cartID: String?
        let cardNumber: String
        let cvc: Int
        let exp: String
        let email: String
        let createdAt: String
        let updatedAt: String
    }
}
