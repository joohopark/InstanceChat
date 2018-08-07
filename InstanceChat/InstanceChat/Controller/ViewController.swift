import UIKit
import Firebase
import GoogleSignIn
import SocketIO
//192.168.0.34
let manager = SocketManager(socketURL: URL(string: "http://localhost:8080")!, config: [.log(false), .compress])
let socket = manager.defaultSocket



//MARK :- IBOutlet & TestSet
class ViewController: UIViewController {
    // 채팅 tableView
    @IBOutlet weak var tableView: UITableView!
    // input 관련 UIVIew
    @IBOutlet weak var inputContainerView: UIView!
    // input Text View
    @IBOutlet weak var inputTextView: UITextView!
    // 전송 Btn
    @IBOutlet weak var inputDoneBtn: UIButton!
    // inputView Bottom 마진
    @IBOutlet weak var inputviewBottomMargin: NSLayoutConstraint!
    // inputTextView 높이
    @IBOutlet weak var inputTextViewHeight: NSLayoutConstraint!
    // test data
    var chatData: [String] = ["ㅎㅇㅎㅇ","ㅂㄱㅂㄱ"]
}

//MARK :- life Cycle
extension ViewController{
    override func viewDidLoad() {
        super.viewDidLoad()
//        print("Socket 연결 전=============================================================]")
        socket.on("connect") { data, ack in
            print("===============================socket connect!!!!!!!!!!!!!!!!!!================")
            socket.emit("adduser", "ㅇㄴㄴㅇㄹㄴㄹ")

        }
        

        socket.connect()



        inputTextView.delegate = self
        tableView.register(UINib(nibName: "myBublleCell", bundle: nil),
                           forCellReuseIdentifier: "MyCell")
        
        tableView.register(UINib(nibName: "YourBubbleCell", bundle: nil),
                           forCellReuseIdentifier: "YourCell")
        tableView.rowHeight = UITableViewAutomaticDimension
        
        
        // 키보드 Notification
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(self.keyboardWillShow(noti:)) ,
                                               name: NSNotification.Name.UIKeyboardWillShow,
                                               object: nil)
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(self.keyboardWillHide(noti:)) ,
                                               name: NSNotification.Name.UIKeyboardWillHide,
                                               object: nil)
        
        
    }
    
//    override func loadViewIfNeeded() {
//        super.loadViewIfNeeded()
//        self.navigationController?.hideNavigationBar()
//    }
}

// MARK :- keyboard Noti , IBAction
extension ViewController{
    @objc private func keyboardWillShow(noti: NSNotification) {
        // userInfo 값을 가져옴
        guard let notiInfo = noti.userInfo as NSDictionary? else {return}
        //let notiInfo = noti.userInfo //as! NSDictionary
        // keyboardfrema 값을 가져온후, CGRect값으로 변경함
        
        let keyboardFrema = notiInfo[UIKeyboardFrameEndUserInfoKey] as! CGRect
        let height = keyboardFrema.size.height
        self.inputviewBottomMargin.constant = -height// 키보드 사이즈만큼 해당 유아이가 올라감.
        let keyboardDuration = notiInfo[UIKeyboardAnimationDurationUserInfoKey] as! TimeInterval
        UIView.animate(withDuration: keyboardDuration) {
            // animation, frema 을 실시간으로 적용할때 무조건 필요함
            self.view.layoutIfNeeded()
        }
    }

    @objc private func keyboardWillHide(noti: NSNotification){
        guard let notiInfo = noti.userInfo as NSDictionary? else {return}
        
        let keyboardDuration = notiInfo[UIKeyboardAnimationDurationUserInfoKey] as! TimeInterval
        UIView.animate(withDuration: keyboardDuration) {
            self.view.layoutIfNeeded()
            self.inputviewBottomMargin.constant = 0
        }
    }

    @IBAction func testInputDone(_ sender: UIButton) {
        if inputTextView.text.isEmpty != true {
            
            socket.emit("sendchat", inputTextView.text);

            
            
            chatData.append(inputTextView.text)
            inputTextView.text = ""
            self.tableView.reloadData()
            let lastIndexPath = IndexPath(row: self.chatData.count-1, section: 0)
            
            //layout 이 잘 안가는경우에, 아래의 녀석을 호출하고 이동시켜보자.
            self.view.layoutIfNeeded()
            //원하는 tableView의 low로 이동하는
            // 전송을 누르면 마지막에 추가된 텍스트로 포커스를 맞춰 스크롤 - 채팅의 마지막 부분만 보인다.
            tableView.scrollToRow(at: lastIndexPath, at: UITableViewScrollPosition.bottom, animated: false)
            
        }
        //같은 함수 한번더 호출해서 해결
        textViewDidChange(inputTextView)
        
    }
    @IBAction func testLogout(_ sender: Any){
//       // log out
//        try! Auth.auth().signOut()
//        // check log out
//        let user = Auth.auth().currentUser
//
//        if user != nil {
//            print("User is signed in.")
//            print(user?.displayName! ?? "")
//            print(user?.photoURL! ?? "")
//        } else {
//            print("No user is signed in.")
//        }

    }
}

//MARK :- tableView
//섹션은 1, 로우는 chatData를 기준으로 결정됨.
extension ViewController: UITableViewDelegate, UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.view.endEditing(true)
        let testOffset = """
        self.tableView.contentOffset : \(self.tableView.contentOffset)
        self.view.frame.origin.y : \(self.view.frame.origin.y)
        self.view.bounds.origin.y : \(self.view.bounds.origin.y)
        """
        print(testOffset)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.chatData.count
    }
    
    // 일단은 두개의 셀을 번갈아 추가 시켜서 나타낼것.
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let defaultCell: UITableViewCell
        if indexPath.row % 2 == 0 {
            let myCell = tableView.dequeueReusableCell(withIdentifier: "MyCell", for: indexPath) as! MyBubbleCell
            myCell.myTextBubble.text = self.chatData[indexPath.row]
            defaultCell = myCell
        }else {
            let yourCell = tableView.dequeueReusableCell(withIdentifier: "YourCell", for: indexPath) as! YourBubbleCell
            yourCell.yourTextBubble.text = self.chatData[indexPath.row]
            defaultCell = yourCell
        }
        
        defaultCell.selectionStyle = UITableViewCellSelectionStyle.none
        return defaultCell
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
}

//MARK :- TextView Delegate
extension ViewController: UITextViewDelegate {
    
    // textView에 글자를 작성할때마다 호출되는 녀석
    func textViewDidChange(_ textView: UITextView) {
        print("같은 함수 한번더 호출")
        if textView.contentSize.height <= 83 {// 입력할때 높이 값이 83 미만일경우 동일하게
            inputTextViewHeight.constant = textView.contentSize.height// 텍스트의 높이를 동일하게 유지, 스크롤이 생성 되더라도.
            textView.setContentOffset(CGPoint.zero, animated: true)
        }
    }
}
