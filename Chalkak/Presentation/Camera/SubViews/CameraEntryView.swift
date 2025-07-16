//
//  Untitled.swift
//  Chalkak
//
//  Created by 배현진 on 7/16/25.
//

import SwiftUI

struct CameraEntryView: View {
    @State private var clipUrl: URL? = nil
    @State private var navigateToEdit = false

    var body: some View {
        NavigationStack {
            CameraView(
                clipUrl: $clipUrl,
                navigateToEdit: $navigateToEdit,
                isFirstShoot: true
            )
        }
        .navigationDestination(isPresented: $navigateToEdit) {
            if let url = clipUrl {
                ClipEditView(clipURL: url, isFirstShoot: true)
            }
        }
    }
}
