//
//  UploadViewController.swift
//  InstagramFirebaseClone
//
//  Created by Mustafa on 9.10.2021.
//

import UIKit
import Firebase

class UploadViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    @IBOutlet weak var image: UIImageView!
    @IBOutlet weak var commentText: UITextField!
    @IBOutlet weak var upload: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        upload.isEnabled = false
        // Do any additional setup after loading the view.
        
        image.isUserInteractionEnabled = true
        let imageTapRecognizer = UITapGestureRecognizer(target: self, action: #selector(selectImage))
        image.addGestureRecognizer(imageTapRecognizer)
    }
    //MARK: - Galeriye erişme ve fotoğrafı seçme olayını yaptığımız alan.
    @objc func selectImage (){
        //Fotoğraflara erişebilmek için picker isimli bu arkadaşı kullanıyoruz.
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.sourceType = .photoLibrary
        picker.allowsEditing = true
        present(picker, animated: true, completion: nil)
    }
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        image.image = info[.originalImage] as? UIImage
        if image.image != nil {
            upload.isEnabled = true
        }
        self.dismiss(animated: true, completion: nil)
    }
    //MARK: - Verileri yükleme işlemini bu alanda yapıyoruz.
    @IBAction func uploadClicked(_ sender: UIButton) {
        
        if upload.isEnabled != false {
            //Bu alanda bir referans oluşturuyoruz storage alanı için.
            //child ise bir alt klasörü belirtiyor. Eğer ki o klasör yoksa otomatik olarak o klasörü oluşturuyor.
            let storage = Storage.storage()
            let storageReference = storage.reference()
            
            let mediaFolder = storageReference.child(K.FS.media)
            
            if let data = image.image?.jpegData(compressionQuality: 0.5) {
                
                //Yüklenilen bir önceki resmin üstüne yazılmasın diye resimlerimize unique isimler veriyoruz.
                let uuid = UUID().uuidString
                
                let imageReference = mediaFolder.child("\(uuid).jpg")
                imageReference.putData(data, metadata: nil) { metaData, error in
                    
                    if error != nil {
                        self.makeAlert(title: "Save error", message: error!.localizedDescription)
                    }else {
                        imageReference.downloadURL { url, error in
                            if error == nil {
                                let imageUrl = url?.absoluteString
                                //DATABASE --> Bu alanda ise Firestore kaydetme işlemlerini gerçekleştiriyoruz.
                                
                                let firestoreDatabase = Firestore.firestore()
                                var firestoreReference : DocumentReference? = nil
                                
                                //Yüklemek istediğimiz verileri bu alanda sözlük içine kaydediyoruz.
                                let firestorePost: [String: Any] = [K.FS.imageUrl: imageUrl!, K.FS.postedBy: Auth.auth().currentUser!.email!, K.FS.postComment: self.commentText.text!, K.FS.date: FieldValue.serverTimestamp(),K.FS.likes: 0]
                                
                                firestoreReference = firestoreDatabase.collection(K.FS.Posts).addDocument(data: firestorePost, completion: { error in
                                    if error != nil {
                                        self.makeAlert(title: "Error", message: error!.localizedDescription)
                                    }else {
                                        
                                        //Kayıt işlemleri başarılı olduktan sonra yapılacak olan işlemleri bu alanda yapıyoruz.
                                        
                                        //Burada ise kullanıcının girmiş olduğu değerleri default değerler ile değiştiriyoruz.
                                        self.image.image = UIImage(systemName: K.photo)
                                        self.commentText.text = ""
                                        
                                        //Burada seçmiş olduğumuz index'e(tabBarController arasında geçişler bu şekilde yapılıyor) bizi götürücek.
                                        self.tabBarController?.selectedIndex = 0
                                    }
                                })
                            }else {
                                self.makeAlert(title: "Error !!!", message: error!.localizedDescription)
                            }
                        }
                    }
                }
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
