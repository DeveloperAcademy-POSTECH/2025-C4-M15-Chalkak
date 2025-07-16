////
////  CameraView.swift
////  Chalkak
////
////  Created by 배현진 on 7/16/25.
////
//
//import SwiftUI
//
//struct BoundingBoxCameraView: View {
//    @StateObject private var viewModel: CameraViewModel = .init()
//    @State private var clipUrl: URL?
//    @Binding var navigateToEdit: Bool // <-- 바인딩으로 받아오기
//
//    let isFirstShoot: Bool
//    let guide: Guide?
//
//    var body: some View {
//        ZStack {
//            CameraPreviewView(session: viewModel.session, showGrid: $viewModel.isGrid)
//
//            VStack {
//                CameraTopControlView(viewModel: viewModel)
//                Spacer()
//                CameraBottomControlView(viewModel: viewModel)
//            }
//        }
////        .onReceive(NotificationCenter.default.publisher(for: .init("VideoSaved"))) { output in
////            if let userInfo = output.userInfo, let url = userInfo["url"] as? URL {
////                self.clipUrl = url
////                if !isFirstShoot {
////                    self.navigateToEdit = true // 바깥에서 push 하도록 요청
////                }
////            }
////        }
//        .onAppear {
//            viewModel.model.onVideoSaved = { url in
//                if !isFirstShoot {
//                    self.clipUrl = url
//                    self.navigateToEdit = true
//                }
//            }
//        }
//
//    }
//}
