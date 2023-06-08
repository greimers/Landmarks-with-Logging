import SwiftUI

/// A view showing featured landmarks above a list of all of the landmarks.
struct ContentView: View {

    @State private var selection: Tab = .featured

    /// Enum for the the tabs in the main view
    enum Tab: Int {
        case featured = 1
        case list = 2
    }

    var body: some View {
        TabView(selection: $selection) {
            CategoryHome()
                .tabItem {
                    Label("Featured", systemImage: "star")
                }
                .tag(Tab.featured)

            LandmarkList()
                .tabItem {
                    Label("List", systemImage: "list.bullet")
                }
                .tag(Tab.list)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .environmentObject(ModelData())
    }
}
