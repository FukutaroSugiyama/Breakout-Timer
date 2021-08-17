//
//  ModalViewController.swift
//  Breakout-Timer
//
//  Created by 杉山福太郎 on 2021/08/13.
//

import UIKit

class ModalViewController: UIViewController ,UIPickerViewDelegate ,UIPickerViewDataSource {
    
    

    @IBOutlet weak var countDawnTimer: UIPickerView!
    
    //カウントダウンタイマーのデータリスト
    let dateList = [10,15,30,60,120]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Delegate設定
        countDawnTimer.delegate = self
        countDawnTimer.dataSource = self
                
    }
    
    //列の数
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    //行数、リストの数
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return dateList.count
    }

    //最初の表示
        func pickerView(_ pickerView: UIPickerView,
                        titleForRow row: Int,
                        forComponent component: Int) -> String? {
            
            return dataList[row]
        }
        
        //Rowが選択された時の挙動
        func pickerView(_ pickerView: UIPickerView,
                        didSelectRow row: Int,
                        inComponent component: Int) {
            
            label.text = dataList[row]
            
        }
    
    //Backボタンの制御
    @IBAction func backButtonAction(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
