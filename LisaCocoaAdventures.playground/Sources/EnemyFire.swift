//
//  EnemyFire.swift
//  DummyGame
//
//  Created by Shreyas Aiyar on 29/03/18.
//  Copyright © 2018 Shreyas Aiyar. All rights reserved.
//

import Foundation
import SpriteKit

public class EnemyFire:SKSpriteNode{
  
  enum EnemyType{
    case Normal
    case Special
  }
  var type:EnemyType!
  
  public var damageAmount:Int!
  
  public convenience init(position:CGPoint) {
    self.init(imageNamed: "Enemy")
    self.position = position
    setupEnemy()
  }
  
  public func setupEnemy(){
    let scale = CGFloat(arc4random_uniform(5) + 3)
    self.setScale(scale)
    self.zRotation = CGFloat(M_PI/2)
    self.physicsBody = SKPhysicsBody(rectangleOf: self.size)
    self.physicsBody?.affectedByGravity = false
    self.physicsBody?.allowsRotation = false
    self.physicsBody?.collisionBitMask = 0
    self.physicsBody?.contactTestBitMask = 2
    self.physicsBody?.categoryBitMask = 2
    self.name = "Enemy"
    self.damageAmount = Int(scale*scale)
  }
  
  public func enchancedAttack(newPosition:CGPoint){
    let velocity = arc4random_uniform(6) + 3
    var heroPosition = CGPoint()
    heroPosition.x = newPosition.x + 300
    heroPosition.y = newPosition.y + CGFloat(arc4random_uniform(100))
    let action = SKAction.move(to: heroPosition, duration: TimeInterval(15/velocity))
    let remove = SKAction.removeFromParent()
    let sequence = SKAction.sequence([action,remove])
    self.run(sequence)
  }
  public func normalAttack(gameRotation:CGFloat){
    let velocity = arc4random_uniform(100) + 70
    let moveVector = CGVector(dx: -1000*gameRotation, dy: 0)
    let action = SKAction.move(by: moveVector, duration: TimeInterval(1000/velocity))
    let remove = SKAction.removeFromParent()
    let sequence = SKAction.sequence([action,remove])
    self.run(sequence)
  }
  
}
