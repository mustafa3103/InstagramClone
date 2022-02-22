//
//  ViewController.swift
//  InstagramFirebaseClone
//
//  Created by Mustafa on 8.10.2021.
//

import UIKit
import Firebase

class ViewController: UIViewController {
    //Her şeye başlamadan önce firebase'i cocoapods ile uygulamamıza entegre ediyoruz bu alanda.
    //Firebase'i entegre ettikten sonra eğer ki bir sürü sarı hatadan çıkarsa alttaki linkten o sorunu çözebiliriz.
    //https://stackoverflow.com/questions/63951540/googledatatransport-is-throwing-double-quoted-include-in-framework-header-expect?answertab=active#tab-top
    
    @IBOutlet weak var emailText: UITextField!
    @IBOutlet weak var passwordText: UITextField!
    
    var email: String = ""
    var password: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    //MARK: - Kayıt ve Giriş işlemlerinin bulunduğu fonksiyonlar.
    @IBAction func signUpClicked(_ sender: UIButton) {
        //Burada önce email ve şifrenin boş olup olmadığını kontrol ediyoruz.
        if emailText.text != "" && passwordText.text != "" {
            email = emailText.text!
            password = passwordText.text!
            
            Auth.auth().createUser(withEmail: email, password: password) { authResult, error in
              // ...
                if error != nil {
                    self.makeAlert(title: "Creating error", message: "Error occured while creating new user. Error is: \(error!.localizedDescription).")
                }else {
                    self.performSegue(withIdentifier: K.Controllers.feedVC, sender: nil)
                    
                }
            }
            
        }else {
            makeAlert(title: "Empty area !!!", message: "Please fill the email and password area.")
        }
        
    }
    
    @IBAction func signInClicked(_ sender: UIButton) {
        
        if emailText.text != "" && passwordText.text != "" {
            email = emailText.text!
            password = passwordText.text!
            
            Auth.auth().signIn(withEmail: email, password: password) { authResult, error in
                if error != nil {
                    self.makeAlert(title: "Error while signing account", message: error!.localizedDescription)
                    
                }else {
                    self.performSegue(withIdentifier: K.Controllers.feedVC, sender: nil)
                }
                
            }
            
        }
    
    }
    //MARK: - Alert oluşturduğumuz fonksiyon.
    func makeAlert(title: String, message: String) {
        
        //Uyarı mesajını oluşturma
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
        let okButton = UIAlertAction(title: "Okay", style: UIAlertAction.Style.destructive, handler: nil)
        
        //Ok butonunu uyarı mesajımıza ekleme
        alert.addAction(okButton)
        //Uyarı mesajını gösterme
        self.present(alert, animated: true, completion: nil)
    }
}
