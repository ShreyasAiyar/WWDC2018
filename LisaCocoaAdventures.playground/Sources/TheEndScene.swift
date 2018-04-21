//
//  TheEndScene.swift
//  DummyGame
//
//  Created by Shreyas Aiyar on 31/03/18.
//  Copyright © 2018 Shreyas Aiyar. All rights reserved.
//

import Foundation
import SpriteKit

class TheEndScene:SKScene{
  
  var frameworksCollected:Int = 0
  var fireworksEmmiter:SKEmitterNode!
  
  public override func didMove(to view: SKView) {
    self.backgroundColor = NSColor.black
    self.shouldEnableEffects = false
    configureHero()
    configureMusic()
    configureFireworks()
    configureWinScreen()
  }
  
  func configureHero(){
    let lisa = SKSpriteNode(imageNamed: "Hero")
    lisa.position = CGPoint(x: 400, y: 400)
    lisa.setScale(1.5)
    self.addChild(lisa)
  }
  
  func configureFireworks(){
    fireworksEmmiter = SKEmitterNode(fileNamed: "Fireworks")
    let emitRandomly = SKAction.run(emit)
    let timeDuration = SKAction.wait(forDuration: 2.0)
    let sequence = SKAction.sequence([emitRandomly,timeDuration])
    let infiniteSequence = SKAction.repeatForever(sequence)
    run(infiniteSequence)
  }
  
  func emit(){
    let randomX = arc4random_uniform(800)
    let randomPosition = CGPoint(x: Int(randomX), y: 600)
    fireworksEmmiter.position = randomPosition
    fireworksEmmiter.particleColor = NSColor.red
    fireworksEmmiter.resetSimulation()
    let action = SKAction.run {
      self.addChild(self.fireworksEmmiter)
    }
    let waitAction = SKAction.wait(forDuration: TimeInterval(self.fireworksEmmiter.particleLifetime))
    let sequence = SKAction.sequence([action,waitAction])
    run(sequence) {
      self.fireworksEmmiter.removeFromParent()
    }
    
  }
  
  func configureMusic(){
    let audioNode = SKAudioNode(fileNamed: "FireCracker")
    self.addChild(audioNode)
  }
  func configureWinScreen(){
    let text = OldSchoolText(fontSize: 25, fontText: "You Collected \(frameworksCollected) of 7 Frameworks!")
    text.position = CGPoint(x: 400, y: 250)
    self.addChild(text)
    
    
    let thankYouText = OldSchoolText(fontSize: 20, fontText: "Thank You For Reviewing My Submission! Hope You Had As Much Fun Evaluating It As I Did Creating It!")
    thankYouText.preferredMaxLayoutWidth = 650
    thankYouText.position = CGPoint(x: 400, y: 100)
    self.addChild(thankYouText)
    
    let theEndText = OldSchoolText(fontSize: 30, fontText: "The End")
    theEndText.position = CGPoint(x: 400, y: 700)
    self.addChild(theEndText)
    
  }
}
