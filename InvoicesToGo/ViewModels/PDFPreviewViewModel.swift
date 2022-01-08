//
//  PDFPreviewViewModel.swift
//  InvoicesToGo
//
//  Created by Derrick Mateja on 1/3/22.
//

import Foundation

class PDFPreviewViewModel {
    var documentData: Data
    
    init(documentData: Data) {
        self.documentData = documentData
    }
}
