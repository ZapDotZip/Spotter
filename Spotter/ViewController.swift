//
//  ViewController.swift
//  Spotter
//

import UIKit

class ViewController: UITabBarController {
	let appDel = UIApplication.shared.delegate as! AppDelegate
	
	override func viewDidLoad() {
		super.viewDidLoad()
		appDel.viewCon = self
		// Do any additional setup after loading the view.
	}
	
	func alert(title: String, msg: String, style: UIAlertController.Style) {
		let alert = UIAlertController.init(title: title, message: msg, preferredStyle: style)
		let ok = UIAlertAction.init(title: "Ok", style: .default)
		alert.addAction(ok)
		self.present(alert, animated: true)
	}
	
	
}

