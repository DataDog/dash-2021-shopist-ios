/*
 * Unless explicitly stated otherwise all files in this repository are licensed under the Apache License Version 2.0.
 * This product includes software developed at Datadog (https://www.datadoghq.com/).
 * Copyright 2019-2020 Datadog, Inc.
 */

import Foundation
import ShopistNetworking
import Datadog

internal final class API {
    typealias Completion<T: Decodable> = (Result<T, Error>) -> Void

    internal let client: NetworkClient
    internal let requestEncoder: RequestEncoder
    internal let responseDecoder: ResponseDecoder

    init() throws {
        self.requestEncoder = try RequestEncoder(shopistDomain: "shopist.io")
        self.responseDecoder = ResponseDecoder()

        // Configure NetworkClient along with its `URLSessionDelegate` (or `nil` if not needed):
        self.client = NetworkClient(sessionDelegate: nil)
    }

    func getCategories(completion: @escaping Completion<[Category]>) {
        let request = requestEncoder.createGETCategoriesRequest()
        make(request: request, completion: completion)
    }

    func getItems(for category: Category, completion: @escaping Completion<[Product]>) {
        let request = requestEncoder.createGETCategoryItemsRequest(for: category.id)
        make(request: request, completion: completion)
    }

    func getImageData(with url: URL, completion: @escaping (Data) -> Void) -> RequestCancellationToken {
        return client.makeCancellableRequest(for: url) { result in
            switch result {
            case .success(let data):
                completion(data)
            case .failure:
                break
            }
        }
    }

    func checkout(with payment: Payment, discountCode: String?, completion: @escaping Completion<Payment.Response>) {
        // swiftlint:disable force_try
        let request = try! requestEncoder.createPOSTCheckoutRequest(with: payment, cuponCode: discountCode)
        // swiftlint:enable force_try
        make(request: request, completion: completion)
    }

    private func make<T: Decodable>(request: URLRequest, completion: @escaping Completion<T>) {
        client.make(request: request) { [unowned self] result in
            switch result {
            case .success(let data):
                do {
                    let decoded: T = try self.responseDecoder.decode(data: data, for: request)
                    completion(.success(decoded))
                } catch {
                    completion(.failure(error))
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}
