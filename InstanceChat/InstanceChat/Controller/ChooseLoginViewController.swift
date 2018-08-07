import UIKit
// google login import
import Firebase
import GoogleSignIn

class ChooseLoginViewController: UIViewController {

    @IBOutlet weak var signInBtn4Google: GIDSignInButton!
    
}


//MARK :- Login
extension ChooseLoginViewController: GIDSignInUIDelegate{
    // Login Login 중 호출
    func signIn(signIn: GIDSignIn!, didSignInForUser user: GIDGoogleUser!,
                withError error: NSError!) {
        print("=================[ google login ]=================")
        if (error == nil) {
            // Perform any operations on signed in user here.
            // ...
        } else {
            print("\(error.localizedDescription)")
        }
    }
    
}

//MARK :- LifeCycle
extension ChooseLoginViewController{
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //
        GIDSignIn.sharedInstance().uiDelegate = self

        
        // TODO(developer) Configure the sign-in button look/feel
        // ...
    }
}

//MARK :- IBAction
extension ChooseLoginViewController{
    @IBAction func signIn(_ sender: Any){
        GIDSignIn.sharedInstance().signIn()
        
        let nextViewController = self.storyboard?.instantiateViewController(withIdentifier: "ViewController") as! ViewController
        self.present(nextViewController, animated: true, completion: nil)
    }
}

