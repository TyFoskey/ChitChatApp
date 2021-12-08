//
//  RegisterProfilePicViewController.swift
//  ChitChat
//
//  Created by ty foskey on 9/15/20.
//  Copyright © 2020 ty foskey. All rights reserved.
//

import UIKit
import SnapKit
import BSImagePicker
import CropViewController

class RegisterProfilePicViewController: UIViewController {
    
    let registerProfileView = RegisterProfilePicView()
    let assetManager = AssetManager()
    var onBottomButtTap: ((UIImage) -> Void)?
    var onGoToCreateProfile: ((SignInRegistrationType) -> Void)?
    var onChangeProfilePicTap: (() -> Void)?
    var isImageLoaded = false
    let name: String?
    let id: String?
   
    
    // MARK: - View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setView()
    }
    
    
    // MARK: - Set View
    
    private func setView() {
        self.navigationItem.setHidesBackButton(true, animated: true)
        view.backgroundColor = .systemBackground
        view.addSubview(registerProfileView)
        addCustomBackButton()
        registerProfileView.snp.makeConstraints { (make) in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.topMargin)
            make.left.right.equalTo(view)
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottomMargin)
        }
        registerProfileView.delegate = self
    }
    
    // MARK: - Init
    init(name: String?, id: String?) {
        self.name = name
        self.id = id
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}

// MARK: - Register ProfilePic Delegate
extension RegisterProfilePicViewController: RegisterProfilePicDelegate {
    func changePic() {
        print("change pic")
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
    
    func bottomButtTapped() {
        print("bottom but tapped")
        guard let image = registerProfileView.profilePicImageView.image else { return }
        if name != nil, let imageData = image.jpegData(compressionQuality: 0.5) {
            // go to verification sign in
            onGoToCreateProfile?(.createProfile(id!, name!, imageData))
        } else {
            onBottomButtTap?(image)
        }
    }
    
}

// MARK: - CircleCrop Delegate
extension RegisterProfilePicViewController: CropViewControllerDelegate {
    func cropViewController(_ cropViewController: CropViewController, didCropToCircularImage image: UIImage, withRect cropRect: CGRect, angle: Int) {
        if isImageLoaded == false {
            registerProfileView.bottomButt.isValid()
            registerProfileView.changePicButt.setTitle("Change Profile Photo", for: .normal)
            isImageLoaded = true
        }
        registerProfileView.profilePicImageView.image = image
        cropViewController.dismiss(animated: true, completion: nil)
    }
}

