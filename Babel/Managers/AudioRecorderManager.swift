import AVFoundation

enum RecordingState {
    case start
    case stop
    case notGranted
}

final class AudioRecorderManager: NSObject, AVAudioRecorderDelegate {
    private var audioRecorder: AVAudioRecorder?
    private var authorizationHandler: ((_ granted: Bool) -> Void)?

    static let shared = AudioRecorderManager()
    
    private override init() {
        super.init()
    }
    
    func isAudioRecordingGranted() -> Bool {
        if #available(iOS 17.0, *) {
            return AVAudioApplication.shared.recordPermission == .granted
        } else {
            return AVAudioSession.sharedInstance().recordPermission == .granted
        }
    }
    
    func authorizeMicrophoneAccess(completion: @escaping ((_ granted: Bool) -> Void)) {
        authorizationHandler = completion
        
        if #available(iOS 17.0, *) {
            switch AVAudioApplication.shared.recordPermission {
            case .granted:
                completion(true)
            default:
                AVAudioApplication.requestRecordPermission { isAllowed in
                    completion(isAllowed)
                }
            }
        } else {
            switch AVAudioSession.sharedInstance().recordPermission {
            case .granted:
                completion(true)
            default:
                AVAudioSession.sharedInstance().requestRecordPermission { isAllowed in
                    if isAllowed {
                        completion(isAllowed)
                    }
                }
            }
        }
    }
    
    func setupRecorder() {
        if isAudioRecordingGranted() {
            do {
                try AVAudioSession.sharedInstance().setCategory(.playAndRecord, mode: .default)
                try AVAudioSession.sharedInstance().setActive(true)
            } catch {
                print("error setting up audio recorder", error.localizedDescription)
            }
        } else {
            authorizeMicrophoneAccess(completion: { _ in })
        }
    }
    
    
    func startRecording(fileName: String) {
        let documentsURL = StorageManager.shared.getDocumentsURL()
        let audioFileName = documentsURL.appendingPathComponent(fileName + ".m4a")
        
        let settings = [
            AVFormatIDKey: Int(kAudioFormatMPEG4AAC),
            AVSampleRateKey: 12000,
            AVNumberOfChannelsKey: 1,
            AVEncoderAudioQualityKey: AVAudioQuality.high.rawValue
        ]
        
        setupRecorder()
        
        do {
            audioRecorder = try AVAudioRecorder(url: audioFileName, settings: settings)
            audioRecorder?.delegate = self
            audioRecorder?.record()
        } catch {
            print("Error recording ", error.localizedDescription)
            finishRecording()
        }
    }
    
    func finishRecording() {
        if let audioRecorder {
            audioRecorder.stop()
            self.audioRecorder = nil
        }
    }
    
    func cancelRecording() {
        if let audioRecorder {
            audioRecorder.stop()
            audioRecorder.deleteRecording()
            self.audioRecorder = nil
        }
    }
}
