//
//  LaunchViewController.swift
//  TestProjectForXDSoft
//
//  Created by Anna Buzhinskaya on 06.07.2022.
//

import UIKit

class LaunchViewController: UIViewController {

    @IBOutlet weak var headingTextLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        headingTextLabel.text = "Тестовое задание\nна позицию iOS-разработчик\nв компанию XDSoft"
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "Назад", style: .plain, target: nil, action: nil)
    }
}
