//
//  ViewController.swift
//  canvasapp
//
//  Created by Mely Bohlman on 10/22/18.
//  Copyright © 2018 Chris Bohlman. All rights reserved.
//

import UIKit

class CanvasViewController: UIViewController {

    @IBOutlet weak var trayView: UIView!
    var trayDownOffset: CGFloat!
    var trayUp: CGPoint!
    var trayDown: CGPoint!
    var trayOriginalCenter: CGPoint!
    var newlyCreatedFaceOriginalCenter: CGPoint!
    var newlyCreatedFace: UIImageView!
    
    
    @IBOutlet weak var face1: UIImageView!
    @IBOutlet weak var face2: UIImageView!
    @IBOutlet weak var face3: UIImageView!
    @IBOutlet weak var face4: UIImageView!
    @IBOutlet weak var face5: UIImageView!
    @IBOutlet weak var face6: UIImageView!
    @IBOutlet weak var arrowImageView: UIImageView!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        trayDownOffset = 197
        trayUp = trayView.center // The initial position of the tray
        trayDown = CGPoint(x: trayView.center.x ,y: trayView.center.y + trayDownOffset) // The position of the tray transposed down
    }

    @IBAction func didPanTray(_ sender: UIPanGestureRecognizer) {
        let translation = sender.translation(in: view)
        
        if (sender.state == .began) {
            trayOriginalCenter = trayView.center
        }
        if (sender.state == .changed) {
            trayView.center = CGPoint(x: trayOriginalCenter.x, y: trayOriginalCenter.y + translation.y)
        }
        if (sender.state == .ended) {
            let velocity = sender.velocity(in: view)
            if (velocity.y > 0) {
                //moving down
                UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.4, initialSpringVelocity: 1, options:[] , animations: {
                    self.trayView.center = self.trayDown
                });
                arrowImageView.image = UIImage(named: "up_arrow")
            } else if (velocity.y < 0) {
                //moving up
                UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.4, initialSpringVelocity: 1, options:[] , animations: {
                    self.trayView.center = self.trayUp
                });
                arrowImageView.image = UIImage(named: "down_arrow")
            }
        }
    }
    
    @IBAction func didPanFace(_ sender: UIPanGestureRecognizer) {
        
        let translation = sender.translation(in: view)
        
        if (sender.state == .began) {
            let imageView = sender.view as! UIImageView
            //print(imageView.image)
            newlyCreatedFace = UIImageView(image: imageView.image)
            view.addSubview(newlyCreatedFace)
            newlyCreatedFace.center = imageView.center
            newlyCreatedFace.center.y += trayView.frame.origin.y
            newlyCreatedFaceOriginalCenter = newlyCreatedFace.center
        }
        if (sender.state == .changed) {
            newlyCreatedFace.center = CGPoint(x: newlyCreatedFaceOriginalCenter.x + translation.x, y: newlyCreatedFaceOriginalCenter.y + translation.y)

        }
        if (sender.state == .ended) {
            // Here we use the method didPan(sender:), which we defined in the previous step, as the action.
            let panGestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(didPanFaceOnCanvas(sender:)))
            
            // Attach it to a view of your choice. If it's a UIImageView, remember to enable user interaction
            newlyCreatedFace.transform = view.transform.scaledBy(x: 1.25, y: 1.25)
            newlyCreatedFace.isUserInteractionEnabled = true
            newlyCreatedFace.addGestureRecognizer(panGestureRecognizer)
        }
        
    }
    
    @objc func didPanFaceOnCanvas(sender: UIPanGestureRecognizer) {
        let translation = sender.translation(in: view)
        
        if sender.state == .began {
            newlyCreatedFace = sender.view as! UIImageView // to get the face that we panned on.
            newlyCreatedFaceOriginalCenter = newlyCreatedFace.center // so we can offset by translation later.
            newlyCreatedFace.transform = view.transform.scaledBy(x: 0.8, y: 0.8)
        } else if sender.state == .changed {
            newlyCreatedFace.center = CGPoint(x: newlyCreatedFaceOriginalCenter.x + translation.x, y: newlyCreatedFaceOriginalCenter.y + translation.y)
        } else if sender.state == .ended {
            //when gesture ends
            newlyCreatedFace.transform = view.transform.scaledBy(x: 1.25, y: 1.25)
        }
    }
    

}

