import Foundation
import OSLog
import os

#if os(macOS)
import AppKit
#else
import UIKit
#endif


/// Helper to extract and store the logging data.
struct LogStorage {
    
    let log = Logger(subsystem: Bundle.main.bundleIdentifier!, category: "LogStorage")
    
    func showSaveSheet(forFile fileURL: URL) {
#if os(macOS)
        let savePanel = NSSavePanel()
        savePanel.canCreateDirectories = true
        savePanel.isExtensionHidden = false
        savePanel.allowsOtherFileTypes = false
        savePanel.title = "Save log data"
        
        let response = savePanel.runModal()
        if (response == .OK) {
            guard let saveURL = savePanel.url else {
                return
            }
            try? FileManager.default.copyItem(at: fileURL, to: saveURL)
        }
#else
        
        let activityController = UIActivityViewController(activityItems: [fileURL], applicationActivities: nil)
        UIApplication.shared.windows.first?.rootViewController!.present(activityController, animated: true, completion: nil)
        
#endif
    }
    
    func saveToTempFolder(content: String) -> URL? {
        let now = Date().ISO8601Format()
        let tempFolder = FileManager.default.temporaryDirectory
        let logFileURL = tempFolder.appendingPathComponent("\(now).log")
        
        do {
            try content.write(to: logFileURL, atomically: false, encoding: .utf8)
        } catch let error {
            log.error("Write to file failed: \(error.localizedDescription, privacy: .public)")
            return nil
        }
        return logFileURL
    }

    /// Retrieves all logs for the last 24 hours and combines them into a
    /// string that can be stored or exported.
    ///
    /// - Returns: Human readable logs
    func loadLogEntriesAsText() -> String {
        // Article on OSLog:
        // https://steipete.com/posts/logging-in-swift/#update-ios-15
        
        // Open the log store.
        guard let logStore = try? OSLogStore(scope: .currentProcessIdentifier) else {
            return "Could not retrieve Log Store"
        }
        
        // Get all the logs from the 24 hours.
        let timeframe = logStore.position(date: Date().addingTimeInterval(3600 * 24 * 1))
        
        // Fetch log objects.
        // let filterPredicate = NSPredicate(format: "(subsystem == %@)", Bundle.main.bundleIdentifier!)
        let filterPredicate = NSPredicate(format: "TRUEPREDICATE")
        
        guard let allEntries = try? logStore.getEntries(at: timeframe, matching: filterPredicate) else {
            return "Could not retrieve Log Entries"
        }
        
        let dateStyle = Date.ISO8601FormatStyle(dateSeparator: .dash, dateTimeSeparator: .space, timeSeparator: .colon, timeZoneSeparator: Date.ISO8601FormatStyle.TimeZoneSeparator.omitted, includingFractionalSeconds: true)
        
        // Filter the log to be relevant for our specific subsystem
        let logMessages: [String] = allEntries.compactMap { entry in
            guard let logEntry = entry as? OSLogEntryLog else {
                // Filter out entries that are not log entries (e.g. signposts)
                return nil
            }
            // only get our own logs or warnings (4) and errors (5)
            guard logEntry.subsystem == Bundle.main.bundleIdentifier || logEntry.level.rawValue > 3 else {
                return nil
            }
            let date = logEntry.date.formatted(dateStyle)
            let line = [logEntry.levelName(),
                        date,
                        logEntry.subsystem,
                        "[\(logEntry.category)]",
                        logEntry.composedMessage]
                .joined(separator: " ")
            return line
        }
        return logMessages.joined(separator: "\n")
    }
    
}

extension OSLogEntryLog {
    
    /// Returns the human readable name of the log level.
    /// Error and Fault are marked with emojis.
    ///
    /// - Parameter withPadding: Determines if blank padding should be applied. Default is `false`
    /// - Returns: The name of the level
    func levelName() -> String {
        let levelName: String
        switch self.level {
        case .debug:
            levelName = "·"
        case .info:
            levelName = "•"
        case .notice:
            levelName = "⌾"
        case .error:
            levelName = "⚠️"
        case .fault:
            levelName = "💥"
            
        default:
            levelName = "❔"
        }
        
        return levelName
    }
}
