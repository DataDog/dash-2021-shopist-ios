/*
 * Unless explicitly stated otherwise all files in this repository are licensed under the Apache License Version 2.0.
 * This product includes software developed at Datadog (https://www.datadoghq.com/).
 * Copyright 2019-2020 Datadog, Inc.
 */

import Foundation

/// A set of diagnostics information for Shopist runs monitoring in 'Mobile - Integration' org.
internal struct Diagnostics {
    /// If extra telemetry info should be added.
    /// This ENV is only configured for runs targeting Mobile - Integration org.
    static var collectExtraTelemetry: Bool {
        let env = ProcessInfo.processInfo.environment["ADD_EXTRA_TELEMETRY"]
        return env == "1" || env == "true"
    }

    /// Bitrise build URL injected through ENV.
    static var bitriseBuildURL: String? {
        ProcessInfo.processInfo.environment["BITRISE_BUILD_URL"]
    }

    /// Generates report on features storage capacity.
    static func getStorageReportAttributes() -> [String: Int] {
        let fileManager = FileManager.default

        guard let cacheDirectoryURL = fileManager.urls(for: .cachesDirectory, in: .userDomainMask).first else {
            print("🔥 Cannot obtain cache directory URL")
            return ["error": -1]
        }

        var report: [String: Int] = [:]

        // Check authorised data folder for each feature
        let logsDirectory = cacheDirectoryURL.appendingPathComponent("com.datadoghq.logs/v1")
        let tracingDirectory = cacheDirectoryURL.appendingPathComponent("com.datadoghq.traces/v1")
        let rumDirectory = cacheDirectoryURL.appendingPathComponent("com.datadoghq.rum/v1")

        report["log-files-count"] = fileManager.recursivelyFindFiles(in: logsDirectory)?.count ?? -1
        report["trace-files-count"] = fileManager.recursivelyFindFiles(in: tracingDirectory)?.count ?? -1
        report["rum-files-count"] = fileManager.recursivelyFindFiles(in: rumDirectory)?.count ?? -1

        return report
    }
}

// MARK: - Helpers

private extension FileManager {
    /// Recursively finds all files in given directory `url`.
    func recursivelyFindFiles(in directoryURL: URL) -> [URL]? {
        guard let enumerator = self.enumerator(
                at: directoryURL,
                includingPropertiesForKeys: [.isRegularFileKey]
        ) else {
            print("🔥 Failed to recursively enumerate file names in \(directoryURL)")
            return nil
        }
        var files: [URL] = []
        for case let fileURL as URL in enumerator { files.append(fileURL) }
        return files
    }
}
