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
    
    var planes = [ARPlaneAnchor: Plane]()
    var dudes = [ARAnchor: SCNNode]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpScene()
        setUpTapGestureRecognizer()
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
//        sceneView.debugOptions = [.showFeaturePoints]
        
        // Run the view's session
        sceneView.session.run(configuration)
    
        sceneView.autoenablesDefaultLighting = true
    }
    
    func setUpTapGestureRecognizer() {
        let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(handleTap(for:)))
        sceneView.addGestureRecognizer(tapRecognizer)
    }
    
    @objc
    func handleTap(for recognizer: UIGestureRecognizer) {
        let location = recognizer.location(in: self.sceneView)
        let hitTestResults = sceneView.hitTest(location, types: .existingPlaneUsingExtent)
        guard let hitTestResult = hitTestResults.first else { return }
        let translation = hitTestResult.worldTransform.self
        
        addNodeToScene(at: translation)
        
    }
    
    func addNodeToScene(at position: matrix_float4x4) {
        
        guard let scene = SCNScene(named: "art.scnassets/dl4.scn") else {
            print("could not get scene")
            return
        }
        
        let newNode = SCNNode()
        newNode.setWorldTransform(SCNMatrix4(position))

        for child in scene.rootNode.childNodes {
            newNode.addChildNode(child)
        }
        newNode.scale = SCNVector3(0.005, 0.005, 0.005)
        
        sceneView.scene.rootNode.addChildNode(newNode)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // Pause the view's session
        sceneView.session.pause()
    }
    
    func renderer(_ renderer: SCNSceneRenderer, didAdd node: SCNNode, for anchor: ARAnchor) {
        DispatchQueue.main.async {
            if let planeAnchor = anchor as? ARPlaneAnchor {
                self.addPlane(node: node, anchor: planeAnchor)
            }
            
            self.dudes[anchor] = node
        }
    }
    
    func renderer(_ renderer: SCNSceneRenderer, didUpdate node: SCNNode, for anchor: ARAnchor) {
        DispatchQueue.main.async {
            if let planeAnchor = anchor as? ARPlaneAnchor {
                self.updatePlane(anchor: planeAnchor)
            }
            
            print(node)
            print(anchor)
        }
    }
    
    func addPlane(node: SCNNode, anchor: ARPlaneAnchor) {
        let plane = Plane(anchor)
        planes[anchor] = plane
        node.addChildNode(plane)
    }
    
    func updatePlane(anchor: ARPlaneAnchor) {
        if let plane = planes[anchor] {
            plane.update(anchor)
        }
    }
    
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
