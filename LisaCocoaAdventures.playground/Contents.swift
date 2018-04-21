import PlaygroundSupport
import SpriteKit

//: # Lisa's Cocoa Adventures
//: A 2D Platformer Inspired By Apple & Megaman
//: ## Objective
//: Help Lisa Attain The Power Of Cocoa By Collecting All 7 Frameworks
//: ## Controls
//: Click On The Left Side Of The Screen To Jump And The Right Side To Flip Gravity (Requires The Core Motion Powerup)


let frame = NSRect(x: 0, y: 0, width: 800, height: 800)
let view = SKView(frame: frame)
let scene = StartScene()
scene.scaleMode = .resizeFill
view.presentScene(scene)

PlaygroundPage.current.liveView = view


//: ##### All Game Assets Under The Creative Commons License




