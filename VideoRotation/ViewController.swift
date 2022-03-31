//
//  ViewController.swift
//  VideoRotation
//
//  Created by Morten Just on 3/31/22.
//

import Cocoa
import SceneKit
import AVKit
import AVFoundation

class ViewController: NSViewController {
    @IBOutlet weak var sceneView: SCNView!
    var scene : SCNScene { sceneView.scene! }
    var boxNode : SCNNode!
    @IBOutlet weak var playerView: AVPlayerView!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        sceneView.allowsCameraControl = true
        sceneView.autoenablesDefaultLighting = true
        sceneView.rendersContinuously = true
        sceneView.scene = SCNScene()
        
        let box = SCNBox(width: 1, height: 2, length: 0.1, chamferRadius: 0)
        boxNode = SCNNode(geometry: box)
        boxNode.geometry?.materials.first?.diffuse.contents = NSColor.red
        scene.rootNode.addChildNode(boxNode)
        
        
//        addVideo2(nil)
    }

    
    @IBAction func addVideo2(_ sender: Any?) {
        let url = Bundle.main.url(forResource: "bunny", withExtension: "mp4")!
//        let url = Bundle.main.url(forResource: "maps-landscape", withExtension: "mp4")!
        let asset = AVAsset(url: url)
        let item = AVPlayerItem(asset: asset)
        let player = AVPlayer(playerItem: item)
        
        let videoTrack = player.currentItem?.asset.tracks(withMediaType: .video).first!
        let preferredTransform = videoTrack?.preferredTransform
        let naturalSize = videoTrack?.naturalSize
        let transformedSize = videoTrack!.naturalSize.applying(preferredTransform!)
        let radians = atan2(preferredTransform!.b, preferredTransform!.a)
        let degrees = radians * 180.0 / .pi
        
        print("natural size: ", naturalSize!)
        print("transformed size:", transformedSize)
        print("radians: ", radians)
        print("degrees: ", degrees)
        
        
        
        playerView.player = player
        boxNode.geometry?.firstMaterial?.diffuse.contents = player
        
        boxNode.geometry?.firstMaterial?.diffuse.wrapS = .clampToBorder
        boxNode.geometry?.firstMaterial?.diffuse.wrapT = .clampToBorder
        
        
        // reset, not necessary in this case
        self.boxNode.geometry?.firstMaterial?.diffuse.contentsTransform = SCNMatrix4Identity
        
        let rot = SCNMatrix4MakeRotation(
        90 * .pi / 180, // 90 degrees in radians
        0, 0, 1) // around z, counter-clockwise
        
        
        let tra = SCNMatrix4MakeTranslation(0, -1, 0)
        let traRot = SCNMatrix4Mult(tra, rot)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            SCNTransaction.begin()
            SCNTransaction.animationDuration = 5
            self.boxNode.geometry?.firstMaterial?.diffuse.contentsTransform = traRot
            SCNTransaction.commit()
        }

//        player.play()
        
    }
    
    
    

}

