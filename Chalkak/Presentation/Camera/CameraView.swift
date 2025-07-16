//
//  CameraView.swift
//  Chalkak
//
//  Created by 정종문 on 7/12/25.
//

import SwiftUI

struct CameraView: View {
    @StateObject private var viewModel: CameraViewModel = .init()

    @State private var clipUrl: URL?
    @State private var navigateToEdit = false
    
    let isFirstShoot: Bool
    let guide: Guide?

    var body: some View {
        ZStack {
            CameraPreviewView(session: viewModel.session, showGrid: $viewModel.isGrid)

            VStack {
                CameraTopControlView(viewModel: viewModel)

                Spacer()

                CameraBottomControlView(viewModel: viewModel)
            }
        }
        
        // 저장된 영상 있는 경우 (영상 촬영 중지)
        .onReceive(NotificationCenter.default.publisher(for: .init("VideoSaved"))) { output in
            guard isFirstShoot else { return }

            if let userInfo = output.userInfo, let url = userInfo["url"] as? URL {
                self.clipUrl = url
                self.navigateToEdit = true
            }
        }
//            .onAppear {
//                viewModel.model.onVideoSaved = { url in
//                    if isFirstShoot {
//                        self.clipUrl = url
//                        self.navigateToEdit = true
//                    }
//                }
//            }
    
        .onDisappear {
            self.navigateToEdit = false
        }
        
        .navigationDestination(isPresented: $navigateToEdit) {
            if let url = clipUrl {
                ClipEditView(clipURL: url, isFirstShoot: true)
            }
        }
    }
}
