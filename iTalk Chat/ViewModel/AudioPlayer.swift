//
//  AudioPlayer.swift
//  iTalk Chat
//
//  Created by Patricio Benavente on 15/05/2022.
//

import Foundation
import SwiftUI
import Combine
import AVFoundation

class AudioPlayer: ObservableObject {
    private var audioSession: AVAudioSession!
    @Published var audioPlayer: AVAudioPlayer!
    let objectWillChange = PassthroughSubject<AudioPlayer, Never>()
    @Published var isPlaying = false {
        didSet {
            objectWillChange.send(self)
        }
    }
    
    deinit {
        self.stopPlay()
    }
    
    // MARK: - Play Audio
    private func isAllowedToPlay() -> Bool {
        var isAllowed = false
        do {
            try audioSession?.overrideOutputAudioPort(.speaker)
            isAllowed = true
            print("Audio -> Allowed to Play")
        } catch {
            print("Playing over the device's speakers failed: \(error)")
        }
        return isAllowed
    }
    
    func playAudio(_ audio: String) {
        print("Play Audio: \(audio)")
        if isAllowedToPlay() {
            guard let soundFileURL = URL(string: audio) else {
                print("Not found")
                return
            }
            do {
                let audioData = try Data(contentsOf: soundFileURL)
                print("Audio -> Getting Data: \(audioData)")
            } catch {
                print("Error getting data")
                return
            }
            do {
                try AVAudioSession.sharedInstance().setCategory(.soloAmbient)
                print("Audio -> Set Category")
            } catch {
                print("Error on Solo")
                return
            }
            do {
                try AVAudioSession.sharedInstance().setActive(true)
                print("Audio -> Activate session")
            } catch {
                print("Error on activate session: \(error)")
                return
            }
            do {
                let player = try AVAudioPlayer(data: Data(contentsOf: soundFileURL), fileTypeHint: "m4a")
                player.volume = 1.0
                player.prepareToPlay()
                player.play()
                self.isPlaying = true
                print("Audio -> audio is playing")
            } catch {
                print("Error Playing: \(error)")
                return
            }
            print("Audio Played without errors")
        }
    }
    

    private func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        if flag {
            isPlaying = false
        }
    }
    
    func stopPlay() {
        audioPlayer?.stop()
        isPlaying = false
    }
}
