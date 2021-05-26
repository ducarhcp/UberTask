//
//  CarListViewController.swift
//  UberTask
//
//  Created by Dusan Mitrasinovic on 5/21/21.
//

import UIKit

protocol CarListViewCOntrollerDelegate: AnyObject {
    func didBottomViewMinimized()
    func didBottomViewMaximized()
}

class CarListViewController: UIViewController, UIGestureRecognizerDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    let initialHeight: CGFloat = 100
    let openHeight: CGFloat = UIScreen.main.bounds.height - 200
    let closeHeight = UIScreen.main.bounds.height - 200
    var panGestureRecognizer: UIPanGestureRecognizer?
    var animator: UIViewPropertyAnimator?
    weak var delegate: CarListViewCOntrollerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initialSetup()
    }
    
    func initialSetup() {
        tableView.delegate = self
        tableView.dataSource = self
        let gestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(respondToPanGesture))
        view.addGestureRecognizer(gestureRecognizer)
        gestureRecognizer.delegate = self
        panGestureRecognizer = gestureRecognizer
    }
    
    @objc func respondToPanGesture(recognizer: UIPanGestureRecognizer) {
        if recognizer.state == .ended {
            let maxY = UIScreen.main.bounds.height - CGFloat(openHeight)
            
            //            print("MIN X: \(self.view.frame.minX)")
            //            print("MAX X: \(self.view.frame.maxX)")
            //            print("MAX Y: \(self.view.frame.maxY)")
            //            print("MIN Y: \(self.view.frame.minX)")
            
            if maxY > self.view.frame.minY {
                maximizeSubview {}
            } else {
                minimizeSubview {}
            }
            return
        }
        let translation = recognizer.translation(in: self.view)
        moveToY(self.view.frame.minY + translation.y)
        recognizer.setTranslation(.zero, in: self.view)
    }

    func maximizeSubview(completion: (() -> Void)?) {
        UIView.animate(withDuration: 0.5, animations: {
            self.moveToY(84)
            self.delegate?.didBottomViewMaximized()
        }) { _ in
            if let completion = completion {
                completion()
            }
        }
    }

    func minimizeSubview(completion: (() -> Void)?) {
        UIView.animate(withDuration: 0.5, animations: {
            self.moveToY(400)
            self.delegate?.didBottomViewMinimized()
        }) { _ in
            if let completion = completion {
                completion()
            }
        }
    }
    
    private func moveToY(_ position: CGFloat) {
        print("position is: \(position)")
        view.frame = CGRect(x: 0, y: position, width: view.frame.width, height: view.frame.height)

        let maxHeight = view.frame.height - 300//- initialHeight
        let percentage = Int(100 - ((position * 100) / maxHeight))
        
//        print("inital height is: \(view.frame.height)")
//        print("Max height is: \(maxHeight)")
//        print("percentage is: \(percentage)")
        
        let name = NSNotification.Name(rawValue: "BottomViewMoved")
        NotificationCenter.default.post(name: name, object: nil, userInfo: ["percentage": percentage])
    }
    
}

extension CarListViewController: UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 11
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "RideCell", for: indexPath)
        return cell
    }
    
    
}

extension CarListViewController: UITableViewDelegate {
    
}
