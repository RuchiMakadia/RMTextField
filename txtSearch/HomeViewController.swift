//
//  HomeViewController.swift
//  txtSearch
//
//  Created by eHeuristic on 03/03/21.
//

import UIKit

class HomeViewController: UIViewController {

    @IBOutlet weak var txt_skill: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    


}

extension HomeViewController: UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        let new_vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ViewController") as! ViewController
        new_vc.didSelect { (str, id1, id2) in
            self.txt_skill.text = str
        }
        self.present(new_vc, animated: true, completion: nil)
        textField.endEditing(true)
    }
}
