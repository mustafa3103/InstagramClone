import UIKit
import Firebase

class FeedCell: UITableViewCell {
    
    @IBOutlet weak var userEmailLabel: UILabel!
    @IBOutlet weak var commentLabel: UILabel!
    @IBOutlet weak var userImageLabel: UIImageView!
    @IBOutlet weak var likeLabel: UILabel!
    @IBOutlet weak var documentIdLabel: UILabel!
    
    //Kendi özel cell'imizi burada oluşturup gerekli olan değişkenleri vs bu alanda tanımlıyoruz.
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    //MARK: - Beğenileri arttırma olayını bu alanda yapıyoruz. 
    @IBAction func likeButtonClicked(_ sender: UIButton) {
        
        let firestoreDatabase = Firestore.firestore()
        print(likeLabel.text!)
        if let likeCount = Int(likeLabel.text!) {
           
            let likeStore = [K.FS.likes: likeCount + 1] as [String: Any]
            
            firestoreDatabase.collection(K.FS.Posts).document(documentIdLabel.text!).setData(likeStore, merge: true)
        }
    }
}
