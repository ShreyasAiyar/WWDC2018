//
//  GameOverScene.swift
//  DummyGame
//
//  Created by Shreyas Aiyar on 29/03/18.
//  Copyright © 2018 Shreyas Aiyar. All rights reserved.
//

import Foundation
import SpriteKit

public class GameOverScene:SKScene{
  
  public override func didMove(to view: SKView) {
    self.backgroundColor = NSColor.black 
    let gameText = OldSchoolText(fontSize: 40, fontText: "Game")
    let overText = OldSchoolText(fontSize: 40, fontText: "Over")
    let retryText = OldSchoolText(fontSize: 25, fontText: "Click To Retry")
    retryText.position = CGPoint(x: 300, y: -500)
    gameText.position = CGPoint(x: -300, y: 400)
    overText.position = CGPoint(x: 900, y: 300)
    self.addChild(gameText)
    self.addChild(overText)
    self.addChild(retryText)
    let waitAction = SKAction.wait(forDuration: 1.0)
    let fadeInAction = SKAction.fadeIn(withDuration: 0.3)
    let sequence = SKAction.sequence([waitAction,fadeInAction])
    retryText.run(sequence)
    let slideInAction = SKAction.move(to: CGPoint(x: 400,y: 400), duration: 1.0)
    let slideInActionTwo = SKAction.move(to: CGPoint(x: 400, y:300), duration: 1.0)
    let slideInActionThree = SKAction.move(to: CGPoint(x:400, y:200), duration: 1.3)
    gameText.run(slideInAction)
    overText.run(slideInActionTwo)
    retryText.run(slideInActionThree)
  }
  
  override public func mouseDown(with event: NSEvent) {
    restartGame()
  }
  
  
  func restartGame(){
    let exitTransition = SKTransition.fade(withDuration: 1.0)
    let exitScene = SceneTwo(fileNamed: "GameScene")
    exitScene?.shouldEnableEffects = true
    view?.preferredFramesPerSecond = 30
    self.view?.presentScene(exitScene!, transition: exitTransition)
  }
}
