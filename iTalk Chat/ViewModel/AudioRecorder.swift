//
//  AudioRecorder.swift
//  iTalk Chat
//
//  Created by Patricio Benavente on 19/04/2022.
//

import Foundation
import Firebase
import FirebaseFirestoreSwift
import Combine
import AVFoundation

class AudioRecorder: ObservableObject {
    let objectWillChange = PassthroughSubject<AudioRecorder, Never>()
    var audioRecorder: AVAudioRecorder!
    var recordingSession: AVAudioSession!
    var soundURL: String?
    var recording = false {
        didSet {
            objectWillChange.send(self)
        }
    }
    
    private func isAllowedToRecord() {
        do {
            try recordingSession.setCategory(.playAndRecord, mode: .default)
            try recordingSession.setActive(true)
            recordingSession.requestRecordPermission() { [unowned self] allowed in
                DispatchQueue.main.async {
                    if allowed {
//                        self.startRecording()
                        print("Allowed")
                    } else {
                        print("Error Session Recording")
                    }
                }
            }
        } catch {
            print(error)
        }
    }
    
    private func getDocumentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }
    
    func startRecording() {
        let audioFileName = UUID().uuidString + "m4a"
        let audioFileURL = getDocumentsDirectory().appendingPathComponent(audioFileName)
        soundURL = audioFileName
        let settings = [
            AVFormatIDKey: Int(kAudioFormatMPEG4AAC),
            AVSampleRateKey: 12000,
            AVNumberOfChannelsKey: 1,
            AVEncoderAudioQualityKey: AVAudioQuality.high.rawValue
        ]
        do {
            audioRecorder = try AVAudioRecorder(url: audioFileURL, settings: settings)
//            audioRecorder.delegate = self
            audioRecorder.isMeteringEnabled = true
            audioRecorder.prepareToRecord()
            audioRecorder.record()
        } catch {
            print(error)
        }
    }
    
    func stopRecording() {
        self.audioRecorder.stop()
        self.recording = false
    }
}
