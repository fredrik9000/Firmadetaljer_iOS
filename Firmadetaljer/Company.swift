//
//  Company.swift
//  Firmadetaljer
//
//  Created by Fredrik Eilertsen on 04/05/16.
//  Copyright © 2016 Fredrik Eilertsen. All rights reserved.
//
//  Values from "komplett datasett" https://confluence.brreg.no/display/DBNPUB/API

import Foundation

class Company: Codable, Hashable {
    
    var organisasjonsnummer:Int?
    var navn:String?
    var stiftelsesdato:String?
    var registreringsdatoEnhetsregisteret:String?
    var oppstartsdato:String?
    var datoEierskifte:String?
    var organisasjonsform:String?
    var hjemmeside:String?
    var registrertIFrivillighetsregisteret:String?
    var registrertIMvaregisteret:String?
    var registrertIForetaksregisteret:String?
    var registrertIStiftelsesregisteret:String?
    var frivilligRegistrertIMvaregisteret:String?
    var antallAnsatte:Int?
    var sisteInnsendteAarsregnskap: Int?
    var konkurs: String?
    var underAvvikling: String?
    var underTvangsavviklingEllerTvangsopplosning: String?
    var overordnetEnhet:Int?
    var institusjonellSektorkode:InstitusjonellSektorkode?
    var naeringskode1:Naeringskode?
    var naeringskode2:Naeringskode?
    var naeringskode3:Naeringskode?
    var postadresse:Adresse?
    var forretningsadresse:Adresse?
    var beliggenhetsadresse:Adresse?
    
    var hashValue: Int {
        return navn!.hashValue
    }
    
    static func == (lhs: Company, rhs: Company) -> Bool {
        return lhs.navn == rhs.navn && lhs.navn == rhs.navn
    }
}

class InstitusjonellSektorkode: Codable {
    var kode: Int?
    var beskrivelse: String?
}

class Naeringskode: Codable {
    var kode: String?
    var beskrivelse: String?
}

class Adresse: Codable {
    var adresse: String?
    var postnummer: Int?
    var poststed: String?
    var kommunenummer: Int?
    var kommune: String?
    var landkode: String?
    var land: String?
}
