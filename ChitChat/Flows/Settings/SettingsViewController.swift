//
//  SettingsViewController.swift
//  ChitChat
//
//  Created by ty foskey on 9/26/20.
//  Copyright © 2020 ty foskey. All rights reserved.
//

import UIKit
import IGListKit
import CropViewController
import SVProgressHUD

class SettingsViewController: UIViewController {
    
    // MARK: - Properties
    let usersManager = UsersManager()
    let settingsView = SettingsView()
    var onSignOut: (()-> Void)?
    let auth = Authentication()
    let assetManager = AssetManager()
    let settingsController = SettingsModelController(dataFetcher: DataFetcher())
    var isNumberTextFieldNil = false
    var isNameTextFieldNil = false
    var cells = [SettingsCellViewModel]()

    
    lazy var adapter: ListAdapter = {
        let adapater = ListAdapter(updater: ListAdapterUpdater(), viewController: self, workingRangeSize: 0)
        adapater.dataSource = self
        return adapater
    }()
    
    // MARK: - View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        usersManager.delegate = self
        view.backgroundColor = .systemBackground
        navigationController?.navigationItem.largeTitleDisplayMode = .never
        navigationItem.largeTitleDisplayMode = .never
        navigationItem.title = "Settings"
        let doneButt = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(doneTapped))
        doneButt.isEnabled = false
        navigationItem.rightBarButtonItem = doneButt
        view.addSubview(settingsView)
        settingsView.delegate = self
        settingsView.snp.makeConstraints { (make) in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            make.left.right.equalTo(view)
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
        }
        adapter.collectionView = settingsView.collectionView
        setUpToHideKeyboardOnTapOnView()
        usersManager.fetchCurrentUser()

    }
    
    init() {
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Get Cells
    func getCells(user: Users) {
     
        let titleFont = UIFont.systemFont(ofSize: 14, weight: .semibold)
        
        let profilePicCell = SettingsCellViewModel(text: user.profilePhotoUrl, cellType: .profilePic)
        let nameTitle = SettingsCellViewModel(text: "\n \n \n Name", cellType: .text, textFont: titleFont)
        let nameTextViewCell = SettingsCellViewModel(text: user.name, cellType: .textField, maxCharCount: 100, placeholderText: "Name")
        let numberTitle = SettingsCellViewModel(text: "\n\n Phone Number", cellType: .text, textFont: titleFont)
        let numberTextFeildCell = SettingsCellViewModel(text: user.phoneNumber ?? " ", cellType: .textField, placeholderText: "Phone Number")
        
        cells = [profilePicCell,
                nameTitle,
                nameTextViewCell,
                numberTitle,
                numberTextFeildCell]
        adapter.performUpdates(animated: true, completion: nil)
    }
    
    private func verifyDoneButt() {
        navigationItem.rightBarButtonItem?.isEnabled = settingsController.nameChange || settingsController.numberChange || settingsController.profilePicChange
    }
    
    @objc private func doneTapped() {
        SVProgressHUD.show()
        settingsController.updateSettings() { result in
            switch result {
            case .completed(_):
                break
                
            case .error(let error):
                SVProgressHUD.showError(withStatus: "Error")
                print(error, "the settings error")
                
            case .success(let success):
                SVProgressHUD.showSuccess(withStatus: "Success!")
                print("success!!")
            }
        }
    }
  
}

// MARK: - List Adapter Datasource
extension SettingsViewController: ListAdapterDataSource {
    func objects(for listAdapter: ListAdapter) -> [ListDiffable] {
        return cells as [ListDiffable]
    }
    
    func listAdapter(_ listAdapter: ListAdapter, sectionControllerFor object: Any) -> ListSectionController {
        let settingsSection = SettingSectionController()
        settingsSection.delegate = self
        return settingsSection
    }
    
    func emptyView(for listAdapter: ListAdapter) -> UIView? {
        return nil
    }
    
}

// MARK: - Users Manager Delegate
extension SettingsViewController: UsersManagerDelegate {
    func showError(error: String) {
        
    }
    
    func setUsers(users: [Users]) {
        
    }
    
    func currentUser(user: Users) {
        getCells(user: user)
    }
}

// MARK: - Settings Delegate
extension SettingsViewController: SettingsDelegate {
    func changeProfilePic() {
        let imagePicker = ChitChatImagePicker(isSupportingBothMediaTypes: false)
        imagePicker.modalPresentationStyle = .fullScreen
        presentImagePicker(imagePicker,
                           select: nil,
                           deselect: nil,
                           cancel: nil,
                           finish: {[weak self] assets in
                            guard let asset = assets.first, let strongSelf = self else { return }
                            print("finished")
                            
                            strongSelf.assetManager.fetchPhoto(asset: asset) { (image) in
                                let cropViewController = CropViewController(croppingStyle: .circular, image: image)
                                cropViewController.delegate = self
                                strongSelf.present(cropViewController, animated: true, completion: nil)
                            }
                            
        })
    }
    
    func signOut() {
        SVProgressHUD.show(withStatus: "Signing Out")
        auth.signOut {[weak self] result in
            guard let strongSelf = self else { return }
            switch result {
            case .error(let errorMessage):
                SVProgressHUD.showError(withStatus: "Sign out error")

                
            case .success(()):
                SVProgressHUD.showSuccess(withStatus: "Signed Out")
                strongSelf.onSignOut?()
                
            default:
                break
            }
        }
    }
    
    func textFieldDidChange(textFieldType: SettingsTextFeildType, text: String?) {
        switch textFieldType {
        case .name:
            settingsController.nameChange = true
            settingsController.newName = text
          //  isNameTextFieldNil = text?.isEmpty ""
        case .number:
            settingsController.numberChange = true
            settingsController.newNumber = text
            isNumberTextFieldNil = text == ""
        }
        verifyDoneButt()
    }
}

// MARK: - CircleCrop Delegate
extension SettingsViewController: CropViewControllerDelegate {
    func cropViewController(_ cropViewController: CropViewController, didCropToCircularImage image: UIImage, withRect cropRect: CGRect, angle: Int) {
        guard let settingsSection = adapter.sectionController(forSection: 0) as? SettingSectionController,
            let imageData = image.jpegData(compressionQuality: 0.5) else { return }
        settingsSection.changeProfilePic(image: image)
        settingsController.profilePicChange = true
        settingsController.newImageData = imageData
        verifyDoneButt()
        cropViewController.dismiss(animated: true, completion: nil)
    }
}
