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
    @StateObject private var playerViewModel: PlayerViewModel

    init() {
        let audioService = AudioPlayerService()
        let trackRepository = ITunesTrackRepository()
        let colorExtractor = ColorExtractorService()
        let nowPlayingManager = NowPlayingManager(audioService: audioService)

        _playerViewModel = StateObject(wrappedValue: PlayerViewModel(
            audioService: audioService,
            trackRepository: trackRepository,
            colorExtractorService: colorExtractor
        ))
    }

    var body: some Scene {
        WindowGroup {
            RootView()
                .environmentObject(playerViewModel)
        }
    }
}
