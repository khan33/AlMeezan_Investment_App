//
//  AlertView.swift
//  AlMeezan
//
//  Created by Atta khan on 17/11/2021.
//  Copyright © 2021 Atta khan. All rights reserved.
//
import UIKit

enum Theme {
    case error
    case warning
    case success
}

class AlertView: UIView {
    private let titleLable = UILabel()
    private let messageLable = UILabel()
    private let imageView = UIImageView()

    private var type: Theme
    private var message: String
    private var title: AllertTitles

    init(message: String, title: AllertTitles, type: Theme) {
        self.type = type
        self.title = title
        self.message = message
        super.init(frame: .zero)
        setup()
    }

    private func setup() {
        switch type {
        case .success:
//            imageView.image = #imageLiteral(resourceName: "successIconLight").withRenderingMode(.alwaysTemplate)
            titleLable.textColor = #colorLiteral(red: 0.1176470588, green: 0.737254902, blue: 0.2392156863, alpha: 1)
            imageView.backgroundColor = #colorLiteral(red: 0.1176470588, green: 0.737254902, blue: 0.2392156863, alpha: 1)
        case .warning:
            imageView.image = #imageLiteral(resourceName: "infoIconLight").withRenderingMode(.alwaysTemplate)
            titleLable.textColor = #colorLiteral(red: 0.9843137255, green: 0.8509803922, blue: 0.1411764706, alpha: 1)
            imageView.backgroundColor = #colorLiteral(red: 0.9843137255, green: 0.8509803922, blue: 0.1411764706, alpha: 1)
        case .error:
            imageView.image = #imageLiteral(resourceName: "errorIconLight").withRenderingMode(.alwaysTemplate)
            titleLable.textColor = #colorLiteral(red: 0.8784313725, green: 0.168627451, blue: 0.1529411765, alpha: 1)
            imageView.backgroundColor = #colorLiteral(red: 0.8784313725, green: 0.168627451, blue: 0.1529411765, alpha: 1)
        }

        backgroundColor = .white
        messageLable.text = message
        imageView.tintColor = .white
        messageLable.textColor = .gray
        titleLable.text = title.localize

        let swipeToTop = UISwipeGestureRecognizer(target: self, action: #selector(handelGesture(_:)))
        swipeToTop.direction = .up

        addGestureRecognizer(swipeToTop)

        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
            self.closeMe()
        }
    }

    @objc
    private func handelGesture(_: UISwipeGestureRecognizer) {
        closeMe()
    }

    private func closeMe() {
        UIView.animate(withDuration: 0.5, animations: {
            self.transform = .init(translationX: 0, y: -1000)
        }) { _ in
            self.removeFromSuperview()
        }
    }

    fileprivate func layout() {
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 30 / 2
        imageView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(imageView)
        NSLayoutConstraint.activate([
            imageView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            imageView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -10),
            imageView.widthAnchor.constraint(equalToConstant: 30),
            imageView.heightAnchor.constraint(equalToConstant: 30),
        ])

        titleLable.translatesAutoresizingMaskIntoConstraints = false
        titleLable.font = .systemFont(ofSize: 13, weight: .medium)
        addSubview(titleLable)
        NSLayoutConstraint.activate([
            titleLable.leadingAnchor.constraint(equalTo: imageView.trailingAnchor, constant: 15),
            titleLable.topAnchor.constraint(equalTo: imageView.topAnchor, constant: 0),
            titleLable.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
        ])

        messageLable.translatesAutoresizingMaskIntoConstraints = false
        messageLable.font = .systemFont(ofSize: 13, weight: .regular)
        addSubview(messageLable)
        NSLayoutConstraint.activate([
            messageLable.leadingAnchor.constraint(equalTo: imageView.trailingAnchor, constant: 15),
            messageLable.topAnchor.constraint(equalTo: titleLable.bottomAnchor, constant: 2),
            messageLable.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
        ])

        transform = .init(translationX: 0, y: -1000)
        alpha = 1

        UIView.animate(withDuration: 1) {
            self.transform = .identity
        }
    }

    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class AlertViewHandler {
    // iOS13 or later
//    let sceneDelegate = UIApplication.shared.connectedScenes
//        .first!.delegate as! SceneDelegate
//    lazy var window = sceneDelegate.window!
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    lazy var window = appDelegate.window!

    func showAlert(message: String, title: AllertTitles, type: Theme) {
        let view = AlertView(message: message, title: title, type: type)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.alpha = 0
        window.addSubview(view)
        NSLayoutConstraint.activate([
            view.topAnchor.constraint(equalTo: window.topAnchor, constant: 0),
            view.leadingAnchor.constraint(equalTo: window.leadingAnchor, constant: 0),
            view.trailingAnchor.constraint(equalTo: window.trailingAnchor, constant: 0),
            view.heightAnchor.constraint(equalToConstant: 90),
        ])
        view.layout()
    }
}
protocol localizableProtocol {
    var localize: String { get }
}

enum AllertTitles: localizableProtocol {
    case error
    case success
    case warning

    var localize: String {
        switch self {
        case .error:
            return "Error"
        case .success:
            return "Success"
        case .warning:
            return "Warning"
        }
    }
}
