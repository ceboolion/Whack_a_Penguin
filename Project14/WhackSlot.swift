//
//  WhackSlot.swift
//  Project14
//
//  Created by Roman Cebula on 14/05/2020.
//  Copyright © 2020 Roman Cebula. All rights reserved.
//

import UIKit
import SpriteKit

class WhackSlot: SKNode {
  var charNode: SKSpriteNode!
  var isVisble = false
  var isHit = false
  
  func configure(at position: CGPoint){
    self.position = position
    let sprite = SKSpriteNode(imageNamed: "whackHole")
    addChild(sprite)
    
    let cropNode = SKCropNode()
    cropNode.position = CGPoint(x: 0, y: 15)
    cropNode.zPosition = 1
    cropNode.maskNode = SKSpriteNode(imageNamed: "whackMask")
    
    charNode = SKSpriteNode(imageNamed: "penguinGood")
    charNode.position = CGPoint(x: 0, y: -90)
    charNode.name = "character"
    cropNode.addChild(charNode)
    addChild(cropNode)
  }
  
  func show(hideTime: Double){
    if isVisble {return}
    charNode.xScale = 1
    charNode.yScale = 1
    charNode.run(SKAction.moveBy(x: 0, y: 80, duration: 0.05))
    isVisble = true
    isHit = false
    
    if Int.random(in: 0...2) == 0 {
      charNode.texture = SKTexture(imageNamed: "penguinGood")
      charNode.name = "charFriend"
      showMud()
    } else {
      charNode.texture = SKTexture(imageNamed: "penguinEvil")
      charNode.name = "charEnemy"
      showMud()
    }
    
    DispatchQueue.main.asyncAfter(deadline: .now() + (hideTime * 3.5)) {
      [weak self] in
      self?.hide()
    }
  }
  
  func showMud(){
    if let mud = SKEmitterNode(fileNamed: "Mud"){
      mud.zPosition = 1
      mud.position = CGPoint(x: 0, y: -10)
      addChild(mud)
      mud.run(SKAction.sequence([
        SKAction.wait(forDuration: 2.5),
        SKAction.removeFromParent()
      ]))
    }
  }
  
  func hide(){
    if !isVisble {return}
    charNode.run(SKAction.moveBy(x: 0, y: -80, duration: 0.05))
    isVisble = false
  }
  
  func hit(){
    isHit = true
    let delay = SKAction.wait(forDuration: 0.25)
    let hide = SKAction.moveBy(x: 0, y: -80, duration: 0.5)
    let notVisible = SKAction.run { [weak self] in self?.isVisble = false}
    let sequence = SKAction.sequence([delay, hide, notVisible])
    if let smoke = SKEmitterNode(fileNamed: "Smoke"){
      addChild(smoke)
      smoke.run(SKAction.sequence([
        SKAction.wait(forDuration: 4.0),
        SKAction.removeFromParent()
      ]))
    }
    charNode.run(sequence)
  }
}
