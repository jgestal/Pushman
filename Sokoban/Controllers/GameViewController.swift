//
//  GameViewController.swift
//  Sokoban
//
//  Created by Juan Gestal Romani on 29/8/18.
//  Copyright © 2018 Juan Gestal Romani. All rights reserved.
//

import UIKit
import QuartzCore
import SceneKit

class GameViewController: CustomViewController {
    
    @IBOutlet weak var scnView: SCNView!
    @IBOutlet weak var movesLabel: UILabel!
    
    @IBOutlet weak var exitButton: UIButton!
    @IBOutlet weak var reloadButton: UIButton!
    @IBOutlet weak var zoomInButton: UIButton!
    @IBOutlet weak var zoomOutButton: UIButton!
    @IBOutlet weak var moveBackButton: UIButton!
    @IBOutlet weak var hudView: UIView!
    @IBOutlet weak var levelCompletedCoverView: UIView!
    @IBOutlet weak var levelCompletedView: RoundedView!
    @IBOutlet weak var levelCompletedBestLabel: UILabel!
    @IBOutlet weak var levelCompleteMovesLabel: UILabel!

    var selectedWorld: Int!
    var selectedLevel: Int!
    
    private var scene: SCNScene!
    
    private let maxZoom: Float = 6
    private let minZoom: Float = 28
    private let defaultZoom: Float = 16
    
    private var cameraNode: SCNNode!
    private var cameraFollowNode: SCNNode!
    private var lightFollowNode: SCNNode!
    private var playerNode: SCNNode!
    
    private var canMove = true
    
    private var sounds: [String: SCNAudioSource] = [:]
    private var playerNodeRotation : [SCNVector4]!
    
    private var level = Level()
    private var levelMap : String!

    private var moves = 0 {
        didSet {
            let movesText = "MOVES: \(moves)"
            movesLabel.text = movesText
            levelCompleteMovesLabel.text = movesText
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        levelCompletedCoverView.isHidden = true
        levelCompletedView.alpha = 0
        
        setupScene()
        setupSwipes()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        SoundManager.shared.playGameMusic()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        SoundManager.shared.playMenuMusic()
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "kLevelCompletedSegue" {
            
        }
    }

    func loadLevelMap(levelMap: String) {
        self.levelMap = levelMap
        level.loadLevelMap(levelMap: levelMap)
        level.delegate = self
        setupZoom()
        setupFloor()
        setupGameNodes()
    }
    
    func setupScene() {
        playerNodeRotation = [SCNVector4]()
        scene = SCNScene(named: "art.scnassets/game.scn")
        scnView.scene = scene
        moves = 0
        
        playerNode = scene.rootNode.childNode(withName: "player", recursively: true)!
        cameraNode = scene.rootNode.childNode(withName: "camera", recursively: true)!
        cameraFollowNode = scene.rootNode.childNode(withName: "followCamera", recursively: true)!
        lightFollowNode = scene.rootNode.childNode(withName: "followLight", recursively: true)!
    
        let levelMap = LevelManager.shared.worlds[selectedWorld].levels[selectedLevel].levelMap!
        loadLevelMap(levelMap: levelMap)
      
        // allows the user to manipulate the camera
        // scnView.allowsCameraControl = true
        // show statistics such as fps and timing information
        // scnView.showsStatistics = true
        
        scnView.backgroundColor = UIColor.black
    }
    
    func setupSwipes() {
        let swipeRecognizerUp = UISwipeGestureRecognizer(target: self, action: #selector(swipe))
        swipeRecognizerUp.direction = .up
        let swipeRecognizerLeft = UISwipeGestureRecognizer(target: self, action: #selector(swipe))
        swipeRecognizerLeft.direction = .right
        let swipeRecognizerDown = UISwipeGestureRecognizer(target: self, action: #selector(swipe))
        swipeRecognizerDown.direction = .down
        let swipeRecognizerRight = UISwipeGestureRecognizer(target: self, action: #selector(swipe))
        swipeRecognizerRight.direction = .left
        [swipeRecognizerUp,swipeRecognizerRight,swipeRecognizerDown,swipeRecognizerLeft].forEach { scnView.addGestureRecognizer($0) }
    }
    
    @objc func swipe(swipeGesture: UISwipeGestureRecognizer) {
        
        switch swipeGesture.direction {
        case .up:
            moveUp()
        case .right:
            moveRight()
        case .down:
            moveDown()
        case .left:
            moveLeft()
        default:
            return
        }
    }
}

// Player movement
extension GameViewController {
        
    func moveUp() {
        move(displacement: IJPoint.up, angle: Angle.up)
    }
    
    func moveRight() {
        move(displacement: IJPoint.right, angle: Angle.right)
    }
    
    func moveDown() {
        move(displacement: IJPoint.down, angle: Angle.down)
    }
    
    func moveLeft() {
        move(displacement: IJPoint.left, angle: Angle.left)
    }
}

// UI Buttons
extension GameViewController {
    
    func exit() {
        let alertController = UIAlertController(title: "Exit Level", message: "You will lose your current progress. Are you sure?", preferredStyle: .alert)
        
        let action1 = UIAlertAction(title: "Yes", style: .default) { (action:UIAlertAction) in
            self.navigationController?.popViewController(animated: true)
        }
        
        let action2 = UIAlertAction(title: "No", style: .cancel)
        
        alertController.addAction(action1)
        alertController.addAction(action2)
        self.present(alertController, animated: true, completion: nil)
    }
    
    func zoomIn() {
        changeZoom(increment: -1)
    }
    
    func zoomOut() {
        changeZoom(increment: 1)
    }
    
    func reload() {
        let alertController = UIAlertController(title: "Restart Level", message: "You will lose your current progress. Are you sure?", preferredStyle: .alert)
        
        let action1 = UIAlertAction(title: "Yes", style: .default) { (action:UIAlertAction) in
            self.setupScene()
            
        }
        
        let action2 = UIAlertAction(title: "No", style: .cancel)
        
        alertController.addAction(action1)
        alertController.addAction(action2)
        self.present(alertController, animated: true, completion: nil)
    }
    
    func levelCompletedButton() {
        navigationController?.popViewController(animated: true)
    }
}


extension GameViewController {

    @IBAction func exitButtonTapped(_ sender: UIButton) {
       exit()
    }
    
    @IBAction func zoomInButtonTapped(_ sender: UIButton) {
        zoomIn()
    }
    
    @IBAction func zoomOutButtonTapped(_ sender: UIButton) {
        zoomOut()
    }
    
    @IBAction func backMovementButtonTapped(_ sender: UIButton) {
        moveBack()
    }
    
    @IBAction func reloadButtonTapped(_ sender: UIButton) {
       reload()
    }
    
    @IBAction func levelCompletedOKButtonTapped(_ sender: UIButton) {
       levelCompletedButton()
    }
}

extension GameViewController: LevelDelegate {
    func setupZoom() {
        let x = cameraNode.position.x
        let y = cameraNode.position.y
        var z = defaultZoom
        if let savedZoom = UserDefaults.standard.value(forKey: "customZoom") as? Float {
            z = savedZoom
        }
        cameraNode.position = SCNVector3(x: x, y: y, z: z)
    }
    
    private func positionForNode(point: IJPoint, isFloor: Bool) -> SCNVector3 {
        let xPos = Float(point.j)
        let yPos = isFloor ? 0 : Float(0.1)
        let zPos = Float(point.i)
        return SCNVector3(x: xPos, y: yPos, z: zPos)
    }
    
    private func setupFloor() {
        for i in 0..<level.fields.count {
            for j in 0..<level.fields[i].count {
                let field = level.fields[i][j]
                var floor: SCNNode!
                if field == .boxOnGoalSquare || field == .goalSquare || field == .playerOnGoalSquare {
                    floor = scnView.scene!.rootNode.childNode(withName: "boxTarget", recursively: true)!.flattenedClone()
                } else {
                    floor = scnView.scene!.rootNode.childNode(withName: "darkFloor", recursively: true)!.flattenedClone()
                }
                floor.position = positionForNode(point: IJPoint(i: i, j: j), isFloor: true)
                floor.isHidden = false
                scnView.scene!.rootNode.addChildNode(floor)
            }
        }
    }
    
    private func setupGameNodes() {
        for i in 0..<level.fields.count {
            for j in 0..<level.fields[i].count {
                let field = level.fields[i][j]
                var nodes = [SCNNode]()
                switch field {
                case .box, .boxOnGoalSquare:
                    let boxNode = scnView.scene!.rootNode.childNode(withName: "box", recursively: true)!.flattenedClone()
                    boxNode.isHidden = false
                    let boxYellowNode = scnView.scene!.rootNode.childNode(withName: "yellowBox", recursively: true)!.flattenedClone()
                    boxYellowNode.isHidden = field == .box
                    boxNode.isHidden = field == .boxOnGoalSquare
                    nodes.append(boxNode)
                    nodes.append(boxYellowNode)
                case .player, .playerOnGoalSquare:
                    playerNode.position = positionForNode(point: IJPoint(i: i, j: j), isFloor: false)
                    cameraFollowNode.position = playerNode.position
                    lightFollowNode.position = playerNode.position
                    playerNode.isHidden = false
                    nodes.append(playerNode)
                case .wall:
                    let wall = scnView.scene!.rootNode.childNode(withName: "wall", recursively: true)!.flattenedClone()
                    wall.isHidden = false
                    nodes.append(wall)
                default:
                    break
                }
                
                nodes.forEach {
                    $0.position = positionForNode(point: IJPoint(i: i, j: j), isFloor: false)
                    scnView.scene!.rootNode.addChildNode($0)
                }
            }
        }
    }
    
    
    func moveBack() {
        
        SoundManager.shared.playSound(node: playerNode, name: "moveBack")
        
        if level.moveBack() {
            moves += 1
            var boxes = [SCNNode]()
            var yellowBoxes = [SCNNode]()
            scnView.scene!.rootNode.childNodes.forEach {
                if $0.name == "box" {
                    boxes.append($0)
                }
                if $0.name == "yellowBox" {
                    yellowBoxes.append($0)
                }
            }
            for i in 0..<level.fields.count {
                for j in 0..<level.fields[i].count {
                    let field = level.fields[i][j]
                    if field == .box || field == .boxOnGoalSquare {
                        let box = boxes.removeLast()
                        box.position = positionForNode(point: IJPoint(i: i, j: j), isFloor: false)
                        let yellowBox = yellowBoxes.removeLast()
                        yellowBox.position = positionForNode(point: IJPoint(i: i, j: j), isFloor: false)
                        box.isHidden = field == .boxOnGoalSquare
                        yellowBox.isHidden = field == .box
                    }
                    else if field == .player || field == .playerOnGoalSquare {
                        playerNode.position = positionForNode(point: IJPoint(i: i, j: j), isFloor: false)
                        playerNode.rotation = playerNodeRotation.removeLast()
                        cameraFollowNode.position = playerNode.position
                        lightFollowNode.position = playerNode.position
                    }
                }
            }
        }
        
        if !level.canMoveBack() {
            moves = 0
        }
    }
    private func move(displacement: IJPoint, angle: CGFloat) {
        if canMove {
            canMove = false
            unowned let unownedSelf = self
            let deadlineTime = DispatchTime.now() + 0.3
            DispatchQueue.main.asyncAfter(deadline: deadlineTime, execute: {
                unownedSelf.canMove = true
            })
            level.move(with: displacement)
            rotatePlayer(to: angle)
        }
    }
    
    private func rotatePlayer(to: CGFloat) {
        playerNodeRotation.append(playerNode.rotation)
        playerNode?.runAction(SCNAction.rotateTo(x: 0, y: to, z: 0, duration: 0.3, usesShortestUnitArc: true))
    }
    
    func changeZoom(increment: Float) {
        
        let x = cameraNode.position.x
        let y = cameraNode.position.y
        
        var z = cameraNode.position.z + increment
        
        if z > minZoom { z = minZoom }
        if z < maxZoom { z = maxZoom }
        
        cameraNode.position = SCNVector3(x: x, y: y, z: z)
        
        UserDefaults.standard.set(z, forKey: "customZoom")
        UserDefaults.standard.synchronize()
    }
    
    func movementNotAllowed() {
        print("Bad Movement")
        SoundManager.shared.playSound(node: playerNode, name: "badMovement")
        if playerNodeRotation.count > 0 {
            playerNodeRotation.removeLast()
        }
    }
    
    func showScore() {
        if let bestScore = LevelManager.shared.getScore(worldID: selectedWorld, levelID: selectedLevel) {
            if moves < bestScore {
                LevelManager.shared.saveScore(worldID: selectedWorld, levelID: selectedLevel, moves: moves)
                levelCompletedBestLabel.text = "NEW RECORD!"
            } else {
                levelCompletedBestLabel.text = "BEST: \(bestScore)"
            }
        } else {
            LevelManager.shared.saveScore(worldID: selectedWorld, levelID: selectedLevel, moves: moves)
            levelCompletedBestLabel.text = "NEW RECORD!"
        }
    }
    
    func levelCompleted() {
        SoundManager.shared.playSound(node: playerNode, name: "levelCompleted")
        showScore()
        levelCompletedCoverView.isHidden = false
        UIView.animate(withDuration: 1.0) {
        [self.exitButton,self.reloadButton,self.zoomInButton,self.zoomOutButton,self.moveBackButton,self.hudView].forEach {
                $0.alpha = 0
            }
            self.levelCompletedView.alpha = 1.0
        }
        print("Level Completed")
    }
    func nodeMoves(from: IJPoint, to: IJPoint) {
        let origin = positionForNode(point: from, isFloor: false)
        let destiny = positionForNode(point: to, isFloor: false)
        
        var nodes = [SCNNode]()
        
        if SCNVector3EqualToVector3(playerNode.position, origin) {
            nodes.append(playerNode)
            nodes.append(cameraFollowNode)
            nodes.append(lightFollowNode)
        } else {
            scene.rootNode.childNodes.forEach {
                if ($0.name == "box" || $0.name == "yellowBox") && SCNVector3EqualToVector3($0.position, origin) {
                    nodes.append($0)
                }
            }
        }
        nodes.forEach {
            $0.runAction(SCNAction.move(to: destiny, duration: 0.2))
            
            if $0.name == "player" {
                SoundManager.shared.playSound(node: $0, name: "footStep")
                moves += 1
            }
            else if $0.name == "box" {
                SoundManager.shared.playSound(node: $0, name: "boxMovement")
            }
            let destinyField = level.fields[to.i][to.j]
            
            if $0.name == "yellowBox" {
                $0.isHidden = destinyField == .box
            }
            if $0.name == "box" {
                $0.isHidden = destinyField == .boxOnGoalSquare
            }
        }
    }
}
