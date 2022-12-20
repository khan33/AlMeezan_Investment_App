//
//  DocumentUploadVC.swift
//  AlMeezan
//
//  Created by Atta khan on 30/01/2022.
//  Copyright © 2022 Atta khan. All rights reserved.
//

import UIKit

class DocumentUploadVC: UIViewController {
    private (set) lazy var headerView: HeaderView = { [unowned self] in
        let view = HeaderView.init(stepValue: "6 / 9", titleStr: "Document Upload", subTitle: "Document Upload", numberOfPages: 0, currentPageNo: 0, closeAction: {
            self.navigationController?.popViewController(animated: true)
        }, nextAction: {
            print("next")
        }, previousAction: {
            self.navigationController?.popViewController(animated: true)
        })
        view.translatesAutoresizingMaskIntoConstraints = false
        view.previousBtn.isHidden = true
        view.nextBtn.isHidden = true
        view.lblStep.isHidden = true
        return view
    }()
    
    private (set) lazy var containerView: UIView = { [unowned self] in
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.clipsToBounds = true
        //view.backgroundColor = .white
        return view
    }()
    
    private (set) lazy var scrollView: UIScrollView = { [unowned self] in
        let view = UIScrollView()
        view.showsVerticalScrollIndicator = true
        view.translatesAutoresizingMaskIntoConstraints = false
        view.clipsToBounds = true
        return view
    }()
    
    private (set) lazy var contentView: UIView = { [unowned self] in
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.clipsToBounds = true
        return view
    }()
    
    private (set) lazy var stackView: UIStackView = { [unowned self] in
        let view = UIStackView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.distribution = .equalSpacing
        view.alignment = .fill
        view.axis = .vertical
        view.spacing = 24
        view.clipsToBounds = true
        return view
    }()
    
    private (set) lazy var disclaimerLbl: UILabel = { [unowned self] in
        var label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor =  UIColor.themeColor
        label.font = UIFont(name: AppFontName.robotoMedium, size: 12)
        label.text = "File size should be less than 1MB (JPG & PNG supported)."
        return label
    }()
    
    private (set) lazy var signatureCardLbl: UILabel = { [unowned self] in
        var label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor =  UIColor.themeColor
        label.font = UIFont(name: AppFontName.robotoMedium, size: 12)
        label.text = "Take a blank paper and sign your name and upload it."
        return label
    }()
    private (set) lazy var downloadLbl: UILabel = { [unowned self] in
        var label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor =  UIColor.themeColor
        label.font = UIFont(name: AppFontName.robotoMedium, size: 12)
        label.text = "Download the Health Declaration Form and upload a signed copy."
        label.numberOfLines = 0
        return label
    }()
    
    private (set) lazy var downloadIncomeLbl: UILabel = { [unowned self] in
        var label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor =  UIColor.themeColor
        label.font = UIFont(name: AppFontName.robotoMedium, size: 12)
        label.numberOfLines = 0
        label.text = "Download the Source of Income Declaration Form and upload a signed copy."
        return label
    }()
    
    private (set) lazy var downloadW9FromLbl: UILabel = { [unowned self] in
        var label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor =  UIColor.themeColor
        label.font = UIFont(name: AppFontName.robotoMedium, size: 12)
        label.numberOfLines = 0
        label.text = "Download the W9-Form and upload a filled copy."
        return label
    }()
    
    private (set) lazy var downloadW9FromJointLbl: UILabel = { [unowned self] in
        var label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor =  UIColor.themeColor
        label.font = UIFont(name: AppFontName.robotoMedium, size: 12)
        label.numberOfLines = 0
        label.text = "Download the W9-Form and upload a filled copy."
        return label
    }()
    
    private (set) lazy var incomeDocumentLbl: UILabel = { [unowned self] in
        var label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor =  UIColor.themeColor
        label.font = UIFont(name: AppFontName.robotoMedium, size: 16)
        label.text = ""
        return label
    }()
    
    
    var imagePicker: UIImagePickerController!
    var image: UIImage? = UIImage()
    
    
    
    // Principal Documents Views
    
    var CNICFrontPrincipalView: DocumentView!
    var CNICFrontPrincipalUploadView: UploadView!
    var isCNICFrontPrincipal: Bool = false

    var CNICBackPrincipalView: DocumentView!
    var CNICBackPrincipalUploadView: UploadView!
    var isCNICBackPrincipal:  Bool = false
    
    var signaturePrincipalView: DocumentView!
    var signaturePrincipalUploadView: UploadView!
    var issignaturePrincipal:  Bool = false
    
    
    // Simowner Docuemnts Views
    // MObile bill, Affidavite, CNIC front, back
    
    var CNICFrontSimOwnerView: DocumentView!
    var CNICFrontSimOwnerUploadView: UploadView!
    var isSimOwnerFront: Bool = false

    var CNICBackSimOwnerView: DocumentView!
    var CNICBackSimOwnerUploadView: UploadView!
    var isSimOwnerBack: Bool = false

    
    var CompanyMobileBillView: DocumentView!
    var CompanyMobileBillUploadView: UploadView!
    var isCompanybill: Bool = false

    
    var AffidavitSimOwnerView: DocumentView!
    var AffidavitSimOwnerUploadView: UploadView!
    var isAffdivit: Bool = false
    
    // Zakat Docuemnt View
    var ZakatDeclarationView: DocumentView!
    var ZakatDeclarationUploadView: UploadView!
    var isuploadZakat:  Bool = false


    // Health Docuemnt View
    var healthDeclarationView: DocumentView!
    var healthDeclarationUploadView: UploadView!
    var ishealthDeclaration:  Bool = false


    // Joint Documents Views
    //  JOint front, back, sign
    var CNICFrontJointView: DocumentView!
    var CNICFrontJointUploadView: UploadView!
    var isCNICFrontJoint:  Bool = false
    
    var CNICBackJointView: DocumentView!
    var CNICBackJointUploadView: UploadView!
    var isCNICBackJoint:  Bool = false
    
    var SignatureCardJointView: DocumentView!
    var SignatureCardJointUploadView: UploadView!
    var isSignatureCardJoint:  Bool = false
    
    
    
    // Source OF Income Views
    // source of income, decleartion, Cnic fornt/back for student/house wife
    var sourceOfIncomeView: DocumentView!
    var sourceOfIncomeUploadView: UploadView!
    var isSourceOfIncome: Bool = false

    var incomeDeclarationView: DocumentView!
    var incomeDeclarationUploadView: UploadView!
    var isIncomeDeclaration: Bool = false
    
    // IN case Student/house wife
    var fundSupporterCNICFrontView: DocumentView!
    var fundSupporterCNIVFrontUploadView: UploadView!
    var isFundSupporterCNICFornt: Bool = false
    
    var fundSupporterCNICBackView: DocumentView!
    var fundSupporterCNIVBackUploadView: UploadView!
    var isFundSupporterCNICBack: Bool = false
    
    
    // W9 Form
    // joint/pricpal

    // Live Photo
    var uploadPhoto: DocumentView!
    var uploadLivePhotoView: UploadView!
    var isuploadLivePhoto:  Bool = false

    
   
    // W9 From Views
    var w9fromView: DocumentView!
    var w9fromUploadView: UploadView!
    var isw9from: Bool = false
    var jointW9fromView: DocumentView!
    var jointW9fromUploadView: UploadView!
    var isW9fromJoint: Bool = false
   
    var jointAccount = ""
    var health_dec = ""
    var accountType: String = "BOTH"
    var cnicTxt: String = ""
    var filePathKey: DocumentType = .PrincipalCnicFront
    let decryptObj = DecryptionHelper()
    let w9From = UserDefaults.standard.bool(forKey: "W9Form") ?? false
    let w9JointForm = UserDefaults.standard.bool(forKey: "W9JointForm") ?? false
    
    var onlineAccountType: String = OnlineAccountType.SSA.rawValue

    
    override func viewDidLoad() {
        super.viewDidLoad()

        if let _ = Constant.health_dec {
            health_dec = "Yes"
        }
        if let name = Constant.joint_account?.fullName, name != "" {
            jointAccount = "Yes"
        }
        self.view.backgroundColor = .white
        if let account = UserDefaults.standard.string(forKey: "OnlineAccountType") {
            onlineAccountType = account
        }
        setupViews()
    }
    override func viewDidAppear(_ animated: Bool) {
        
    }
   
    
    
    private func createBody(with parameters: [String: String]? = nil, filePathKey: String, imageDataKey: NSData, boundary: String) throws -> Data {
        var body = Data()
        let mimeType = "image/jpg"

        parameters?.forEach { (key, value) in
            body.append("--\(boundary)\r\n")
            body.append("Content-Disposition: form-data; name=\"\(key)\"\r\n\r\n")
            body.append("\(value)\r\n")
        }
        let filename = "\(filePathKey).jpg"
        body.append("--\(boundary)\r\n")
        body.append("Content-Disposition: form-data; name=\"\(filePathKey)\"; filename=\"\(filename)\"\r\n")
        body.append("Content-Type: \(mimeType)\r\n\r\n")
        body.append(imageDataKey as Data)
        body.append("\r\n")
        body.append("--\(boundary)--\r\n")
        return body
    }
    
    func createRequest() throws -> URLRequest? {
        let parameters = [
            "AccountType"  : self.accountType,
            "CnicNo"    : self.cnicTxt,
        ]  // build your dictionary however appropriate
        
        let boundary = generateBoundaryString()
        
        let url = URL(string: "\(BASE_URL)DocumentUpload")!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
        let capturedImage = self.image
        let imageData: NSData! = capturedImage?.jpegData(compressionQuality: 0.25) as! NSData
        var imageSize: Double = Double(imageData.count) / 1000.0
        
        if imageSize > 1024.0 {
            self.showAlert(title: "Alert", message: "File size should be less than 1 MB.(JPG & PNG are supported).", controller: self) {
                //self.nameView.txt.becomeFirstResponder()
            }
            return nil
        }
        
        showLoader()
        request.httpBody = try createBody(with: parameters, filePathKey: self.filePathKey.rawValue, imageDataKey: imageData as NSData, boundary: boundary)
        
        return request
    }
    private func generateBoundaryString() -> String {
        return "Boundary-\(UUID().uuidString)"
    }
    
    public override func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        print("Cancel")
        imagePicker.dismiss(animated: true, completion: nil)
    }

    override func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        imagePicker.dismiss(animated: true, completion: nil)
        image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage
        
        
        do {
            if let request = try createRequest() {
                let task = URLSession.shared.dataTask(with: request as URLRequest) {
                    data, response, error in
                    self.hideLoader()
                    if error != nil {
                        print("error=\(String(describing: error))")
                        return
                    }
                    print("******* response = \(String(describing: response))")
                    let responseString = NSString(data: data!, encoding: String.Encoding.utf8.rawValue)
                    print("****** response data = \(responseString!)")
                    let string = (responseString as! String).replacingOccurrences(of: "\"", with: "")
                    if let decrptyData = self.decryptObj.decrypt(with: string) {
                        print(decrptyData)
                        let _ = CodableHelper().decodeArray(decrptyData, isCaching: false) { (dataResult: [SubmissionResponse] ) in
                            print(dataResult)
                            DispatchQueue.main.async {
                                if dataResult.count > 0 {
                                    if dataResult[0].errID == "00" {
                                        switch self.filePathKey {
                                        case .PrincipalCnicFront:
                                            self.isCNICFrontPrincipal = true
                                            self.CNICFrontPrincipalUploadView.isHidden = false
                                            self.CNICFrontPrincipalUploadView.uploadImageView.contentMode = .scaleAspectFill
                                            self.CNICFrontPrincipalUploadView.uploadImageView.image = self.image
                                        case .PrincipalCnicBack:
                                            self.isCNICBackPrincipal = true
                                            self.CNICBackPrincipalUploadView.isHidden = false
                                            self.CNICBackPrincipalUploadView.uploadImageView.contentMode = .scaleAspectFill
                                            self.CNICBackPrincipalUploadView.uploadImageView.image = self.image
                                        case .SignCard:
                                            self.issignaturePrincipal = true
                                            self.signaturePrincipalUploadView.isHidden = false
                                            self.signaturePrincipalUploadView.uploadImageView.contentMode = .scaleAspectFill
                                            self.signaturePrincipalUploadView.uploadImageView.image = self.image
                                        case .JointHolderCnicFront:
                                            self.isCNICFrontJoint = true
                                            self.CNICFrontJointUploadView.isHidden = false
                                            self.CNICFrontJointUploadView.uploadImageView.contentMode = .scaleAspectFill
                                            self.CNICFrontJointUploadView.uploadImageView.image = self.image
                                        case .JointHolderCnicBack:
                                            self.isCNICBackJoint = true
                                            self.CNICBackJointUploadView.isHidden = false
                                            self.CNICBackJointUploadView.uploadImageView.contentMode = .scaleAspectFill
                                            self.CNICBackJointUploadView.uploadImageView.image = self.image
                                        case .JointHolderSignCard:
                                            self.isSignatureCardJoint = true
                                            self.SignatureCardJointUploadView.isHidden = false
                                            self.SignatureCardJointUploadView.uploadImageView.contentMode = .scaleAspectFill
                                            self.SignatureCardJointUploadView.uploadImageView.image = self.image
                                        case .HealthDeclaration:
                                            self.ishealthDeclaration = true
                                            self.healthDeclarationUploadView.isHidden = false
                                            self.healthDeclarationUploadView.uploadImageView.contentMode = .scaleAspectFill
                                            self.healthDeclarationUploadView.uploadImageView.image = self.image
                                        case .LivePhoto:
                                            self.isuploadLivePhoto = true
                                            self.uploadLivePhotoView.isHidden = false
                                            self.uploadLivePhotoView.uploadImageView.contentMode = .scaleAspectFill
                                            self.uploadLivePhotoView.uploadImageView.image = self.image
                                        case .ZakatDeclaration:
                                            self.isuploadZakat = true
                                            self.ZakatDeclarationUploadView.isHidden = false
                                            self.ZakatDeclarationUploadView.uploadImageView.contentMode = .scaleAspectFill
                                            self.ZakatDeclarationUploadView.uploadImageView.image = self.image
                                        case .SimOwnerCnicFront:
                                            self.CNICFrontSimOwnerUploadView.isHidden = false
                                            self.CNICFrontSimOwnerUploadView.uploadImageView.contentMode = .scaleAspectFit
                                            self.CNICFrontSimOwnerUploadView.uploadImageView.image = self.image
                                            self.isSimOwnerFront = true
                                        case .SimOwnerCnicBack:
                                            self.isSimOwnerBack = true
                                            self.CNICBackSimOwnerUploadView.isHidden = false
                                            self.CNICBackSimOwnerUploadView.uploadImageView.contentMode = .scaleAspectFit
                                            self.CNICBackSimOwnerUploadView.uploadImageView.image = self.image
                                        case .Affidavite:
                                            self.isAffdivit = true
                                            self.AffidavitSimOwnerUploadView.isHidden = false
                                            self.AffidavitSimOwnerUploadView.uploadImageView.contentMode = .scaleAspectFit
                                            self.AffidavitSimOwnerUploadView.uploadImageView.image = self.image
                                        case .MobileBill:
                                            self.isCompanybill = true
                                            self.CompanyMobileBillUploadView.isHidden = false
                                            self.CompanyMobileBillUploadView.uploadImageView.contentMode = .scaleAspectFit
                                            self.CompanyMobileBillUploadView.uploadImageView.image = self.image
                                        case .SourceOfIncome:
                                            self.isSourceOfIncome = true
                                            self.sourceOfIncomeUploadView.isHidden = false
                                            self.sourceOfIncomeUploadView.uploadImageView.contentMode = .scaleAspectFill
                                            self.sourceOfIncomeUploadView.uploadImageView.image = self.image
                                        case .FundSupporterDec:
                                            self.isIncomeDeclaration = true
                                            self.incomeDeclarationUploadView.isHidden = false
                                            self.incomeDeclarationUploadView.uploadImageView.contentMode = .scaleAspectFill
                                            self.incomeDeclarationUploadView.uploadImageView.image = self.image
                                        case .FundSupporterCnicFront:
                                            self.isFundSupporterCNICFornt = true
                                            self.fundSupporterCNIVFrontUploadView.isHidden = false
                                            self.fundSupporterCNIVFrontUploadView.uploadImageView.contentMode = .scaleAspectFill
                                            self.fundSupporterCNIVFrontUploadView.uploadImageView.image = self.image
                                        case .FundSupporterCnicBack:
                                            self.isFundSupporterCNICBack = true
                                            self.fundSupporterCNIVBackUploadView.isHidden = false
                                            self.fundSupporterCNIVBackUploadView.uploadImageView.contentMode = .scaleAspectFill
                                            self.fundSupporterCNIVBackUploadView.uploadImageView.image = self.image
                                        case .W9Form:
                                            self.isw9from = true
                                            self.w9fromUploadView.isHidden = false
                                            self.w9fromUploadView.uploadImageView.contentMode = .scaleAspectFill
                                            self.w9fromUploadView.uploadImageView.image = self.image
                                        case .W9FormForJoint:
                                            self.isW9fromJoint = true
                                            self.jointW9fromUploadView.isHidden = false
                                            self.jointW9fromUploadView.uploadImageView.contentMode = .scaleAspectFill
                                            self.jointW9fromUploadView.uploadImageView.image = self.image
                                        default:
                                            break
                                        }
                                        self.showAlert(title: "Alert", message: "File uploaded successfully!", controller: self) {
                                            
                                        }
                                        return
                                    } else {
                                        self.showAlert(title: "Alert", message: "File not uploading please try again!", controller: self) {
                                        }
                                        return
                                    }
                                }
                            }
                        }
                    }
                  
                }
                task.resume()
            }
        } catch {
            print("")
        }
    }
    @objc func tappedOnLabel(_ gesture: UITapGestureRecognizer) {
        guard let text = self.healthDeclarationView.lblHeading.text else { return }
        openLink("https://members.almeezangroup.com/healthDeclarationForm.aspx?CNIC=\(cnicTxt)") //2323232323232
    }
    @objc func tappedOnFundSupporterLabel(_ gesture: UITapGestureRecognizer) {
        guard let text = self.incomeDeclarationView.lblHeading.text else { return }
        openLink("https://members.almeezangroup.com/FundSupportDeclaration.aspx?CNIC=\(cnicTxt)") //1313131313134
    }
    
    
    @objc func tappedOnW9FormLabel(_ gesture: UITapGestureRecognizer) {
        guard let text = self.w9fromView.lblHeading.text else { return }
        openLink("https://members.almeezangroup.com/Document/Form_W_9.pdf")
    }
    
    
    @objc func tappedOnW9FormJointLabel(_ gesture: UITapGestureRecognizer) {
        guard let text = self.jointW9fromView.lblHeading.text else { return }
        openLink("https://members.almeezangroup.com/Document/Form_W_9.pdf")
    }
    
    
    private func openLink(_ url: String) {
        let appURL = URL(string: url)!
        if #available(iOS 10.0, *) {
            UIApplication.shared.open(appURL, options: [:], completionHandler: nil)
        } else {
            UIApplication.shared.openURL(appURL)
        }
    }
}

extension DocumentUploadVC {
    
    fileprivate func setupViews() {
        
        cnicTxt = UserDefaults.standard.string(forKey: "CNIC") ?? ""
        accountType = UserDefaults.standard.string(forKey: "accountType") ?? "BOTH"
        
        if !headerView.isDescendant(of: self.view) {
            self.view.addSubview(headerView)
        }
        headerView.topAnchor.constraint(equalTo: self.view.topAnchor).isActive = true
        headerView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor).isActive = true
        headerView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor).isActive = true
        headerView.heightAnchor.constraint(equalToConstant: 124.0).isActive = true
       
        if !containerView.isDescendant(of: self.view) {
            self.view.addSubview(containerView)
        }
        
        containerView.topAnchor.constraint(equalTo: headerView.bottomAnchor, constant: 16).isActive = true
        containerView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 16).isActive = true
        containerView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -16).isActive = true
        containerView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: -16).isActive = true
        

        if !scrollView.isDescendant(of: containerView) {
            containerView.addSubview(scrollView)
        }

        scrollView.topAnchor.constraint(equalTo: self.containerView.topAnchor).isActive = true
        scrollView.leadingAnchor.constraint(equalTo: self.containerView.leadingAnchor).isActive = true
        scrollView.trailingAnchor.constraint(equalTo: self.containerView.trailingAnchor).isActive = true
       // scrollView.bottomAnchor.constraint(equalTo: self.containerView.bottomAnchor, constant: -16).isActive = true

        if !contentView.isDescendant(of: scrollView) {
            scrollView.addSubview(contentView)
        }
       // contentView.backgroundColor = .white
        contentView.layer.cornerRadius = 8
        contentView.topAnchor.constraint(equalTo: self.scrollView.topAnchor, constant: 0).isActive = true
        contentView.bottomAnchor.constraint(equalTo: self.scrollView.bottomAnchor, constant: 0).isActive = true
        contentView.leadingAnchor.constraint(equalTo: self.scrollView.leadingAnchor, constant: 0).isActive = true
        contentView.trailingAnchor.constraint(equalTo: self.scrollView.trailingAnchor, constant: 0).isActive = true
        contentView.widthAnchor.constraint(equalTo: self.scrollView.widthAnchor).isActive = true

        if !stackView.isDescendant(of: contentView) {
            contentView.addSubview(stackView)
        }

        stackView.topAnchor.constraint(equalTo: self.contentView.topAnchor, constant: 10).isActive = true
        stackView.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor, constant: 8).isActive = true
        stackView.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor, constant: -8).isActive = true
        stackView.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor, constant: 0).isActive = true
        
        
        stackView.addArrangedSubview(disclaimerLbl)
        
        principalDocumentsView()

        if Constant.SSA_data?.basicInfo?.zakatStatus == "Y" {
            zakatView()
        }
        if accountType == "CIS" || accountType == "BOTH" {
            jointAccountDocument()
        }
        if accountType == "VPS" || accountType == "BOTH" {
            HealthDeclarationDocumentView()
        }

        let simOwnerCode = UserDefaults.standard.string(forKey: "SimOwner_Code") ?? "Self"
        if simOwnerCode != "Self" {
            SimOwnerDocumentView(simOwnerCode)
        }
        if onlineAccountType == OnlineAccountType.digital.rawValue {
            sourceOfIncomeDocuments()
        }
        
        w9FormDocuments()
        
        
        

        uploadPhoto = DocumentView(title: "Live Photo", image: "Group 2586"){ checked in
            self.filePathKey = .LivePhoto
            self.openCamera()
        }
        stackView.addArrangedSubview(uploadPhoto)
        uploadLivePhotoView = UploadView(image: "") { checked in
            print(checked)
            //self.cnicUploadView.isHidden = true
        }
        stackView.addArrangedSubview(uploadLivePhotoView)
        uploadLivePhotoView.isHidden = true

        let btnView = CenterButtonView.init(title: AppString.Heading.savebtn) { [weak self] (clicked) in
            guard let self = self else {return}
//
            if self.isCNICFrontPrincipal == false || self.isCNICBackPrincipal == false || self.issignaturePrincipal == false, self.isSourceOfIncome == false {
                self.showAlert(title: "Alert", message: "Document are required!", controller: self) {
                }
                return
            }

            if self.accountType == "BOTH" {
                if self.jointAccount == "Yes" {
                    if self.isCNICBackJoint == false || self.isCNICFrontJoint == false || self.isSignatureCardJoint == false {
                        self.showAlert(title: "Alert", message: "Document are required!", controller: self) {
                        }
                        return
                    }

                }
                if self.health_dec == "Yes" {
                    if self.ishealthDeclaration == false {
                        if self.isCNICBackJoint == false || self.isCNICFrontJoint == false || self.isSignatureCardJoint == false {
                            self.showAlert(title: "Alert", message: "Document are required!", controller: self) {
                            }
                            return
                        }

                    }
                }
            }
            if Constant.SSA_data?.basicInfo?.zakatStatus == "Y" {
                if self.isuploadZakat == false {
                    self.showAlert(title: "Alert", message: "Document are required!", controller: self) {
                    }
                    return
                }
            }
            if self.onlineAccountType == OnlineAccountType.digital.rawValue {
                let sourceOfIncome = UserDefaults.standard.string(forKey: "SourceOfIncome") ?? ""
                
                if sourceOfIncome != "" {
                    if self.isSourceOfIncome == false {
                        self.showAlert(title: "Alert", message: "Document are required!", controller: self) {
                        }
                        return
                    }
                }
                
                if sourceOfIncome == "Student" || sourceOfIncome == "House Wife" {
                    if self.isIncomeDeclaration == false {
                        self.showAlert(title: "Alert", message: "Document are required!", controller: self) {
                        }
                        return
                    }
                    
                    if self.isFundSupporterCNICFornt == false {
                        self.showAlert(title: "Alert", message: "Document are required!", controller: self) {
                        }
                        return
                    }
                    
                    if self.isFundSupporterCNICBack == false {
                        self.showAlert(title: "Alert", message: "Document are required!", controller: self) {
                        }
                        return
                    }
                    
                }
            }
            if self.w9JointForm == true {
                if self.isw9from == false {
                    self.showAlert(title: "Alert", message: "Document are required!", controller: self) {
                    }
                    return
                }
            }
            
            if self.w9From == true {
                if self.isw9from == false {
                    self.showAlert(title: "Alert", message: "Document are required!", controller: self) {
                    }
                    return
                }
            }
            
            if self.isuploadLivePhoto == false {
                self.showAlert(title: "Alert", message: "Document are required!", controller: self) {
                }
                return
            }
            let vc = PreviewBasicInfoVC()
            self.navigationController?.pushViewController(vc, animated: false)
        }
        btnView.containerView.backgroundColor = UIColor.rgb(red: 242, green: 244, blue: 248, alpha: 1)
        btnView.translatesAutoresizingMaskIntoConstraints = false
        btnView.clipsToBounds = true
        if !btnView.isDescendant(of: containerView) {
            containerView.addSubview(btnView)
        }
        btnView.topAnchor.constraint(equalTo: scrollView.bottomAnchor, constant: 0).isActive = true
        btnView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 16).isActive = true
        btnView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -16).isActive = true
        btnView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -10).isActive = true
        btnView.containerView.backgroundColor = .white
    }
    
    func principalDocumentsView() {
        CNICFrontPrincipalView = DocumentView(title: "CNIC Front - Principal", image: "Group 2586") { checked in
            print("click to uplaod image")
            self.filePathKey = .PrincipalCnicFront
            self.uploadSheet()
        }
        stackView.addArrangedSubview(CNICFrontPrincipalView)

        CNICFrontPrincipalUploadView = UploadView(image: "") { checked in
            //self.cnicUploadView.isHidden = true
        }
        stackView.addArrangedSubview(CNICFrontPrincipalUploadView)
        CNICFrontPrincipalUploadView.isHidden = true

        CNICBackPrincipalView = DocumentView(title: "CNIC Back - Principal", image: "Group 2586"){ checked in
            self.filePathKey = .PrincipalCnicBack
            self.uploadSheet()
        }
        stackView.addArrangedSubview(CNICBackPrincipalView)
        CNICBackPrincipalUploadView = UploadView(image: "") { checked in
            print(checked)
            //self.cnicUploadView.isHidden = true
        }
        stackView.addArrangedSubview(CNICBackPrincipalUploadView)
        CNICBackPrincipalUploadView.isHidden = true
        signaturePrincipalView = DocumentView(title: "Signature Card - Principal", image: "Group 2586"){ checked in
            self.filePathKey = .SignCard
            self.uploadSheet()
        }
        stackView.addArrangedSubview(signaturePrincipalView)
        stackView.addArrangedSubview(signatureCardLbl)

        
        
        signaturePrincipalUploadView = UploadView(image: "") { checked in
            print(checked)
            //self.cnicUploadView.isHidden = true
        }
        stackView.addArrangedSubview(signaturePrincipalUploadView)
        signaturePrincipalUploadView.isHidden = true

    }
    
    
    func SimOwnerDocumentView(_ code: String) {
        if code == "Relative" {
            CNICFrontSimOwnerView = DocumentView(title: "CNIC Front - SimOwner", image: "Group 2586"){ checked in
                self.filePathKey = .SimOwnerCnicFront
                self.uploadSheet()
            }
            stackView.addArrangedSubview(CNICFrontSimOwnerView)
            
            CNICFrontSimOwnerUploadView = UploadView(image: "") { checked in
            }
            stackView.addArrangedSubview(CNICFrontSimOwnerUploadView)
            CNICFrontSimOwnerUploadView.isHidden = true
            
            
            CNICBackSimOwnerView = DocumentView(title: "CNIC Back - SimOwner", image: "Group 2586"){ checked in
                self.filePathKey = .SimOwnerCnicBack
                self.uploadSheet()
            }
            stackView.addArrangedSubview(CNICBackSimOwnerView)
            
            CNICBackSimOwnerUploadView = UploadView(image: "") { checked in
            }
            stackView.addArrangedSubview(CNICBackSimOwnerUploadView)
            CNICBackSimOwnerUploadView.isHidden = true
            
        }
        
        if code == "Company" || code == "Relative" {
            AffidavitSimOwnerView = DocumentView(title: "Add Affidavit - SimOwner", image: "Group 2586"){ checked in
                self.filePathKey = .Affidavite
                self.uploadSheet()
            }
            stackView.addArrangedSubview(AffidavitSimOwnerView)
            
            AffidavitSimOwnerUploadView = UploadView(image: "") { checked in
            }
            stackView.addArrangedSubview(AffidavitSimOwnerUploadView)
            AffidavitSimOwnerUploadView.isHidden = true
        }
            
        if code == "Company" || code == "Intl" {
            CompanyMobileBillView = DocumentView(title: "Add Company Mobile Bill", image: "Group 2586"){ checked in
                self.filePathKey = .MobileBill
                self.uploadSheet()
            }
            stackView.addArrangedSubview(CompanyMobileBillView)
            
            CompanyMobileBillUploadView = UploadView(image: "") { checked in
            }
            stackView.addArrangedSubview(CompanyMobileBillUploadView)
            CompanyMobileBillUploadView.isHidden = true
            
            
        }
    }
    
    func HealthDeclarationDocumentView() {
        
        if health_dec == "Yes" {
            healthDeclarationView = DocumentView(title: "", image: "Group 2586"){ checked in
                self.filePathKey = .HealthDeclaration
                self.uploadSheet()
            }
            let string = "Health Declaration Click here to download."
            let attributedString = NSMutableAttributedString(string:string)
            let range: NSRange = attributedString.mutableString.range(of: "Click here", options: .caseInsensitive)
            attributedString.addAttribute(.font, value: UIFont(name: AppFontName.robotoMedium, size: 13), range: range)
            attributedString.addAttribute(.foregroundColor, value: UIColor.init(rgb: 0x0000FF), range: range)
            attributedString.addAttribute(.underlineStyle, value: NSUnderlineStyle.thick.rawValue, range: range)

            let range1: NSRange = attributedString.mutableString.range(of: "to download.", options: .caseInsensitive)
            attributedString.addAttribute(.font, value: UIFont(name: AppFontName.robotoRegular, size: 13), range: range1)
            attributedString.addAttribute(.foregroundColor, value: UIColor.init(rgb: 0x4F5A65), range: range1)
            //0x4F5A65
            healthDeclarationView.lblHeading.attributedText = attributedString
            self.healthDeclarationView.lblHeading.isUserInteractionEnabled = true
            let tapgesture = UITapGestureRecognizer(target: self, action: #selector(tappedOnLabel(_ :)))
            tapgesture.numberOfTapsRequired = 1
            tapgesture.numberOfTouchesRequired = 1
            self.healthDeclarationView.lblHeading.addGestureRecognizer(tapgesture)

            stackView.addArrangedSubview(healthDeclarationView)

            stackView.addArrangedSubview(downloadLbl)
            
            healthDeclarationUploadView = UploadView(image: "") { checked in
                print(checked)
                //self.cnicUploadView.isHidden = true
            }
            stackView.addArrangedSubview(healthDeclarationUploadView)
            healthDeclarationUploadView.isHidden = true
        }
    }
    
    
    func jointAccountDocument() {
        if self.jointAccount == "Yes" {
            CNICFrontJointView = DocumentView(title: "CNIC Front - Joint Holder", image: "Group 2586"){ checked in
                self.filePathKey = .JointHolderCnicFront
                self.uploadSheet()
            }
            stackView.addArrangedSubview(CNICFrontJointView)



            CNICFrontJointUploadView = UploadView(image: "") { checked in
                print(checked)
                //self.cnicUploadView.isHidden = true

            }
            stackView.addArrangedSubview(CNICFrontJointUploadView)
            CNICFrontJointUploadView.isHidden = true


            CNICBackJointView = DocumentView(title: "CNIC Back - Joint Holder", image: "Group 2586"){ checked in
                self.filePathKey = .JointHolderCnicBack
                self.uploadSheet()
            }
            stackView.addArrangedSubview(CNICBackJointView)
            CNICBackJointUploadView = UploadView(image: "") { checked in
                print(checked)
                //self.cnicUploadView.isHidden = true

            }
            stackView.addArrangedSubview(CNICBackJointUploadView)
            CNICBackJointUploadView.isHidden = true
            SignatureCardJointView = DocumentView(title: "Signature Card - Joint Holder", image: "Group 2586"){ checked in
                self.filePathKey = .JointHolderSignCard
                self.uploadSheet()
            }
            stackView.addArrangedSubview(SignatureCardJointView)

            SignatureCardJointUploadView = UploadView(image: "") { checked in
                print(checked)
                //self.cnicUploadView.isHidden = true

            }
            stackView.addArrangedSubview(SignatureCardJointUploadView)
            SignatureCardJointUploadView.isHidden = true
        }
    }
    
    func zakatView() {
        ZakatDeclarationView = DocumentView(title: "Zakat Declaration", image: "Group 2586"){ checked in
            self.filePathKey = .ZakatDeclaration
            self.uploadSheet()
        }
        stackView.addArrangedSubview(ZakatDeclarationView)
        ZakatDeclarationUploadView = UploadView(image: "") { checked in
            print(checked)
            //self.cnicUploadView.isHidden = true
        }
        stackView.addArrangedSubview(ZakatDeclarationUploadView)
        ZakatDeclarationUploadView.isHidden = true
        
    }
    
    func sourceOfIncomeDocuments() {
        let sourceOfIncome = UserDefaults.standard.string(forKey: "SourceOfIncome") ?? ""
        if sourceOfIncome != "" {
            sourceOfIncomeView = DocumentView(title: "Source Of Income", image: "Group 2586"){ checked in
                self.filePathKey = .SourceOfIncome
                self.uploadSheet()
            }
            stackView.addArrangedSubview(sourceOfIncomeView)
            
            sourceOfIncomeUploadView = UploadView(image: "") { checked in
            }
            stackView.addArrangedSubview(sourceOfIncomeUploadView)
            sourceOfIncomeUploadView.isHidden = true
 
            if var incomeDocuemnt = UserDefaults.standard.string(forKey: "document") {
                incomeDocuemnt = incomeDocuemnt.replacingOccurrences(of: "CNIC Front<br>CNIC Back<br>", with: "")
//                if incomeDocuemnt.contains("Supporter’s CNIC Front") {
//                    incomeDocuemnt = incomeDocuemnt.replacingOccurrences(of: "Supporter’s CNIC Front<br>Supporter’s CNIC Back<br>", with: "")
//                }
                incomeDocumentLbl.attributedText = incomeDocuemnt.htmlToAttributedString
                incomeDocumentLbl.numberOfLines = 0
                stackView.addArrangedSubview(incomeDocumentLbl)
            }
            
            if sourceOfIncome == "Student" || sourceOfIncome == "House Wife" {
                
                incomeDeclarationView = DocumentView(title: "", image: "Group 2586"){ checked in
                    self.filePathKey = .FundSupporterDec
                    self.uploadSheet()
                }
                let string = "Fund Supporter Declaration Click here to download."
                let attributedString = NSMutableAttributedString(string:string)
                let range: NSRange = attributedString.mutableString.range(of: "Click here", options: .caseInsensitive)
                attributedString.addAttribute(.font, value: UIFont(name: AppFontName.robotoMedium, size: 14), range: range)
                attributedString.addAttribute(.foregroundColor, value: UIColor.init(rgb: 0x0000FF), range: range)
                attributedString.addAttribute(.underlineStyle, value: NSUnderlineStyle.thick.rawValue, range: range)
                
                let range1: NSRange = attributedString.mutableString.range(of: "to download.", options: .caseInsensitive)
                attributedString.addAttribute(.font, value: UIFont(name: AppFontName.robotoRegular, size: 14), range: range1)
                attributedString.addAttribute(.foregroundColor, value: UIColor.init(rgb: 0x4F5A65), range: range1)
                incomeDeclarationView.lblHeading.attributedText = attributedString
                incomeDeclarationView.lblHeading.isUserInteractionEnabled = true
                let tapgesture = UITapGestureRecognizer(target: self, action: #selector(tappedOnFundSupporterLabel(_ :)))
                tapgesture.numberOfTapsRequired = 1
                tapgesture.numberOfTouchesRequired = 1
                self.incomeDeclarationView.lblHeading.addGestureRecognizer(tapgesture)
                
                
                stackView.addArrangedSubview(incomeDeclarationView)
                stackView.addArrangedSubview(downloadIncomeLbl)
                
                
                incomeDeclarationUploadView = UploadView(image: "") { checked in
                }
                stackView.addArrangedSubview(incomeDeclarationUploadView)
                incomeDeclarationUploadView.isHidden = true
                
                
                
                fundSupporterCNICFrontView = DocumentView(title: "Supporter’s CNIC Front", image: "Group 2586"){ checked in
                    self.filePathKey = .FundSupporterCnicFront
                    self.uploadSheet()
                }
                stackView.addArrangedSubview(fundSupporterCNICFrontView)
                
                fundSupporterCNIVFrontUploadView = UploadView(image: "") { checked in
                }
                stackView.addArrangedSubview(fundSupporterCNIVFrontUploadView)
                fundSupporterCNIVFrontUploadView.isHidden = true
                
                
                
                fundSupporterCNICBackView = DocumentView(title: "Supporter’s CNIC Back", image: "Group 2586"){ checked in
                    self.filePathKey = .FundSupporterCnicBack
                    self.uploadSheet()
                }
                stackView.addArrangedSubview(fundSupporterCNICBackView)
                
                fundSupporterCNIVBackUploadView = UploadView(image: "") { checked in
                }
                stackView.addArrangedSubview(fundSupporterCNIVBackUploadView)
                fundSupporterCNIVBackUploadView.isHidden = true
            }
            
            
            
        }
    }
    
    func w9FormDocuments() {
        if self.w9JointForm == true {
            jointW9fromView = DocumentView(title: "", image: "Group 2586"){ checked in
                self.filePathKey = .W9FormForJoint
                self.uploadSheet()
            }
            let string = "W-9 Form for Joint Account holder Click here to download."
            let attributedString = NSMutableAttributedString(string:string)
            let range: NSRange = attributedString.mutableString.range(of: "Click here", options: .caseInsensitive)
            attributedString.addAttribute(.font, value: UIFont(name: AppFontName.robotoMedium, size: 14), range: range)
            attributedString.addAttribute(.foregroundColor, value: UIColor.init(rgb: 0x0000FF), range: range)
            attributedString.addAttribute(.underlineStyle, value: NSUnderlineStyle.thick.rawValue, range: range)
            
            let range1: NSRange = attributedString.mutableString.range(of: "to download.", options: .caseInsensitive)
            attributedString.addAttribute(.font, value: UIFont(name: AppFontName.robotoRegular, size: 14), range: range1)
            attributedString.addAttribute(.foregroundColor, value: UIColor.init(rgb: 0x4F5A65), range: range1)
            jointW9fromView.lblHeading.attributedText = attributedString
            jointW9fromView.lblHeading.isUserInteractionEnabled = true
            let tapgesture = UITapGestureRecognizer(target: self, action: #selector(tappedOnW9FormJointLabel(_ :)))
            tapgesture.numberOfTapsRequired = 1
            tapgesture.numberOfTouchesRequired = 1
            self.jointW9fromView.lblHeading.addGestureRecognizer(tapgesture)
            
            stackView.addArrangedSubview(jointW9fromView)
            stackView.addArrangedSubview(downloadW9FromJointLbl)


            jointW9fromUploadView = UploadView(image: "") { checked in
            }
            stackView.addArrangedSubview(jointW9fromUploadView)
            jointW9fromUploadView.isHidden = true
        }
        if self.w9From == true {
        
            w9fromView = DocumentView(title: "", image: "Group 2586"){ checked in
                self.filePathKey = .W9Form
                self.uploadSheet()
            }
            
            
            let string = "W-9 Form for Principle Account holder Click here to download."
            let attributedString = NSMutableAttributedString(string:string)
            let range: NSRange = attributedString.mutableString.range(of: "Click here", options: .caseInsensitive)
            attributedString.addAttribute(.font, value: UIFont(name: AppFontName.robotoMedium, size: 14), range: range)
            attributedString.addAttribute(.foregroundColor, value: UIColor.init(rgb: 0x0000FF), range: range)
            attributedString.addAttribute(.underlineStyle, value: NSUnderlineStyle.thick.rawValue, range: range)
            
            let range1: NSRange = attributedString.mutableString.range(of: "to download.", options: .caseInsensitive)
            attributedString.addAttribute(.font, value: UIFont(name: AppFontName.robotoRegular, size: 14), range: range1)
            attributedString.addAttribute(.foregroundColor, value: UIColor.init(rgb: 0x4F5A65), range: range1)
            w9fromView.lblHeading.attributedText = attributedString
            w9fromView.lblHeading.isUserInteractionEnabled = true
            let tapgesture = UITapGestureRecognizer(target: self, action: #selector(tappedOnW9FormLabel(_ :)))
            tapgesture.numberOfTapsRequired = 1
            tapgesture.numberOfTouchesRequired = 1
            self.w9fromView.lblHeading.addGestureRecognizer(tapgesture)
            
            
            
            
            
            stackView.addArrangedSubview(w9fromView)
            stackView.addArrangedSubview(downloadW9FromLbl)


            w9fromUploadView = UploadView(image: "") { checked in
            }
            stackView.addArrangedSubview(w9fromUploadView)
            w9fromUploadView.isHidden = true
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
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: {
            (alert: UIAlertAction!) -> Void in
            print("Cancelled")
        })
        
        optionMenu.addAction(option1)
        optionMenu.addAction(option2)
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
            self .present(self.imagePicker, animated: true, completion: nil)
        }
        else {
            let alertWarning = UIAlertView(title:"Warning", message: "You don't have camera", delegate:nil, cancelButtonTitle:"OK")
            alertWarning.show()
        }
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

enum DocumentType: String {
    case PrincipalCnicFront = "PrincipalCnicFront"
    case PrincipalCnicBack = "PrincipalCnicBack"
    case SourceOfIncome = "SourceOfIncome"
    case ZakatDeclaration = "ZakatDeclaration"
    case MobileBill = "MobileBill"
    case SignCard = "SignCard"
    case Affidavite = "Affidavite"
    case SimOwnerCnicFront = "SimOwnerCnicFront"
    case SimOwnerCnicBack = "SimOwnerCnicBack"
    case HealthDeclaration = "HealthDeclaration"
    case JointHolderCnicFront = "JointHolderCnicFront"
    case JointHolderCnicBack = "JointHolderCnicBack"
    case JointHolderSignCard = "JointHolderSignCard"
    case LivePhoto = "LivePhoto"
    case FundSupporterDec = "FundSupporterDec"
    case FundSupporterCnicFront = "FundSupporterCnicFront"
    case FundSupporterCnicBack = "FundSupporterCnicBack"
    case W9Form = "W9Form"
    case W9FormForJoint = "W9FormForJoint"
}



