//
//  SoundBox.swift
//  Sokoban
//
//  Created by Juan Gestal Romani on 15/9/18.
//  Copyright © 2018 Juan Gestal Romani. All rights reserved.
//

import SceneKit
import AVFoundation

class SoundManager {
    
    static let shared = SoundManager()
    var sounds: [String: SCNAudioSource] = [:]
    var audioPlayer: AVAudioPlayer?

    func setupSounds() {
            loadSound(name: "boxMovement", fileNamed: "art.scnassets/Sounds/boxMovement.wav")
            loadSound(name: "footStep", fileNamed: "art.scnassets/Sounds/footStep.wav")
            loadSound(name: "badMovement", fileNamed: "art.scnassets/Sounds/badMovement.wav")
            loadSound(name: "moveBack", fileNamed: "art.scnassets/Sounds/moveBack.wav")
            loadSound(name: "levelCompleted", fileNamed: "art.scnassets/Sounds/levelCompleted.wav")
    }

    private func loadSound(name:String, fileNamed:String) {
        if let sound = SCNAudioSource(fileNamed: fileNamed) {
            sound.isPositional = false
            sound.volume = 0.3
            sound.load()
            sounds[name] = sound
        }
    }
    
    func playSound(node:SCNNode, name:String) {
        if UserDefaults.standard.bool(forKey: "isSoundDisabled") {
            return
        }
        let sound = sounds[name]
        node.runAction(SCNAction.playAudio(sound!, waitForCompletion: false))
    }
    
    
    func playGameMusic() {
        playLoopMusic(fileName: "gameMusic")
    }
    
    func playMenuMusic() {
        playLoopMusic(fileName: "menuMusic")
    }
    
    func stopMusic() {
        audioPlayer?.stop()
    }
    
    private func playLoopMusic(fileName: String) {
        if UserDefaults.standard.bool(forKey: "isMusicDisabled") {
            return
        }
        
        audioPlayer?.stop()
        let audioPath = Bundle.main.path(forResource: fileName, ofType: "mp3")!
        let audioURL = URL.init(fileURLWithPath: audioPath)

        do {
            audioPlayer = try AVAudioPlayer(contentsOf: audioURL)
            audioPlayer!.numberOfLoops = -1
            audioPlayer!.prepareToPlay()
            audioPlayer!.play()
        } catch {
            print("Cannot play the file")
        }
    }
}
