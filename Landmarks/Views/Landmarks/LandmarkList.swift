import SwiftUI
import os

/// A view showing a list of landmarks.
struct LandmarkList: View {
    @EnvironmentObject var modelData: ModelData
    @State private var showFavoritesOnly = false
    @State private var filter = FilterCategory.all
    @State private var selectedLandmark: Landmark?

    private var log = Logger(subsystem: Bundle.main.bundleIdentifier!, category: "LandmarkList")

    /// Enum for the different categories that can be filtered for
    enum FilterCategory: String, CaseIterable, Identifiable {
        case all = "All"
        case lakes = "Lakes"
        case rivers = "Rivers"
        case mountains = "Mountains"
        var id: FilterCategory { self }
    }

    /// The title to display in the navigation view depending on which filter is selected
    var title: String {
        let title = filter == .all ? "Landmarks" : filter.rawValue
        log.debug("Navigation title: \(title, privacy: .public)")
        return showFavoritesOnly ? "Favorite \(title)" : title
    }

    /// Filters the landmarks list according to the properties set in the filter.
    var filteredLandmarks: [Landmark] {
        let filtered = modelData.landmarks.filter { landmark in
            (!showFavoritesOnly || landmark.isFavorite)
                && (filter == .all || filter.rawValue == landmark.category.rawValue)
        }
        log.debug("Filtered landmarks: \(filtered.count, align: .left(columns: 2))")
        return filtered
    }



    var index: Int? {
        modelData.landmarks.firstIndex(where: { $0.id == selectedLandmark?.id })
    }

    var body: some View {
        NavigationView {
            List(selection: $selectedLandmark) {
                ForEach(filteredLandmarks) { landmark in
                    NavigationLink {
                        LandmarkDetail(landmark: landmark)
                    } label: {
                        LandmarkRow(landmark: landmark)
                    }
                    .tag(landmark)
                }
            }
            .navigationTitle(title)
            .frame(minWidth: 300)
            .toolbar {
                ToolbarItem {
                    Menu {
                        Picker("Category", selection: $filter) {
                            ForEach(FilterCategory.allCases) { category in
                                Text(category.rawValue).tag(category)
                            }
                        }
                        .pickerStyle(.inline)
                        
                        Toggle(isOn: $showFavoritesOnly) {
                            Label("Favorites only", systemImage: "star.fill")
                        }
                    } label: {
                        Label("Filter", systemImage: "slider.horizontal.3")
                    }
                }
                
                ToolbarItem {
                    Button {
                        let logStorage = LogStorage()
                        let entries = logStorage.loadLogEntriesAsText()
                        guard let logURL = logStorage.saveToTempFolder(content: entries) else {
                            log.error("Cloud not save log")
                            return
                        }
                        logStorage.showSaveSheet(forFile: logURL)
                        
                    } label: {
                        Label("Expor Log", systemImage: "square.and.arrow.up")
                            .help("Export Log")
                    }
                }
            }

            Text("Select a Landmark")
        }
        .focusedValue(\.selectedLandmark, $modelData.landmarks[index ?? 0])
    }
}

struct LandmarkList_Previews: PreviewProvider {
    static var previews: some View {
        LandmarkList()
            .environmentObject(ModelData())
    }
}
