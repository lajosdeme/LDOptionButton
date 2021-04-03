//
//  ViewController.swift
//  LDOptionButtonExample
//
//  Created by Lajos Deme on 2021. 04. 03..
//

import UIKit
import MapKit
import CoreLocation
import LDOptionButton

class ViewController: UIViewController {

    var mapView: MKMapView!
    var button: LDOptionButton!

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(red: 0.17, green: 0.18, blue: 0.29, alpha: 1.00)
        addMap()
        addSearchView()
        addOptionButton()
    }
    
    private func addMap() {
        mapView = MKMapView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height))
        view.addSubview(mapView)
    }
    
    private func addSearchView() {
        let view = UIView(frame: CGRect(x: 24, y: 60, width: UIScreen.main.bounds.width - 48, height: 30))
        self.view.addSubview(view)
        
        view.backgroundColor = .white
        view.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.25).cgColor
        view.layer.shadowOffset = CGSize(width: 2.0, height: 2.0)
        view.layer.shadowOpacity = 1.0
        view.layer.shadowRadius = 3.0
        view.layer.cornerRadius = 15
        view.layer.masksToBounds = false
        
        let img = UIImage.init(systemName: "magnifyingglass")
        let imgView = UIImageView(image: img)
        imgView.tintColor = .lightGray
        imgView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(imgView)
        imgView.heightAnchor.constraint(equalToConstant: 20).isActive = true
        imgView.widthAnchor.constraint(equalToConstant: 20).isActive = true
        imgView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 8).isActive = true
        imgView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(label)
        label.text = "Search..."
        label.font = .systemFont(ofSize: 15)
        label.textColor = .lightGray
        label.leadingAnchor.constraint(equalTo: imgView.trailingAnchor, constant: 3).isActive = true
        label.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        
        view.isUserInteractionEnabled = true
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(tapView)))
    }
    @objc func tapView() {
        button.showButtons()
    }
    
    private func addOptionButton() {
        let configs = [
            SideButtonConfig(backgroundColor: .blue, normalIcon: "settings"),
            SideButtonConfig(backgroundColor: .green, normalIcon: "info"),
            SideButtonConfig(backgroundColor: .red, normalIcon: "location")
        ]
        button = LDOptionButton(frame: CGRect(x: view.bounds.width - 100 , y: view.bounds.height - 130, width: 50, height: 50), normalIcon: "home", selectedIcon: "close", buttonsCount: 3, sideButtonConfigs: configs, duration: 0.2)
        
        button.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.25).cgColor
        button.layer.shadowOffset = CGSize(width: 2.0, height: 2.0)
        button.layer.shadowOpacity = 1.0
        button.layer.shadowRadius = 3.0
        button.layer.masksToBounds = false
        
        button.backgroundColor = .white
        button.startAngle = 0
        button.endAngle = 90
        button.delegate = self
        view.addSubview(button)
    }
}

//MARK: - Option button delegate
extension ViewController: LDOptionButtonDelegate {
    func optionButton(optionButton: LDOptionButton, willSelect button: UIButton, atIndex: Int) {
        print("will select button at \(atIndex)")
    }
    
    func optionButton(optionButton: LDOptionButton, didSelect button: UIButton, atIndex: Int) {
        print("did select button at \(atIndex)")
    }
    
    func optionButton(didOpen options: LDOptionButton) {
        print("did open options")
    }
    
    func optionButton(didClose options: LDOptionButton) {
        print("did close options")
    }
}
