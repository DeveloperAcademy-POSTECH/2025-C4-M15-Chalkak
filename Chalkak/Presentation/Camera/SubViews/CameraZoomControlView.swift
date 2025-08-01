//
//  CameraZoomControlView.swift
//  Chalkak
//
//  Created by 정종문 on 7/25/25.
//

import SwiftUI

struct CameraZoomControlView: View {
    @ObservedObject var viewModel: CameraViewModel
    @State private var longPressStarted = false

    // 줌 활성범위
    private let zoomRanges = [
        ZoomRange(label: ".5", min: 0.0, max: 0.95, preset: 0.5),
        ZoomRange(label: "1", min: 0.95, max: 1.9, preset: 1.0),
        ZoomRange(label: "2", min: 2.0, max: .infinity, preset: 2.0)
    ]

    private var zoomIndicator: some View {
        HStack(spacing: Layout.zoomIndicatorSpacing) {
            ForEach(Array(zoomRanges.enumerated()), id: \.element.label) { index, range in
                zoomButton(for: range, at: index)
            }
        }
        .padding(.all, Layout.zoomIndicatorPadding)
        .background(SnappieColor.darkHeavy.opacity(Layout.zoomIndicatorBackgroundOpacity))
        .clipShape(Capsule())
        .offset(y: viewModel.showingZoomControl ? Layout.zoomIndicatorOffset : 0)
    }

    private var zoomSliderView: some View {
        ZoomSlider(
            zoomScale: viewModel.zoomScale,
            minZoom: viewModel.minZoomScale,
            maxZoom: viewModel.maxZoomScale,
            onValueChanged: viewModel.selectZoomScale
        )
        .frame(width: Layout.zoomSliderWidth, height: Layout.zoomSliderHeight)
        .transition(.move(edge: .top).combined(with: .opacity))
    }

    private func zoomButton(for range: ZoomRange, at index: Int) -> some View {
        let config = range.buttonConfiguration(for: viewModel.zoomScale)

        return ZoomButton(
            text: config.text,
            isActive: config.isActive,
            width: config.width
        )
        .zoomButtonGestures(
            onTap: { handleTapGesture(for: range) },
            onLongPress: handleLongPressGesture
        )
    }

    private func handleTapGesture(for range: ZoomRange) {
        guard !viewModel.isTimerRunning,
              !range.isActive(viewModel.zoomScale) else { return }

        withAnimation(.easeInOut(duration: Layout.animationDuration)) {
            viewModel.selectZoomScale(range.preset)
        }
    }

    private func handleLongPressGesture() {
        guard !viewModel.isTimerRunning else { return }

        withAnimation(.easeInOut(duration: Layout.animationDuration)) {
            viewModel.toggleZoomControl()
        }
    }

    var body: some View {
        VStack(spacing: 8) {
            zoomIndicator

            if viewModel.showingZoomControl && !viewModel.isTimerRunning {
                zoomSliderView
            }
        }
        .animation(.easeInOut(duration: Layout.animationDuration), value: viewModel.showingZoomControl)
        .padding(.bottom, Layout.zoomControlBottomPadding)
    }
}

private extension Layout {
    static let zoomControlBottomPadding: CGFloat = 13
    static let animationDuration: CGFloat = 0.3
    static let zoomIndicatorSpacing: CGFloat = 8
    static let zoomIndicatorPadding: CGFloat = 8
    static let zoomIndicatorBackgroundOpacity: CGFloat = 0.3
    static let zoomIndicatorOffset: CGFloat = -8
    static let zoomSliderWidth: CGFloat = 349
    static let zoomSliderHeight: CGFloat = 48
}

/// 줌 범위 설정
/// 라벨(.5,1,2 고정텍스트), 최소값~최대값(각각 인디케이터들이 활성화되는 줌 범위), 활성 너비, 기본값 설정
private struct ZoomRange {
    let label: String
    let min: CGFloat
    let max: CGFloat
    let activeWidth: CGFloat = 60
    let preset: CGFloat

    func isActive(_ currentZoom: CGFloat) -> Bool {
        return currentZoom >= min && currentZoom < max
    }

    func buttonConfiguration(for currentZoom: CGFloat) -> (text: String, width: CGFloat, isActive: Bool) {
        let isActive = isActive(currentZoom)
        let text = isActive ? String(format: "%.1fx", currentZoom) : label
        let width = isActive ? activeWidth : 32
        return (text, width, isActive)
    }
}
