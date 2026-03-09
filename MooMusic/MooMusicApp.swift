//
//  MooMusicApp.swift
//  MooMusic
//
//  Created by Shmatov Nikita on 07.03.2026.
//

import SwiftUI
import PresentationLayer
import PlatformLayer
import DomainLayer
import DataLayer

@main
struct MooMusicApp: App {
    let audioService: AudioServiceProtocol
    let trackRepository: TrackRepositoryProtocol
    let nowPlayingManager: NowPlayingManager

    init() {
        audioService = AudioPlayerService()
        trackRepository = ITunesTrackRepository()
        nowPlayingManager = NowPlayingManager(audioService: audioService)
    }

    var body: some Scene {
        WindowGroup {
            PlayerView(viewModel: PlayerViewModel(
                audioService: audioService,
                trackRepository: trackRepository
            ))
        }
    }
}
