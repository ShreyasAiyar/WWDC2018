//
//  StartScene.swift
//  DummyGame
//
//  Created by Shreyas Aiyar on 31/03/18.
//  Copyright © 2018 Shreyas Aiyar. All rights reserved.
//

import Foundation
import SpriteKit

public class StartScene:SKScene{
  
  public override func didMove(to view: SKView) {
    self.backgroundColor = NSColor.black
    configureText()
    configureLisa()
    configureStartButton()
    configureCopyright()
  }
  
  func configureText(){
    let mainText = OldSchoolText(fontSize: 30, fontText: "Lisa's Cocoa Adventures")
    mainText.position = CGPoint(x: 400, y: 500)
    mainText.preferredMaxLayoutWidth = 300
    self.addChild(mainText)
  }
  
  func configureLisa(){
    let hero = SKSpriteNode(imageNamed: "Hero")
    self.addChild(hero)
    hero.position = CGPoint(x: 400, y: 400)
  }
  
  func configureStartButton(){
    let startButton = OldSchoolText(fontSize: 25, fontText: "Start 1P")
    startButton.position = CGPoint(x: 400, y: 300)
    self.addChild(startButton)
    startButton.preferredMaxLayoutWidth = 300
    
    let blinkAction = SKAction.run {
      if(startButton.alpha == 0){
        startButton.alpha = 1
      }else{
        startButton.alpha = 0
      }
    }
    let repeatAction = SKAction.wait(forDuration: 1.0)
    let sequence = SKAction.sequence([blinkAction,repeatAction])
    let runForever = SKAction.repeatForever(sequence)
    startButton.run(runForever)
  }
  
  func configureCopyright(){
    let copyrightText = OldSchoolText(fontSize: 20, fontText: "TM ©Copyright WWDC 2018")
    copyrightText.position = CGPoint(x: 400, y: 150)
    self.addChild(copyrightText)
  }
  
  public override func mouseDown(with event: NSEvent) {
    let playAction = SKAction.playSoundFileNamed("MenuSelect", waitForCompletion: false)
    run(playAction)
    let tutorialScene = TutorialScene()
    tutorialScene.scaleMode = .resizeFill
    let transition = SKTransition.fade(withDuration: 3.0)
    self.view?.presentScene(tutorialScene, transition: transition)
    
  }
  
}
