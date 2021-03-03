//
//  RMtextField.swift
//  txtSearch
//
//  Created by eHeuristic on 03/03/21.
//

import Foundation
import UIKit

class RMtextField: UITextField, UITextFieldDelegate, UITableViewDelegate, UITableViewDataSource {
   
    var table_view = UITableView()

    var arr_skills:[String] = ["swift", "obj c", "java", "java2", "kotline", "PHP", "angular", "java script", "node", "node js", "larawel", "swift3", "ios", "xcode", "firebase", "react", "native", "flutter", "dart", "development", "c", "c++", "java3", "andriod"] {
        didSet {
            arr_tableData = arr_skills
        }
    }

    var arr_tableData: [String] = [] {
        didSet {
            table_view.frame.size.height = /*arr_tableData.count > 5 ? 200 : */CGFloat(arr_tableData.count * 40)
            table_view.reloadSections(IndexSet(0...0), with: UITableView.RowAnimation.fade)
        }
    }
    
    fileprivate  var parentController:UIViewController?
    fileprivate var didSelectCompletion: (String, Int ,Int) -> () = {selectedText, index , id  in }
    // Init
    public override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
        self.delegate = self
    }

    public required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
        setupUI()
        self.delegate = self
    }
    
    
    func setupUI () {
        if parentController == nil {
            parentController = UIApplication.getPresentedViewController()
        }
        table_view.frame.origin.x = self.frame.origin.x
        table_view.frame.origin.y = self.frame.origin.y
        table_view.frame.size.width = self.frame.size.width
        table_view.dataSource = self
        table_view.delegate = self
        table_view.backgroundColor = .blue
        parentController?.view.addSubview(table_view)
    }
    
    
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
    
    //MARK:- TextFeild Delegate
    func textFieldDidBeginEditing(_ textField: UITextField) {
        table_view.isHidden = false
    }
    
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        table_view.isHidden = false
        let old_string = NSString(string: textField.text ?? "")
        let new_string = old_string.replacingCharacters(in: range, with: string)
        print(new_string)
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
        self.text = arr_tableData[indexPath.row]
        didSelectCompletion(arr_tableData[indexPath.row], indexPath.row, indexPath.row)
        self.endEditing(true)
        table_view.isHidden = true
    }
    
    public func didSelect(completion: @escaping (_ selectedText: String, _ index: Int , _ id:Int ) -> ()) {
        didSelectCompletion = completion
    }
    
    public func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        print(textField.text)
        superview?.endEditing(true)
        return false
    }
}

extension UIApplication {
    class func getPresentedViewController() -> UIViewController? {
    var presentViewController = UIApplication.shared.windows.first?.rootViewController
    while let pVC = presentViewController?.presentedViewController {
        presentViewController = pVC
    }
    return presentViewController
  }
}
