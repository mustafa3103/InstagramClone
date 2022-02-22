//
//  FeedViewController.swift
//  InstagramFirebaseClone
//
//  Created by Mustafa on 9.10.2021.
//

import UIKit
import Firebase
import SDWebImage

class FeedViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    //Storyboard içerisinde tanımlamış olduğumuz tableView'u buraya bağlıyoruz.
    @IBOutlet weak var tableView: UITableView!
    
    var userEmailArray = [String]()
    var userCommentArray = [String]()
    var likeArray = [Int]()
    var userImageArray = [String]()
    var documentIdArray = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        tableView.delegate = self
        tableView.dataSource = self
        
        getDataFromFirestore()
    }
    //MARK: - TableView metodlarımızın bulunduğu alan.
    
    //Kaç tane cell gösterilmesi gerektiğini belirttiğimiz alan.
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return userEmailArray.count
    }
    
    //Cell içinde gösterilecek olan itemleri bu alanda belirtiyoruz.
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! FeedCell
        
        //Firestoredan aldığımız verileri dizilere aktardık ve o dizileri kullanarak bu alanda verilerimizi kullanıyoruz bu şekilde.
        cell.userEmailLabel.text = userEmailArray[indexPath.row]
        cell.commentLabel.text = userCommentArray[indexPath.row]
        cell.likeLabel.text = "\(likeArray[indexPath.row])"
        cell.userImageLabel.sd_setImage(with: URL(string: userImageArray[indexPath.row]))
        
        cell.documentIdLabel.text = documentIdArray[indexPath.row]
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        //Bu kodun olayı seçilen satırı animasyonlu bir şekilde gösteriyor ve seçildikten kısa bir süre sonra kaldırıyor seçilme olayını.
        tableView.deselectRow(at: indexPath, animated: true)
    }
    //MARK: - Firestoredan veriyi çekme olayını yaptığımız alan.
    func getDataFromFirestore() {
        
        let firestoreDataBase = Firestore.firestore()
        
        //Order ile verileri tarihe göre çekiyoruz.
        firestoreDataBase.collection(K.FS.Posts)
            .order(by: K.FS.date, descending: true)
            .addSnapshotListener { snapshot, error in
            
            if error != nil {
                self.makeAlert(title: "Error", message: error!.localizedDescription)
            }else {
                //Data alma işlemlerimizi bu alanda yapıyoruz.
                //Snapshot'ın dolu olup olmadığını kontrol ediyoruz bu alanda.
                if snapshot?.isEmpty != true && snapshot != nil {
                    //Loop içinde güzel ve okunaklı olması için documents isimli bir sabite eşitledim ve ünlem ile casting yaptım.
                    let documents = snapshot!.documents
                    //Burada oluşturduğumuz listeleri temizliyoruz tekrarlayan itemler olmasın diye.
                    self.userEmailArray.removeAll()
                    self.userCommentArray.removeAll()
                    self.likeArray.removeAll()
                    self.userImageArray.removeAll()
                    self.documentIdArray.removeAll()
                    
                    for document in documents {
                        //Bu alanda döngü içerisinde firestore'a eklemiş olduğumuz verileri casting yaparak çekiyoruz ve bir arraya ekliyoruz.
                        let documentId = document.documentID
                        //Buradaki documentId'nin olayı beğenileri arttırmak için bu alanda önce yüklenilen postların Id'sini alıyoruz ve FeedCell tarafında arttırma işlemini yapıyoruz.
                        self.documentIdArray.append(documentId)
                        
                        if let postedBy = document.get(K.FS.postedBy) as? String {
                            self.userEmailArray.append(postedBy)
                        }
                        
                        if let comment = document.get(K.FS.postComment) as? String {
                            self.userCommentArray.append(comment)
                        }
                        
                        if let like = document.get(K.FS.likes) as? Int {
                            self.likeArray.append(like)
                        }
                        
                        if let imageUrl = document.get(K.FS.imageUrl) as? String {
                            self.userImageArray.append(imageUrl)
                        }
                    }
                    self.tableView.reloadData()
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
