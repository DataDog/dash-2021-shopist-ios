/*
 * Unless explicitly stated otherwise all files in this repository are licensed under the Apache License Version 2.0.
 * This product includes software developed at Datadog (https://www.datadoghq.com/).
 * Copyright 2019-2020 Datadog, Inc.
 */

import Foundation

internal struct ResponseDecoder {
    private let bodyDecoder: JSONDecoder

    init() {
        self.bodyDecoder = JSONDecoder()
        bodyDecoder.keyDecodingStrategy = .convertFromSnakeCase
    }

    func decode<T: Decodable>(data: Data, for request: URLRequest) throws -> T {
        return try bodyDecoder.decode(T.self, from: data)
    }
}
