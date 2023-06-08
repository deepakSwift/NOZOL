//
//  PDFController.swift
//  TenderApp
//
//  Created by Saurabh Chandra Bose on 09/11/19.
//  Copyright © 2019 Abhinav Saini. All rights reserved.
//

import UIKit
import PDFKit


class PDFController: UIViewController {
    
    private let pdfUrl: URL
    private let document: PDFDocument!
    private let outline: PDFOutline?
    private var pdfView = PDFView()
    private var thumbnailView = PDFThumbnailView()
    private var outlineButton = UIButton()
    private var dismissButton = UIButton()
    private var selectButton = UIButton()
    
    var delegate: DataToPreviousController?
    
    init(pdfUrl: URL) {
        self.pdfUrl = pdfUrl
        self.document = PDFDocument(url: pdfUrl)
        self.outline = document.outlineRoot
        pdfView.document = document
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupPDFView()
        setupDismissButton()
        setupSelectButton()
        setupThumbnailView()
        setupOutlineButton()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        pdfView.frame = view.safeAreaLayoutGuide.layoutFrame
        let thumbanilHeight: CGFloat = 120
        thumbnailView.translatesAutoresizingMaskIntoConstraints = false
        view.addConstraintsWithFormat(format: "H:|[v0]|", views: thumbnailView)
        view.addConstraintsWithFormat(format: "V:[v0(\(thumbanilHeight))]|", views: thumbnailView)
    }
    
    private func setupPDFView() {
        view.addSubview(pdfView)
        pdfView.displayDirection = .horizontal
        pdfView.usePageViewController(true)
        pdfView.pageBreakMargins = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        pdfView.autoScales = true
        
        let touch = UITapGestureRecognizer(target: self, action: #selector(toggleTools))
        pdfView.addGestureRecognizer(touch)
    }
    
    
    @objc func toggleTools() {
        if outlineButton.alpha != 0 {
            UIView.animate(withDuration: 0.3, animations: {
                self.outlineButton.alpha = 0
                self.thumbnailView.alpha = 0
                self.dismissButton.alpha = 0
                self.selectButton.alpha = 0
            }, completion: nil)
        } else {
            UIView.animate(withDuration: 0.3, animations: {
                self.outlineButton.alpha = 1
                self.thumbnailView.alpha = 1
                self.dismissButton.alpha = 1
                self.selectButton.alpha = 1
            }, completion: nil)
        }
    }
    
    private func setupDismissButton() {
        dismissButton = UIButton(frame: CGRect(x: 30, y: 45, width: 60, height: 60))
        dismissButton.layer.cornerRadius = dismissButton.frame.width/2
        dismissButton.setTitle("X", for: .normal)
        dismissButton.titleLabel?.font = UIFont(name: "AppleSDGothicNeo-Bold", size: 30)
        dismissButton.titleEdgeInsets = UIEdgeInsets(top: 5, left: 0, bottom: 0, right: 0)
        dismissButton.setTitleColor(.white, for: .normal)
        dismissButton.backgroundColor = .black
        dismissButton.alpha = 0.8
        view.addSubview(dismissButton)
        dismissButton.addTarget(self, action: #selector(back), for: .touchUpInside)
    }
    
    @objc private func back() {
        self.dismiss(animated: true) {
            self.delegate?.pdfNotSelected?()
        }
    }
    
    private func setupSelectButton() {
        selectButton = UIButton(frame: CGRect(x: (self.view.frame.width/2) - 30, y: 45, width: 60, height: 60))
        selectButton.layer.cornerRadius = selectButton.frame.width/2
        selectButton.setTitle("✓", for: .normal)
        selectButton.titleLabel?.font = UIFont(name: "AppleSDGothicNeo-Bold", size: 30)
        selectButton.titleEdgeInsets = UIEdgeInsets(top: 5, left: 0, bottom: 0, right: 0)
        selectButton.setTitleColor(.white, for: .normal)
        selectButton.backgroundColor = .black
        selectButton.alpha = 0.8
        view.addSubview(selectButton)
        selectButton.addTarget(self, action: #selector(selectPDF), for: .touchUpInside)
    }
    
    @objc private func selectPDF() {
        print("PDF selected")
        self.dismiss(animated: true) {
            self.delegate?.pdfSelected?()
        }
    }
    
    private func setupThumbnailView() {
        thumbnailView.pdfView = pdfView
        thumbnailView.backgroundColor = UIColor(displayP3Red: 179/255, green: 179/255, blue: 179/255, alpha: 0.5)
        thumbnailView.layoutMode = .horizontal
        thumbnailView.thumbnailSize = CGSize(width: 80, height: 100)
        thumbnailView.contentInset = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10)
        view.addSubview(thumbnailView)
    }
    
    private func setupOutlineButton() {
        outlineButton = UIButton(frame: CGRect(x: view.frame.maxX - 90, y: 45, width: 60, height: 60))
        outlineButton.layer.cornerRadius = outlineButton.frame.width/2
        outlineButton.setTitle("三", for: .normal)
        outlineButton.titleLabel?.font = UIFont(name: "AppleSDGothicNeo-Bold", size: 30)
        outlineButton.titleEdgeInsets = UIEdgeInsets(top: 5, left: 0, bottom: 0, right: 0)
        outlineButton.setTitleColor(.white, for: .normal)
        outlineButton.backgroundColor = .black
        outlineButton.alpha = 0.8
        view.addSubview(outlineButton)
        outlineButton.addTarget(self, action: #selector(toggleOutline(sender:)), for: .touchUpInside)
    }
    
    @objc private func toggleOutline(sender: UIButton) {
        
        guard let outline = self.outline else {
          //  print("PDF has no outline")
            return
        }
        
        let outlineViewController = OutlineTableViewController(outline: outline, delegate: self)
        outlineViewController.preferredContentSize = CGSize(width: 300, height: 400)
        outlineViewController.modalPresentationStyle = UIModalPresentationStyle.popover
        
        let popoverPresentationController = outlineViewController.popoverPresentationController
        popoverPresentationController?.sourceView = outlineButton
        popoverPresentationController?.sourceRect = CGRect(x: sender.frame.width/2, y: sender.frame.height, width: 0, height: 0)
        popoverPresentationController?.permittedArrowDirections = UIPopoverArrowDirection.up
        popoverPresentationController?.delegate = self
        
        self.present(outlineViewController, animated: true, completion: nil)
    }
}

extension PDFController: OutlineDelegate {
    func goTo(page: PDFPage) {
        pdfView.go(to: page)
    }
}

extension PDFController: UIPopoverPresentationControllerDelegate {
    func adaptivePresentationStyle(for controller: UIPresentationController) -> UIModalPresentationStyle {
        return .none
    }
}

extension UIView {
    func addConstraintsWithFormat(format: String, views: UIView...) {
        var viewsDictionary = [String: UIView]()
        for (index, view) in views.enumerated() {
            let key = "v\(index)"
            view.translatesAutoresizingMaskIntoConstraints = false
            viewsDictionary[key] = view
        }
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: format, options: NSLayoutConstraint.FormatOptions(), metrics: nil, views: viewsDictionary))
    }
}

extension PDFController: DataToPreviousController {
    
}
