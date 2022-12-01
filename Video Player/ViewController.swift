//
//  ViewController.swift
//  Video Player
//
//  Created by Angel Dev on 5/3/20.
//  Copyright © 2020 erica. All rights reserved.
//

import UIKit

import UIKit
import AVKit
import AVFoundation

class ViewController: UIViewController, AVPlayerViewControllerDelegate {
    
    var videoPlayer = AVPlayer()
    var playerViewController = AVPlayerViewController()

    // Set the shouldAutorotate to False
    override open var shouldAutorotate: Bool {
       return false
    }

    // Specify the orientation.
    override open var supportedInterfaceOrientations: UIInterfaceOrientationMask {
       return .portrait
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        play()
    }

    func play() {
        
        let urlpath1     = Bundle.main.path(forResource: "Minido", ofType: "mp4")
        let urlPath1        = NSURL.fileURL(withPath: urlpath1!)
        
        let urlpath2     = Bundle.main.path(forResource: "Forest", ofType: "mp4")
        let urlPath2     = NSURL.fileURL(withPath: urlpath2!)
        
        print("urlPath1==>", urlPath1)
        
        let videos = [urlPath1, urlPath2]
        let selectedNum = Int.random(in: 0 ..< 2)
        let mergedVideoFile = videos[selectedNum]
        
        let asset = AVAsset(url: mergedVideoFile)
        let playerItem = AVPlayerItem(asset: asset)
        let videoPlayer = AVPlayer(playerItem: playerItem)
        
        var playerViewController = AVPlayerViewController()
            switch asset.g_orientation {
            case .landscapeLeft:
                playerViewController = LandscapeLeftPlayer()
            case .landscapeRight:
                playerViewController = LandscapeRightPlayer()
            case .portrait:
                playerViewController = PortraitPlayer()
            default:
                playerViewController = LandscapeLeftPlayer()
        }
        
        playerViewController.player = videoPlayer
        
         self.present(playerViewController, animated: true) {
             if let validPlayer = playerViewController.player {
                 validPlayer.play()
                 playerViewController.showsPlaybackControls = true
            }
        }
     }
    
    override func willTransition(to newCollection: UITraitCollection, with coordinator: UIViewControllerTransitionCoordinator) {
        coordinator.animate(alongsideTransition: { context in
            if UIApplication.shared.statusBarOrientation.isLandscape {
                print("state: landscape")
                // activate landscape changes
            } else {
                // activate portrait changes
                print("state: portrait")
            }
        })
    }

}

class LandscapeLeftPlayer: AVPlayerViewController {
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return .landscapeLeft
    }
}
class LandscapeRightPlayer: AVPlayerViewController {
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return .landscapeRight
    }
}

class PortraitPlayer: AVPlayerViewController {
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return .portrait
    }
}

extension AVAsset {

    var g_size: CGSize {
        return tracks(withMediaType: AVMediaType.video).first?.naturalSize ?? .zero
    }

    var g_orientation: UIInterfaceOrientation {
//        guard let transform = tracks(withMediaType: AVMediaType.video).first?.preferredTransform else {
//            return .portrait
//        }

//        switch (transform.tx, transform.ty) {
//            case (0, 0):
//                return .landscapeRight
//            case (g_size.width, g_size.height):
//                return .landscapeLeft
//            case (0, g_size.width):
//                return .portraitUpsideDown
//            default:
//                return .portrait
//        }
        
        if g_size.width > g_size.height{
            return .landscapeRight
            
        } else {
            return .portrait
        }
    }
}
