/*
 * Unless explicitly stated otherwise all files in this repository are licensed under the Apache License Version 2.0.
 * This product includes software developed at Datadog (https://www.datadoghq.com/).
 * Copyright 2019-2020 Datadog, Inc.
 */

import Foundation

internal struct Scenario: Codable {
    /// The fake user running this scenario.
    let user: User
    /// If `true` the app will produce a bunch fake errors along with its regular data.
    let hasErrors: Bool
    /// If set, the app will crash in given scenarion.
    var crash: Crash?
    /// Tells how many items will be added to the cart in this scenario.
    let targetPurchaseCount: UInt8

    static let envVarKey: String = "env_var.scenario"
    static func getScenarioFromEnvironment() -> Self? {
        guard let encodedString = ProcessInfo.processInfo.environment[envVarKey],
              let encodedData = encodedString.data(using: .utf8) else {
            return nil
        }
        guard let scenario = try? JSONDecoder().decode(Scenario.self, from: encodedData) else {
            fatalError("Can't decode `Scenario` from ENV value: '\(encodedString)'")
        }
        return scenario
    }
}

internal enum Crash: String, Codable, CaseIterable {
    /// Crash caused by bad cell identifier when dequeuing `UITableViewCell` in `HomeViewController`.
    case badCellIdentifierInHomeViewController
    /// Crash caused by bad cell identifier when dequeuing `UITableViewCell` in `CatalogViewController`.
    case badCellIdentifierInCatalogViewController
    /// Crash caused by decoding wrong data models from network response  in `CatalogViewController`.
    case networkResponseDecodingErrorInCatalogViewController
    /// Crash caused by accessing deallocated `unowned self` API object from response callback in `CatalogViewController`.
    case accessingDeallocatedUnownedSelfInAPIClientOnNetworkResponseForCatalogViewController
    /// Crash caused by `fatalError()` executed in `ShopistNetworking` and called from `CatalogViewController`.
    case explicitShopistNetworkingFatalErrorInCatalogViewController
    /// Crash caused by infinite recursive loop started after opening `CheckoutViewController`.
    case infiniteLoopDueToRecursiveCallAfterOpeningCheckoutViewController
}
