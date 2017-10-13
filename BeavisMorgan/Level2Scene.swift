//
//  Level1Scene.swift
//  BeavisMorgan
//
//  Created by Selvamurugan on 17/11/16.
//  Copyright © 2016 Bosco Soft. All rights reserved.
//

import SpriteKit
import AVFoundation

class Level2Scene: SKScene, SKPhysicsContactDelegate, AVSpeechSynthesizerDelegate {
    
    private var bottom : SKNode!
    private var character : SKSpriteNode!
    private var specialist : SKSpriteNode!
    private var ground1 : SKSpriteNode!
    private var ground2 : SKSpriteNode!
    private var checkPoint : SKSpriteNode!
    private var securityGaurd : SKSpriteNode!
    private var dialogue : SKSpriteNode!
    private var treasure : SKSpriteNode!
    private var start : SKSpriteNode!
    private var startBackground : SKSpriteNode!
    private var dangerBoard : SKSpriteNode!
    private var hmrcBoard : SKSpriteNode!
    private var groundTexture : SKTexture!
    private var moveBackGround : SKAction!
    private var moveCheckPoint : SKAction!
    private var moveSecurityGaurd : SKAction!
    private var synthesizer: AVSpeechSynthesizer!
    
    private var gameStarted: Bool = false
    private var stopScene: Bool = false
    private var stopAction: Bool = true
    private var lastTime : Int = 0
    private var timeElapsed : Int = 0
    
    override init(size: CGSize) {
        super.init(size: size)
        
        self.backgroundColor = SKColor.white
        self.physicsWorld.gravity = CGVector(dx: 0.0, dy: -5.0)
        self.physicsWorld.contactDelegate = self
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func didMove(to view: SKView) {
        synthesizer = AVSpeechSynthesizer()
        synthesizer.delegate = self
        addGround()
        addCharacter()
        addSpecalist()
        addBottom()
        addStartButtons()
        let audio = SKAudioNode(fileNamed: "Background.mp3")
        self.addChild(audio)
    }
    
    // Bottom layer
    
    func addBottom() {
        // Create ground physics container
        bottom = SKNode()
        bottom.position = CGPoint(x: 0, y: self.frame.height / 7.7)
        bottom.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: self.frame.size.width * 2, height: 1))
        bottom.physicsBody?.isDynamic = false
        bottom.physicsBody?.categoryBitMask = BottomCategory
        bottom.physicsBody?.contactTestBitMask = CharacterCategory
        bottom.physicsBody?.collisionBitMask = 0
        self.addChild(bottom)
    }
    
    // BackGround Scene
    
    func addGround() {
        // Create ground
        groundTexture = SKTexture(imageNamed: "Ground1.jpg")
        groundTexture.filteringMode = SKTextureFilteringMode.nearest
        let moveGroundSprite = SKAction.moveBy(x: -self.frame.size.width, y: 0, duration: Double(CGFloat(0.015) * self.frame.size.width))
        let resetGroundSprite = SKAction.moveBy(x: self.frame.size.width, y: 0, duration: 0)
        moveBackGround = SKAction.repeatForever(SKAction.sequence([moveGroundSprite, resetGroundSprite]))
        
        ground1 = SKSpriteNode(texture: groundTexture, size: self.size)
        ground1.position = CGPoint(x: groundTexture.size().width / 3.85, y: groundTexture.size().height / 3.85)
        self.addChild(ground1)
        
        ground2 = SKSpriteNode(texture: groundTexture, size: self.size)
        ground2.position = CGPoint(x: groundTexture.size().width / 3.85 + ground1.size.width, y: groundTexture.size().height / 3.85)
        self.addChild(ground2)
    }
    
    // Character
    
    func addCharacter() {
        let characterTexture = SKTexture(imageNamed: "c4.png")
        character = SKSpriteNode(texture: characterTexture)
        character.setScale(0.3)
        character.position = CGPoint(x: self.frame.size.width / 4, y: self.frame.size.height / 3.85)
        character.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: (character.size.width), height: (character.size.height)))
        character.physicsBody?.isDynamic = true
        character.physicsBody?.allowsRotation = false
        character.physicsBody?.categoryBitMask = CharacterCategory
        character.physicsBody?.contactTestBitMask = BottomCategory
        self.addChild(character)
    }
    
    func addSpecalist() {
        let specialistTexture = SKTexture(imageNamed: "s3.png")
        specialist = SKSpriteNode(texture: specialistTexture)
        specialist.setScale(0.2)
        specialist.position = CGPoint(x: self.frame.size.width / 4 + 40, y: self.frame.size.height / 3.85)
        specialist.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: (specialist.size.width), height: (specialist.size.height)))
        specialist.physicsBody?.isDynamic = true
        specialist.physicsBody?.allowsRotation = false
        specialist.physicsBody?.categoryBitMask = CharacterCategory
        specialist.physicsBody?.contactTestBitMask = BottomCategory
        self.addChild(specialist)
    }
    
    func addStartButtons() {
        characterStop()
        
        startBackground = SKSpriteNode(imageNamed: "StartBackground.png")
        startBackground.size = (self.view?.frame.size)!
        startBackground.position = CGPoint(x: self.frame.midX, y: self.frame.midY)
        self.addChild(startBackground)
        
        start = SKSpriteNode(imageNamed: "Start.png")
        start.name = StartCategoryName
        start.setScale(0.3)
        start.position = CGPoint(x: self.frame.midX, y: self.frame.midY)
        self.addChild(start)
    }
    
    func characterWalk() {
        let characterMove = SKAction.animate(with: self.characterTextures(), timePerFrame: 0.13)
        let characterAnim = SKAction.repeatForever(characterMove)
        character.run(characterAnim)
        character.isPaused = false
        let specialistMove = SKAction.animate(with: self.specialistTextures(), timePerFrame: 0.13)
        let specialistAnim = SKAction.repeatForever(specialistMove)
        specialist.run(specialistAnim)
        specialist.isPaused = false
        ground1.isPaused = false
        ground2.isPaused = false
        stopAction = false
        if checkPoint != nil {
            checkPoint.isPaused = false
            securityGaurd.isPaused = false
            hmrcBoard.isPaused = false
        }
        if dangerBoard != nil {
            dangerBoard.isPaused = false
        }
    }
    
    func characterStop() {
        character.texture = SKTexture(imageNamed: "c4.png")
        character.isPaused = true
        specialist.texture = SKTexture(imageNamed: "s3.png")
        specialist.isPaused = true
        ground1.isPaused = true
        ground2.isPaused = true
        stopAction = true
        if checkPoint != nil {
            checkPoint.isPaused = true
            securityGaurd.isPaused = true
            hmrcBoard.isPaused = true
        }
        if dangerBoard != nil {
            dangerBoard.isPaused = true
        }
    }
    
    func characterTextures() -> [SKTexture] {
        return [SKTexture(imageNamed: "c1"), SKTexture(imageNamed: "c2"), SKTexture(imageNamed: "c3"), SKTexture(imageNamed: "c4"), SKTexture(imageNamed: "c5"), SKTexture(imageNamed: "c6"), SKTexture(imageNamed: "c7"), SKTexture(imageNamed: "c8")]
    }

    func specialistTextures() -> [SKTexture] {
        return [SKTexture(imageNamed: "s1.png"), SKTexture(imageNamed: "s2.png"), SKTexture(imageNamed: "s3.png"), SKTexture(imageNamed: "s4.png"), SKTexture(imageNamed: "s5.png"), SKTexture(imageNamed: "s6.png"), SKTexture(imageNamed: "s7.png"), SKTexture(imageNamed: "s8.png")]
    }
    
    // Check Point
    
    func throwCheckPoint() {
        let checkPointTexture = SKTexture(imageNamed: "ClosedGate.png")
        checkPointTexture.filteringMode = SKTextureFilteringMode.nearest
        let moveCheckPoint = SKAction.moveBy(x: -self.frame.size.width / 2, y: 0, duration: Double(CGFloat(0.015) * self.frame.size.width / 2))
        checkPoint = SKSpriteNode(texture: checkPointTexture, size: self.size)
        checkPoint.setScale(0.1)
        checkPoint.position = CGPoint(x: self.frame.size.width, y: self.frame.size.height / 6)
        checkPoint.run(SKAction.sequence([moveCheckPoint, SKAction.run {
            self.reachedCheckPoint()
            }]))
        self.addChild(checkPoint)
        
        let securityGaurdTexture = SKTexture(imageNamed: "SecurityGaurd.png")
        securityGaurdTexture.filteringMode = SKTextureFilteringMode.nearest
        securityGaurd = SKSpriteNode(texture: securityGaurdTexture)
        securityGaurd.setScale(0.1)
        securityGaurd.position = CGPoint(x: self.frame.size.width + 50, y: self.frame.size.height / 3.85)
        securityGaurd.run(moveCheckPoint)
        self.addChild(securityGaurd)
        
        let hmrcTexture = SKTexture(imageNamed: "HMRC.png")
        hmrcTexture.filteringMode = SKTextureFilteringMode.nearest
        hmrcBoard = SKSpriteNode(texture: hmrcTexture)
        hmrcBoard.setScale(0.5)
        hmrcBoard.position = CGPoint(x: self.frame.size.width, y: self.frame.size.height / 3.7)
        hmrcBoard.run(moveCheckPoint)
        self.addChild(hmrcBoard)
    }
    
    // Danger Board
    
    func throwDangerBoard() {
        let dangerTexture = SKTexture(imageNamed: "Danger.png")
        dangerTexture.filteringMode = SKTextureFilteringMode.nearest
        let moveDangerBoard = SKAction.moveBy(x: -(self.frame.size.width + 100) , y: 0, duration: Double(CGFloat(0.015) * (self.frame.size.width + 100)))
        dangerBoard = SKSpriteNode(texture: dangerTexture)
        dangerBoard.setScale(0.5)
        dangerBoard.position = CGPoint(x: self.frame.size.width, y: self.frame.size.height / 3.7)
        dangerBoard.run(SKAction.sequence([moveDangerBoard, SKAction.removeFromParent()]))
        self.addChild(dangerBoard)
    }
    
    func reachedCheckPoint() {
        characterStop()
        stopScene = true
        showInstruction(message: "Reached Check Point 2")
        askQuestion()
    }
    
    func askQuestion() {
        characterStop()
        self.run(SKAction.sequence([SKAction.wait(forDuration: 3), SKAction.run {
            self.showDialogue(name: "Q14.png", position: self.securityGaurd.position)
            self.speakDialogue("Under how many heads the income of a taxpayer is classified?", voice: "en-GB")
            }, SKAction.wait(forDuration: 5), SKAction.run {
                self.showDialogue(name: "Q15.png", position: self.character.position)
                self.speakDialogue("Section 14 of the income tax act has classified the income of a taxpayer under five different heads of income.", voice: "en-GB")
            }, SKAction.wait(forDuration: 8), SKAction.run {
                self.showDialogue(name: "Q5.png", position: self.securityGaurd.position)
                self.speakDialogue("You can pass checkpoint.", voice: "en-GB")
            }, SKAction.wait(forDuration: 3), SKAction.run {
                self.pushCheckPoint()
            }]))
    }
    
    func getTreasure() {
        stopScene = true
        ground1.isPaused = true
        ground2.isPaused = true
        self.character.isPaused = false
        self.specialist.isPaused = false
        let goToNextAction = SKAction.moveBy(x: self.frame.size.width, y: 0, duration: 8)
        self.character.run(goToNextAction)
        self.specialist.run(goToNextAction)
    }
    
    func pushCheckPoint() {
        self.checkPoint.texture = SKTexture(imageNamed: "OpenedGate.png")
        stopScene = false
        characterWalk()
        moveCheckPoint = SKAction.moveBy(x: -(self.frame.size.width + 100) / 2, y: 0, duration: Double(CGFloat(0.015) * (self.frame.size.width + 100) / 2))
        checkPoint.run(SKAction.sequence([moveCheckPoint, SKAction.removeFromParent()]))
        hmrcBoard.run(SKAction.sequence([moveCheckPoint, SKAction.removeFromParent()]))
        securityGaurd.run(SKAction.sequence([moveCheckPoint, SKAction.removeFromParent(), SKAction.run {
            self.throwTreasure()
            }]))
    }
    
    func throwTreasure() {
        let treasureTexture = SKTexture(imageNamed: "GoldTreasure.png")
        treasureTexture.filteringMode = SKTextureFilteringMode.nearest
        treasure = SKSpriteNode(texture: treasureTexture)
        treasure.setScale(0.1)
        treasure.position = CGPoint(x: self.frame.size.width - 100, y: self.frame.size.height / 6)
        treasure.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: treasure.size.width, height: treasure.size.height))
        treasure.physicsBody?.isDynamic = true
        treasure.physicsBody?.allowsRotation = false
        treasure.physicsBody?.categoryBitMask = TreasureCategory
        treasure.physicsBody?.contactTestBitMask = CharacterCategory
        bottom.physicsBody?.collisionBitMask = 0
        self.addChild(treasure)
        self.getTreasure()
    }
    
    func crossCheckPoint() {
        self.checkPoint.texture = SKTexture(imageNamed: "OpenedGate.png")
        self.character.isPaused = false
        self.specialist.isPaused = false
        let goToNextAction = SKAction.moveBy(x: self.frame.size.width, y: 0, duration: 8)
        self.character.run(goToNextAction)
        self.specialist.run(goToNextAction)
        self.run(SKAction.sequence([SKAction.playSoundFileNamed("LevelUp.wav", waitForCompletion: true), SKAction.run {
            self.goToEndScene()
            }]))
    }
    
    func goToEndScene() {
        self.removeAllActions()
        self.removeAllChildren()
        let scene = EndScene(size: (self.view?.frame.size)!)
        scene.scaleMode = .aspectFill
        view?.presentScene(scene)
    }
    
    // Touch Delegate Methods
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touch = touches.first!
        let location = touch.location(in: self)
        let node = self.atPoint(location)
        if (node.name == StartCategoryName) {
            start.run(SKAction.removeFromParent())
            startBackground.run(SKAction.removeFromParent())
            ground1.run(moveBackGround)
            ground2.run(moveBackGround)
            characterWalk()
            self.run(SKAction.sequence([SKAction.run {
                self.showInstruction(message: "Level 2")
                }, SKAction.wait(forDuration: 3), SKAction.run {
                    self.showInstruction(message: "Cross the checkpoint 2 with the help of R&D Tax Specialist")
                }]))
            gameStarted = true
        }else {
            if stopScene || !gameStarted {
                return
            }
            self.characterWalk()
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        if stopScene {
            return
        }
        self.characterStop()
    }
    
    // AVSpeechSynthesizerDelegate Methods
    
    func speakDialogue(_ text: String, voice: String) {
        let utterence: AVSpeechUtterance = AVSpeechUtterance(string: text)
        utterence.voice = AVSpeechSynthesisVoice(language: voice)
        synthesizer.speak(utterence)
    }
    
    func speechSynthesizer(_ synthesizer: AVSpeechSynthesizer, didFinish utterance: AVSpeechUtterance) {
        dialogue.run(SKAction.removeFromParent())
    }
    
    // Physics Contact Delegate Method
    
    func didBegin(_ contact: SKPhysicsContact) {
        var firstBody: SKPhysicsBody
        var secondBody: SKPhysicsBody
        if contact.bodyA.categoryBitMask < contact.bodyB.categoryBitMask {
            firstBody = contact.bodyA
            secondBody = contact.bodyB
        } else {
            firstBody = contact.bodyB
            secondBody = contact.bodyA
        }
        if firstBody.categoryBitMask == CharacterCategory && secondBody.categoryBitMask == TreasureCategory {
            let spark = SKEmitterNode(fileNamed: "Spark.sks")
            spark?.position = self.treasure.position
            spark?.run(SKAction.sequence([SKAction.wait(forDuration: 2), SKAction.removeFromParent()]))
            self.addChild(spark!)
            self.treasure.run(SKAction.removeFromParent())
            self.run(SKAction.playSoundFileNamed("Reward.wav", waitForCompletion: true))
            self.run(SKAction.sequence([SKAction.wait(forDuration: 3), SKAction.run {
                    let messageLabel = SKLabelNode(fontNamed: "Chalkduster")
                    messageLabel.text = "You got treasure!"
                    messageLabel.setScale(0.5)
                    messageLabel.fontSize = 25
                    messageLabel.fontColor = UIColor.black
                    messageLabel.position = CGPoint(x: self.frame.midX, y: self.frame.midY)
                    messageLabel.run(SKAction.scale(to: 0.8, duration: 3))
                    self.addChild(messageLabel)
                },SKAction.playSoundFileNamed("LevelUp.wav", waitForCompletion: true), SKAction.run {
                    self.goToEndScene()
                }]))
        }
    }
    
    // Delegate Methods
    
    override func update(_ currentTime: TimeInterval) {
        if !stopAction {
            // Calculate elapsed time
            if lastTime == 0 {
                lastTime = Int(currentTime)
            }
            if lastTime < Int(currentTime) {
                timeElapsed += 1
                lastTime = Int(currentTime)
                if timeElapsed == 6 {
                    showDialogue(name: "Q10.png", position: character.position)
                    self.speakDialogue("What is gross total income?", voice: "en-GB")
                }
                if timeElapsed == 11 {
                    showDialogue(name: "Q11.png", position: specialist.position)
                    self.speakDialogue("Total income of a taxpayer from all the heads of income is referred to as gross total income.", voice: "en-US")
                }
                if timeElapsed == 17 {
                    showDialogue(name: "Q12.png", position: character.position)
                    self.speakDialogue("Can i claim deduction of personal expenses while computing the taxable income?", voice: "en-GB")
                }
                if timeElapsed == 23 {
                    showDialogue(name: "Q13.png", position: specialist.position)
                    self.speakDialogue("No, you cannot claim deduction of personal expenses while computing the taxable income.", voice: "en-US")
                }
                if timeElapsed == 24 {
                    throwDangerBoard()
                }
                if (timeElapsed == 30) {
                    throwCheckPoint()
                }
            }
        }
    }
    
    // Instruction
    
    func showInstruction(message: String) {
        let messageLabel = SKLabelNode(fontNamed: "Chalkduster")
        messageLabel.text = message
        messageLabel.setScale(0.7)
        messageLabel.fontSize = 20
        messageLabel.fontColor = UIColor.red
        messageLabel.position = CGPoint(x: self.frame.midX, y: self.frame.midY + 125)
        messageLabel.run(SKAction.playSoundFileNamed("Bubble.wav", waitForCompletion: true))
        messageLabel.run(SKAction.sequence([SKAction.scale(to: 0.8, duration: 1), SKAction.wait(forDuration: 2), SKAction.removeFromParent()]))
        self.addChild(messageLabel)
    }
    
    func showDialogue(name: String, position: CGPoint) {
        if dialogue != nil {
            dialogue.run(SKAction.removeFromParent())
        }
        dialogue = SKSpriteNode(imageNamed: name)
        dialogue.setScale(0.3)
        dialogue.position = CGPoint(x: position.x, y: position.y + 100)
        dialogue.run(SKAction.playSoundFileNamed("Bubble.wav", waitForCompletion: true))
        dialogue.run(SKAction.scale(to: 0.4, duration: 1))
        self.addChild(dialogue)
    }
    
}
