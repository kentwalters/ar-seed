//
//  ViewController.swift
//  ar-seed
//
//  Created by Kent Walters on 2019-05-17.
//  Copyright © 2019 ae. All rights reserved.
//

import UIKit
import SceneKit
import ARKit

class ViewController: UIViewController, ARSCNViewDelegate {

    @IBOutlet var sceneView: ARSCNView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpScene()
    }
    
    func setUpScene() {
        // Set the view's delegate
        sceneView.delegate = self
        
        // Show statistics such as fps and timing information
        sceneView.showsStatistics = true
        
        // Create a new scene
        let scene = SCNScene()
        
        // Set the scene to the view
        sceneView.scene = scene
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        configureSceneView()
    }
    
    func configureSceneView() {
        // Create a session configuration
        let configuration = ARWorldTrackingConfiguration()
        
        // Detect horizontal planes
        configuration.planeDetection = .horizontal
        
        // Let us know how our plane detection is going
        sceneView.debugOptions = [.showFeaturePoints]
        
        // Run the view's session
        sceneView.session.run(configuration)
    
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // Pause the view's session
        sceneView.session.pause()
    }
    
    func renderer(_ renderer: SCNSceneRenderer, didAdd node: SCNNode, for anchor: ARAnchor) {
        addPlaneNode(for: anchor, with: node)
    }
    
    func addPlaneNode(for anchor: ARAnchor, with node: SCNNode) {
        guard let planeAnchor = anchor as? ARPlaneAnchor else { return }
        let plane = SCNPlane(width: CGFloat(planeAnchor.extent.x), height: CGFloat(planeAnchor.extent.z))
        
        let material = SCNMaterial()
        material.diffuse.contents = UIColor.white
        plane.materials = [material]
        plane.firstMaterial?.transparency = 0.5
        
        let planeNode = SCNNode(geometry: plane)
        
        planeNode.position = SCNVector3(planeAnchor.center.x, planeAnchor.center.y, planeAnchor.center.z)
        planeNode.eulerAngles.x = -.pi / 2
        planeNode.name = "planeGrid"
        node.addChildNode(planeNode)
    }

    // MARK: - ARSCNViewDelegate
    
/*
    // Override to create and configure nodes for anchors added to the view's session.
    func renderer(_ renderer: SCNSceneRenderer, nodeFor anchor: ARAnchor) -> SCNNode? {
        let node = SCNNode()
     
        return node
    }
*/
    
    func session(_ session: ARSession, didFailWithError error: Error) {
        // Present an error message to the user
        
    }
    
    func sessionWasInterrupted(_ session: ARSession) {
        // Inform the user that the session has been interrupted, for example, by presenting an overlay
        
    }
    
    func sessionInterruptionEnded(_ session: ARSession) {
        // Reset tracking and/or remove existing anchors if consistent tracking is required
        
    }
}
