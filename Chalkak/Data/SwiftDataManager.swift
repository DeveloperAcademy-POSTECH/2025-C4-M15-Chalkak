//
//  SwiftDataManager.swift
//  Chalkak
//
//  Created by 배현진 on 7/15/25.
//

import Foundation
import SwiftData
import SwiftUI

/**
 SwiftData 사용을 편리하게 하기 위한 클래스
 
 `SwiftDataManager`는 SwiftData 사용을 편리하게 하기 위해 쿼리 메서드를 모아 관리합니다.
 
 ## 사용 예시
 ```
 @Published var clips: [Clip] = []
 
 func loadClips() {
     clips = SwiftDataManager.shared.fetchAllClips()
 }
 
 func createClip(
     videoURL: URL,
     startPoint: Double,
     endPoint: Double,
     tiltList: [TimeStampedTilt] = [],
     heightList: [TimeStampedHeight] = []
 ) {
     let _ = SwiftDataManager.shared.createClip(
         videoURL: videoURL,
         startPoint: startPoint,
         endPoint: endPoint,
         tiltList: tiltList,
         heightList: heightList
     )
     SwiftDataManager.shared.saveContext()
     loadClips()
 }
 
 func deleteClip(_ clip: Clip) {
     SwiftDataManager.shared.deleteClip(clip)
     SwiftDataManager.shared.saveContext()
     loadClips()
 }
 ```
 */

@MainActor
class SwiftDataManager {
    static let shared = SwiftDataManager()
    
    private var container: ModelContainer?
    var context: ModelContext {
        guard let container = container else {
            fatalError("ModelContainer가 아직 설정되지 않았습니다. configure(container:)를 먼저 호출하세요.")
        }
        return container.mainContext
    }

    private init() {}
    
    func configure(container: ModelContainer) {
        self.container = container
    }

    // MARK: - Project
    
    /// `Project` 생성
    func createProject(
        id: String,
        guide: Guide? = nil,
        clips: [Clip] = [],
        cameraSetting: CameraSetting? = nil,
        referenceDuration: Double? = nil
    ) -> Project {
        let project = Project(
            id: id,
            guide: guide,
            clipList: clips,
            cameraSetting: cameraSetting,
            referenceDuration: referenceDuration
        )
        context.insert(project)
        return project
    }

    // TODO: - 프로젝트 단의 관리 시작 시점에 구현 (Berry)
    //    func fetchAllProjects() -> [Project] {
    //    }
    
    /// `Project` id 이용해 조회
    func fetchProject(byID id: String) -> Project? {
        let predicate = #Predicate<Project> { $0.id == id }
        let descriptor = FetchDescriptor<Project>(predicate: predicate)
        return try? context.fetch(descriptor).first
    }

    /// `Project` 삭제
    func deleteProject(_ project: Project) {
        context.delete(project)
    }

    // MARK: - Clip

    /// `Clip` 생성: Clip 객체 데이터로
    func createClip(
        id: String,
        videoURL: URL,
        originalDuration: Double,
        startPoint: Double = 0,
        endPoint: Double,
        tiltList: [TimeStampedTilt] = [],
        heightList: [TimeStampedHeight] = []
    ) -> Clip {
        let clip = Clip(
            id: id,
            videoURL: videoURL,
            originalDuration: originalDuration,
            startPoint: startPoint,
            endPoint: endPoint,
            tiltList: tiltList,
            heightList: heightList
        )
        context.insert(clip)
        return clip
    }
    
    /// `Clip` 생성: Clip 객체로
    func createClip(clip: Clip) -> Clip {
        context.insert(clip)
        return clip
    }

    /// `Clip` 가져오기
    func fetchClip(byID id: String) -> Clip? {
        let predicate = #Predicate<Clip> { $0.id == id }
        let descriptor = FetchDescriptor<Clip>(predicate: predicate)
        return try? context.fetch(descriptor).first
    }

    /// `Clip` 삭제하기
    func deleteClip(_ clip: Clip) {
        context.delete(clip)
    }

    // MARK: - Guide

    /// `Guide` 생성
    func createGuide(
        clipID: String,
        boundingBoxes: [BoundingBoxInfo],
        outlineImage: UIImage,
        cameraTilt: Tilt,
        cameraHeight: Float
    ) -> Guide {
        let guide = Guide(
            clipID: clipID,
            boundingBoxes: boundingBoxes,
            outlineImage: outlineImage,
            cameraTilt: cameraTilt,
            cameraHeight: cameraHeight
        )
        context.insert(guide)
        return guide
    }

    /// `Guide` 가져오기
    func fetchGuide(forClipID clipID: String) -> Guide? {
        let predicate = #Predicate<Guide> { $0.clipID == clipID }
        let descriptor = FetchDescriptor<Guide>(predicate: predicate)
        return try? context.fetch(descriptor).first
    }

    /// `Guide` 삭제하기
    func deleteGuide(_ guide: Guide) {
        context.delete(guide)
    }
    
    // MARK: - CameraSetting
    
    /// `CameraSetting` 생성
    func createCameraSetting(
        zoomScale: CGFloat,
        isGridEnabled: Bool,
        isFrontPosition: Bool,
        timerSecond: Int
    ) -> CameraSetting {
        let setting = CameraSetting(
            zoomScale: zoomScale,
            isGridEnabled: isGridEnabled,
            isFrontPosition: isFrontPosition,
            timerSecond: timerSecond
        )
        context.insert(setting)
        return setting
    }

    // MARK: - Save & Rollback

    /// Context 저장하기 - 변경사항 반영
    func saveContext() {
        do {
            try context.save()
        } catch {
            print("저장 실패: \(error)")
        }
    }
}
