//
//  ViewController.swift
//  DemoAR001
//
//  Created by GSK on 7/7/21.
//

import UIKit
import ARKit
import SceneKit

class ViewController: UIViewController, ARSCNViewDelegate {

    weak var sceneView: ARSCNView!
    private let configuration = ARWorldTrackingConfiguration()
    private var node: SCNNode!

    //MARK: - Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()

        self.sceneView.showsStatistics = false
        self.sceneView.debugOptions = [ARSCNDebugOptions.showFeaturePoints]
        self.sceneView.automaticallyUpdatesLighting = false
        self.sceneView.delegate = self
        self.addTapGesture()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

       configuration.planeDetection = .horizontal
       self.sceneView.session.run(configuration)

    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.sceneView.session.pause()
    }

    //MARK: - Methods
    @available(iOS 14.0, *)
    func addObjectRaycasting(hitTestResult: ARRaycastResult) {

        let scene = SCNScene(named: "BlackCockpit")!
        let modelNode = scene.rootNode.childNodes.first
        modelNode?.position = SCNVector3(hitTestResult.worldTransform.columns.3.x,
                                         hitTestResult.worldTransform.columns.3.y,
                                         hitTestResult.worldTransform.columns.3.z)
        let scale = 1
        modelNode?.scale = SCNVector3(scale, scale, scale)
        self.node = modelNode
        self.sceneView.scene.rootNode.addChildNode(modelNode!)


       let lightNode = SCNNode()
       lightNode.light = SCNLight()
       lightNode.light?.type = .omni
       lightNode.position = SCNVector3(x: 0, y: 10, z: 20)
       self.sceneView.scene.rootNode.addChildNode(lightNode)

       let ambientLightNode = SCNNode()
       ambientLightNode.light = SCNLight()
       ambientLightNode.light?.type = .ambient
       ambientLightNode.light?.color = UIColor.darkGray
       self.sceneView.scene.rootNode.addChildNode(ambientLightNode)


    }

    
//'ARHitTestResult' was deprecated in iOS 14.0: Use raycasting
    //@available (if iOS )
    @available(iOS , introduced: 11.0, deprecated: 14.0, message: "in iOS 14.0: Use raycasting")
    func addObject(hitTestResult: ARHitTestResult) {

        let scene = SCNScene(named: "BlackCockpit")!
        let modelNode = scene.rootNode.childNodes.first
        modelNode?.position = SCNVector3(hitTestResult.worldTransform.columns.3.x,
                                         hitTestResult.worldTransform.columns.3.y,
                                         hitTestResult.worldTransform.columns.3.z)
        let scale = 1
        modelNode?.scale = SCNVector3(scale, scale, scale)
        self.node = modelNode
        self.sceneView.scene.rootNode.addChildNode(modelNode!)


       let lightNode = SCNNode()
       lightNode.light = SCNLight()
       lightNode.light?.type = .omni
       lightNode.position = SCNVector3(x: 0, y: 10, z: 20)
       self.sceneView.scene.rootNode.addChildNode(lightNode)

       let ambientLightNode = SCNNode()
       ambientLightNode.light = SCNLight()
       ambientLightNode.light?.type = .ambient
       ambientLightNode.light?.color = UIColor.darkGray
       self.sceneView.scene.rootNode.addChildNode(ambientLightNode)


    }

    private func addTapGesture() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(didTap(_:)))
        self.sceneView.addGestureRecognizer(tapGesture)
    }

    @objc func didTap(_ gesture: UIPanGestureRecognizer) {
        let tapLocation = gesture.location(in: self.sceneView)
        if #available(iOS 14.0, *) {
            print("")
            //'hitTest(_:types:)' was deprecated in iOS 14.0: Use [ARSCNView raycastQueryFromPoint:allowingTarget:alignment]
//            let results = self.sceneView.raycastQuery(from: tapLocation, allowing: .estimatedPlane, alignment: .horizontal)
//            guard let result = results.first else {
//                        return
//                    }
//
//                    let translation = result.worldTransform.translation
//
//                    guard let node = self.node else {
//
//                        self.addObjectRaycasting(hitTestResult: result)
//                        return
//                    }
//                    node.position = SCNVector3Make(translation.x, translation.y, translation.z)
//                    self.sceneView.scene.rootNode.addChildNode(self.node)
//
//            //let tapLocation: CGPoint = sender.location(in: arView)
//                let estimatedPlane: ARRaycastQuery.Target = .estimatedPlane
//                let alignment: ARRaycastQuery.TargetAlignment = .any
//
//            let resultss = self.sceneView.raycast(from: tapLocation,
//                                        allowing: estimatedPlane,
//                                       alignment: alignment)
//
//                guard let raycast: ARRaycastResult = result.first
//                else { return }
//
//                let anchor = AnchorEntity(world: raycast.worldTransform)
//                anchor.addChild(model)
//                arView.scene.anchors.append(anchor)
//
//                print(raycast.worldTransform.columns.3)
            
        } else {
            // Fallback on earlier versions
            let results = self.sceneView.hitTest(tapLocation, types: .featurePoint)
            guard let result = results.first else {
                        return
                    }

                    let translation = result.worldTransform.translation

                    guard let node = self.node else {
                        self.addObject(hitTestResult: result)
                        return
                    }
                    node.position = SCNVector3Make(translation.x, translation.y, translation.z)
                    self.sceneView.scene.rootNode.addChildNode(self.node)
        }

        
    }

}

extension float4x4 {
    var translation: SIMD3<Float> {
        let translation = self.columns.3
        return SIMD3<Float>(translation.x, translation.y, translation.z)
    }
}
