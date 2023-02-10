//
//  BMIViewController.swift
//  Allen_BMI
//
//  Created by BS K on 2023/02/09.
//

import UIKit

class BMIViewController: UIViewController {

    @IBOutlet weak var bmiNumberLabel: UILabel!
    @IBOutlet weak var adviceLabel: UILabel!
    
    @IBOutlet weak var backButton: UIButton!
    
    var bmiNumber : Float?
    var adviceString: String?
    var bmiColor: UIColor?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        makeUI()
    }
    
    func makeUI() {
        
        bmiNumberLabel.clipsToBounds = true
        bmiNumberLabel.layer.cornerRadius = 8
        bmiNumberLabel.backgroundColor = .gray
        
        backButton.clipsToBounds = true
        backButton.layer.cornerRadius = 5
       
        guard let bmi = bmiNumber else {return}
        bmiNumberLabel.text = String(bmi)
        
        adviceLabel.text = adviceString
        bmiNumberLabel.backgroundColor = bmiColor
        
        
        
    }
    
    @IBAction func backButtonTapped(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
        
        
        
    }
    
    

}
