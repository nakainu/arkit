//
//  ViewController.swift
//  arkit_wall
//
//  Created by Masaya on 2019/10/04.
//  Copyright © 2019 中山雅也. All rights reserved.
//

import UIKit
import SceneKit
import ARKit

class ViewController: UIViewController, ARSCNViewDelegate {

    @IBOutlet var sceneView: ARSCNView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set the view's delegate
        sceneView.delegate = self
        
        // シーンを作成して登録
        sceneView.scene = SCNScene()
        
        // 特徴点を表示する
        sceneView.debugOptions = [ARSCNDebugOptions.showFeaturePoints]
        
        // 平面と垂直面を検出する
        let configuration = ARWorldTrackingConfiguration()
        configuration.planeDetection = [.horizontal, .vertical]
        sceneView.session.run(configuration)
    }
    
    // 平面を検出したときに呼ばれる
    func renderer(_ renderer: SCNSceneRenderer, didAdd node: SCNNode, for anchor: ARAnchor) {
            guard let planeAnchor = anchor as? ARPlaneAnchor else
            {fatalError()}
            
            // ノードを作成
            let planeNode = SCNNode()
            
            //ジオメトリの作成
            let geometry = SCNPlane(width: CGFloat(planeAnchor.extent.x),
                                    height: CGFloat(planeAnchor.extent.z))
        
            let floorColor: UIColor = UIColor.red.withAlphaComponent(0.5)
            let wallColor: UIColor = UIColor.blue.withAlphaComponent(0.5)
                
            // 水平面化垂直面かで色を分ける
            if planeAnchor.alignment == .vertical
            {
                geometry.materials.first?.diffuse.contents = wallColor
            }
            else
            {
                geometry.materials.first?.diffuse.contents = floorColor
            }
        
            // ノードにGeometryとTransformを指定
            planeNode.geometry = geometry
            planeNode.transform = SCNMatrix4MakeRotation(-Float.pi / 2.0, 1, 0, 0)
            
            // 検出したアンケートに対応するノードに子ノードとしてもたせる
            node.addChildNode(planeNode)

    }
    
    // 平面が更新されたときに呼ばれる
    func renderer(_ renderer: SCNSceneRenderer, didUpdate node: SCNNode, for anchor: ARAnchor) {
            guard let planeAnchor = anchor as? ARPlaneAnchor else
        {fatalError()}
            guard let geometryPlaneNode = node.childNodes.first,
                let planeGeometory = geometryPlaneNode.geometry as? SCNPlane else {fatalError()}
        
        // ジオメトリをアップデートする
        planeGeometory.width = CGFloat(planeAnchor.extent.x)
        planeGeometory.height = CGFloat(planeAnchor.extent.z)
        geometryPlaneNode.simdPosition = float3(planeAnchor.center.x, 0, planeAnchor.center.z)
    }
}
