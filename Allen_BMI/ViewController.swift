



// 델리게이트를 채택을 할 때 생각을 해봐야해 텍스트필드 같은 경우에 유저가 입력을 하잖아?
// 근데 그 입력값이 어디로 가? 모른단 말이야 그래서 뭘 해야해?
// 전달자가 있어야하잖아 그래서 delegate -> 대리자 즉 전달을 해줘야한다고.
// 근데 그 대리자를 쓰려면 일단 뷰컨에 확장을 해야하고
// 그리고 내가 대리자가 가져올 곳 여기서는 텍스트필드지 그러니까 텍스트필드.delegate = self(뷰컨)
// 즉 뷰컨트롤러가 대리자 역할을 해서 가져온다는 말이야.





import UIKit


class ViewController: UIViewController {
    
    @IBOutlet weak var mainLabel: UILabel!
    
    @IBOutlet weak var heightTextField: UITextField!
    @IBOutlet weak var weightTextField: UITextField!
    
    @IBOutlet weak var calculateButton: UIButton!
    
   
    // 전달해야하니까 변수를 만들어서 담아놔야한다.
    var bmi: Float?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        makeUI()
        
        
    }
    
    func makeUI() {
        //텍스트필드 델리게이트 채택.
        heightTextField.delegate = self
        weightTextField.delegate = self
        
        mainLabel.text = " 키와 몸무게를 입력하세요. "
        //버튼 둥글게 만들기
        calculateButton.clipsToBounds = true
        calculateButton.layer.cornerRadius = 5
        calculateButton.setTitle("BMI 계산하기", for: .normal)
        heightTextField.placeholder = "cm 단위로 입력해주세요."
        weightTextField.placeholder = "kg 단위로 입력해주세요."
        
    }
    
    // MARK: - BMI 계산 버튼
    @IBAction func calculateButtonTapped(_ sender: UIButton) {
        
        // 버튼 누르면 결과값이 나와야한다.
        // 느낌표를 쓴 이유는 강제로 옵셔널 바인딩 해서 한다 아니면 guard let 하면 된다.
        guard let weight = weightTextField.text,
              let height = heightTextField.text else {return}
        
        bmi = calculateBMI(weight: weight, height: height)
        
      
        
    }
    
    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        
//        Alert 창으로 경고하기.
        
//        if let heightTextField = self.heightTextField, let weightTextField = self.weightTextField {
//            if heightTextField.text?.isEmpty == false && weightTextField.text?.isEmpty == false {
//                return true
//            } else {
//                let alert = UIAlertController(title: "Error", message: "\n 키와 몸무게를 입력해주세요.\n\n", preferredStyle: .alert)
//                let action = UIAlertAction(title: "확인", style: .default, handler: nil)
//                alert.addAction(action)
//                self.present(alert, animated: true, completion: nil)
//                return false
//            }
//        } else {
//            return false
//
        
        // mainLabel에 경고 메시지 띄우기.
        
        if heightTextField.text == "" || weightTextField.text == "" {
            mainLabel.text = "키와 몸무게를 입력하셔야만 합니다!!"
            mainLabel.textColor = .red
            return  false
        }
            mainLabel.text = " 키와 몸무게를 입력해 주세요"
            mainLabel.textColor = UIColor.black
            return true
    }
    
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        //세그웨이의 식별자를 확인한 것이다. 이제 데이터 전달.
        if segue.identifier == "toBMIVC" {
            //속성 자체가 뷰컨트롤러로 선언이 되어있어서 타입캐스팅을 해주는 것이다. 옵션 눌러서 segue.destination 보면 뷰컨이기때문에!
            let secondVC = segue.destination as! BMIViewController
            
            //            BMI 계산 값을 전달.
            secondVC.bmiNumber = self.bmi
            secondVC.adviceString = self.changedBMIAdvice()
            secondVC.bmiColor = self.changedBMIColor()
            
        }
        
        //다음화면 가기전에 텍스트필드 비우기
        
        heightTextField.text = ""
        weightTextField.text = ""
        
        
        }
    
    //BMI계산 메서드
    
    func calculateBMI(weight: String, height: String) -> Float {
            guard let weightValue = Float(weight),
                  let heightValue = Float(height) else { return 0.0 }
           
            var bmi = weightValue / (heightValue * heightValue) * 10000
//        print("BMI 결과전 :\(bmi)")
        
            // 반올림 처리할 때 뒤의 소수점 버리고 다시 나눠주는 형태를 많이 채택한다.
            let roundedBMI = round(bmi * 10) / 10
//        print("BMI 결과후 :\(roundedBMI)")
            return roundedBMI
        }
    
    //색깔 변환 메서드
    
    func changedBMIColor() -> UIColor {
        guard let bmi = bmi else { return UIColor.black}
        switch bmi {
        case ..<18.6:
            return UIColor.blue
        case 18.6..<23.0:
            return UIColor.brown
        case 23.0..<25.0:
            return UIColor.gray
        case 25.0..<29.0:
            return UIColor.green
        default:
            return UIColor.red
        }
    }
    
    // 체중 알려주는 메서드
    func changedBMIAdvice() -> String {
        guard let bmi = bmi else { return " " }
        switch bmi {
        case ..<18.6:
            return "저체중"
        case 18.6..<23.0:
            return "표준"
        case 23.0..<25.0:
            return "표준 조금 벗어남"
        case 25.0..<29.0:
            return "과체중"
        default:
            return " "
        }
    }
    
}








// MARK: - 텍스트필드 델리게이트
extension ViewController: UITextFieldDelegate {
    
    //한글자 한글자 들어올 때마다 불러오는 함수.
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        //숫자만 입력 가능하게 하기 1번 방법
        if Int(string) != nil || string == "" {
            return true
        }else{
            return false
        }
//        숫자만 가능하게 하기. 2번 방법
//            let allowedCharacters = CharacterSet.decimalDigits
//            let characterSet = CharacterSet(charactersIn: string)
//            return allowedCharacters.isSuperset(of: characterSet)
        }
    
    // 키보드 밖에 터치하면 내려가게.
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    //자... 이제 키를 입력하고 엔터치면 몸무게로 넘어가게 만들고 싶어
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        //두개의 텍스트필드를 모두 종료 (키보드 내려가게)
        if heightTextField.text != "", weightTextField.text != "" {
            weightTextField.resignFirstResponder()
            return true
        // 두번째 텍스트필드로 넘어가게.
        } else if heightTextField.text != "" {
            weightTextField.becomeFirstResponder()
            return true
        }
        return false
        
        
//        textField.resignFirstResponder()
//        if let nextField = textField.superview?.viewWithTag(textField.tag + 1) as? UITextField {
//            nextField.becomeFirstResponder()
//        }
//        return false
    }

    
}
