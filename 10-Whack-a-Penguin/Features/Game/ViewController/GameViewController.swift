//
//  GameViewController.swift
//  10-Whack-a-Penguin
//
//  Created by Igor Cotrim on 14/01/25.
//

import UIKit
import SpriteKit
import GameplayKit

class GameViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let view = self.view as! SKView? {
            let sceneSize = CGSize(width: 1024, height: 768)
            let gameViewModel = GameViewModel()
            
            let scene = GameScene(size: sceneSize, viewModel: gameViewModel)
            scene.scaleMode = .aspectFit
            
            let soundService = SoundService(scene: scene)
            gameViewModel.setSoundService(soundService)
            
            view.presentScene(scene)
            view.ignoresSiblingOrder = true
            view.showsFPS = true
            view.showsNodeCount = true
        }
    }
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        if UIDevice.current.userInterfaceIdiom == .phone {
            return .allButUpsideDown
        } else {
            return .all
        }
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
}
