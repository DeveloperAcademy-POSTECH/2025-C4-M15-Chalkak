//
//  VideoPreview.swift
//  Chalkak
//
//  Created by Youbin on 7/15/25.
//

import AVKit
import SwiftUI


/**
 VideoPreviewView: 영상 미리보기 뷰

 트리밍 중인 영상의 현재 상태를 보여주는 프리뷰 뷰.
 드래그 중일 때는 정적인 프리뷰 이미지, 그렇지 않으면 AVPlayer를 통한 영상 재생 화면

 ## 호출 위치
 - ClipEditView 내부에서 현재 영상 구간 시각화 용도로 사용됨
 - 호출 예시: `VideoPreviewView(previewImage: ..., player: ..., isDragging: ...)`
 */
struct VideoPreviewView: View {
    let previewImage: UIImage?
    let player: AVPlayer?
    let isDragging: Bool
    let overlayImage: UIImage?

    var body: some View {
        ZStack {
            Group {
                if isDragging, let previewImage = previewImage {
                    Image(uiImage: previewImage)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 296, height: 526)
                } else if let player = player {
                    VideoPlayer(player: player)
                        .frame(width: 296, height: 526)
                } else {
                    Text("영상을 불러오는 중...")
                        .frame(width: 296, height: 526)
                }
            }

            if let overlayImage = overlayImage {
                Image(uiImage: overlayImage)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 296, height: 526)
            }
        }
    }
}
