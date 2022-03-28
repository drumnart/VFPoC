//
//  BirthdaySelectionViewController.swift
//  VFPoC
//
//  Created by Sergey Gorin on 25/02/2019.
//  Copyright © 2019 Sergey Gorin. All rights reserved.
//

import UIKit

class BirthdaySelectionViewController: UIViewController {
    
    struct Settings {
        var minYear: Int = 1900
        var initialAge: Int = 18
    }
    
    var settings = Settings()
    
    private lazy var years: [Int] = {
        let date = Date()
        let calendar = Calendar.current
        let year = calendar.component(.year, from: date)
        return Array(settings.minYear...year)
    }()
    
    private var defaultBirthYear: Int? {
        guard let last = years.last else { return nil }
        return  last - settings.initialAge
    }
    
    lazy var titleLbl = UILabel().with {
        $0.numberOfLines = 1
        $0.textColor = .tbxBlackTint
        $0.textAlignment = .center
        $0.font = .light(ofSize: 17)
        $0.text = L10n.Onboarding.Birthday.text1
    }
    
    lazy var separator = LineView(lineColor: .tbxMainTint)
    
    lazy var descriptionLbl = UILabel().with {
        $0.numberOfLines = 0
        $0.textColor = .tbxBlackTint
        $0.textAlignment = .center
        $0.font = .light(ofSize: 14)
        $0.text = L10n.Onboarding.Birthday.text2
    }
    
    lazy var birthPicker = UIPickerView().with {
        $0.showsSelectionIndicator = true
        $0.dataSource = self
        $0.delegate = self
    }
    
    var initiallySelectedYear: Int?
    
    private var yearSelection: ((Int) -> Void)?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
    }
}

extension BirthdaySelectionViewController {
    func configure() {
        view.backgroundColor = .tbxWhite
        
        titleLbl.xt.layout(in: view) {
            $0.top(56, to: view.topAnchor)
            $0.centerX(equalTo: view)
            $0.height(20)
        }
        
        separator.xt.layout(in: view) {
            $0.top(20, to: titleLbl.bottomAnchor)
            $0.centerX(equalTo: view)
            $0.size(w: 56, h: 2)
        }
        
        descriptionLbl.xt.layout(in: view) {
            $0.top(20, to: separator.bottomAnchor)
            $0.centerX(equalTo: view)
            $0.size(w: 280, h: 36)
        }
        
        birthPicker.xt.layout(in: view) {
            $0.top(27, to: descriptionLbl.bottomAnchor)
            $0.attachEdges([.left, .right],
                           insets: UIEdgeInsets(top: 0, left: 18, bottom: 0, right: 18)
            )
            $0.height(160)
        }

        selectYear(initiallySelectedYear ?? defaultBirthYear)
    }
    
    func selectYear(_ year: Int?, animated: Bool = false) {
        if let year = year, let index = years.firstIndex(where: { $0 == year }) {
            birthPicker.selectRow(index, inComponent: 0, animated: animated)
        }
    }
    
    func onYearSelected(_ closure: ((Int) -> Void)?) {
        yearSelection = closure
    }
}

extension BirthdaySelectionViewController: UIPickerViewDataSource {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return years.count
    }
}

extension BirthdaySelectionViewController: UIPickerViewDelegate {
    
    func pickerView(_ pickerView: UIPickerView,
                    viewForRow row: Int,
                    forComponent component: Int,
                    reusing view: UIView?) -> UIView {
        
        return ((view as? UILabel) ?? UILabel()).with {
            $0.textAlignment = .center
            $0.backgroundColor = .tbxWhite
            $0.font = .regular(ofSize: 19)
            $0.textColor = pickerView.selectedRow(inComponent: component) == row
                ? .tbxMainTint
                : .tbxLightBlueGrey
            $0.text = String(years[row])
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
        return 48.0
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        pickerView.reloadAllComponents()
        yearSelection?(years[row])
    }
}
