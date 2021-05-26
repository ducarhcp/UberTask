//
//  ViewController.swift
//  UberTask
//
//  Created by Dusan Mitrasinovic on 5/20/21.
//

import UIKit
import GoogleMaps

class ViewController: UIViewController {
    
    @IBOutlet weak var mapView: GMSMapView!
    var animator: UIViewPropertyAnimator?
    var settingsBarButton: UIBarButtonItem?
    @IBOutlet weak var bottomView: UIView!
    @IBOutlet weak var containerView: UIView!
    
    @IBOutlet weak var leftArrowImageView: UIImageView!
    @IBOutlet weak var navigationBarView: UIView!
    @IBOutlet weak var chooseRideLabel: UILabel!
    @IBOutlet weak var bottomViewHeight: NSLayoutConstraint!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupInitiaSubview()
        let name = NSNotification.Name(rawValue: "BottomViewMoved")
        NotificationCenter.default.addObserver(forName: name, object: nil, queue: nil, using: notificationReceived(_:))
    }
    
    func rideListIsPanned(_ percentage: Int) {
        print("Received percentage \(percentage)")
        guard let propAnimator = animator else {
            animator = UIViewPropertyAnimator(duration: 3, curve: .linear, animations: {
                UIView.animate(withDuration: 0.8) {
                    self.leftArrowImageView?.transform =
                        CGAffineTransform(rotationAngle: CGFloat(CGFloat.pi * -1/2))
                    self.navigationBarView.alpha = 1
                   // self.navigationBarView.backgroundColor = .black
                    
                   // let scaleTransform = CGAffineTransform(scaleX: 1, y: 5).concatenating(CGAffineTransform(translationX: 0, y: 100))
//                    let scaleTransform = CGAffineTransform(scaleX: 1, y: 5)
//                    self.navigationBarView.transform = scaleTransform
                    // self.navigationBarView.isHidden = false
                   // self.navigationBarView.alpha = 1
                  
                    print("Alpha percentage is \(percentage)")
                }
                
            })
            animator?.startAnimation()
            animator?.pauseAnimation()
            return
        }
        propAnimator.fractionComplete = CGFloat(percentage) / 100
    }

    func notificationReceived(_ notification: Notification) {
        guard let percentage = notification.userInfo?["percentage"] as? Int else { return }
        rideListIsPanned(percentage)
    }

    func setupInitiaSubview() {
        self.mapView.isMyLocationEnabled = true
        leftArrowImageView.roundCornersClipped()
        self.navigationBarView.backgroundColor = .clear
        //self.chooseRideLabel.isHidden = true
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        guard let sub = storyboard.instantiateViewController(withIdentifier: "CarListViewController") as? CarListViewController else { return }
        self.addChild(sub)
        self.view.addSubview(sub.view)
        sub.didMove(toParent: self)
        sub.delegate = self
      
        print("view max Y --- \(view.frame.maxY)")
        
        sub.view.frame = CGRect(x: 0, y: view.frame.maxY, width: view.frame.width, height: view.frame.height)
        sub.minimizeSubview(completion: nil)
        
        self.view.insertSubview(containerView, aboveSubview: sub.view)
        
        setupBackButton()
    }
    
    func setupBackButton() {
        let backButton = UIButton(type: .system)
        backButton.tintColor = .black
        backButton.setImage(UIImage(named: "back_arrow"), for: .normal)
        backButton.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
        self.settingsBarButton = UIBarButtonItem(customView: backButton)
        self.navigationItem.setLeftBarButton(settingsBarButton, animated: false)
    }

}

extension ViewController: CarListViewCOntrollerDelegate {
    func didBottomViewMaximized() {
        UIView.animate(withDuration: 0.9) {
            self.containerView.isHidden = true
            self.navigationBarView.backgroundColor = .black
            self.chooseRideLabel.isHidden = false
            
            guard let propAnimator = self.animator else {
                self.animator = UIViewPropertyAnimator(duration: 3, curve: .linear, animations: {
                    let scaleTransform = CGAffineTransform(scaleX: 1, y: 5)
//                    self.navigationBarView.transform = scaleTransform
//                    self.navigationBarView.alpha = 1
//                    self.chooseRideLabel.isHidden = false
                  
                })
                self.animator?.startAnimation()
                self.animator?.pauseAnimation()
                return
            }
            propAnimator.fractionComplete = 1
           
        }
    }
    
    func didBottomViewMinimized() {
        self.navigationBarView.backgroundColor = .clear
        UIView.animate(withDuration: 0.8) {
            self.containerView.isHidden = false
            self.chooseRideLabel.isHidden = true
            self.leftArrowImageView.isHidden = false

        }
    }
    
}

