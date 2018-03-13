import UIKit
import Speech

class mainVC: UIViewController,AVAudioPlayerDelegate {
    
    var audioPlayer: AVAudioPlayer!
    
    @IBOutlet weak var acitivitySpinner: UIActivityIndicatorView!
    @IBOutlet weak var transcriptionTextField: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        acitivitySpinner.isHidden = true
    }
    
    //Stop the activitySpinner animation and player when the audio player finish.
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        player.stop()
        acitivitySpinner.stopAnimating()
        acitivitySpinner.isHidden = true
    }
    
    func speechToTextConverter() {
        //Ask for permission to use speech recognizer.
        SFSpeechRecognizer.requestAuthorization { authStatus in
            
            if authStatus == .authorized {
                //Store the path for the internal resource sound file if it exists.
                if let path = Bundle.main.url(forResource: "secret", withExtension: "wav") {
                    //Try do play file, catch error if it fails.
                    do {
                        let sound = try AVAudioPlayer(contentsOf: path)
                        self.audioPlayer = sound
                        self.audioPlayer.delegate = self
                        self.audioPlayer.play()
                    }
                    catch {
                        print("ERROR: Failed to play file.")
                    }
                    let recognizer = SFSpeechRecognizer()
                    //Request to recognize speech in the file.
                    let request = SFSpeechURLRecognitionRequest(url: path)
                    //Set up the speech recognition.
                    recognizer?.recognitionTask(with: request) {
                        (result,error) in
                        if let error = error {
                            print("There was an error \(error)")
                        }
                        else {
                            //Print the result of the speech rec to text field.
                            self.transcriptionTextField.text = (result!.bestTranscription.formattedString)
                        }
                    }
                }
            }
        }
    }
    
    //Start activity spinner and run speechToTextConverter.
    @IBAction func playAndTransBtnPressed(_ sender: UIButton) {
        acitivitySpinner.isHidden = false
        acitivitySpinner.startAnimating()
        speechToTextConverter()
    }
}

