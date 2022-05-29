//
//  AudioRecorder.swift
//  iTalk Chat
//
//  Created by Patricio Benavente on 19/04/2022.
//

import Foundation
import SwiftUI
import Combine
import AVFoundation
// import AVKit

class AudioRecorder: ObservableObject {
    @Published var audios = [URL]()
    private var audioRecorder: AVAudioRecorder!
    private var audioSession: AVAudioSession!
    
    deinit {
        self.stopRecording()
    }
    
    
    // MARK: - Recording
    private func isAllowedToRecord() -> Bool {
        var isAllowed = false
        do {
            let recordingSession = AVAudioSession.sharedInstance()
            try recordingSession.setCategory(.record, mode: .spokenAudio)
            try recordingSession.setActive(true)
            recordingSession.requestRecordPermission() { allowed in
                if allowed {
                    isAllowed = true
                    print("Audio -> Allowed to Record")
                } else {
                    let vmAlerts = Alerts()
                    vmAlerts.showCancel = true
                    vmAlerts.title = "Audio Recording"
                    vmAlerts.message = "Audio recording not allowed please change settings in Settings"
                    vmAlerts.defaultText = "Go to Settings"
                    vmAlerts.okHandler = {
                        print("Go to Settings")
                    }
                    vmAlerts.isAlert = true
                    print("Error Session Recording")
                }
            }
        } catch {
            print("Error not allowed to record: \(error)")
        }
        return isAllowed
    }
    
    func startRecording() {
        guard isAllowedToRecord() else { return }
        
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        let audioFileName = Date().toString(dateFormat: "YY-MM-dd_HH-mm-ss") + ".m4a"
        let audioFileURL = paths.appendingPathComponent(audioFileName)
        let settings = [
            AVFormatIDKey: Int(kAudioFormatMPEG4AAC),
            AVSampleRateKey: 12000,
            AVNumberOfChannelsKey: 1,
            AVEncoderAudioQualityKey: AVAudioQuality.high.rawValue
        ]
        print("Audio -> Start Record")
        do {
            audioRecorder = try AVAudioRecorder(url: audioFileURL, settings: settings)
            audioRecorder.isMeteringEnabled = true
            audioRecorder.prepareToRecord()
            audioRecorder.record()
            print("Audio -> Recording")
        } catch {
            print("Error recording: \(error)")
        }
    }
    
    func stopRecording() {
        self.audioRecorder?.stop()
    }
    
    
    // MARK: - Get Audios
    func getAudios() -> [URL]? {
        self.audios.removeAll()
        let fileManager = FileManager.default
        let documentDirectory = fileManager.urls(for: .documentDirectory, in: .userDomainMask)[0]
        do {
            let directoryContents = try fileManager.contentsOfDirectory(at: documentDirectory, includingPropertiesForKeys: nil)
            for audio in directoryContents {
                self.audios.append(audio)
            }
            return self.audios
        } catch {
            return nil
        }
    }
    

    // MARK: - Delete Recordings
    func deleteRecording(url : URL){
        do {
            try FileManager.default.removeItem(at: url)
        } catch {
            print("Can't delete")
        }
    }
}
