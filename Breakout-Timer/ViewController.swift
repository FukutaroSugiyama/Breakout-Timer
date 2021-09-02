//
//  ViewController.swift
//  Breakout-Timer
//
//  Created by 杉山福太郎 on 2021/08/07.
//

import UIKit

class ViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource, UITextFieldDelegate {

    @IBOutlet weak var setTime: UILabel!
    @IBOutlet weak var startTimeTextField: UITextField!
    @IBOutlet weak var closeTimeTextField: UITextField!
    @IBOutlet weak var CountDawnTextField: UITextField!
    
    var startPicker: UIDatePicker!
    var closePicker: UIDatePicker!
    var alertController: UIAlertController!
    
    var startTime = ""
    var closeTime = ""
    var countDawn = ""
    
    //StringとDateの相互変換
    class DateUtils {
        class func dateFromString(string: String, format: String) -> Date {
            let formatter: DateFormatter = DateFormatter()
            formatter.calendar = Calendar(identifier: .gregorian)
            formatter.dateFormat = format
            return formatter.date(from: string)!
        }

        class func stringFromDate(date: Date, format: String) -> String {
            let formatter: DateFormatter = DateFormatter()
            formatter.calendar = Calendar(identifier: .gregorian)
            formatter.dateFormat = format
            return formatter.string(from: date)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        startPicker = makePicker(true)
        startTimeTextField.inputView = startPicker

        closePicker = makePicker(false)
        closeTimeTextField.inputView = closePicker
        createPickerView()
    }
    
    //ピッカーの設定
    func makePicker(_ isA:Bool) -> UIDatePicker {
        
        let myPicker:UIDatePicker!
        myPicker = UIDatePicker()
        myPicker.tag = isA ? 1 : 2
        myPicker.datePickerMode = .dateAndTime
        myPicker.locale = NSLocale(localeIdentifier: "ja_JP") as Locale
        myPicker.preferredDatePickerStyle = .wheels

        myPicker.addTarget(self, action:  #selector(onDidChangeDate(sender:)), for: .valueChanged)

        return myPicker
    }

    //テキストフィールド入力
    @objc internal func onDidChangeDate(sender: UIDatePicker){
        let formatter: DateFormatter = DateFormatter()
        formatter.dateFormat = "M月d日 HH:mm"

        let mySelectedDate = formatter.string(from: sender.date)
        if sender.tag == 1 {
            startTimeTextField.text = mySelectedDate
        } else {
            closeTimeTextField.text = mySelectedDate
        }
    }

    //何もないところをタップで閉じる
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        startTimeTextField.endEditing(true)
        closeTimeTextField.endEditing(true)
        CountDawnTextField.endEditing(true)
    }
    
    //アラート
    func alert(title:String, message:String) {
            alertController = UIAlertController(title: title,
                                       message: message,
                                       preferredStyle: .alert)
            alertController.addAction(UIAlertAction(title: "OK",
                                           style: .default,
                                           handler: nil))
            present(alertController, animated: true)
        }
    
    //カウントダウンピッカーの設定
        var pickerView = UIPickerView()
        let dateList = [10, 15, 30, 60, 120]
        let strDateList = ["10", "15", "30", "60", "120"]
        //列数
        func numberOfComponents(in pickerView: UIPickerView) -> Int {
            return 1
        }
        //行数
        func pickerView(_ pickerView: UIPickerView,
                        numberOfRowsInComponent component: Int) -> Int {
            return dateList.count
        }
        //PickerViewの選択肢として表示する文字列を設定（これがないと、?として表示されてしまう）
        func pickerView(_ pickerView: UIPickerView,
                        titleForRow row: Int,
                        forComponent component: Int) -> String? {
            return strDateList[row]
            }
        //Rowが選択された時の挙動
        func pickerView(_ pickerView: UIPickerView,
                        didSelectRow row: Int,
                        inComponent component: Int) {
            CountDawnTextField.text = "\(dateList[row])"
        }
        //pickerView を UITextField の入力に設定する
        func createPickerView() {
            pickerView.delegate = self
            CountDawnTextField.inputView = pickerView
        }
        
        @objc func donePicker() {
            CountDawnTextField.endEditing(true)
        }
    //計算ボタン
    @IBAction func CalculationButtonAction(_ sender: Any) {
        //textFieldの値を取得
        let startTime: String = startTimeTextField.text!
        let closeTime: String = closeTimeTextField.text!
        let countDawn: String = CountDawnTextField.text!
        
        //値が入力されていることを確認
        if startTime.isEmpty || closeTime.isEmpty || countDawn.isEmpty {
            alert(title: "エラー", message:"テキストフィールドの入力が完了していません。")
            return
        }
        //string型からdate型に変換する
        let date1: Date? = DateUtils.dateFromString(string: startTime, format: "M月d日 HH:mm")
        let date2: Date? = DateUtils.dateFromString(string: closeTime, format: "M月d日 HH:mm")
        let date3: Int? = Int(countDawn)!
        
        //時間差を求める
        //返ってくる値は秒単位
        var timeDiff: Int = Int(date2!.timeIntervalSince(date1!))
        
        if timeDiff >= 60 {
            timeDiff /= 60
        } else if timeDiff >= 3600 {
            timeDiff /= 3600
        } else if timeDiff < 0 {
            alert(title: "エラー", message:"クローズ時間がスタート時間よりも前になっています。")
        }
        
        //カウントダウンタイマーの分数を追加
        switch date3 {
            case 10, 15, 30, 60:
                timeDiff += 1
            case 120:
                timeDiff += 2
            default:
                break
        }
        
        //分数をセットする
        if timeDiff >= 0 {
            setTime.text = String(timeDiff)
        } else {
            setTime.text = "0"
        }
        
    }
    
}
