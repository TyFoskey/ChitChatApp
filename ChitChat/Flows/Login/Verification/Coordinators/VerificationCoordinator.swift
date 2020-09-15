//
//  VerificationCoordinator.swift
//  ChitChat
//
//  Created by ty foskey on 9/14/20.
//  Copyright © 2020 ty foskey. All rights reserved.
//

import UIKit
import PhoneNumberKit
import FloatingPanel

class VerificationCoordinator: Coordinator, CoordinatorFinishOutput {
    
    // MARK: - Properties
    private let router: Router
    private let phoneKit: PhoneNumberKit
    private var currentCountry = PhoneNumberKit()
    var phoneNumber: String!
    
    // MARK: - Coordinator Finish Output
    var finishFlow: ((Any?) -> Void)?
    
    // MARK: - Coordinator Lifecylce
    init(router: Router, phoneKit: PhoneNumberKit) {
        self.router = router
        self.phoneKit = phoneKit
    }
    
    func start() {
        showPhoneNumberVC()
    }
    
    deinit {
        print("verification coordinator being deallocated")
    }
    
    // MARK: - Show VCs
    
    // Starts with asking for either their email or phone number
    private func showPhoneNumberVC() {
        let phoneNumberVC = PhoneNumberViewController()
        phoneNumberVC.onButtomButtTap = { [weak self] text in
            guard let strongSelf = self else { return }
            strongSelf.phoneNumber = text
            strongSelf.showCodeVerificationVC(phoneNumber: text)
        }
        
        phoneNumberVC.onCountryButtTap = {[weak self] in
            print("country code tapped")
            self?.showCountryPickerVC(phoneNumberVC: phoneNumberVC)
        }
        
        router.push(phoneNumberVC)
    }
    
    // Creates an country code picker VC
    private func showCountryPickerVC(phoneNumberVC: PhoneNumberViewController) {
        let commomCountries = ["US", "CA", "MX", "AU", "GB", "DE"]
        let countryPickerVC = CountryCodePickerViewController(phoneNumberKit: phoneKit, commonCountryCodes: commomCountries, tableViewStyle: .insetGrouped)
        countryPickerVC.navigationItem.searchController?.hidesNavigationBarDuringPresentation = false
        countryPickerVC.navigationItem.searchController?.searchBar.showsCancelButton = false
        countryPickerVC.navigationItem.hidesSearchBarWhenScrolling = false
        
        countryPickerVC.onCancelAction = {[weak self] in
            self?.router.dismissModule()
        }
        
        countryPickerVC.countryCodePickerViewControllerDidPickCountry = {[weak self] country in
            
            phoneNumberVC.updateRegionButton(region: country.code)
            self?.router.dismissModule()
            print(country.code)
        }
                
        
        let navContr = UINavigationController(rootViewController: countryPickerVC)
        countryPickerVC.navigationController?.navigationBar.tintColor = .white
        let fpc = FloatingPanelController()
        fpc.set(contentViewController: navContr)
        fpc.surfaceView.cornerRadius = 24.0
        fpc.surfaceView.shadowHidden = false
        fpc.track(scrollView: countryPickerVC.tableView)

        fpc.surfaceView.contentInsets = UIEdgeInsets(top: 10, left: 0, bottom: 0, right: 0)
        fpc.surfaceView.containerMargins = UIEdgeInsets(top: 0, left: 5, bottom: 0, right: 5)
 
        fpc.isRemovalInteractionEnabled = true // Optional: Let it removable by a swipe-down
        fpc.delegate = self

        router.present(fpc)
        
    }
    
    // Shows a verification view if signed up with phone number to verify
    private func showCodeVerificationVC(phoneNumber: String) {
        let codeVerificationVC = CodeVerificationViewController(phoneNumber: phoneNumber,
                                                                authentication: Authentication())
        codeVerificationVC.onVerifiedAction = {[weak self] in
            guard let strongSelf = self else { return }
            strongSelf.finishFlow?(strongSelf.phoneNumber)
        }
        
        router.push(codeVerificationVC)
    }
    
}

extension VerificationCoordinator: FloatingPanelControllerDelegate {
    
    func floatingPanel(_ vc: FloatingPanelController, layoutFor newCollection: UITraitCollection) -> FloatingPanelLayout? {
        return PhoneFloatingPanelLayout()
    }
}

class PhoneFloatingPanelLayout: FloatingPanelLayout {
    var initialPosition: FloatingPanelPosition {
        return .full
    }
    
    var supportedPositions: Set<FloatingPanelPosition> {
        return [.full]
    }
    
    func insetFor(position: FloatingPanelPosition) -> CGFloat? {
        switch position {
        case .full: return 16
        default: return nil
        }
    }
    
    
}
