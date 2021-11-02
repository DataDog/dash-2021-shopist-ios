/*
 * Unless explicitly stated otherwise all files in this repository are licensed under the Apache License Version 2.0.
 * This product includes software developed at Datadog (https://www.datadoghq.com/).
 * Copyright 2019-2020 Datadog, Inc.
 */

import XCTest

/// This suite executes Shopist integration tests by playing randomized `Scenarios` in a `~30min` loop.
/// By running this suite on CI multiple times a day, we send RUM data to Datadog Demo org which is used by our Sales team to showcase
/// platfrom features to our clients.
///
/// The order of running tests in this `XCTestCase` is critical - hence we are naming them in alphabetical order which is respected by Xcode.
class ShopistUITests: XCTestCase {
    /// For how long scenarios should be played in loop on CI.
    private static let scenariosLoopingDuration: TimeInterval = 26.5 * 60.0 // 26.5 minutes
    /// The start date of tests execution.
    private static var startTime: Date! // swiftlint:disable:this implicitly_unwrapped_optional

    override class func setUp() {
        super.setUp()
        startTime = Date()
    }

    // MARK: - Tests - ordered alphabetically

    /// This test is run first. It runs the scenario with expecting the app to crash on one of the `Crash` reasons.
    /// The crash event will be uploaded from next tests.
    func test00_runCrashingScenario() {
        var scenario: Scenario = .random()
        scenario.crash = .random()

        // We can't make this expected failure more strict with `XCTExpectedFailure.Options.issueMatcher`,
        // as sometimes it fails due to "Shopist crashed in <...>" (indicating expected crash) and sometimes due to
        // "Failed to get matching snapshots: Lost connection to the application (pid 6851)" (indicating the UI Test
        // runner failure on accessing element in terminated process).
        //
        // As strict assertion would be flaky, here we do a broad one:
        XCTExpectFailure("The scenario is configured to crash the app (\(String(describing: scenario.crash))), so we expect test failure.")

        run(scenario: scenario)
    }

    /// Following tests are run in alphabetical order.
    /// If overal execution time exceeds planned duration (`scenariosLoopingDuration`), remaining tests are skipped.
    func test01_runNextScenario() throws { try runOrSkip(scenario: .next()) }
    func test02_runNextScenario() throws { try runOrSkip(scenario: .next()) }
    func test03_runNextScenario() throws { try runOrSkip(scenario: .next()) }
    func test04_runNextScenario() throws { try runOrSkip(scenario: .next()) }
    func test05_runNextScenario() throws { try runOrSkip(scenario: .next()) }
    func test06_runNextScenario() throws { try runOrSkip(scenario: .next()) }
    func test07_runNextScenario() throws { try runOrSkip(scenario: .next()) }
    func test08_runNextScenario() throws { try runOrSkip(scenario: .next()) }
    func test09_runNextScenario() throws { try runOrSkip(scenario: .next()) }

    func test10_runNextScenario() throws { try runOrSkip(scenario: .next()) }
    func test11_runNextScenario() throws { try runOrSkip(scenario: .next()) }
    func test12_runNextScenario() throws { try runOrSkip(scenario: .next()) }
    func test13_runNextScenario() throws { try runOrSkip(scenario: .next()) }
    func test14_runNextScenario() throws { try runOrSkip(scenario: .next()) }
    func test15_runNextScenario() throws { try runOrSkip(scenario: .next()) }
    func test16_runNextScenario() throws { try runOrSkip(scenario: .next()) }
    func test17_runNextScenario() throws { try runOrSkip(scenario: .next()) }
    func test18_runNextScenario() throws { try runOrSkip(scenario: .next()) }
    func test19_runNextScenario() throws { try runOrSkip(scenario: .next()) }

    func test20_runNextScenario() throws { try runOrSkip(scenario: .next()) }
    func test21_runNextScenario() throws { try runOrSkip(scenario: .next()) }
    func test22_runNextScenario() throws { try runOrSkip(scenario: .next()) }
    func test23_runNextScenario() throws { try runOrSkip(scenario: .next()) }
    func test24_runNextScenario() throws { try runOrSkip(scenario: .next()) }
    func test25_runNextScenario() throws { try runOrSkip(scenario: .next()) }
    func test26_runNextScenario() throws { try runOrSkip(scenario: .next()) }
    func test27_runNextScenario() throws { try runOrSkip(scenario: .next()) }
    func test28_runNextScenario() throws { try runOrSkip(scenario: .next()) }
    func test29_runNextScenario() throws { try runOrSkip(scenario: .next()) }

    func test30_runNextScenario() throws { try runOrSkip(scenario: .next()) }
    func test31_runNextScenario() throws { try runOrSkip(scenario: .next()) }
    func test32_runNextScenario() throws { try runOrSkip(scenario: .next()) }
    func test33_runNextScenario() throws { try runOrSkip(scenario: .next()) }
    func test34_runNextScenario() throws { try runOrSkip(scenario: .next()) }
    func test35_runNextScenario() throws { try runOrSkip(scenario: .next()) }
    func test36_runNextScenario() throws { try runOrSkip(scenario: .next()) }
    func test37_runNextScenario() throws { try runOrSkip(scenario: .next()) }
    func test38_runNextScenario() throws { try runOrSkip(scenario: .next()) }
    func test39_runNextScenario() throws { try runOrSkip(scenario: .next()) }

    func test40_runNextScenario() throws { try runOrSkip(scenario: .next()) }
    func test41_runNextScenario() throws { try runOrSkip(scenario: .next()) }
    func test42_runNextScenario() throws { try runOrSkip(scenario: .next()) }
    func test43_runNextScenario() throws { try runOrSkip(scenario: .next()) }
    func test44_runNextScenario() throws { try runOrSkip(scenario: .next()) }
    func test45_runNextScenario() throws { try runOrSkip(scenario: .next()) }
    func test46_runNextScenario() throws { try runOrSkip(scenario: .next()) }
    func test47_runNextScenario() throws { try runOrSkip(scenario: .next()) }
    func test48_runNextScenario() throws { try runOrSkip(scenario: .next()) }
    func test49_runNextScenario() throws { try runOrSkip(scenario: .next()) }

    func test50_runNextScenario() throws { try runOrSkip(scenario: .next()) }

    /// This test is run last. It launches the app and waits enough time to ensure that all data from previous tests is uploaded.
    func test99_launchTheAppOneLastTimeToUploadPendingData() {
        let app = ShopistApp()
        app.launchToHomepage(with: .next())
        Thread.sleep(forTimeInterval: 30.0)
    }

    // MARK: - Helpers

    /// Runs given scenario only if tests execution time does not exceed planned duration.
    private func runOrSkip(scenario: Scenario) throws {
        let expectedEndTime = ShopistUITests.startTime.addingTimeInterval(ShopistUITests.scenariosLoopingDuration)
        let currentTime = Date()

        try XCTSkipIf(currentTime > expectedEndTime)

        run(scenario: scenario)
    }

    /// Navigates the app through given `scenario`.
    private func run(scenario: Scenario) {
        let app = ShopistApp()
        let categories = app.launchToHomepage(with: scenario)

        var itemCount = 0
        while itemCount < scenario.targetPurchaseCount {
            do {
                categories.swipeRandomly()
                let products = try categories.goToProducts()
                products.swipeRandomly()

                let productDetails = try products.goToProductDetails()
                if productDetails.addToCart() {
                    itemCount += 1
                }
                app.goBackToHomepage()

                if itemCount == scenario.targetPurchaseCount {
                    let cart = try app.goToCart()
                    cart.checkout()
                    cart.proceed()
                }
            } catch {
                app.goBackToHomepage()
            }
        }
        app.terminate()
    }
}
