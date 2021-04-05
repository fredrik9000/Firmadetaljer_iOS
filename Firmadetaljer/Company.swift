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
    
    var organisasjonsnummer: String?
    var navn: String?
    var stiftelsesdato: String?
    var registreringsdatoEnhetsregisteret: String?
    var oppstartsdato: String?
    var datoEierskifte: String?
    var organisasjonsform: Organisasjonsform?
    var hjemmeside: String?
    var registrertIFrivillighetsregisteret: Bool?
    var registrertIMvaregisteret: Bool?
    var registrertIForetaksregisteret: Bool?
    var registrertIStiftelsesregisteret: Bool?
    var frivilligRegistrertIMvaregisteret: Bool?
    var antallAnsatte: Int?
    var sisteInnsendteAarsregnskap: Int?
    var konkurs: Bool?
    var underAvvikling: Bool?
    var underTvangsavviklingEllerTvangsopplosning: Bool?
    var overordnetEnhet: String?
    var institusjonellSektorkode: InstitusjonellSektorkode?
    var naeringskode1: Naeringskode?
    var naeringskode2: Naeringskode?
    var naeringskode3: Naeringskode?
    var postadresse: Adresse?
    var forretningsadresse: Adresse?
    var beliggenhetsadresse: Adresse?
    
    static func == (lhs: Company, rhs: Company) -> Bool {
        return lhs.organisasjonsnummer == rhs.organisasjonsnummer
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(organisasjonsnummer)
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

class Organisasjonsform: Codable {
    var kode: String?
    var beskrivelse: String?
}
