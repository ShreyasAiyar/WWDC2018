//
//  TutorialScene.swift
//  DummyGame
//
//  Created by Shreyas Aiyar on 31/03/18.
//  Copyright © 2018 Shreyas Aiyar. All rights reserved.
//

import Foundation
import SpriteKit

class TutorialScene:SKScene{

  var startLabel:SKLabelNode!
  let messages:[String] = ["This Is Lisa","Lisa Is An Old Macintosh","Help Lisa Attain The Power Of Cocoa By Collecting All The Frameworks","Here Comes The First Framework","Click On The Left Side Of The Screen To Make Lisa Jump","Each Framework Modifies The Game In Some Way",""]
  var currentIndex:Int = 0
  var framework:SKSpriteNode!
  var hero:SKSpriteNode!
  
  public override func didMove(to view: SKView) {
    configureBackground()
    configureHero()
    configureLabels()
    configureFramework()
  }
  
  func configureBackground(){
    self.backgroundColor = NSColor.black
  }

  func configureHero(){
    hero = SKSpriteNode(imageNamed: "Hero")
    hero.setScale(1.5)
    hero.position = CGPoint(x: 400, y: 400)
    self.addChild(hero)
  }
  
  func configureFramework(){
    framework = SKSpriteNode(imageNamed: "Framework")
    framework.shader = SKShader(fileNamed: "FrameworkShader")
    framework.position = CGPoint(x: 1000, y: 400)
    self.addChild(framework)
  }

  func configureLabels(){
    startLabel = OldSchoolText(fontSize: 25, fontText: messages[currentIndex])
    startLabel.position = CGPoint(x: 400, y: 600)
    startLabel.preferredMaxLayoutWidth = 500
    self.addChild(startLabel)
    
    let continueLabel = OldSchoolText(fontSize: 25, fontText: "Click to Continue")
    continueLabel.position = CGPoint(x: 400, y: 200)
    self.addChild(continueLabel)
    
  }

  public override func mouseDown(with event: NSEvent) {
    currentIndex += 1
    updateScene()
  }
  
  func updateScene(){
    startLabel.text = messages[currentIndex]
    if(currentIndex == 3){
      let moveInAction = SKAction.moveTo(x: 420, duration: 2.5)
      framework.run(moveInAction, completion: {
        let playAction = SKAction.playSoundFileNamed("Powerup", waitForCompletion: false)
        self.run(playAction)
        self.framework.removeFromParent()
        self.startLabel.text = "You Obtained Foundation! You Can Now Move And Jump"
      })
    }
    if(currentIndex == 4){
      let vectorUp = CGVector(dx: 0, dy: 80)
      let vectorDown = CGVector(dx: 0, dy: -80)
      let jumpUpAction = SKAction.move(by: vectorUp, duration: 0.5)
      let fallAction = SKAction.move(by: vectorDown, duration: 0.3)
      let sequence = SKAction.sequence([jumpUpAction,fallAction])
      hero.run(sequence)
    }
    if(currentIndex == 6){
      let scene = SceneTwo(fileNamed: "GameScene")
      scene?.scaleMode = .resizeFill
      scene?.shouldEnableEffects = true
      self.view?.preferredFramesPerSecond = 30
      let transition = SKTransition.fade(withDuration: 2.0)
      self.view?.presentScene(scene!, transition: transition)
    }
    
  }


}

