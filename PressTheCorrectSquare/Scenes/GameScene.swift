//
//  GameScene.swift
//  PressTheCorrectSquare
//
//  Created by Yauheni Bunas on 7/6/20.
//  Copyright © 2020 Yauheni Bunas. All rights reserved.
//

import SpriteKit
import GameplayKit

var leftSquare: SKSpriteNode?
var rightSquare: SKSpriteNode?

var mainLabel: SKLabelNode?
var scoreLabel: SKLabelNode?

let squareSize = CGSize(width: 210, height: 210)
let squareOffsetX = CGFloat(-150)
let squareOffsetY = CGFloat(0)
let labelOffsetY = 300

var backgroundCustomColor = UIColor.orange
var offBlackColor = UIColor(red: 0.2, green: 0.2, blue: 0.2, alpha: 1.0)
var offWhiteColor = UIColor(red: 0.98, green: 0.98, blue: 0.98, alpha: 1.0)

var score = 0

var colorSquare = 0

var tappedLeftSquare = false
var tappedRightSquare = false

var touchedNode: [SKNode?] = []
var touchLocation: CGPoint?

var countDown = 13

var isAlive = true

class GameScene: SKScene {
    
    override func didMove(to view: SKView) {
        self.backgroundColor = backgroundCustomColor
        
        spawnMainLabel()
        spawnScoreLabel()
        spawnLeftSquare()
        spawnRightSquare()
        
        randomizeSquare()
        
        countDonwTimer()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {
            touchLocation = touch.location(in: self)
            touchedNode = nodes(at: touchLocation!)
            
            if isAlive == true {
                touchedNodeLogic()
            }
        }
    }
    
    override func update(_ currentTime: TimeInterval) {
        
    }
    
    func spawnLeftSquare() {
        leftSquare = SKSpriteNode(color: offWhiteColor, size: squareSize)
        
        leftSquare?.size = squareSize
        leftSquare?.position = CGPoint(x: -squareOffsetX, y: squareOffsetY)
        leftSquare?.name = "leftSquareWhite"
        
        self.addChild(leftSquare!)
    }
    
    func spawnRightSquare() {
        rightSquare = SKSpriteNode(color: offBlackColor, size: squareSize)
        
        rightSquare?.size = squareSize
        rightSquare?.position = CGPoint(x: squareOffsetX, y: squareOffsetY)
        rightSquare?.name = "rightSquareWhite"
        
        self.addChild(rightSquare!)
    }
    
    func spawnMainLabel() {
        mainLabel = SKLabelNode(fontNamed: "Futura")
        
        mainLabel?.fontSize = 55
        mainLabel?.fontColor = offWhiteColor
        mainLabel?.position = CGPoint(x: 0, y: labelOffsetY)
        mainLabel?.text = "Tap The White Square"
        
        self.addChild(mainLabel!)
    }
    
    func spawnScoreLabel() {
        scoreLabel = SKLabelNode(fontNamed: "Futura")
        
        scoreLabel?.fontSize = 40
        scoreLabel?.fontColor = offWhiteColor
        scoreLabel?.position = CGPoint(x: 0, y: -labelOffsetY)
        scoreLabel?.text = "Score: \(score)"
        
        self.addChild(scoreLabel!)
    }
    
    func randomizeSquare() {
        animateSquaresOnChange()
        
        colorSquare = Int(arc4random_uniform(2))
        
        if colorSquare == 0 {
            leftSquare?.color = offWhiteColor
            leftSquare?.name = "leftSquareWhite"
            
            rightSquare?.color = offBlackColor
            rightSquare?.name = "nil"
        }
        
        if colorSquare == 1 {
            rightSquare?.color = offWhiteColor
            rightSquare?.name = "rightSquareWhite"
            
            leftSquare?.color = offBlackColor
            leftSquare?.name = "nil"
        }
    }
    
    func animateSquaresOnChange() {
        leftSquare?.alpha = 0.0
        rightSquare?.alpha = 0.0
        
        
        let fadeIn = SKAction.fadeIn(withDuration: 0.4)
        let rotation = SKAction.rotate(byAngle: 90, duration: 1.0)
        
        leftSquare?.run(rotation)
        leftSquare?.run(fadeIn)
        
        rightSquare?.run(rotation)
        rightSquare?.run(fadeIn)
    }
    
    func touchedNodeLogic() {
        if touchedNode.isEmpty == false {
            if touchedNode[0]?.name == "nil" {
                isAlive = false
                countDown = 0
                mainLabel?.fontSize = 90
                mainLabel?.text = "Game Over"
                
                resetTheGame()
            }
            
            if touchedNode[0]?.name == "leftSquareWhite" {
                score += 1
                
                tappedLeftSquare = true
                tappedRightSquare = false
                
                updateScore()
                randomizeSquare()
            }
            
            if touchedNode[0]?.name == "rightSquareWhite" {
                score += 1
                
                tappedLeftSquare = false
                tappedRightSquare = true
                
                updateScore()
                randomizeSquare()
            }
        }
        
        
    }
    
    func countDonwTimer() {
        let wait = SKAction.wait(forDuration: 1.0)
        
        let countDownVar = SKAction.run {
            countDown -= 1
            
            if countDown <= 10 {
                if isAlive == true {
                    mainLabel?.fontSize = 200
                    mainLabel?.text = "\(countDown)"
                }
            }
            
            if countDown <= 0 {
                self.resetTheGame()
            }
        }
        
        let sequence = SKAction.sequence([wait, countDownVar])
        self.run(SKAction.repeat(sequence, count: countDown))
    }
    
    func resetTheGame() {
        let wait = SKAction.wait(forDuration: 3)
        
        let theGameScene = GameScene(size: self.size)
        let theTransition = SKTransition.crossFade(withDuration: 1.0)
        
        theGameScene.scaleMode = SKSceneScaleMode.aspectFill
        
        let sceneChange = SKAction.run {
            self.scene?.view?.presentScene(theGameScene, transition: theTransition)
        }
        
        let sequence = SKAction.sequence([wait, sceneChange])
        self.run(SKAction.repeat(sequence, count: 1))
    }
    
    func resetGameVariablesOnStart() {
        countDown = 13
        score = 0
        isAlive = true
        colorSquare = 0
    }
    
    func updateScore() {
        scoreLabel?.text = "Score: \(score)"
    }
}
