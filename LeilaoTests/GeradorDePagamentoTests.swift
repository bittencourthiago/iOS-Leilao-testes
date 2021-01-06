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
    
    var daoFalso:MockLeilaoDao!
    var avaliador:Avaliador!
    var pagamentos:MockRepositorioDePagamento!
    
    override func setUp() {
        daoFalso = MockLeilaoDao().withEnabledSuperclassSpy()
        pagamentos = MockRepositorioDePagamento().withEnabledSuperclassSpy()
        
        avaliador = Avaliador()
    }

    override func tearDown() {
        
    }

    func testDeveGerarPagamentoParaUmLeilaoEncerrado() {
        
        
        let playstation = CriadorDeLeilao().para(descricao: "Playstation")
            .lance(Usuario(nome:"José"), 2000.0)
            .lance(Usuario(nome:"Maria"), 2500.0)
            .constroi()
        
        
        stub(daoFalso) { (daoFalso) in
            when(daoFalso.encerrados()).thenReturn([playstation])
        
        }
        
        
        
        
        
        let geradorDePagamento = GeradorDePagamento(daoFalso, avaliador, pagamentos)
        
        geradorDePagamento.gera()
        
        let capturadorDeArgumento = ArgumentCaptor<Pagamento>()
        
        
        verify(pagamentos).salva(capturadorDeArgumento.capture())
        
        let pagamentoGerado = capturadorDeArgumento.value
        
        XCTAssertEqual(2500.0,  pagamentoGerado?.getValor())
        
    }

    func testDeveEmpurrarParaProximoDiaUtil() {
        let iphone = CriadorDeLeilao().para(descricao: "Iphone")
            .lance(Usuario(nome: "João"), 2000.0)
            .lance(Usuario(nome: "Maria"), 2500.0)
            .constroi()
        
        stub(daoFalso) { (daoFalso) in
            when(daoFalso).encerrados().thenReturn([iphone])
            
        }
        
        let formatador = DateFormatter()
        formatador.dateFormat = "yyyy/MM/dd"
        
        guard let dataAntiga = formatador.date(from: "2018/05/19") else { return }
        
        let geradorDePagamento = GeradorDePagamento(daoFalso, avaliador, pagamentos, dataAntiga)
        
        geradorDePagamento.gera()
        
        let capturadorDeArgumento = ArgumentCaptor<Pagamento>()
        
        verify(pagamentos).salva(capturadorDeArgumento.capture())
        
        let pagamentoGerado = capturadorDeArgumento.value
        
        let formatadorDeData = DateFormatter()
        
        formatadorDeData.dateFormat = "ccc"
        
        guard let dataDoPagamento = pagamentoGerado?.getData() else { return }
        
        let diaDaSemana = formatadorDeData.string(from: dataDoPagamento)
        
        XCTAssertEqual("Mon", diaDaSemana)
        
    }
    
}
