//
//  GameCenter.swift
//  swiftui-quiz-app
//
//  Created by Vinícius Binder on 20/02/21.
//

import GameKit

class GameCenter: NSObject, GKGameCenterControllerDelegate {
    
    static let shared = GameCenter()
    
    private(set) var isEnabled = false
    private(set) var isMultiplayerEnabled = false
    
    // TODO:- Pass actual "parent" controller
    func authenticateUser(parent: UIViewController = UIViewController()) {
        if isEnabled { return }
        
        GKLocalPlayer.local.authenticateHandler = { viewController, error in
            if let viewController = viewController {
                // Present the view controller so the player can sign in
                parent.present(viewController, animated: true, completion: nil)
                return
            }
            
            guard error == nil else { return }
            
            // Player was successfully authenticated
            self.isEnabled = true
            
            // Check if there are any player restrictions before starting the game
            if GKLocalPlayer.local.isMultiplayerGamingRestricted {
                // Disable multiplayer game features
                self.isMultiplayerEnabled = false
            }
            
            // Other configurations
            GKAccessPoint.shared.location = .topLeading
        }
    }
    
    func showAccessPoint(show: Bool) {
        GKAccessPoint.shared.isActive = show
    }
    
    func updateScore(to score: Int) {
        GKLeaderboard.submitScore(score, context: 0,
                                  player: GKLocalPlayer.local,
                                  leaderboardIDs: ["quiz_me_up_scores"]) { error in
            print(error.debugDescription)
        }
    }
    
    func gameCenterViewControllerDidFinish(_ gameCenterViewController: GKGameCenterViewController) {
        gameCenterViewController.dismiss(animated: true, completion: nil)
    }
}
