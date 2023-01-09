//
//  Redemption + Extension.swift
//  AlMeezan
//
//  Created by Atta khan on 28/12/2022.
//  Copyright © 2022 Atta khan. All rights reserved.
//

import Foundation
import SwiftKeychainWrapper
import Photos
import SVProgressHUD

extension RedemptionVC {
    
    func createDataBody(withParameters params: [String: String]?, media: [Media]?, boundary: String) -> Data {
        let lineBreak = "\r\n"
        var body = Data()
        if let parameters = params {
            for (key, value) in parameters {
                body.append("--\(boundary + lineBreak)")
                body.append("Content-Disposition: form-data; name=\"\(key)\"\(lineBreak + lineBreak)")
                body.append("\(value as! String + lineBreak)")
            }
        }
        if let media = media {
            for photo in media {
                print(photo.filename)
                body.append("--\(boundary + lineBreak)")
                body.append("Content-Disposition: form-data; name=\"\(photo.key)\"; filename=\"\(photo.filename)\"\(lineBreak)")
                body.append("Content-Type: \(photo.mimeType + lineBreak + lineBreak)")
                body.append(photo.data)
                body.append(lineBreak)
            }
        }
        body.append("--\(boundary)--\(lineBreak)")
        return body
    }
    func uploadImageToServer() {
        SVProgressHUD.show()
        let CustomerID = KeychainWrapper.standard.string(forKey: "CustomerId")!
        let AccessToken = KeychainWrapper.standard.string(forKey: "AccessToken")!
        
        let parameters = [
            "CustomerID"  : CustomerID,
            "AccessToken" : AccessToken,
            "Tax1-Year": tax1Year,
            "Tax2-Year" : tax2Year,
            "Tax3-Year" : tax3Year,
        ]

        guard let url = URL(string: BASE_URL + "vpstaxdocumentsubmit") else { return }
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        //create boundary
        let boundary = generateBoundary()
        //set content type
        request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
        //call createDataBody method
        let dataBody = createDataBody(withParameters: parameters, media: media, boundary: boundary)
        request.httpBody = dataBody
        let sessionConfig = URLSessionConfiguration.default
        sessionConfig.timeoutIntervalForRequest = 60.0
        let session = URLSession(configuration: sessionConfig)
        
        
        session.dataTask(with: request) { (data, response, error) in
            SVProgressHUD.dismiss()
            if let response = response {
                print(response)
            }
            guard let data = data, let responseString = String.init(data: data, encoding: String.Encoding.utf8) else {
                return
            }
            print(responseString)
            let value = responseString.replacingOccurrences(of: "\"", with: "")
            if let str = self.container.createDecryptionManger().decrypt(with: value) {
                self.container.createCodeableManger().decodeArray(str, isCaching: false) { (dataResult: [MTPFDocumentUploadModel] ) in
                    print(dataResult)
                    if let uniqueId = dataResult[0].uniqueId {
                        self.documentUniqueId = uniqueId
                    }
                }
            }
            
            
        }.resume()
    }
    
    func generateBoundary() -> String {
        return "Boundary-\(NSUUID().uuidString)"
    }
    
    public override func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        print("Cancel")
        imagePicker.dismiss(animated: true, completion: nil)
    }
    
    override func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        imagePicker.dismiss(animated: true, completion: nil)
        image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage
        
        if let asset = info[UIImagePickerController.InfoKey(rawValue: "UIImagePickerControllerPHAsset") ] as? PHAsset {
            if let fileName = asset.value(forKey: "filename") as? String{
                self.fileName = fileName
            }
        }
        
        if image != nil {
            imageUploading = vpsTax[imageUploadingIndex].key ?? ""
            if media.count > 0 {
                if let index = media.firstIndex(where: { $0.key == imageUploading}) {
                    media.remove(at: index)
                }
            }
            if let med = Media(withImage: image!, forKey: imageUploading, fileName: imageUploading + ".jpg") {
                media.append(med)
            }
            print("uploading image array , = \(media)")
            
            
            vpsTax[imageUploadingIndex].isExpandable = true
            let indexPath = IndexPath(row: imageUploadingIndex, section: 0)
            let cell = tableView.cellForRow(at: indexPath) as? DocuemntUploadingCell
            cell?.uplaodingView.isHidden = true
            tableView.reloadRows(at: [indexPath], with: .automatic)
            let count = vpsTax.filter{ $0.isExpandable == true }.count
            tableViewHeightConstraint.constant = (CGFloat(vpsTax.count) * rowHeight ) + (CGFloat( count ) * rowHeight)
            
        }
        
    }
    
    
    func uploadSheet() {
        imagePicker =  UIImagePickerController()
        let optionMenu = UIAlertController(title: "Choose Your Option", message: nil, preferredStyle: UIAlertController.Style.actionSheet)
        
        let option1 = UIAlertAction(title: "Camera", style: .default, handler: {
            (alert: UIAlertAction!) -> Void in
            self.openCamera()
        })
        
        let option2 = UIAlertAction(title: "Photo Library ", style: .default, handler: {
            (alert: UIAlertAction!) -> Void in
            self.openGallary()
        })
        
//        let documentUpload = UIAlertAction(title: "Documents", style: .default, handler: {
//            (alert: UIAlertAction!) -> Void in
//            self.openGallary()
//        })
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: {
            (alert: UIAlertAction!) -> Void in
            print("Cancelled")
        })
        
        optionMenu.addAction(option1)
        optionMenu.addAction(option2)
//        optionMenu.addAction(documentUpload)
        optionMenu.addAction(cancelAction)
        
        self.present(optionMenu, animated: true, completion: nil)
        return
    }
    
    func openCamera() {
        imagePicker =  UIImagePickerController()
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerController.SourceType.camera) {
            imagePicker.delegate = self
            self.imagePicker.sourceType = UIImagePickerController.SourceType.camera
            imagePicker.allowsEditing = true
            self.present(self.imagePicker, animated: true, completion: nil)
        }
        else {
            let alertWarning = UIAlertView(title:"Warning", message: "You don't have camera", delegate:nil, cancelButtonTitle:"OK")
            alertWarning.show()
        }
    }
    
    func openDocument() {
        let importMenu = UIDocumentMenuViewController(documentTypes: [String()], in: .import)
        importMenu.delegate = self
        self.present(importMenu, animated: true, completion: nil)
    }
    
    func openGallary() {
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerController.SourceType.photoLibrary) {
            imagePicker.delegate = self
            imagePicker.sourceType = UIImagePickerController.SourceType.photoLibrary
            imagePicker.allowsEditing = true
            self.present(imagePicker, animated: true, completion: nil)
        }
    }
}

// MARK: - DOCUMENT PICKER VIEW DELEGATE

extension RedemptionVC : UIDocumentPickerDelegate {
    
    func documentMenu(_ documentMenu: UIDocumentPickerViewController, didPickDocumentPicker documentPicker: UIDocumentPickerViewController) {
        documentPicker.delegate = self
        self.present(documentPicker, animated: true, completion: nil)
    }
    
    func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentAt url: URL) {
        print("url = \(url)")
    }
    
    func documentPickerWasCancelled(_ controller: UIDocumentPickerViewController) {
        dismiss(animated: true, completion: nil)
    }
}
// MARK: - SCROLLVIEW DELEGATE

extension RedemptionVC: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        tipView.dismiss()
    }
}

// MARK: - TEXT FIELD DELEGATE

extension RedemptionVC: UITextFieldDelegate {
    
    
    func textFieldDidChangeSelection(_ textField: UITextField) {
        convertCurrencyIntoWord(textField.text!)
    }
    
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        var message = ""
        var actualValue = 0.0
        if selectedSegmentIndex == 0 {
            message = "Amount Exceeds the available amount."
            actualValue = self.funds_list?[self.selectedFundFromId].marketValue ?? 0.0
        } else if selectedSegmentIndex == 1 {
            message = "Units Exceeds the available units."
            actualValue = Double(self.funds_list?[self.selectedFundFromId].balunits ?? 0.0)
        } else if selectedSegmentIndex == 3 {
            message = "Amount Exceeds the available amount."
            if self.redemptionMTPF?.count ?? 0 > 0 {
                actualValue = self.redemptionMTPF?[0].bal ?? 0.0
            }
        }
        let newStr = (textField.text! as NSString)
            .replacingCharacters(in: range, with: string)
        let amount: Double? = Double(newStr.filter("0123456789.".contains))
        
        if let value = amount {
            if value > actualValue {
                self.showAlert(title: "Alert", message: message, controller: self) {
                    //return false
                }
            }
        }
        return true
    }
}

// MARK: - PICKER VIEW DELEGATE & DATA SOURCE

extension RedemptionVC: UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if pickerView.tag == 1 {
            return funds_list?.count ?? 0
        } else {
            return portfolioid_list?.count ?? 0
        }
        
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if pickerView.tag == 1 {
            return funds_list?[row].fundAgentName
        } else {
            return portfolioid_list?[row].portfolioID
        }
        
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if pickerView.tag == 1 {
            fundFromTxtField.text = funds_list?[row].fundAgentName
            selectedFundFromId = row
        } else {
            portfolioTxtField.text = portfolioid_list?[row].portfolioID
            selectedPortfolioId = row
        }
        
    }
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        var title = UILabel()
        if let titleLbl = view {
            title = titleLbl as! UILabel
        }
        title.font = UIFont(name: "Roboto-Regular", size: pickerTitleFontSize)
        if pickerView.tag == 1 {
            title.text = funds_list?[row].fundAgentName
        } else {
            title.text =  portfolioid_list?[row].portfolioID
        }
        
        title.textAlignment = .center
        return title
    }
}



struct Media {
    let key: String
    let filename: String
    let data: Data
    let mimeType: String
    init?(withImage image: UIImage, forKey key: String, fileName: String) {
        self.key = key
        self.mimeType = "image/jpeg"
        self.filename = fileName
        guard let data = image.jpegData(compressionQuality: 0.7) else { return nil }
        self.data = data
    }
}



struct MTPFDocumentUploadModel : Codable {
    let uniqueId : String?
    enum CodingKeys: String, CodingKey {
        case uniqueId = "uniqueId"
    }
}
