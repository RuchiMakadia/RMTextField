//
//  ViewController.swift
//  txtSearch
//
//  Created by eHeuristic on 02/03/21.
//

import UIKit
import IQKeyboardManagerSwift

//var arr_skills =



class ViewController: UIViewController {
    
    @IBOutlet weak var txt_skill: UITextField!
    
    var table_view = UITableView()

    fileprivate var arr_skills:[String] = ["swift", "obj c", "java", "java2", "kotline", "PHP", "angular", "java script", "node", "node js", "larawel", "swift3", "ios", "xcode", "firebase", "react", "native", "flutter", "dart", "development", "c", "c++", "java3", "andriod"] {
        didSet {
            arr_tableData = arr_skills
        }
    }

    fileprivate var arr_tableData: [String] = [] {
        didSet {
            table_view.frame.size.height = /*arr_tableData.count > 5 ? 200 : */CGFloat(arr_tableData.count * 40)
            table_view.reloadSections(IndexSet(0...0), with: UITableView.RowAnimation.automatic)
        }
    }
    
    fileprivate var didSelectCompletion: (String, Int ,Int) -> () = {selectedText, index , id  in }
    fileprivate var is_editable: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print(txt_skill.bounds)
        print(txt_skill.frame)
        table_view.frame.origin.x = txt_skill.frame.origin.x
        table_view.frame.origin.y = txt_skill.frame.origin.y - 20
        table_view.frame.size.width = txt_skill.frame.size.width
        table_view.dataSource = self
        table_view.delegate = self
        self.view.addSubview(table_view)
        table_view.isHidden = true
        IQKeyboardManager.shared.disabledToolbarClasses = [ViewController.self]
        txt_skill.becomeFirstResponder()
        
    }
    
    @IBAction func btn_Cancel_selct(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.navigationBar.isHidden = true
    }
}

extension ViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arr_tableData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellIdentifier = "DropDownCell"
        var cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier)
        if cell == nil {
            cell = UITableViewCell(style: .default, reuseIdentifier: cellIdentifier)
        }
        cell?.textLabel?.text = arr_tableData[indexPath.row]
        return cell!
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 40
    }
}

extension ViewController: UITextFieldDelegate {
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        table_view.isHidden = false
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let old_string = NSString(string: textField.text ?? "")
        let new_string = old_string.replacingCharacters(in: range, with: string)
        if new_string == "" {
            arr_tableData = arr_skills
        }
        else {
                arr_tableData = arr_skills.filter { $0.lowercased().contains(new_string.lowercased())
            }
        }
        return true
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        didSelectCompletion(arr_tableData[indexPath.row], indexPath.row, indexPath.row)
        dismiss(animated: true, completion: nil)
    }
    
    public func didSelect(completion: @escaping (_ selectedText: String, _ index: Int , _ id:Int ) -> ()) {
        didSelectCompletion = completion
    }
    
    public func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.endEditing(true)
        dismiss(animated: true, completion: nil)
        if is_editable {
            didSelectCompletion(textField.text ?? "", 0, 0)
        }
        return false
    }
}


