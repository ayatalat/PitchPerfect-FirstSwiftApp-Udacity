
import UIKit
import AVFoundation

class RecordSoundViewController: UIViewController , AVAudioRecorderDelegate{

    @IBOutlet weak var tabToRecord: UILabel!
    
    @IBOutlet weak var stopRecord: UIButton!
    @IBOutlet weak var record: UIButton!
    
    var audioRecorder: AVAudioRecorder!
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    @IBAction func audioRecord(_ sender: Any) {
        configureUI(isRecording: true)
        let dirPath = NSSearchPathForDirectoriesInDomains(.documentDirectory,.userDomainMask, true)[0] as String
        let recordingName = "recordedVoice.wav"
        let pathArray = [dirPath, recordingName]
        let filePath = URL(string: pathArray.joined(separator: "/"))
        
        let session = AVAudioSession.sharedInstance()
       try! session.setCategory(AVAudioSessionCategoryPlayAndRecord, with:AVAudioSessionCategoryOptions.defaultToSpeaker)

        
        try! audioRecorder = AVAudioRecorder(url: filePath!, settings: [:])
        audioRecorder.delegate = self
        audioRecorder.isMeteringEnabled = true
        audioRecorder.prepareToRecord()
        audioRecorder.record()
    }
    
    
    @IBAction func stopRecording(_ sender: Any) {
        configureUI(isRecording: false)
        audioRecorder.stop()
        let auidoSession = AVAudioSession.sharedInstance()
        try! auidoSession.setActive(false)
    }
    
    
    func configureUI(isRecording: Bool) {
        tabToRecord.text = isRecording ?  "Recording in progress" : "Tap to record"
        stopRecord.isEnabled = isRecording
        record.isEnabled = !isRecording
    }
    
    func audioRecorderDidFinishRecording(_ recorder: AVAudioRecorder, successfully flag: Bool) {
        if flag {
            performSegue(withIdentifier: "stopRecording", sender: audioRecorder.url)
        }else {
            print("Failed To Recording")
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "stopRecording" {
            let playSoundVc = segue.destination as! playSoundViewController
            let recordUrl = sender as! URL
            playSoundVc.auidoRecordUrl = recordUrl
        }
    }
}

