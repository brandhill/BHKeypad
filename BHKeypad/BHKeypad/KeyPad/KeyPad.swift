//
//  NumPad.swift
//  BHKeypad
//
//  Created by Hill on 2016/7/19.
//  Copyright © 2016年 Mitsw. All rights reserved.
//

import Foundation
import AVFoundation

@IBDesignable
class KeyPad: UIView {
    
    @IBOutlet weak var creditPointView: CreditView!
    @IBOutlet weak var numKey0: NumKey!
    @IBOutlet weak var numKey1: NumKey!
    @IBOutlet weak var numKey2: NumKey!
    @IBOutlet weak var numKey3: NumKey!
    @IBOutlet weak var numKey4: NumKey!
    @IBOutlet weak var numKey5: NumKey!
    @IBOutlet weak var numKey6: NumKey!
    @IBOutlet weak var numKey7: NumKey!
    @IBOutlet weak var numKey8: NumKey!
    @IBOutlet weak var numKey9: NumKey!
    @IBOutlet weak var numKeyStar: NumKey!
    @IBOutlet weak var numKeyHash: NumKey!
    @IBOutlet weak var dialBar: DialBar!
    
    private var contentView: UIView!
    private let digitAlphaMapping = ["", "\u{0020}", "ABC", "DEF", "GHI", "JKL", "MNO", "PQRS", "TUV", "WXYZ"]
    private var backSpaceHoldTimer: NSTimer!
    
    private let digitStart = 48 // ascii code range of number 0 ~ 9 is between 48 and 57
    private let hashKeyTag = 35 // ascii code for hash character is 35
    private let starKeyTag = 42 // ascii code for star character is 42
    private let backSpaceKeyTag = 8 // ascii code for backspace character is 8
    private let dialKeyTag = 200
    
    var numKeyPressedClosure: ((phone: String) -> Void)?
    var dialKeyPressedClosure: ((phone: String) -> Void)?
    var currInput = ""
    
    private let dtmfPlayer = DTMFPlayer()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initFromXIB()
        setupUiComponent()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initFromXIB()
        setupUiComponent()
    }
    
    func initFromXIB() {
        let bundle = NSBundle(forClass: self.dynamicType)
        let nib = UINib(nibName: "KeyPad", bundle: bundle)
        contentView = nib.instantiateWithOwner(self, options: nil)[0] as! UIView
        contentView.frame = bounds
        contentView.autoresizingMask = [.FlexibleWidth]
        
        self.addSubview(contentView)
        self.backgroundColor = UIColor(red:5/255.0, green:37/255.0, blue:60/255.0,  alpha:1)
        self.clipsToBounds = true
    }
    
    func setupUiComponent(){
        
        let numKeys = [numKey0, numKey1, numKey2,numKey3,
                       numKey4, numKey5, numKey6,
                       numKey7, numKey8, numKey9]
        
        for (index, key) in numKeys.enumerate() {
            key.digitLabel.text = String(index)
            key.alphaLabel.text = digitAlphaMapping[index]
            key.button.tag = digitStart + index
            key.button.addTarget(self, action: #selector(onNumKeyClick), forControlEvents: .TouchUpInside)
            key.button.addTarget(self, action: #selector(onNumKeyPressed), forControlEvents: .TouchDown)
        }
        
        numKeyStar.digitLabel.text = "*"
        numKeyStar.alphaLabel.text = ""
        numKeyStar.button.tag = starKeyTag
        numKeyStar.button.addTarget(self, action: #selector(onNumKeyClick), forControlEvents: .TouchUpInside)
        numKeyStar.button.addTarget(self, action: #selector(onNumKeyPressed), forControlEvents: .TouchDown)
        
        numKeyHash.digitLabel.text = "#"
        numKeyHash.alphaLabel.text = ""
        numKeyHash.button.tag = hashKeyTag
        numKeyHash.button.addTarget(self, action: #selector(onNumKeyClick), forControlEvents: .TouchUpInside)
        numKeyHash.button.addTarget(self, action: #selector(onNumKeyPressed), forControlEvents: .TouchDown)
        
        dialBar.dialButton.tag = dialKeyTag
        dialBar.dialButton.addTarget(self, action: #selector(onDialClick), forControlEvents: .TouchUpInside)
        
        dialBar.backSpaceView.button.tag = backSpaceKeyTag
        dialBar.backSpaceView.button.addTarget(self, action: #selector(backSpaceKeyDown), forControlEvents: .TouchDown)
        dialBar.backSpaceView.button.addTarget(self, action: #selector(backSpaceKeyUp), forControlEvents: [.TouchUpInside, .TouchUpOutside])
    }
    
    func backSpaceKeyDown(sender: UIButton) {
        onBackSpaceKeyClick(sender)
        backSpaceHoldTimer = NSTimer.scheduledTimerWithTimeInterval(0.2, target: self, selector: #selector(backSpaceBtnHold), userInfo: nil, repeats: true)
    }
    
    func backSpaceKeyUp(sender: AnyObject) {
        backSpaceHoldTimer.invalidate()
    }
    
    func backSpaceBtnHold(sender: UIButton) {
        if !currInput.isEmpty {
            onBackSpaceKeyClick(sender)
        } else {
            backSpaceHoldTimer.invalidate()
        }
    }
    
    func onNumKeyClick(sender: UIButton) {
        currInput.append(Character(UnicodeScalar(sender.tag)))
        
        if let closure = numKeyPressedClosure{
            closure(phone: currInput)
        }
    }
    
    func onNumKeyPressed(sender: UIButton) {
        dtmfPlayer.playTone("\(Character(UnicodeScalar(sender.tag)))")
    }
    
    func onBackSpaceKeyClick(sender: UIButton){
        
        guard !currInput.isEmpty else{
            return
        }
        
        currInput = String(currInput.characters.dropLast())
        
        if let closure = numKeyPressedClosure{
            closure(phone: currInput)
        }
    }
    
    func onDialClick(sender: UIButton){
        if let closure = dialKeyPressedClosure{
            closure(phone: currInput)
        }
    }
    
    func setActionClosure(numKeyPressedClosure numKeyPressedClosure: ((phone: String) -> Void)?, dialKeyPressedClosure: ((phone: String) -> Void)?){
        self.numKeyPressedClosure = numKeyPressedClosure
        self.dialKeyPressedClosure = dialKeyPressedClosure
    }
}

private class DTMFPlayer {
    
    let sampleRate: Float = 8000.0
    let audioFormat: AVAudioFormat
    
    var audioEngine: AVAudioEngine? = nil
    var audioPlayer:AVAudioPlayerNode = AVAudioPlayerNode()
    
    init() {
        audioFormat = AVAudioFormat(commonFormat: .PCMFormatFloat32, sampleRate: Double(sampleRate), channels: 2, interleaved: false)
        
        awakeEngine()
    }
    
    func awakeEngine() -> Bool {
        let audioEngine = AVAudioEngine()
        
        audioPlayer = AVAudioPlayerNode()
        
        audioEngine.attachNode(audioPlayer)
        audioEngine.connect(audioPlayer, to: audioEngine.mainMixerNode, format:audioFormat)
        
        do {
            try audioEngine.start()
            self.audioEngine = audioEngine
            return true
            
        } catch let error as NSError {
            self.audioEngine = nil
            print("engine start error: \(error)")
            return false
        }
    }
    
    func playTone(sequence: String) {
        
        if !(self.audioEngine?.running ?? false) && !awakeEngine() {
            return
        }
        
        guard let tones = DTMFHelper.tonesForString(sequence) else {
            return
        }
        
        let systemVolume = AVAudioSession.sharedInstance().outputVolume
        if systemVolume >= 0.2 {
            self.audioEngine?.mainMixerNode.outputVolume = 0.2 / systemVolume
            audioPlayer.volume = 0.2 / systemVolume
        }
        
        var samples = [Float]()
        for tone in tones {
            let toneSamples = DTMFHelper.generateDTMF(tone, space: .Standard, sampleRate: sampleRate)
            samples.appendContentsOf(toneSamples)
        }
        
        let frameCount = AVAudioFrameCount(samples.count)
        
        let buffer = AVAudioPCMBuffer(PCMFormat: audioFormat, frameCapacity: frameCount)
        buffer.frameLength = frameCount
        
        let channelMemory = buffer.floatChannelData
        for channelIndex in 0 ..< Int(audioFormat.channelCount) {
            let frameMemory = channelMemory[channelIndex]
            memcpy(frameMemory, samples, Int(frameCount) * sizeof(Float))
        }
        
        audioPlayer.scheduleBuffer(buffer, atTime: nil, options: .Interrupts, completionHandler: nil)
        audioPlayer.play()
    }
    
    func stop() {
        audioPlayer.stop()
    }
    
}