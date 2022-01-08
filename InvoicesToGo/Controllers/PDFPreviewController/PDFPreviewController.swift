//
//  PDFPreviewController.swift
//  InvoicesToGo
//
//  Created by Derrick Mateja on 1/3/22.
//

import UIKit
import PDFKit

class PDFPreviewController: UIViewController {

    //MARK: - Properties
    @IBOutlet weak var pdfView: PDFView!
    
    var viewModel: PDFPreviewViewModel?
    
    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let data = viewModel?.documentData {
            pdfView.document = PDFDocument(data: data)
            pdfView.autoScales = true
        }
    }
}
