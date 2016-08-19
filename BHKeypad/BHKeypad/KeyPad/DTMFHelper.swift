//
//  DTMFHelper.swift
//  iWhatsCall
//
//  Created by Roger Chuang on 8/18/16.
//  Copyright © 2016 CheetahMobile. All rights reserved.
//

import Foundation

public typealias DTMFType = (Float, Float)

public class DTMFHelper {
    
    public static let Tone1     = DTMFType(1209.0, 697.0)
    public static let Tone2     = DTMFType(1336.0, 697.0)
    public static let Tone3     = DTMFType(1477.0, 697.0)
    public static let Tone4     = DTMFType(1209.0, 770.0)
    public static let Tone5     = DTMFType(1336.0, 770.0)
    public static let Tone6     = DTMFType(1477.0, 770.0)
    public static let Tone7     = DTMFType(1209.0, 852.0)
    public static let Tone8     = DTMFType(1336.0, 852.0)
    public static let Tone9     = DTMFType(1477.0, 852.0)
    public static let Tone0     = DTMFType(1336.0, 941.0)
    public static let ToneStar  = DTMFType(1209.0, 941.0)
    public static let TonePound = DTMFType(1477.0, 941.0)
    
    public struct SpaceType {
        
        public static let Standard = SpaceType(duration: 100.0, interval: 250.0)
        
        var duration: Float
        var interval: Float
        
        init(duration: Float, interval: Float) {
            self.duration = duration
            self.interval = interval
        }
    }
    
    public static func generateDTMF(DTMF: DTMFType, space: SpaceType = .Standard, sampleRate: Float = 44100.0) -> [Float] {
        let toneLengthInSamples = 10e-4 * space.duration * sampleRate
        let silenceLengthInSamples = 10e-4 * space.interval * sampleRate
        
        var sound = [Float](count: Int(toneLengthInSamples + silenceLengthInSamples), repeatedValue: 0)
        let twoPI = 2.0 * Float(M_PI)
        
        for i in 0 ..< Int(toneLengthInSamples) {
            // Add first tone at half volume
            let sample1 = 0.4 * sin(Float(i) * twoPI / (sampleRate / DTMF.0));
            
            // Add second tone at half volume
            let sample2 = 0.4 * sin(Float(i) * twoPI / (sampleRate / DTMF.1));
            
            sound[i] = sample1 + sample2
        }
        
        return sound
    }
}

extension DTMFHelper {
    
    enum CharacterForTone: Character {
        case Tone1     = "1"
        case Tone2     = "2"
        case Tone3     = "3"
        case Tone4     = "4"
        case Tone5     = "5"
        case Tone6     = "6"
        case Tone7     = "7"
        case Tone8     = "8"
        case Tone9     = "9"
        case Tone0     = "0"
        case ToneA     = "A"
        case ToneB     = "B"
        case ToneC     = "C"
        case ToneD     = "D"
        case ToneStar  = "*"
        case TonePound = "#"
    }
    
    public static func toneForCharacter(character: Character) -> DTMFType? {
        var tone: DTMFType?
        
        guard let ch = CharacterForTone(rawValue: character) else {
            return nil
        }
        
        switch (ch) {
            
        case .Tone1:
            tone = DTMFHelper.Tone1
        
        case .Tone2:
            tone = DTMFHelper.Tone2
        
        case .Tone3:
            tone = DTMFHelper.Tone3
        
        case .Tone4:
            tone = DTMFHelper.Tone4
        
        case .Tone5:
            tone = DTMFHelper.Tone5
        
        case .Tone6:
            tone = DTMFHelper.Tone6
        
        case .Tone7:
            tone = DTMFHelper.Tone7
        
        case .Tone8:
            tone = DTMFHelper.Tone8
        
        case .Tone9:
            tone = DTMFHelper.Tone9
        
        case .Tone0:
            tone = DTMFHelper.Tone0
        
        case .ToneStar:
            tone = DTMFHelper.ToneStar
        
        case .TonePound:
            tone = DTMFHelper.TonePound
        
        default:
            break
        }
        
        return tone
    }
    
    public static func tonesForString(string: String) -> [DTMFType]? {
        var tones = [DTMFType]()
        
        for character in string.characters {
            if let tone = toneForCharacter(character) {
                tones.append(tone)
            }
        }
        
        return tones.count > 0 ? tones : nil
    }
}
