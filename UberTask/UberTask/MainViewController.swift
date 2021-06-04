//
//  MainViewController.swift
//  UberTask
//
//  Created by Dusan Mitrasinovic on 5/27/21.
//

import UIKit

class MainViewController: UIViewController, UIGestureRecognizerDelegate {
    @IBOutlet weak var mapView: UIView!
    @IBOutlet weak var rideListView: UIView!
    @IBOutlet weak var navigationBarView: UIView!
    @IBOutlet weak var confirmRideView: UIView!
    @IBOutlet weak var leftArrowImageView: UIImageView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var chooseRideLabel: UILabel!
    
    @IBOutlet weak var rideListViewTopConstrinat: NSLayoutConstraint!
    @IBOutlet weak var confirmRideViewHeightConstraint: NSLayoutConstraint!
    
    let ridesRepository = RidesRepository()
    let confirmButtonValues = ConfirmButtonViewValues()
    let navigationBarValues = NavigationBarValues()
    let swipeLabelValues = SwipeLabelValues()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initialSetup()
    }
    
    func initialSetup() {
        leftArrowImageView.roundCornersClipped()
        let panGestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(respondToPanGesture))
        rideListView.addGestureRecognizer(panGestureRecognizer)
        rideListView.isUserInteractionEnabled = true
        panGestureRecognizer.delegate = self
        tableView.delegate = self
        tableView.dataSource = self
        let nib = UINib(nibName: "RideTableViewCell", bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: "RideTableViewCell")
        self.tableView.separatorStyle = .none
    }
    
    @objc func respondToPanGesture(recognizer: UIPanGestureRecognizer) {
        if recognizer.state == .ended {
            let halfScreenCoordinate = self.view.frame.height/2
            if halfScreenCoordinate > rideListViewTopConstrinat.constant {
                self.maximizeRideListView()
            } else {
                self.minimizeRideListView()
            }
        } else {
            let translation = recognizer.translation(in: self.view)
            moveToY(rideListViewTopConstrinat.constant + translation.y)            
            recognizer.setTranslation(.zero, in: self.view)
        }
    }
    
    func maximizeRideListView(completion: (() -> Void)? = nil) {
        UIView.animate(withDuration: 0.8) {
            self.rideListViewTopConstrinat.constant = self.calculateMaximizedTableViewTopConstraint()
            self.confirmRideViewHeightConstraint.constant = self.confirmButtonValues.minimizedConfirmButtonViewHeight
        }
    }
    
    func minimizeRideListView(completion: (() -> Void)? = nil) {
        UIView.animate(withDuration: 0.8) {
            self.moveToY(self.view.frame.height * 0.5)
            self.leftArrowImageView.transform = .identity
            self.navigationBarView.alpha = 0
            self.confirmRideViewHeightConstraint.constant = self.confirmButtonValues.initialConfirmButtonViewHeight
        }
    }
    
    private func calculateMaximizedTableViewTopConstraint() -> CGFloat {
        self.navigationBarValues.navigationBaInitialHeight - self.swipeLabelValues.swipeLabelInitialHeight - self.swipeLabelValues.swipeLabelOffset
    }
    
    private func moveToY(_ position: CGFloat) {
        rideListViewTopConstrinat.constant = position
        UIView.animate(withDuration: 0.8) {
            self.animateNavigationBar()
        }
    }
    
    private func animateNavigationBar() {
        self.leftArrowImageView?.transform =
            CGAffineTransform(rotationAngle: CGFloat(Double.pi * -1/2) )
        self.navigationBarView.alpha = 1
    }
}

extension MainViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return ridesRepository.rides.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "RideTableViewCell", for: indexPath) as? RideTableViewCell else { return UITableViewCell() }
        let ride = ridesRepository.rides[indexPath.row]
        cell.carImageView.image = ride.carImage
        cell.dropoffLabel.text = ride.dropoffTime
        cell.totalAmountLabel.text = "\(ride.totalAmount)"
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return ridesRepository.sections.count
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return ridesRepository.sections[section]
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 60
    }
    
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        view.tintColor = UIColor.white
        let header = view as! UITableViewHeaderFooterView
        header.textLabel?.textColor = UIColor.black
        header.textLabel?.font = UIFont.boldSystemFont(ofSize: 18)
    }

}

