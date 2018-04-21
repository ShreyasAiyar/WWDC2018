//
//  GameScene.swift
//  DummyGame
//
//  Created by Shreyas Aiyar on 29/03/18.
//  Copyright © 2018 Shreyas Aiyar. All rights reserved.
//

import SpriteKit
import GameplayKit
import CoreImage

class SceneTwo: SKScene,SKPhysicsContactDelegate {
  
  var gameSpeed:Int = 7
  var hero:SKSpriteNode!
  var heroCamera:SKCameraNode!
  var framework:SKSpriteNode!
  var healthLabel:SKLabelNode!
  var jumpAction:SKAction!
  var canJump:Bool = true
  var popupLabel:SKLabelNode!
  var backgroundMusic:SKAudioNode!
  var enhancedAI:Bool = false
  var customShader:SKShader!
  var pixelFilter:CIFilter!
  var jumpSound:SKAudioNode!
  var allowReverseGravity:Bool = false
  var gravity:GravityState!
  var frameworkCountLabel:SKLabelNode!
  var gameRotation:CGFloat = 1.0
  var currentPowerUp:Int = 0 {
    didSet{
      frameworkCountLabel.text = "Frameworks: \(currentPowerUp)"
    }
  }
  
  var health:Int = 100 {
    didSet{
      if(health < 100){
        healthLabel.fontColor = NSColor.red
      }else if(health >= 100){
        healthLabel.fontColor = NSColor.white
      }
      
      if(health < 0){
        triggerExitScene()
      }
      healthLabel.text = "Health: \(health)"
    }
  }
  
  enum GravityState{
    case normal
    case reversed
  }
  
  let FrameworkList:[String] = ["You Obtained Core Motion! Click On The Right Side Of The Screen To Invert Gravity", "You obtained Audio-Kit! Enjoy The Power Of HD 8 Bit Audio!","You Obtained HealthKit! Your Health Has Increased To 9000", "You obtained MetalKit! Game Graphics Have Improved!","You obtained The Accelerate Framework!. Game Speed Has Increased","You obtained CoreML! Game AI Has Improved.","You obtained ARKit! You Start Hallucinating!!","You Obtained NSObject!",""]
  
  override func didMove(to view: SKView) {
    super.didMove(to: view)
    physicsWorld.contactDelegate = self
    hero = childNode(withName: "Lisa") as! SKSpriteNode
    customShader = SKShader(fileNamed: "FrameworkShader")
    gravity = .normal
    configureCamera()
    configureFilter()
    configureText()
    configureAudio()
    configureEnemy()
    configureBackground()
  }
  
  func configureCamera(){
    heroCamera = SKCameraNode()
    self.camera = heroCamera
    self.addChild(heroCamera)
  }
  
  func configureBackground(){
    let background = SKSpriteNode(imageNamed: "GameBackground")
    background.size = frame.size
    background.position = heroCamera.position
    background.zPosition = -1
    heroCamera.addChild(background)
  }
  
  func configureText(){
    healthLabel = OldSchoolText(fontSize: 25, fontText: "Health: \(health)")
    healthLabel.position.y = 350
    healthLabel.position.x = -250
    healthLabel.color = NSColor.white
    heroCamera.addChild(healthLabel)
    
    frameworkCountLabel = OldSchoolText(fontSize: 25, fontText: "Frameworks: \(currentPowerUp)")
    frameworkCountLabel.position.y = 350
    frameworkCountLabel.position.x = 225
    frameworkCountLabel.color = NSColor.white
    heroCamera.addChild(frameworkCountLabel)
    
    popupLabel = OldSchoolText(fontSize: 20, fontText: "")
    popupLabel.position = CGPoint(x: 0, y: 50)
    heroCamera.addChild(popupLabel)
    popupLabel.isHidden = true
  }
  
  
  func configureAudio(){
    if let musicURL = Bundle.main.url(forResource: "AdventureMusic", withExtension: "mp3") {
      backgroundMusic = SKAudioNode(url: musicURL)
    }
  }
  
  func configureEnemy(){
    let timer = SKAction.wait(forDuration: 5)
    let fireEnemy = SKAction.run(fire)
    let sequence = SKAction.sequence([timer,fireEnemy])
    let foreverAction = SKAction.repeatForever(sequence)
    run(foreverAction)
  }
  
  func configureFilter(){
    self.shouldEnableEffects = true
    let pixelFilter = CIFilter(name: "CIPixellate")
    pixelFilter?.setValue(5.0, forKey: "inputScale")
    self.filter = pixelFilter
  }
  
  func fire(){
    guard hero.isPaused == false else {
      return
    }
    switch enhancedAI{
    case true:
      let position = CGPoint(x: hero.position.x + 1000*gameRotation, y: hero.position.y)
      let bulletNode = EnemyFire(position: position)
      if(gameRotation == -1.0){
        bulletNode.zRotation = CGFloat(3*M_PI/2)
      }
      self.addChild(bulletNode)
      bulletNode.enchancedAttack(newPosition: CGPoint(x: hero.position.x, y: hero.position.y))
    case false:
      let position = CGPoint(x: hero.position.x + 1000*gameRotation, y: hero.position.y)
      let bulletNode = EnemyFire(position: position)
      if(gameRotation == -1.0){
        bulletNode.zRotation = CGFloat(3*M_PI/2)
      }
      self.addChild(bulletNode)
      bulletNode.normalAttack(gameRotation: gameRotation)
    }
  }
  
  func jumpButtonClicked(){
    guard hero.isPaused == false else{
      return
    }
    let dy = (gravity == .normal) ? 40 : -40
    let moveUpVector = CGVector(dx: 0, dy: dy)
    let moveUpImpulse = SKAction.applyImpulse(moveUpVector, duration: 0.2)
    let jumpActionSound = SKAction.playSoundFileNamed("Jump", waitForCompletion: false)
    let jumpSequence = SKAction.sequence([jumpActionSound,moveUpImpulse])
    hero.run(jumpSequence)
  }
  
  override func mouseDown(with event: NSEvent) {
    if (event.locationInWindow.x < 400 && checkForJump()){
        jumpButtonClicked()
      }
    else if(allowReverseGravity && !hero.isPaused && event.locationInWindow.x > 400){
      reverseGravity()
    }
  }
  
  func reverseGravity(){
    let rotateAction = SKAction.rotate(byAngle: CGFloat(Double.pi), duration: 0.5)
    hero.run(rotateAction)
    if(gravity == .normal){
      self.physicsWorld.gravity = CGVector(dx: 0, dy: 9.8)
      gravity = .reversed
    }else{
      self.physicsWorld.gravity = CGVector(dx: 0, dy: -9.8)
      gravity = .normal
  }
}
  
  func checkForJump() -> Bool{
    let check = hero.physicsBody?.velocity.dy == 0 ? true:false
    return check
  }
  
  func didBegin(_ contact: SKPhysicsContact) {
    let firstNode = contact.bodyA.node as! SKSpriteNode
    let secondNode = contact.bodyB.node as! SKSpriteNode
    
    if(firstNode.name == "Framework" && secondNode.name == "Lisa"){
      firstNode.removeFromParent()
      executeFrameworkPower(with: firstNode)
    }else if(secondNode.name == "Framework" && firstNode.name == "Lisa"){
      secondNode.removeFromParent()
      executeFrameworkPower(with: secondNode)
    }
    
    if(firstNode.name == "NSObject" || secondNode.name == "NSObject"){
      presentGameOverScene()
    }
    
    if(firstNode.name == "ExitGround" || secondNode.name == "ExitGround"){
      print("End Game Triggered")
      triggerExitScene()
    }
    
    if(firstNode.name == "Enemy"  && secondNode.name == "Lisa"){
      bulletHit(node: firstNode)
      firstNode.removeFromParent()
    }else if(secondNode.name == "Enemy" && firstNode.name == "Lisa"){
      bulletHit(node: secondNode)
      secondNode.removeFromParent()
    }
    
    if(firstNode.name == "GameOver" || secondNode.name == "GameOver"){
      presentGameOverScene()
    }
    
    if(firstNode.name == "ReverseCamera"){
      firstNode.removeFromParent()
      invertCamera()
    }else if(secondNode.name == "ReverseCamera"){
      secondNode.removeFromParent()
      invertCamera()
    }
  }
  
  func bulletHit(node:SKNode){
    let bulletSound = SKAction.playSoundFileNamed("BulletHit", waitForCompletion: false)
    run(bulletSound)
    let enemyNode = node as! EnemyFire
    updateHealthBar(newHealth: health - enemyNode.damageAmount)
  }
  
  func invertCamera(){
    let playAction = SKAction.playSoundFileNamed("Powerup", waitForCompletion: false)
    run(playAction)
    self.gameRotation = -1.0
    self.shouldEnableEffects = false
    self.pauseNodes(pause: true)
    let newLabel = OldSchoolText(fontSize: 20, fontText: "")
    newLabel.position = CGPoint(x: hero.position.x, y: hero.position.y + 100)
    newLabel.setScale(0.5)
    newLabel.text = "You Obtained AV Foundation! The Game Has Flipped!"
    self.addChild(newLabel)
    let increaseAction = SKAction.scale(by: 2.5, duration: 0.3)
    let sequence = SKAction.sequence([increaseAction])
    newLabel.run(sequence)
    let rotateAction = SKAction.rotate(toAngle: CGFloat.pi, duration: 2.0)
    let scaleAction = SKAction.scale(to: 2.0, duration: 2.0)
    let waitAction = SKAction.wait(forDuration: 5.0)
    run(waitAction, completion: {
      let moveLeftAction = SKAction.moveBy(x: -1500, y: 0, duration: 1.5)
      newLabel.run(moveLeftAction, completion: {
      newLabel.removeFromParent()
      })
      self.pauseNodes(pause: false)
    })
    heroCamera.run(rotateAction) {
      self.gameSpeed *= -1
      self.reverseGravity()
    }
    heroCamera.run(scaleAction)
  }
  
  func increaseGameSpeed(){
    gameSpeed += 1
    let increaseSpeedAction = SKAction.changePlaybackRate(to: 1.3, duration: 0.5)
    backgroundMusic.run(increaseSpeedAction)
  }
  
  func hallucinate(){
    let emmiter = SKEmitterNode(fileNamed: "MyParticle")
    emmiter!.numParticlesToEmit = 0
    emmiter!.particleLifetime = 5.0
    heroCamera.addChild(emmiter!)
  }

  func rotateCamera(){
    allowReverseGravity = true
  }
  
  func executeFrameworkPower(with node: SKSpriteNode){
    let playAction = SKAction.playSoundFileNamed("Powerup", waitForCompletion: false)
    run(playAction)
    pauseNodes(pause: true)
    showObtainedFrameworkText()
    
    if(node.name == "NSObject"){
      presentGameOverScene()
    }
    
    switch(currentPowerUp){
    case 0:
      rotateCamera()
    case 1:
      addChild(backgroundMusic)
    case 2:
      updateHealthBar(newHealth: 9000)
    case 3:
      self.shouldEnableEffects = false
      self.view?.preferredFramesPerSecond = 60
      gameSpeed = gameSpeed/2
    case 4:
      increaseGameSpeed()
    case 5:
      enhancedAI = true
    case 6:
      hallucinate()
    default:
      break
    }
    currentPowerUp += 1
  }
  
  func updateHealthBar(newHealth:Int){
    health = newHealth
  }
  
  func pauseNodes(pause:Bool){
    hero.isPaused = pause
    heroCamera.isPaused = pause
    enumerateChildNodes(withName: "Enemy") { (node, stop) in
      node.isPaused = pause
    }
  }
  
  func showObtainedFrameworkText(){
    let newLabel = OldSchoolText(fontSize: 20, fontText: "")
    newLabel.setScale(0.5)
    newLabel.text = FrameworkList[currentPowerUp]
    self.addChild(newLabel)
    newLabel.position.x = hero.position.x
    newLabel.position.y = hero.position.y + 100*gameRotation
    newLabel.zRotation = CGFloat(M_PI_2) - gameRotation*CGFloat(M_PI_2)
    let increaseAction = SKAction.scale(by: 2.5, duration: 0.3)
    var sequence = SKAction.sequence([increaseAction])
    if(gameRotation == -1.0){
      sequence = SKAction.sequence([increaseAction,increaseAction])
    }
    newLabel.run(sequence)
    
    let waitAction = SKAction.wait(forDuration: 5.0)
    run(waitAction, completion: {
      let moveLeftAction = SKAction.moveBy(x: -1500, y: 0, duration: 1.5)
      newLabel.run(moveLeftAction, completion: {
        newLabel.removeFromParent()
      })
      self.pauseNodes(pause: false)
    })
  }
  
  func triggerExitScene(){
    backgroundMusic.isPaused = true
    let endGameSound = SKAction.playSoundFileNamed("GameOver.wav", waitForCompletion: false)
    self.run(endGameSound)
    let exitTransition = SKTransition.fade(withDuration: 3.0)
    let exitScene = GameOverScene(size: self.size)
    self.view?.presentScene(exitScene, transition: exitTransition)
  }
  
  override func update(_ currentTime: TimeInterval) {
    if(!hero.isPaused){
      heroCamera.position.x = hero.position.x
      heroCamera.position.y = hero.position.y
      hero.position.x += CGFloat(gameSpeed)
    }
  }
  func presentGameOverScene(){
    self.pauseNodes(pause: true)
    let newScene = TheEndScene(size: CGSize(width: 800, height: 800))
    newScene.frameworksCollected = self.currentPowerUp
    let transition = SKTransition.fade(withDuration: 2.0)
    self.view?.presentScene(newScene, transition: transition)
    }
  
  
}
