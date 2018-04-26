//
//  ViewController.swift
//  SwiftDemo
//
//  Created by piggybear on 2017/10/25.
//  Copyright © 2017年 piggybear. All rights reserved.
//

import UIKit
import PGDatePicker

class ViewController: UIViewController {

    @IBAction func yearHandle(_ sender: Any) {
        let datePickerManager = PGDatePickManager()
        datePickerManager.isShadeBackgroud = true
        datePickerManager.style = .style2
        let datePicker = datePickerManager.datePicker!
        datePicker.delegate = self
        datePicker.datePickerMode = .year
        self.present(datePickerManager, animated: false, completion: nil)
//        datePicker.minimumDate = NSDate.setYear(2015)
//        datePicker.maximumDate = NSDate.setYear(2020)
    }
    
    @IBAction func yearAndMonthHandle(_ sender: Any) {
        let datePickerManager = PGDatePickManager()
        datePickerManager.isShadeBackgroud = true
        datePickerManager.style = .style3
        let datePicker = datePickerManager.datePicker!
        datePicker.delegate = self
        datePicker.datePickerType = .type1
        datePicker.datePickerMode = .yearAndMonth
        self.present(datePickerManager, animated: false, completion: nil)
        
//        datePicker.minimumDate = NSDate.setYear(2015, month: 5)
//        datePicker.maximumDate = NSDate.setYear(2020, month: 10)
    }
    
    @IBAction func dateHandle(_ sender: Any) {
        let datePickerManager = PGDatePickManager()
        let datePicker = datePickerManager.datePicker!
        datePicker.delegate = self
        datePicker.isHiddenMiddleText = false;
        datePicker.datePickerType = .type2;
        datePicker.datePickerMode = .date
        self.present(datePickerManager, animated: false, completion: nil)
        
//        datePicker.minimumDate = NSDate.setYear(2015, month: 5, day: 10)
//        datePicker.maximumDate = NSDate.setYear(2020, month: 10, day: 20)
    }
    
    @IBAction func dateHourMinuteHandle(_ sender: Any) {
        let datePickerManager = PGDatePickManager()
        let datePicker = datePickerManager.datePicker!
        datePicker.delegate = self
        datePicker.datePickerMode = .dateHourMinute
        self.present(datePickerManager, animated: false, completion: nil)
    }
    
    @IBAction func dateHourMinuteSecondHandle(_ sender: Any) {
        let datePickerManager = PGDatePickManager()
        let datePicker = datePickerManager.datePicker!
        datePicker.delegate = self
        datePicker.datePickerMode = .dateHourMinuteSecond
        self.present(datePickerManager, animated: false, completion: nil)
    }
    
    @IBAction func timeHandle(_ sender: Any) {
        let datePickerManager = PGDatePickManager()
        let datePicker = datePickerManager.datePicker!
        datePicker.delegate = self
        datePicker.datePickerMode = .time
        self.present(datePickerManager, animated: false, completion: nil)
    }
    
    @IBAction func timeAndSecondHandle(_ sender: Any) {
        let datePickerManager = PGDatePickManager()
        let datePicker = datePickerManager.datePicker!
        datePicker.delegate = self
        datePicker.datePickerMode = .timeAndSecond
        self.present(datePickerManager, animated: false, completion: nil)
    }
    
    @IBAction func dateAndTimeHandle(_ sender: Any) {
        let datePickerManager = PGDatePickManager()
        let datePicker = datePickerManager.datePicker!
        datePicker.delegate = self
        datePicker.datePickerMode = .dateAndTime
        self.present(datePickerManager, animated: false, completion: nil)
    }
    
    @IBAction func titleHandle(_ sender: Any) {
        let datePickerManager = PGDatePickManager()
        datePickerManager.titleLabel.text = "PGDatePicker"
        let datePicker = datePickerManager.datePicker!
        datePicker.delegate = self
        datePicker.datePickerMode = .date
        self.present(datePickerManager, animated: false, completion: nil)
    }
    
    @IBAction func styleHandle(_ sender: Any) {
        let datePickerManager = PGDatePickManager()
        let datePicker = datePickerManager.datePicker!
        self.present(datePickerManager, animated: false, completion: nil)
        datePicker.delegate = self
        datePickerManager.titleLabel.text = "PGDatePicker"
        //设置头部的背景颜色
        datePickerManager.headerViewBackgroundColor = UIColor.orange
        //设置半透明背景
        datePickerManager.isShadeBackgroud = true
        //设置线条的颜色
        datePicker.lineBackgroundColor = UIColor.red
        //设置选中行的字体颜色
        datePicker.textColorOfSelectedRow = UIColor.red
        //设置未选中行的字体颜色
        datePicker.textColorOfOtherRow = UIColor.black
        
        //设置取消按钮的字体颜色
        datePickerManager.cancelButtonTextColor = UIColor.black
        //设置取消按钮的字
        datePickerManager.cancelButtonText = "Cancel"
        //设置取消按钮的字体大小
        datePickerManager.cancelButtonFont = UIFont.boldSystemFont(ofSize: 17)
        
        //设置确定按钮的字体颜色
        datePickerManager.confirmButtonTextColor = UIColor.red
        //设置确定按钮的字
        datePickerManager.confirmButtonText = "Sure"
        //设置确定按钮的字体大小
        datePickerManager.confirmButtonFont = UIFont.boldSystemFont(ofSize: 17)
        datePicker.datePickerMode = .date
    }
}

extension ViewController: PGDatePickerDelegate {
    func datePicker(_ datePicker: PGDatePicker!, didSelectDate dateComponents: DateComponents!) {
        print("dateComponents = ", dateComponents)
    }
}

