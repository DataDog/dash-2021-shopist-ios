/*
 * Unless explicitly stated otherwise all files in this repository are licensed under the Apache License Version 2.0.
 * This product includes software developed at Datadog (https://www.datadoghq.com/).
 * Copyright 2019-2020 Datadog, Inc.
 */

import Foundation

public class RequestCancellationToken {
    /// Task to cancel on token deallocation.
    var task: URLSessionTask!

    deinit {
        task.cancel()
    }

    /// Helper method for producing crash in `ShopistNetworking` library.
    public func makeItCrash() {
        fatalError("Called `RequestCancellationToken.makeItCrash()`")
    }
}

public struct NetworkClient {
    public let session: URLSession

    public init(sessionDelegate: URLSessionDelegate?) {
        let configuration: URLSessionConfiguration = .default
        configuration.urlCache = nil
        self.session = URLSession(configuration: configuration, delegate: sessionDelegate, delegateQueue: nil)
    }

    public func make(
        request: URLRequest,
        completion: @escaping (Result<Data, Error>) -> Void
    ) {
        let task = session.dataTask(with: request) { data, response, error in
            handle(data: data, response: response, error: error, with: completion)
        }
        task.resume()
    }

    public func makeCancellableRequest(
        for url: URL,
        completion: @escaping (Result<Data, Error>) -> Void
    ) -> RequestCancellationToken {
        let task = session.dataTask(with: url) { data, response, error in
            handle(data: data, response: response, error: error, with: completion)
        }
        task.resume()

        let cancellationToken = RequestCancellationToken()
        cancellationToken.task = task
        return cancellationToken
    }
}

private func handle(
    data: Data?,
    response: URLResponse?,
    error: Error?,
    with completion: @escaping (Result<Data, Error>) -> Void
) {
    if let someError = error {
        completion(.failure(someError))
    } else if let someData = data {
        completion(.success(someData))
    } else {
        fatalError(
            """
            🔥 Expected either `error` or `data` got:
            - error: \(String(describing: error))
            - data.count: \(data?.count ?? -1)
            - response: \(String(describing: response))
            """
        )
    }
}
