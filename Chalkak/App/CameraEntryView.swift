////
////  CameraEntryView.swift
////  Chalkak
////
////  Created by 배현진 on 7/16/25.
////
//
//import SwiftUI
//
//struct CameraEntryView: View {
//    @State private var navigateToEdit = false
//    @State private var clipUrl: URL?
//
//    var body: some View {
//        NavigationStack {
//            CameraView(clipUrl: $clipUrl, navigateToEdit: $navigateToEdit, isFirstShoot: true)
//                .navigationDestination(isPresented: $navigateToEdit) {
//                    if let url = clipUrl {
//                        ClipEditView(clipURL: url, isFirstShoot: true)
//                            .onAppear {
//                                // ✅ 전환 직후 상태 초기화
//                                navigateToEdit = false
//                                clipUrl = nil
//                            }
//                    }
//                }
//        }
//    }
//}
