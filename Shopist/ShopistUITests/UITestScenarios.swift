/*
 * Unless explicitly stated otherwise all files in this repository are licensed under the Apache License Version 2.0.
 * This product includes software developed at Datadog (https://www.datadoghq.com/).
 * Copyright 2019-2020 Datadog, Inc.
 */

import Foundation

extension Scenario {
    static func next() -> Self {
        let scenario = scenarios[currentScenarioIndex % scenarios.count]
        currentScenarioIndex += 1
        return scenario
    }

    static func random() -> Self {
        return scenarios.randomElement()!
    }
}

extension Crash {
    static func random() -> Self {
        return allCases.randomElement()!
    }
}

private var currentScenarioIndex = scenarios.startIndex
private let scenarios: [Scenario] = [
    Scenario(
        user: User(name: "John Doe", countries: [.unitedStates, .unitedKingdom]),
        hasErrors: false,
        crash: nil,
        targetPurchaseCount: UInt8.random(in: 4...6)
    ),
    Scenario(
        user: User(name: "Jane Doe", countries: [.unitedStates]),
        hasErrors: true,
        crash: nil,
        targetPurchaseCount: 2
    ),
    Scenario(
        user: User(name: "Pat Doe", countries: [.germany, .ireland]),
        hasErrors: false,
        crash: nil,
        targetPurchaseCount: UInt8.random(in: 2...4)
    ),
    Scenario(
        user: User(name: "Sam Doe", countries: [.germany]),
        hasErrors: true,
        crash: nil,
        targetPurchaseCount: 5
    ),
    Scenario(
        user: User(name: "Maynard Keenan", countries: [.unitedStates]),
        hasErrors: true,
        crash: nil,
        targetPurchaseCount: 2
    ),
    Scenario(
        user: User(name: "Karina Round", countries: [.unitedKingdom]),
        hasErrors: false,
        crash: nil,
        targetPurchaseCount: 1
    ),
    Scenario(
        user: User(name: "Till Lindemann", countries: [.germany]),
        hasErrors: true,
        crash: nil,
        targetPurchaseCount: 3
    ),
    Scenario(
        user: User(name: "Bill Burr", countries: [.unitedStates, .ireland]),
        hasErrors: false,
        crash: nil,
        targetPurchaseCount: 2
    ),
    Scenario(
        user: User(name: "Raj Kapoor", countries: [.india]),
        hasErrors: false,
        crash: nil,
        targetPurchaseCount: 1
    ),
    Scenario(
        user: User(name: "Bong Joon Ho", countries: [.southKorea]),
        hasErrors: false,
        crash: nil,
        targetPurchaseCount: 2
    ),
    Scenario(
        user: User(name: "Fann Wong", countries: [.singapore]),
        hasErrors: false,
        crash: nil,
        targetPurchaseCount: 1
    ),
    Scenario(
        user: User(name: "Hayao Miyazaki", countries: [.japan]),
        hasErrors: true,
        crash: nil,
        targetPurchaseCount: 3
    ),
    Scenario(
        user: User(name: "Karen O", countries: [.unitedStates, .southKorea]),
        hasErrors: false,
        crash: nil,
        targetPurchaseCount: 1
    ),
    Scenario(
        user: User(name: "Hidetoshi Nakata", countries: [.japan]),
        hasErrors: true,
        crash: nil,
        targetPurchaseCount: 1
    ),
    Scenario(
        user: User(name: "Saoirse Ronan", countries: [.ireland]),
        hasErrors: false,
        crash: nil,
        targetPurchaseCount: 2
    ),
    Scenario(
        user: User(name: "David Beckham", countries: [.unitedStates, .unitedKingdom]),
        hasErrors: false,
        crash: nil,
        targetPurchaseCount: 3
    )
]
