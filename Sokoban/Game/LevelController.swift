////
////  GameLevel.swift
////  Sokoban
////
////  Created by Juan Gestal Romani on 29/8/18.
////  Copyright © 2018 Juan Gestal Romani. All rights reserved.
////
//
//import SceneKit
//
//
//
//
//
//protocol LevelControllerDelegate: class {
//    func updatedMovements(movements: Int)
//    func levelCompleted()
//}
//
//
//class LevelController {
//    
//    let maxZoom: Float = 6
//    let minZoom: Float = 28
//    let defaultZoom: Float = 16
//    weak var delegate: LevelControllerDelegate?
//    let scene: SCNScene!
//    var sounds: [String: SCNAudioSource] = [:]
//    var playerNodeRotation = [SCNVector4]()
//    
//    private var cameraNode: SCNNode!
//    private var cameraFollowNode: SCNNode!
//    private var lightFollowNode: SCNNode!
//    private var playerNode: SCNNode!
//    
//    private var isMovementsAllowed = true
//    private var level = Level()
//    private var canMove = true
//    private var movements = 0 {
//        didSet {
//            delegate?.updatedMovements(movements: movements)
//        }
//    }
//    
//    private var dynamicNodes = [NodePoints]()
//    
//    init() {
//        scene = SCNScene(named: "art.scnassets/game.scn")!
//        setupSounds()
//    }
//    
//    func zoomOut() {
//        changeZoom(increment: 1)
//        print("Zoom Out: \(cameraNode.position.z)")
//    }
//    func zoomIn() {
//        changeZoom(increment: -1)
//        print("Zoom In: \(cameraNode.position.z)")
//
//    }
//    
//    func changeZoom(increment: Float) {
//
//        let x = cameraNode.position.x
//        let y = cameraNode.position.y
//        
//        var z = cameraNode.position.z + increment
//        
//        if z > minZoom { z = minZoom }
//        if z < maxZoom { z = maxZoom }
//        
//        cameraNode.position = SCNVector3(x: x, y: y, z: z)
//        
//        UserDefaults.standard.set(z, forKey: "customZoom")
//        UserDefaults.standard.synchronize()
//    }
//    
//    func loadLevelMap(levelMap: String) {
//
//        level.loadLevelMap(levelMap: levelMap)
//        level.delegate = self
//        playerNode = scene.rootNode.childNode(withName: "player", recursively: true)!
//        cameraNode = scene.rootNode.childNode(withName: "camera", recursively: true)!
//        cameraFollowNode = scene.rootNode.childNode(withName: "followCamera", recursively: true)!
//        lightFollowNode = scene.rootNode.childNode(withName: "followLight", recursively: true)!
//        
//        setupZoom()
//        delegate?.updatedMovements(movements: movements)
//        addFloor()
//        addNodes()
//    }
//    
//    func setupZoom() {
//        let x = cameraNode.position.x
//        let y = cameraNode.position.y
//        var z = defaultZoom
//        
//        if let savedZoom = UserDefaults.standard.value(forKey: "customZoom") as? Float {
//            z = savedZoom
//        }
//        cameraNode.position = SCNVector3(x: x, y: y, z: z)
//    }
//    
//    
//    private func positionForNode(point: IJPoint, isFloor: Bool) -> SCNVector3 {
//        let xPos = Float(point.j)
//        let yPos = isFloor ? 0 : Float(0.1)
//        let zPos = Float(point.i)
//        return SCNVector3(x: xPos, y: yPos, z: zPos)
//    }
//    
//    private func addFloor() {
//        for i in 0..<level.fields.count {
//            for j in 0..<level.fields[i].count {
//                let field = level.fields[i][j]
//                var floor: SCNNode!
//                if field == .boxOnGoalSquare || field == .goalSquare || field == .playerOnGoalSquare {
//                    floor = scene.rootNode.childNode(withName: "boxTarget", recursively: true)!.flattenedClone()
//                } else {
//                    floor = scene.rootNode.childNode(withName: "darkFloor", recursively: true)!.flattenedClone()
//                }
//                floor.position = positionForNode(point: IJPoint(i: i, j: j), isFloor: true)
//                floor.isHidden = false
//                scene.rootNode.addChildNode(floor)
//            }
//        }
//    }
//    
//    private func addNodes() {
//        for i in 0..<level.fields.count {
//            for j in 0..<level.fields[i].count {
//                let field = level.fields[i][j]
//                var nodes = [SCNNode]()
//                switch field {
//                case .box, .boxOnGoalSquare:
//                    let boxNode = scene.rootNode.childNode(withName: "box", recursively: true)!.flattenedClone()
//                    boxNode.isHidden = false
//                    let boxYellowNode = scene.rootNode.childNode(withName: "yellowBox", recursively: true)!.flattenedClone()
//                    boxYellowNode.isHidden = field == .box
//                    boxNode.isHidden = field == .boxOnGoalSquare
//                    nodes.append(boxNode)
//                    nodes.append(boxYellowNode)
//                case .player, .playerOnGoalSquare:
//                    playerNode.position = positionForNode(point: IJPoint(i: i, j: j), isFloor: false)
//                    cameraFollowNode.position = playerNode.position
//                    lightFollowNode.position = playerNode.position
//                    playerNode.isHidden = false
//                    nodes.append(playerNode)
//                case .wall:
//                    let wall = scene.rootNode.childNode(withName: "wall", recursively: true)!.flattenedClone()
//                    wall.isHidden = false
//                    nodes.append(wall)
//                default:
//                    break
//                }
//                
//                nodes.forEach {
//                    $0.position = positionForNode(point: IJPoint(i: i, j: j), isFloor: false)
//                    scene.rootNode.addChildNode($0)
//                }
//            }
//        }
//    }
//    
//    // Movements
//    //------------------------------------------------------------------------------------//
//    
//    func moveUp() {
//        print("Move Up")
//        move(displacement: IJPoint.up, angle: Angle.up)
//    }
//    
//    func moveRight() {
//        print("Move Right")
//        move(displacement: IJPoint.right, angle: Angle.right)
//    }
//    
//    func moveDown() {
//        print("Move Down")
//        move(displacement: IJPoint.down, angle: Angle.down)
//    }
//    
//    func moveLeft() {
//        print("Move Left")
//        move(displacement: IJPoint.left, angle: Angle.left)
//    }
//    
//    func moveBack() {
//        playSound(node: playerNode, name: "moveBack")
//        
//        if level.moveBack() {
//            movements += 1
//            var boxes = [SCNNode]()
//            var yellowBoxes = [SCNNode]()
//            scene.rootNode.childNodes.forEach {
//                if $0.name == "box" {
//                    boxes.append($0)
//                }
//                if $0.name == "yellowBox" {
//                    yellowBoxes.append($0)
//                }
//            }
//            for i in 0..<level.fields.count {
//                for j in 0..<level.fields[i].count {
//                    let field = level.fields[i][j]
//                    if field == .box || field == .boxOnGoalSquare {
//                        let box = boxes.removeLast()
//                        box.position = positionForNode(point: IJPoint(i: i, j: j), isFloor: false)
//                        let yellowBox = yellowBoxes.removeLast()
//                        yellowBox.position = positionForNode(point: IJPoint(i: i, j: j), isFloor: false)
//                        box.isHidden = field == .boxOnGoalSquare
//                        yellowBox.isHidden = field == .box
//                    }
//                    else if field == .player || field == .playerOnGoalSquare {
//                        playerNode.position = positionForNode(point: IJPoint(i: i, j: j), isFloor: false)
//                        playerNode.rotation = playerNodeRotation.removeLast()
//                        cameraFollowNode.position = playerNode.position
//                        lightFollowNode.position = playerNode.position
//                    }
//                }
//            }
//        }
//        
//        if !level.canMoveBack() {
//            movements = 0
//        }
//    }
//    private func move(displacement: IJPoint, angle: CGFloat) {
//        if canMove {
//            canMove = false
//            unowned let unownedSelf = self
//            let deadlineTime = DispatchTime.now() + 0.3
//            DispatchQueue.main.asyncAfter(deadline: deadlineTime, execute: {
//                unownedSelf.canMove = true
//            })
//            level.move(with: displacement)
//            rotatePlayer(to: angle)
//        }
//    }
//    
//    private func rotatePlayer(to: CGFloat) {
//        playerNodeRotation.append(playerNode.rotation)
//        playerNode?.runAction(SCNAction.rotateTo(x: 0, y: to, z: 0, duration: 0.3, usesShortestUnitArc: true))
//    }
//}
//
//extension LevelController: LevelDelegate {
//    
//    func nodeMoves(from: IJPoint, to: IJPoint) {
//        let origin = positionForNode(point: from, isFloor: false)
//        let destiny = positionForNode(point: to, isFloor: false)
//        
//        var nodes = [SCNNode]()
//        
//        if SCNVector3EqualToVector3(playerNode.position, origin) {
//            nodes.append(playerNode)
//            nodes.append(cameraFollowNode)
//            nodes.append(lightFollowNode)
//        } else {
//            scene.rootNode.childNodes.forEach {
//                if ($0.name == "box" || $0.name == "yellowBox") && SCNVector3EqualToVector3($0.position, origin) {
//                    nodes.append($0)
//                }
//            }
//        }
//        nodes.forEach {
//            $0.runAction(SCNAction.move(to: destiny, duration: 0.2))
//            
//            if $0.name == "player" {
//                playSound(node: $0, name: "footStep")
//                movements += 1
//            }
//            else if $0.name == "box" {
//                playSound(node: $0, name: "boxMovement")
//            }
//            let destinyField = level.fields[to.i][to.j]
//            
//            if $0.name == "yellowBox" {
//                $0.isHidden = destinyField == .box
//            }
//            if $0.name == "box" {
//                $0.isHidden = destinyField == .boxOnGoalSquare
//            }
//        }
//    }
//    
//    func movementNotAllowed() {
//        print("Bad Movement")
//        playSound(node: playerNode, name: "badMovement")
//        if playerNodeRotation.count > 0 {
//            playerNodeRotation.removeLast()
//        }
//    }
//    
//    func levelCompleted() {
//        print("Level Completed")
//    }
//}
//
//
