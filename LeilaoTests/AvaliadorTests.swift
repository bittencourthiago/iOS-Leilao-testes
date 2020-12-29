//
//  AvaliadorTests.swift
//  LeilaoUITests
//
//  Created by Thiago Bittencourt Coelho on 29/12/20.
//  Copyright © 2020 Alura. All rights reserved.
//

import XCTest
@testable import Leilao

class AvaliadorTests: XCTestCase {

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testDeveEntenderLancesEmOrdemCrescente() {
        let joao = Usuario(nome: "Joao")
        let jose = Usuario(nome: "Jose")
        let maria = Usuario(nome: "Maria")
        
        let leilao = Leilao(descricao: "Playstation 4")
        leilao.propoe(lance: Lance(maria, 250.0))
        leilao.propoe(lance: Lance(joao, 300.0))
        leilao.propoe(lance: Lance(jose, 400.0))
        
        // Acao
        
        let leiloeiro = Avaliador()
        leiloeiro.avalia(leilao: leilao)
        
        // Validacao
        
        let maior = 400.0
        let menor = 250.0
        
        print(leiloeiro.maiorLance() == maior)
        print(leiloeiro.menorLance() == menor)
        
        XCTAssertEqual(250.0, leiloeiro.menorLance())
        XCTAssertEqual(400.0, leiloeiro.maiorLance())
        
    }
    
    func testDeveEntenderLeilaoComApenasUmLance() {
        let joao = Usuario(nome: "João")
        let leilao = Leilao(descricao: "Playstation 4")
     
        leilao.propoe(lance: Lance(joao, 1000.0))
        let leiloeiro = Avaliador()
        leiloeiro.avalia(leilao: leilao)
        
        XCTAssertEqual( 1000.0, leiloeiro.menorLance())
        XCTAssertEqual( 1000.0, leiloeiro.maiorLance())
    }
    
}
