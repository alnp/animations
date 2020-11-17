//
//  ViewController.swift
//  Raquete do Guda
//
//  Created by Alessandra Pereira on 16/11/20.
//

import UIKit
import AVFoundation

class ViewController: UIViewController {
    
    @IBOutlet var topCurtain: UIImageView!
    @IBOutlet var leftCurtain: UIImageView!
    @IBOutlet var rightCurtain: UIImageView!
    
    @IBOutlet var topCurtainConstraint: NSLayoutConstraint!
    @IBOutlet var leftCurtainConstraint: NSLayoutConstraint!
    @IBOutlet var rightCurtainConstraint: NSLayoutConstraint!
    
    @IBOutlet var moises: UIImageView!
    
    var isMoisesMoving = true
    var tap: UITapGestureRecognizer?
    var animator: UIViewPropertyAnimator?
    
    var moisesPlayer: AVAudioPlayer?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addPlayer()
        addGesture()
    }
    
    func addPlayer() {
        if let moisesURL = Bundle.main.url(forResource: "moises", withExtension: "m4a") {
            moisesPlayer = try? AVAudioPlayer(contentsOf: moisesURL)
            moisesPlayer?.prepareToPlay()
        }
    }
    
    func addGesture() {
        tap = UITapGestureRecognizer(target: self, action: #selector(ViewController.handleTap(_:)))
        guard let tap = tap else { return }
        view.addGestureRecognizer(tap)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        pullTopCurtain()
        pullHorizontalCurtains()
        moveMoisesLeft()
    }
    
    func pullTopCurtain() {
        topCurtainConstraint.constant -= topCurtain.frame.size.height
        
        UIView.animate(withDuration: 1.5, delay: 0.7, options: .curveEaseOut, animations: {
            self.view.layoutIfNeeded()
        }, completion: { finished in
            print("Top curtain raised!")
        })
    }
    
    func pullHorizontalCurtains() {
        leftCurtainConstraint.constant += view.frame.size.width/2
        rightCurtainConstraint.constant += view.frame.size.width/2
        
        UIView.animate(withDuration: 1.7, delay: 1.0, options: .curveEaseOut, animations: {

            self.view.layoutIfNeeded()
        }, completion: { finished in
            print("Horizontal curtains opened!")
        })
    }
    
    func moveMoisesLeft() {
        if !isMoisesMoving { return }
        
        UIView.animate(withDuration: 1.0,
                       delay: 2.0,
                       options: [.curveEaseInOut , .allowUserInteraction],
                       animations: {
                        self.moises.center = CGPoint(x: 75, y: 200)
                       },
                       completion: { finished in
                        print("Moises moved left!")
                        self.faceMoisesRight()
                       })
    }
    
    func faceMoisesRight() {
        if !isMoisesMoving { return }
        
        UIView.animate(withDuration: 1.0,
                       delay: 0.0,
                       options: [.curveEaseInOut , .allowUserInteraction],
                       animations: {
                        self.moises.transform = CGAffineTransform(scaleX: -1, y: 1)
                       },
                       completion: { finished in
                        print("Moises faced right!")
                        self.moveMoisesRight()
                       })
    }
    
    func moveMoisesRight() {
        if !isMoisesMoving { return }
        
        UIView.animate(withDuration: 1.0,
                       delay: 1.0,
                       options: [.curveEaseInOut , .allowUserInteraction],
                       animations: {
                        self.moises.center = CGPoint(x: self.view.frame.width - 75, y: self.view.frame.height - 150)
                       },
                       completion: { finished in
                        print("Moises moved right!")
                        self.faceMoisesLeft()
                       })
    }
    
    func faceMoisesLeft() {
        if !isMoisesMoving { return }
        
        UIView.animate(withDuration: 1.0,
                       delay: 0.0,
                       options: [.curveEaseInOut , .allowUserInteraction],
                       animations: {
                        self.moises.transform = CGAffineTransform(scaleX: 1, y: 1)
                       },
                       completion: { finished in
                        print("Moises faced left!")
                        self.moveMoisesLeft()
                       })
    }
    
    @objc func handleTap(_ gesture: UITapGestureRecognizer) {
        let tapLocation = gesture.location(in: moises.superview)
        if (moises.layer.presentation()?.frame.contains(tapLocation))! {
            print("Moises tapped!")
            if !isMoisesMoving { return }
            isMoisesMoving = false
            moisesPlayer?.play()
            UIView.animate(withDuration: 0.7, delay: 0.0, options: [.curveEaseOut , .beginFromCurrentState], animations: {
                self.moises.alpha = 0.0
            }, completion: { finished in
                UIView.animate(withDuration: 2.0, delay: 0, options: [], animations: {
                    self.moises.alpha = 1.0
                    self.moises.center = CGPoint(x: self.view.frame.midX, y: self.view.frame.midY)
                    self.moises.transform = CGAffineTransform(scaleX: 1.5, y: 1.5)
                }, completion: { finished in
                    guard let tap = self.tap else { return }
                    self.view.removeGestureRecognizer(tap)
                    print("Moises returned to center")
                })
            })
        } else {
            print("Moises not tapped!")
        }
    }
    
}

