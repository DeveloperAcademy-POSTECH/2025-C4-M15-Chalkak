//
//  ChalkakApp.swift
//  Chalkak
//
//  Created by 배현진 on 7/11/25.
//

import SwiftData
import SwiftUI

@main
struct ChalkakApp: App {
    let sharedContainer: ModelContainer

    init() {
        let config = ModelConfiguration()
        self.sharedContainer = try! ModelContainer(
            for: Clip.self, Guide.self, Project.self,
            configurations: config
        )
        SwiftDataManager.shared.configure(container: sharedContainer)
    }
    
    var body: some Scene {
        WindowGroup {
            NavigationStack {
//                CameraView(isFirstShoot: true, guide: nil)
                BoundingBoxView(guide: nil, isFirstShoot: true)
            }
        }
        .modelContainer(sharedContainer)
    }
}

//struct CameraEntryView: View {
//    @State private var path = NavigationPath()
//    @StateObject var overlayViewModel = OverlayViewModel()
//
//    var body: some View {
//        NavigationStack(path: $path) {
//            CameraView(path: $path, isFirstShoot: true, guide: nil)
//                .navigationDestination(for: CameraRoute.self) { route in
//                    switch route {
//                    case .clipEdit(let url):
//                        ClipEditView(clipURL: url, isFirstShoot: true, overlayViewModel: overlayViewModel, path: $path)
//                    case .boundingBox(let guide):
//                        BoundingBoxView(guide: guide, path: $path)
//                    case .overlay(let clipID):
//                        let overlayViewModel = OverlayViewModel()
//                        OverlayView(overlayViewModel: overlayViewModel, path: $path, clipID: clipID)
//                    }
//                }
//        }
//    }
//}
//
//enum CameraRoute: Hashable {
//    case clipEdit(URL)
//    case boundingBox(Guide)
//    case overlay(clipID: String)
//}
