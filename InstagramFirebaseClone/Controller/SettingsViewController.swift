//
//  SettingsViewController.swift
//  InstagramFirebaseClone
//
//  Created by Mustafa on 9.10.2021.
//
import UIKit
import Firebase

class SettingsViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    //MARK: - Log out işlemlerinin yapıldığı alan.
    @IBAction func logoutClicked(_ sender: UIButton) {
        if Auth.auth().currentUser != nil {
            do {
                try Auth.auth().signOut()
                
                self.performSegue(withIdentifier: K.Controllers.firstVC, sender: nil)
                
            } catch {
                makeAlert(title: "Error was occured", message: error.localizedDescription)
            }
        }
    }
    //MARK: - Uyarı mesajı fonksiyonumuzu oluşturduğumuz yer.
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
