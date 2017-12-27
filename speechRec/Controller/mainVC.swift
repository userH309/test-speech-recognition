import UIKit
import Speech
import AVFoundation

class mainVC: UIViewController,AVAudioPlayerDelegate
{
    var audioPlayer: AVAudioPlayer!
    @IBOutlet weak var acitivitySpinner: UIActivityIndicatorView!
    @IBOutlet weak var transcriptionTextField: UITextView!
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        acitivitySpinner.isHidden = true
    }
    
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) //run when audio player has finished
    {
        player.stop()
        acitivitySpinner.stopAnimating()
        acitivitySpinner.isHidden = true
    }
    
    func requestSpeechAuth()
    {
        
        SFSpeechRecognizer.requestAuthorization //ask for permission to use speech
        {
            authStatus in
            
            if authStatus == SFSpeechRecognizerAuthorizationStatus.authorized //if user has granted permission
            {
                if let path = Bundle.main.url(forResource: "secret", withExtension: "wav") //get the path for the file
                {
                    do
                    {
                        let sound = try AVAudioPlayer(contentsOf: path) //try the audioplayer
                        self.audioPlayer = sound
                        self.audioPlayer.delegate = self
                        self.audioPlayer.play() //play the sound
                    }
                    catch //catch error
                    {
                        print("Error")
                    }
                    let recognizer = SFSpeechRecognizer()
                    let request = SFSpeechURLRecognitionRequest(url: path) //request to recognize speech in the recorded audio file
                    recognizer?.recognitionTask(with: request) //set up the speech recognition task
                    {
                        (result,error) in
                        if let error = error //catch error
                        {
                            print("There was an error \(error)")
                        }
                        else
                        {
                            print(result!.bestTranscription.formattedString) //print the result of the audio/text operation to the console
                            self.transcriptionTextField.text = (result!.bestTranscription.formattedString) //print the result of the audio/text operation to textfield
                        }
                    }
                }
            }
        }
    }
    
    @IBAction func playAndTransBtnPressed(_ sender: UIButton)
    {
        acitivitySpinner.isHidden = false
        acitivitySpinner.startAnimating()
        requestSpeechAuth()
    }
}

