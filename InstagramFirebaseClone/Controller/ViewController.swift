//
//  ViewController.swift
//  InstagramFirebaseClone
//
//  Created by Mustafa on 8.10.2021.
//

import UIKit

class ViewController: UIViewController {
    //Her şeye başlamadan önce firebase'i cocoapods ile uygulamamıza entegre ediyoruz bu alanda.
    //Firebase'i entegre ettikten sonra eğer ki bir sürü sarı hatadan çıkarsa alttaki linkten o sorunu çözebiliriz.
    //https://stackoverflow.com/questions/63951540/googledatatransport-is-throwing-double-quoted-include-in-framework-header-expect?answertab=active#tab-top
    

    @IBOutlet weak var emailText: UITextField!
    @IBOutlet weak var passwordText: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    @IBAction func signInClicked(_ sender: UIButton) {
        performSegue(withIdentifier: "toFeedVC", sender: nil)
        
    }
    
    
    @IBAction func signUpClicked(_ sender: UIButton) {
        
    }
    
}

