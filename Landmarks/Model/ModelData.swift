/*
See LICENSE folder for this sample’s licensing information.

Abstract:
Storage for model data.
*/

import Foundation
import Combine
import os

final class ModelData: ObservableObject {

    @Published var landmarks: [Landmark] = load("landmarkData.json")
    var hikes: [Hike] = load("hikeData.json")
    @Published var profile = Profile.default

    var features: [Landmark] {
        landmarks.filter { $0.isFeatured }
    }

    var categories: [String: [Landmark]] {
        Dictionary(
            grouping: landmarks,
            by: { $0.category.rawValue }
        )
    }
}

func load<T: Decodable>(_ filename: String) -> T {
    
    let log = Logger(subsystem: Bundle.main.bundleIdentifier!, category: "ModelData")
    
    log.notice("Load Data \(filename, privacy: .public)")
    let data: Data
    
    guard let file = Bundle.main.url(forResource: filename, withExtension: nil)
        else {
            fatalError("Couldn't find \(filename) in main bundle.")
    }
    log.debug("Load Data > file found")

    do {
        data = try Data(contentsOf: file)
    } catch {
        fatalError("Couldn't load \(filename) from main bundle:\n\(error)")
    }
    log.debug("Load Data > content loaded")

    do {
        let decoder = JSONDecoder()
        let decodedData = try decoder.decode(T.self, from: data)
        log.notice("Load Data > data load complete")

        return decodedData
    } catch {
        fatalError("Couldn't parse \(filename) as \(T.self):\n\(error)")
    }
    

}
