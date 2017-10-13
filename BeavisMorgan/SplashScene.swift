//
//  GameScene.swift
//  BeavisMorgan
//
//  Created by Selvamurugan on 11/11/16.
//  Copyright © 2016 Bosco Soft. All rights reserved.
//

import SpriteKit

class SplashScene: SKScene {
    
    override init(size: CGSize) {
        super.init(size: size)
        
        self.backgroundColor = SKColor.white
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func didMove(to view: SKView) {
        let label = SKLabelNode(fontNamed: "Chalkduster")
        label.text = "R&D Tax Relief"
        label.fontSize = 40
        label.fontColor = SKColor(netHex: 0x0D3557)
        label.position = CGPoint(x: view.bounds.midX, y: view.bounds.midY)
        label.alpha = 0.0
        let backgroundMusicAction = SKAction.playSoundFileNamed("Intro.mp3", waitForCompletion: false)
        let nextSceneAction = SKAction.perform(#selector(self.goToGameScene), onTarget: self)
        label.run(SKAction.sequence([backgroundMusicAction, SKAction.fadeIn(withDuration: 2.0), nextSceneAction]))
        self.addChild(label)
        
        let adLogo = SKSpriteNode(imageNamed: "BeavisMorganLogo.png")
        adLogo.setScale(0.2)
        adLogo.position = CGPoint(x: view.bounds.midX, y: label.frame.origin.y - label.frame.size.height - 50)
        adLogo.alpha = 0.0
        adLogo.run(SKAction.fadeIn(withDuration: 1.0))
        self.addChild(adLogo)
        
    }
    
    func goToGameScene() {
        self.removeAllActions()
        self.removeAllChildren()
        let scene = GameScene(size: (self.view?.frame.size)!)
        scene.scaleMode = .aspectFill
        view?.presentScene(scene, transition: SKTransition.crossFade(withDuration: 1.0))
    }
    
}


extension UIColor {
    
    static func color(_ red: Int, green: Int, blue: Int, alpha: Float) -> UIColor {
        return UIColor(
            colorLiteralRed: Float(1.0) / Float(255.0) * Float(red),
            green: Float(1.0) / Float(255.0) * Float(green),
            blue: Float(1.0) / Float(255.0) * Float(blue),
            alpha: alpha)
    }
    
    convenience init(red: Int, green: Int, blue: Int) {
        assert(red >= 0 && red <= 255, "Invalid red component")
        assert(green >= 0 && green <= 255, "Invalid green component")
        assert(blue >= 0 && blue <= 255, "Invalid blue component")
        
        self.init(red: CGFloat(red) / 255.0, green: CGFloat(green) / 255.0, blue: CGFloat(blue) / 255.0, alpha: 1.0)
    }
    
    convenience init(netHex:Int) {
        self.init(red:(netHex >> 16) & 0xff, green:(netHex >> 8) & 0xff, blue:netHex & 0xff)
    }
    
}
