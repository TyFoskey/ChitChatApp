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

class SettingsViewController: UIViewController {
    
    // MARK: - Properties
  
    let settingsView = SettingsView()
    var onSignOut: (()-> Void)?
    let assetManager = AssetManager()
    let settingsController = SettingsModelController(dataFetcher: DataFetcher())
    var isNumberTextFieldNil = false
    var isNameTextFieldNil = false

    
    lazy var adapter: ListAdapter = {
        let adapater = ListAdapter(updater: ListAdapterUpdater(), viewController: self, workingRangeSize: 0)
        adapater.dataSource = self
        return adapater
    }()
    
    // MARK: - View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        navigationController?.navigationItem.largeTitleDisplayMode = .never
        navigationItem.largeTitleDisplayMode = .never
        navigationItem.title = "Settings"
        let doneButt = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(doneTapped))
        doneButt.isEnabled = false
        navigationItem.rightBarButtonItem = doneButt
        view.addSubview(settingsView)
        settingsView.snp.makeConstraints { (make) in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            make.left.right.equalTo(view)
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
        }
        adapter.collectionView = settingsView.collectionView
        setUpToHideKeyboardOnTapOnView()

    }
    
    init() {
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Get Cells
    func getCells() -> [SettingsCellViewModel] {
     
        let titleFont = UIFont.systemFont(ofSize: 14, weight: .semibold)
        
        let profilePicCell = SettingsCellViewModel(text: "", cellType: .profilePic)
        let nameTitle = SettingsCellViewModel(text: "\n \n \n Name", cellType: .text, textFont: titleFont)
        let nameTextViewCell = SettingsCellViewModel(text: "Tyler Fort-Foskey", cellType: .textField, maxCharCount: 100, placeholderText: "Name")
        let numberTitle = SettingsCellViewModel(text: "\n\n Phone Number", cellType: .text, textFont: titleFont)
        let numberTextFeildCell = SettingsCellViewModel(text: " ", cellType: .textField, placeholderText: "Phone Number")
        
        return [profilePicCell,
                nameTitle,
                nameTextViewCell,
                numberTitle,
                numberTextFeildCell]
    }
    
    private func verifyDoneButt() {
        navigationItem.rightBarButtonItem?.isEnabled = isNumberTextFieldNil == false && isNameTextFieldNil == false
    }
    
    @objc private func doneTapped() {
        
    }
  
}

// MARK: - List Adapter Datasource
extension SettingsViewController: ListAdapterDataSource {
    func objects(for listAdapter: ListAdapter) -> [ListDiffable] {
        return getCells() as [ListDiffable]
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
        onSignOut?()
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
