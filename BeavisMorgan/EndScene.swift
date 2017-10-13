//
//  EndScene.swift
//  BeavisMorgan
//
//  Created by Selvamurugan on 19/11/16.
//  Copyright © 2016 Bosco Soft. All rights reserved.
//

import SpriteKit

class EndScene: SKScene {
    
    override init(size: CGSize) {
        super.init(size: size)
        
        self.backgroundColor = SKColor.white
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func didMove(to view: SKView) {
        let label = SKLabelNode(fontNamed: "Chalkduster")
        label.text = "Thank You"
        label.fontSize = 40
        label.fontColor = SKColor.darkGray
        label.position = CGPoint(x: view.bounds.midX, y: (view.frame.size.height / 4) * 3)
        label.alpha = 0.0
        let backgroundMusicAction = SKAction.playSoundFileNamed("Intro.mp3", waitForCompletion: false)
        label.run(SKAction.sequence([backgroundMusicAction, SKAction.fadeIn(withDuration: 2.0)]))
        self.addChild(label)
        
        let adLabel = SKLabelNode(fontNamed: "System-semibold")
        adLabel.text = "Design And Developed By"
        adLabel.fontSize = 12
        adLabel.fontColor = SKColor.darkGray
        adLabel.position = CGPoint(x: view.bounds.midX, y: label.frame.origin.y - label.frame.size.height - 20)
        adLabel.alpha = 0.0
        adLabel.run(SKAction.fadeIn(withDuration: 1.0))
        self.addChild(adLabel)
        
        let adLogo = SKSpriteNode(imageNamed: "BoscoSoftLogo.png")
        adLogo.setScale(0.5)
        adLogo.position = CGPoint(x: view.bounds.midX, y: adLabel.frame.origin.y - adLabel.frame.size.height - 10)
        adLogo.alpha = 0.0
        adLogo.run(SKAction.fadeIn(withDuration: 1.0))
        self.addChild(adLogo)
        
        let nameLabel = SKLabelNode(fontNamed: "System-semibold")
        nameLabel.text = "Bosco Soft Technologies Pvt. Ltd."
        nameLabel.fontSize = 12
        nameLabel.fontColor = SKColor.darkGray
        nameLabel.position = CGPoint(x: view.bounds.midX, y: adLogo.frame.origin.y - adLogo.frame.size.height + 20)
        nameLabel.alpha = 0.0
        nameLabel.run(SKAction.fadeIn(withDuration: 1.0))
        self.addChild(nameLabel)
        
        let urlLabel = SKLabelNode(fontNamed: "System-semibold")
        urlLabel.text = "http://www.boscosofttech.com/"
        urlLabel.fontSize = 12
        urlLabel.fontColor = SKColor(netHex: 0x007AFF)
        urlLabel.position = CGPoint(x: view.bounds.midX, y: nameLabel.frame.origin.y - nameLabel.frame.size.height - 10)
        urlLabel.alpha = 0.0
        urlLabel.run(SKAction.fadeIn(withDuration: 1.0))
        self.addChild(urlLabel)
        
        let emailLabel = SKLabelNode(fontNamed: "System-semibold")
        emailLabel.text = "Email: info@boscosofttech.com"
        emailLabel.fontSize = 12
        emailLabel.fontColor = SKColor.darkGray
        emailLabel.position = CGPoint(x: view.bounds.midX, y: urlLabel.frame.origin.y - urlLabel.frame.size.height - 10)
        emailLabel.alpha = 0.0
        emailLabel.run(SKAction.fadeIn(withDuration: 1.0))
        self.addChild(emailLabel)
        
        let phonenoLabel = SKLabelNode(fontNamed: "System-semibold")
        phonenoLabel.text = "Phone: +91 96 26 800 800"
        phonenoLabel.fontSize = 12
        phonenoLabel.fontColor = SKColor.darkGray
        phonenoLabel.position = CGPoint(x: view.bounds.midX, y: emailLabel.frame.origin.y - emailLabel.frame.size.height - 10)
        phonenoLabel.alpha = 0.0
        phonenoLabel.run(SKAction.fadeIn(withDuration: 1.0))
        self.addChild(phonenoLabel)
        
    }
    
}
