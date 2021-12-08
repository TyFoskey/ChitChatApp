//
//  SettingsSectionController.swift
//  ChitChat
//
//  Created by ty foskey on 9/26/20.
//  Copyright © 2020 ty foskey. All rights reserved.
//

import IGListKit

class SettingSectionController: ListSectionController {
    
    var settingViewModel: SettingsCellViewModel!
    weak var delegate: SettingsDelegate?
    
    override func didUpdate(to object: Any) {
        settingViewModel = object as? SettingsCellViewModel
        inset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }
    
    override func numberOfItems() -> Int {
        return 1
    }
    
    override func sizeForItem(at index: Int) -> CGSize {
        return CGSize(width: collectionContext!.containerSize.width, height: settingViewModel.cellHeight)
    }
    
    override func cellForItem(at index: Int) -> UICollectionViewCell {
        
        switch settingViewModel.cellType {
  
        case .profilePic:
            let cell = collectionContext!.dequeueReusableCell(of: ChangeProfilePicCell.self, for: self, at: index) as! ChangeProfilePicCell
            cell.profilePicImageView.backgroundColor = .secondaryLabel
            cell.profileUrl = settingViewModel.text
            cell.delegate = self
            return cell
            
            
        case .textField:
            let cell = collectionContext!.dequeueReusableCell(of: TextFieldCell.self, for: self, at: index) as! TextFieldCell
            if settingViewModel.text != " " {
                cell.textField.text = settingViewModel.text
            }
            cell.textField.addTarget(self, action: #selector(textFieldDidChange(textField:)), for: .editingChanged)
            cell.textField.placeholder = settingViewModel.placeholderText
            return cell
            
        case .text:
            let cell = collectionContext!.dequeueReusableCell(of: TextCell.self, for: self, at: index) as! TextCell
            cell.textLabel.text = settingViewModel.text
            cell.textLabel.font = settingViewModel.textFont ?? UIFont.systemFont(ofSize: 13.5, weight: .medium)
            return cell
        
        }
    }
    
    func changeProfilePic(image: UIImage) {
        guard let cell = collectionContext?.cellForItem(at: 0, sectionController: self) as? ChangeProfilePicCell else { return }
        cell.profilePicImageView.image = image
    }
}

extension SettingSectionController: SettingsDelegate {
    func changeProfilePic() {
        delegate?.changeProfilePic()
    }
    
    func textFieldDidChange(textFieldType: SettingsTextFeildType, text: String?) {
        
    }
    
    func signOut() {
        
    }

}

// MARK: - TextField Action
extension SettingSectionController {
    @objc func textFieldDidChange(textField: UITextField) {
        
        let cell = collectionContext!.cellForItem(at: 0, sectionController: self) as! TextFieldCell
        let type: SettingsTextFeildType = (settingViewModel.placeholderText == "Name") ? .name : .number
        delegate?.textFieldDidChange(textFieldType: type, text: textField.text)
        
        
        guard let maxCharCount = settingViewModel.maxCharCount, let count = textField.text?.count, count > maxCharCount else {
            cell.wordCountLabel.isHidden = true
            cell.textField.textColor = .label
            return
        }
        
        cell.wordCountLabel.isHidden = false
        cell.wordCountLabel.text = "\(textField.text!.count)/\(maxCharCount)"
        cell.wordCountLabel.textColor = .red
        cell.textField.textColor = .red
        
    }

}
