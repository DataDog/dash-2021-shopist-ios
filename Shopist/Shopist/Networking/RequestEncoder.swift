/*
 * Unless explicitly stated otherwise all files in this repository are licensed under the Apache License Version 2.0.
 * This product includes software developed at Datadog (https://www.datadoghq.com/).
 * Copyright 2019-2020 Datadog, Inc.
 */

import Foundation

/// Headers private to Shopist iOS.
private struct Headers {
    /// An internal header for recognizing the request type within Shopist iOS. It is used to issue
    /// crashes down in the network layer for particular scenarios.
    static let requestTypeField = "shopist-ios-request-type"
    static let getCategoriesTypeValue = "get-categories"
    static let getCategoryItemsTypeValue = "get-category-items"
    static let postCheckoutTypeValue = "post-checkout"
}

internal struct RequestEncoder {
    internal let resourcesURL: URL
    internal let apiURL: URL
    private let bodyEncoder: JSONEncoder

    init(shopistDomain: String) throws {
        guard let resourcesURL = URL(string: "https://" + shopistDomain),
              let apiURL = URL(string: "https://api." + shopistDomain) else {
            throw Exception(description: "Can't build API urls with provided Shopist domain: '\(shopistDomain)'")
        }
        self.resourcesURL = resourcesURL
        self.apiURL = apiURL
        self.bodyEncoder = JSONEncoder()
        bodyEncoder.keyEncodingStrategy = .convertToSnakeCase
    }

    func createGETCategoriesRequest() -> URLRequest {
        var request = URLRequest(url: resourcesURL.appendingPathComponent("categories.json"))
        request.setValue(Headers.getCategoriesTypeValue, forHTTPHeaderField: Headers.requestTypeField)
        return request
    }

    func createGETCategoryItemsRequest(for categoryID: String) -> URLRequest {
        var request = URLRequest(url: resourcesURL.appendingPathComponent("category_\(categoryID).json"))
        request.setValue(Headers.getCategoryItemsTypeValue, forHTTPHeaderField: Headers.requestTypeField)
        return request
    }

    func createPOSTCheckoutRequest(with payment: Payment, cuponCode: String?) throws -> URLRequest {
        let url: URL = apiURL.appendingPathComponent("checkout.json")
        var urlComponents = URLComponents(url: url, resolvingAgainstBaseURL: false)! // swiftlint:disable:this force_unwrapping

        if let someCuponCode = cuponCode, !someCuponCode.isEmpty {
            urlComponents.queryItems = [URLQueryItem(name: "coupon_code", value: cuponCode)]
        }

        var request = URLRequest(url: urlComponents.url!) // swiftlint:disable:this force_unwrapping
        request.httpMethod = "POST"
        request.httpBody = try bodyEncoder.encode(payment)
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue(Headers.postCheckoutTypeValue, forHTTPHeaderField: Headers.requestTypeField)
        return request
    }
}

internal extension URLRequest {
    var isGETCategoriesRequest: Bool {
        return value(forHTTPHeaderField: Headers.requestTypeField) == Headers.getCategoriesTypeValue
    }

    var isGETCategoryItemsRequest: Bool {
        return value(forHTTPHeaderField: Headers.requestTypeField) == Headers.getCategoryItemsTypeValue
    }

    var isPOSTCheckoutRequest: Bool {
        return value(forHTTPHeaderField: Headers.requestTypeField) == Headers.postCheckoutTypeValue
    }
}
