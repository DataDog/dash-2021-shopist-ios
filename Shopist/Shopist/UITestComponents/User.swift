/*
 * Unless explicitly stated otherwise all files in this repository are licensed under the Apache License Version 2.0.
 * This product includes software developed at Datadog (https://www.datadoghq.com/).
 * Copyright 2019-2020 Datadog, Inc.
 */

import Foundation

internal typealias Country = IPv4
internal enum IPv4: String, Codable {
    case unitedStates = "3.18.188.104"
    case unitedKingdom = "18.130.113.168"
    case germany = "18.195.155.52"
    case ireland = "63.35.33.198"
    case india = "13.234.54.8"
    case southKorea = "13.209.118.42"
    case singapore = "3.1.36.99"
    case japan = "52.192.175.207"
}

internal struct User: Codable {
    let name: String
    let countries: [Country]

    let id: String
    let ipAddress: String
    let email: String

    init(name: String, countries: [Country]) {
        self.name = name
        self.countries = countries

        self.id = UUID().uuidString
        self.ipAddress = self.countries.randomElement()!.rawValue // swiftlint:disable:this force_unwrapping
        self.email = self.name.lowercased()
            .replacingOccurrences(of: " ", with: "@")
            .appending(".com")
    }
}
