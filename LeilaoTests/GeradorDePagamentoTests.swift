//
//  GeradorDePagamentoTests.swift
//  LeilaoTests
//
//  Created by Thiago Bittencourt Coelho on 06/01/21.
//  Copyright © 2021 Alura. All rights reserved.
//

import XCTest
@testable import Leilao
import Cuckoo

class GeradorDePagamentoTests: XCTestCase {

    override func setUp() {
        
    }

    override func tearDown() {
        
    }

    func testDeveGerarPagamentoParaUmLeilaoEncerrado() {
        
        
        let playstation = CriadorDeLeilao().para(descricao: "Playstation")
            .lance(Usuario(nome:"José"), 2000.0)
            .lance(Usuario(nome:"Maria"), 2500.0)
            .constroi()
        
        let daoFalso = MockLeilaoDao().withEnabledSuperclassSpy()
        
        stub(daoFalso) { (daoFalso) in
            when(daoFalso.encerrados()).thenReturn([playstation])
        
        }
        let avaliadorFalso = MockAvaliador().withEnabledSuperclassSpy()
        
        stub(avaliadorFalso) { (avaliadorFalso) in
            when(avaliadorFalso.maiorLance()).thenReturn([2500.0])
        }
        
    }

}
