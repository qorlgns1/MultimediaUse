//
//  ViewController.swift
//  MultimediaUse
//
//  Created by 배기훈 on 2020/09/15.
//  Copyright © 2020 배기훈. All rights reserved.
//
import UIKit

import AVFoundation
import AVKit


class ViewController: UIViewController {
    //오디오 재생을 위한 객체의 참조를 저장하기 위한 변수
    var audioPlayer : AVAudioPlayer?
    var player: AVAudioPlayer?
    var audioRecorder: AVAudioRecorder?
    
    @IBAction func audioPlay(_ sender: Any) {
        audioPlayer?.play()
        
        let session = AVAudioSession.sharedInstance()
        
        do {
            try session.setCategory(AVAudioSession.Category.playback,
                                    mode: .default,
                                    policy: AVAudioSession.RouteSharingPolicy.longFormAudio,
                                    options: [])
        } catch let error {
            fatalError("*** Unable to set up the audio session: \(error.localizedDescription) ***")
        }
        if let player = audioPlayer {
            player.play()
        }
    }
    
    @IBAction func audioStop(_ sender: Any) {
        btnStop.isEnabled = false
        btnPlay.isEnabled = true
        btnStart.isEnabled = true
        
        if audioRecorder?.isRecording == true {
            audioRecorder?.stop()
        } else {
            player?.stop()
        }

    }
    
    @IBAction func changeVolumn(_ sender: Any) {
        let slider = sender as! UISlider
        audioPlayer?.volume = slider.value
    }
    
    @IBAction func audioRecordStart(_ sender: Any) {
        if audioRecorder?.isRecording == false {
            btnPlay.isEnabled = false
            btnStop.isEnabled = true
            audioRecorder?.record()
        }
    }
    
    @IBAction func audioRecordStop(_ sender: Any) {
        btnStop.isEnabled = false
        btnPlay.isEnabled = true
        btnStart.isEnabled = true
        
        if audioRecorder?.isRecording == true {
            audioRecorder?.stop()
        } else {
            player?.stop()
        }

    }
    
    @IBAction func recordAudioPlay(_ sender: Any) {
        if audioRecorder?.isRecording == false {
            btnStop.isEnabled = true
            btnStart.isEnabled = false
            
            player = try! AVAudioPlayer(contentsOf: audioRecorder!.url)
            
            player?.delegate = self
            player?.play()
        }
    }
    
    @IBOutlet weak var btnStart: UIButton!
    @IBOutlet weak var btnStop: UIButton!
    @IBOutlet weak var btnPlay: UIButton!
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destination = segue.destination as! AVPlayerViewController
        
        let url = URL(string:"http://www.ebookfrenzy.com/ios_book/movie/movie.mov")
        
        //let filePath:String? = Bundle.main.path(forResource: "IPhone3G", ofType: "mov")
        //let url = URL(fileURLWithPath:filePath!)
        destination.delegate = self
        
        destination.player = AVPlayer(url: url!)
    }
    @IBAction func videoPlay(_ sender: Any) {
        let filePath:String? = Bundle.main.path(forResource: "IPhone3G", ofType: "mov")
        let url = URL(fileURLWithPath:filePath!)
        let player = AVPlayer(url:url)
        let playerController = AVPlayerViewController()
        playerController.player = player
        self.addChild(playerController)
        self.view.addSubview(playerController.view)
        playerController.view.frame = self.view.frame
        player.play()
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //재생할 음원 파일의 URL을 생성
        //번들의 test.mp3
        let url = URL(fileURLWithPath: Bundle.main.path(forResource: "test", ofType: ".mp3")!, relativeTo: nil)
        //오디오 재생기 초기화
        audioPlayer = try! AVAudioPlayer(contentsOf: url)
        //재생 준비
        audioPlayer!.prepareToPlay()
        
        btnPlay.isEnabled = false
        btnStop.isEnabled = false
        
        let dirPaths =
            NSSearchPathForDirectoriesInDomains(
                .documentDirectory, .userDomainMask, true)
        let docsDir = dirPaths[0]
        let soundFilePath = docsDir + "/sound.caf"
        let soundFileURL = URL(fileURLWithPath: soundFilePath)
        let recordSettings:[String:Any] =
            [AVEncoderAudioQualityKey: AVAudioQuality.min.rawValue,
             AVEncoderBitRateKey: 16,
             AVNumberOfChannelsKey: 2,
             AVSampleRateKey: 44100.0]
        
        let audioSession = AVAudioSession.sharedInstance()
        try! audioSession.setCategory(AVAudioSession.Category.playAndRecord)
        
        
        audioRecorder = try! AVAudioRecorder(url: soundFileURL, settings: recordSettings)
        
        audioRecorder?.prepareToRecord()

    }


}

extension ViewController:AVAudioPlayerDelegate, AVPlayerViewControllerDelegate {
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer,
                                         successfully flag: Bool) {
            btnStart.isEnabled = true
            btnStop.isEnabled = false
    }
        
    func audioPlayerDecodeErrorDidOccur(_ player: AVAudioPlayer,
                                            error: Error?) {
            print("Audio Play Decode Error")
    }
        
    func audioRecorderDidFinishRecording(_ recorder: AVAudioRecorder,
                                             successfully flag: Bool) {
    }
        
    func audioRecorderEncodeErrorDidOccur(_ recorder: AVAudioRecorder,
                                              error: Error?) {
            print("Audio Record Encode Error")
    }
    
    func playerViewController(_ playerViewController: AVPlayerViewController,
                              restoreUserInterfaceForPictureInPictureStopWithCompletionHandler completionHandler: @escaping (Bool) -> Void) {
        
        let currentViewController =
            navigationController?.visibleViewController
        
        if currentViewController != playerViewController {
            if let topViewController =
                navigationController?.topViewController {
                
                topViewController.present(playerViewController,
                                          animated: true, completion: {()
                                            completionHandler(true)
                })
            }
        }
    }
}
