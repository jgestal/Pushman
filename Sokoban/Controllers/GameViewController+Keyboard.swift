//
//  GameViewController+Keyboard.swift
//  Pushman
//
//  Created by Juan Gestal on 04/11/2020.
//  Copyright © 2020 Juan Gestal Romani. All rights reserved.
//
import SpriteKit

extension GameViewController {

    override func pressesBegan(_ presses: Set<UIPress>, with event: UIPressesEvent?) {
       
        super.pressesBegan(presses, with: event)
        
        guard let keyCode = presses.first?.key?.keyCode else { return }
        
        switch (keyCode) {
        
        // Movement
        case .keyboardUpArrow,.keyboardW:
            moveUp()
            
        case .keyboardRightArrow,.keyboardD:
            moveRight()
        
        case .keyboardDownArrow,.keyboardS:
            moveDown()
        
        case .keyboardLeftArrow,.keyboardA:
            moveLeft()
            
        // UI Controls
        
        case .keyboardEscape:
            exit()
            
        case .keyboardDeleteOrBackspace:
            moveBack()
            
        case .keyboardCloseBracket:
            zoomIn()
        
        case .keyboardSlash:
            zoomOut()
        
        case .keyboardR:
            reload()

        default:
            print (keyCode.rawValue)
            break
        }
    }
}
