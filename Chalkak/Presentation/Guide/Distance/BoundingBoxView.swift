//
//  BoundingBoxView.swift
//  Chalkak
//
//  Created by 배현진 on 7/14/25.
//

import SwiftUI

struct BoundingBoxView: View {
    let guide: Guide?
    let isFirstShoot: Bool

    @StateObject private var viewModel = BoundingBoxViewModel()
    @StateObject private var cameraViewModel = CameraViewModel()

    var body: some View {
        ZStack {
            if isFirstShoot {
                // 첫촬영 - 가이드 없는 카메라
                CameraView(isFirstShoot: isFirstShoot, guide: nil)
            } else {
                if viewModel.isAligned {
                    Color.blue.ignoresSafeArea().transition(.opacity)
                }

                // 두번째 이후 촬영 - 가이드 있는 카메라
                CameraView(isFirstShoot: isFirstShoot, guide: guide)
            }
        }
        .onAppear {
            if let guide = guide {
                viewModel.setReference(from: guide)
                cameraViewModel.setBoundingBoxUpdateHandler { bboxes in
                    viewModel.liveBoundingBoxes = bboxes
                }
            }
        }
        .onChange(of: viewModel.liveBoundingBoxes) {
            viewModel.compare()
        }
    }
}
