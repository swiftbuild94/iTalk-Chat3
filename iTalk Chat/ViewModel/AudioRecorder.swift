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
    var recording = false {
        didSet {
            objectWillChange.send(self)
        }
    }
    
    func isAllowedToRecord() {
        do {
            try recordingSession.setCategory(.playAndRecord, mode: .default)
            try recordingSession.setActive(true)
            recordingSession.requestRecordPermission { [unowned self] allowed in
                DispatchQueue.main.async {
                    if allowed {
                       // self.loadRecordingUI()
                        print("Allowed")
                    } else {
                        print("Error")
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
        let recordingSession = AVAudioSession.sharedInstance()
        do {
            try recordingSession.setCategory(.playAndRecord, mode: .default)
            try recordingSession.setActive(true)
        } catch {
            print("Error Recording: \(error)")
        }
        let audioFileName = getDocumentsDirectory().appendingPathComponent(".recording.m4a")
        //        let audioFileName = documentPath.description.appendingPathComponent("\(Date().toString(dateFormat: "dd-MM-YY_'at'_HH:mm:ss")).m4a")
        //        let AudioFileUrl = URL(audioFileName)
        let settings = [ AVFormatIDKey: Int(kAudioFormatMPEG4AAC),
                       AVSampleRateKey: 1200,
                 AVNumberOfChannelsKey: 1,
              AVEncoderAudioQualityKey: AVAudioQuality.high.rawValue]
        
        do {
            self.audioRecorder = try AVAudioRecorder(url: audioFileName, settings: settings)
            //self.audioRecorder.delegate = self
            self.audioRecorder.record()
            self.recording = true
        } catch {
            print("Could not start recordings: \(error)")
        }
    }
    
    func stopRecording() {
        self.audioRecorder.stop()
        self.recording = false
    }
}
