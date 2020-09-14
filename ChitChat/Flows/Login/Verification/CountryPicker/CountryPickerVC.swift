//
//  CountryPickerVC.swift
//  ChitChat
//
//  Created by ty foskey on 9/14/20.
//  Copyright © 2020 ty foskey. All rights reserved.
//

import UIKit
import PhoneNumberKit
import SnapKit

protocol CountryPickerDelegate: class {
    func cancel()
    
}

class CountryPickerVC: UIViewController {
    
    // MARK: - Properties
    let pickerVC: CountryCodePickerViewController
    lazy var pickerVCTableView = UITableView(frame: .zero, style: .grouped)
    lazy var searchController = UISearchController(searchResultsController: nil)
    
    var onCancelAction: (() -> Void)?
    var countryCodePickerViewControllerDidPickCountry: ((CountryCodePickerViewController.Country) -> Void)?
    
    // MARK: - View Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.searchController = searchController
        searchController.searchBar.tintColor = .blue
        let cancelButt = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(cancelTapped))
        navigationItem.leftBarButtonItem = cancelButt
        navigationItem.rightBarButtonItem?.tintColor = .black
        navigationItem.title = "Choose your country"
        navigationItem.hidesSearchBarWhenScrolling = false
   //     navigationItem.searchController = searchController
     //   pickerVC. = self
        navigationController?.navigationBar.barTintColor = .white
        pickerVCTableView.insetsContentViewsToSafeArea = true
        pickerVCTableView.dataSource = pickerVC
        pickerVCTableView.delegate = pickerVC
        view.addSubview(pickerVCTableView)
        
        pickerVCTableView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.topMargin)
            make.left.right.equalTo(view)
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottomMargin)
        }
        
        pickerVC.countryCodePickerViewControllerDidPickCountry = countryCodePickerViewControllerDidPickCountry
    }
    
    
    // MARK: - Actions
    
    @objc func cancelTapped() {
        onCancelAction?()
    }
    
    // MARK: - Init
    
    init(phoneKit: PhoneNumberKit, commomCountries: [String]) {
        self.pickerVC = CountryCodePickerViewController(phoneNumberKit: phoneKit, commonCountryCodes: commomCountries, tableViewStyle: .grouped)
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}


extension CountryCodePickerViewController {
    public func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 300
    }
    
    public func tableView(_ tableView: UITableView, estimatedHeightForHeaderInSection section: Int) -> CGFloat {
        return 300
    }
}
