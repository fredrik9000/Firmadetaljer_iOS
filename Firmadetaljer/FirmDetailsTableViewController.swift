//
//  FirmDetailsTableViewController.swift
//  Firmadetaljer
//
//  Created by Fredrik Eilertsen on 06/05/16.
//  Copyright © 2016 Fredrik Eilertsen. All rights reserved.
//

import UIKit

private extension Bool {
    func toYesOrNo() -> String {
        if self {
            return NSLocalizedString("Yes", comment: "")
        } else {
            return NSLocalizedString("No", comment: "")
        }
    }
}

class FirmDetailsTableViewController: UITableViewController {
    
    var company: Company?
    
    private struct SectionCellData {
        var cells = [UITableViewCell]()
        var header: String
        
        init (header: String) {
            self.header = header
        }
    }
    
    private var sections = [SectionCellData]()
    
    private func buildCell(_ name: String, description: String) -> UITableViewCell {
        let cell = UITableViewCell.init(style: UITableViewCell.CellStyle.value1, reuseIdentifier: "Cell")
        cell.textLabel?.text = name
        cell.detailTextLabel?.text = description
        return cell
    }
    
    // Most cells are not interactive, except for when navigating to the homepage or parent company
    private func buildNonInteractiveCell(_ name: String, description: String) -> UITableViewCell {
        let cell = buildCell(name, description: description)
        cell.isUserInteractionEnabled = false
        return cell
    }
    
    private func buildNaeringskodeCells(_ companyNaeringskode: Naeringskode) -> [UITableViewCell] {
        var naeringskodeCellsArray = [UITableViewCell]()
        
        if let kode = companyNaeringskode.kode {
            naeringskodeCellsArray.append(
                buildNonInteractiveCell(NSLocalizedString("Naeringskode-Code", comment: ""), description: kode)
            )
        }

        if let beskrivelse = companyNaeringskode.beskrivelse {
            naeringskodeCellsArray.append(
                buildNonInteractiveCell(
                    NSLocalizedString("Naeringskode-Description", comment: ""), description: beskrivelse
                )
            )
        }
        
        return naeringskodeCellsArray
    }
    
    private func buildAdressCells(_ companyAddress: Adresse) -> [UITableViewCell] {
        var addressCellsArray = [UITableViewCell]()
        
        if let adresse = companyAddress.adresse {
            addressCellsArray.append(
                buildNonInteractiveCell(NSLocalizedString("Adresse-Address", comment: ""), description: adresse)
            )
        }

        if let postnummer = companyAddress.postnummer {
            addressCellsArray.append(
                buildNonInteractiveCell(NSLocalizedString("Adresse-ZipCode", comment: ""), description: String(postnummer))
            )
        }

        if let poststed = companyAddress.poststed {
            addressCellsArray.append(
                buildNonInteractiveCell(NSLocalizedString("Adresse-City", comment: ""), description: poststed)
            )
        }

        if let kommunenummer = companyAddress.kommunenummer {
            addressCellsArray.append(
                buildNonInteractiveCell(
                    NSLocalizedString("Adresse-MunicipalityNumber", comment: ""), description: String(kommunenummer)
                )
            )
        }

        if let kommune = companyAddress.kommune {
            addressCellsArray.append(buildNonInteractiveCell(NSLocalizedString("Adresse-Municipal", comment: ""), description: kommune))
        }

        if let landkode = companyAddress.landkode {
            addressCellsArray.append(buildNonInteractiveCell(NSLocalizedString("Adresse-CountryCode", comment: ""), description: landkode))
        }

        if let land = companyAddress.land {
            addressCellsArray.append(buildNonInteractiveCell(NSLocalizedString("Adresse-Country", comment: ""), description: land))
        }
        
        return addressCellsArray
    }
    
    private func createMainSection() -> SectionCellData {
        var mainSection = SectionCellData(header: NSLocalizedString("Detail-Section", comment: ""))

        if let navn = company?.navn {
            self.title = navn
        }

        if let orgnr = company?.organisasjonsnummer {
            mainSection.cells.append(buildNonInteractiveCell(NSLocalizedString("Detail-Org.number", comment: ""), description: String(orgnr)))
        }

        if let hjemmeside = company?.hjemmeside {
            let hjemmesideCell = buildCell(NSLocalizedString("Detail-Website", comment: ""), description: hjemmeside)
            hjemmesideCell.accessoryType = UITableViewCell.AccessoryType.disclosureIndicator
            mainSection.cells.append(hjemmesideCell)
        }

        if let overordnetEnhet = company?.overordnetEnhet {
            let overordnetEnhetCell = buildCell(NSLocalizedString("Detail-Parent", comment: ""), description: overordnetEnhet)
            overordnetEnhetCell.accessoryType = UITableViewCell.AccessoryType.disclosureIndicator
            mainSection.cells.append(overordnetEnhetCell)
        }

        if let stiftelsesdato = company?.stiftelsesdato {
            mainSection.cells.append(
                buildNonInteractiveCell(NSLocalizedString("Detail-DateOfEstablishment", comment: ""), description: stiftelsesdato)
            )
        }

        if let organisasjonsform = company?.organisasjonsform?.beskrivelse {
            mainSection.cells.append(
                buildNonInteractiveCell(NSLocalizedString("Detail-OrganizationalForm", comment: ""), description: organisasjonsform)
            )
        }

        if let antallAnsatte = company?.antallAnsatte {
            mainSection.cells.append(
                buildNonInteractiveCell(NSLocalizedString("Detail-Employees", comment: ""), description: String(antallAnsatte))
            )
        }

        if let registreringsdatoEnhetsregisteret = company?.registreringsdatoEnhetsregisteret {
            mainSection.cells.append(
                buildNonInteractiveCell(
                    NSLocalizedString("Detail-Enhetsregisteret", comment: ""),
                    description: registreringsdatoEnhetsregisteret
                )
            )
        }

        if let oppstartsdato = company?.oppstartsdato {
            mainSection.cells.append(
                buildNonInteractiveCell(NSLocalizedString("Detail-StartingDate", comment: ""), description: oppstartsdato)
            )
        }

        if let datoEierskifte = company?.datoEierskifte {
            mainSection.cells.append(
                buildNonInteractiveCell(NSLocalizedString("Detail-ChangeOfOwnershipDate", comment: ""), description: datoEierskifte)
            )
        }

        if let registrertIFrivillighetsregisteret = company?.registrertIFrivillighetsregisteret {
            mainSection.cells.append(
                buildNonInteractiveCell(
                    NSLocalizedString("Detail-Frivillighetsregisteret", comment: ""),
                    description: registrertIFrivillighetsregisteret.toYesOrNo()
                )
            )
        }

        if let registrertIMvaregisteret = company?.registrertIMvaregisteret {
            mainSection.cells.append(
                buildNonInteractiveCell(
                    NSLocalizedString("Detail-Mvaregisteret", comment: ""),
                    description: registrertIMvaregisteret.toYesOrNo()
                )
            )
        }

        if let registrertIForetaksregisteret = company?.registrertIForetaksregisteret {
            mainSection.cells.append(
                buildNonInteractiveCell(
                    NSLocalizedString("Detail-Foretaksregisteret", comment: ""),
                    description: registrertIForetaksregisteret.toYesOrNo()
                )
            )
        }

        if let registrertIStiftelsesregisteret = company?.registrertIStiftelsesregisteret {
            mainSection.cells.append(
                buildNonInteractiveCell(
                    NSLocalizedString("Detail-Stiftelsesregisteret", comment: ""),
                    description: registrertIStiftelsesregisteret.toYesOrNo()
                )
            )
        }

        if let frivilligRegistrertIMvaregisteret = company?.frivilligRegistrertIMvaregisteret {
            mainSection.cells.append(
                buildNonInteractiveCell(
                    NSLocalizedString("Detail-Mvaregisteret-Voluntarily", comment: ""),
                    description: frivilligRegistrertIMvaregisteret.toYesOrNo()
                )
            )
        }

        if let sisteInnsendteAarsregnskap = company?.sisteInnsendteAarsregnskap {
            mainSection.cells.append(
                buildNonInteractiveCell(
                    NSLocalizedString("Detail-LatestSubmittedAnnualAccounts", comment: ""),
                    description: String(sisteInnsendteAarsregnskap)
                )
            )
        }

        if let konkurs = company?.konkurs {
            mainSection.cells.append(buildNonInteractiveCell(NSLocalizedString("Detail-Bankrupt", comment: ""), description: konkurs.toYesOrNo()))
        }

        if let underAvvikling = company?.underAvvikling {
            mainSection.cells.append(
                buildNonInteractiveCell(NSLocalizedString("Detail-UnderLiquidation", comment: ""), description: underAvvikling.toYesOrNo())
            )
        }

        if let underTvangsavviklingEllerTvangsopplosning = company?.underTvangsavviklingEllerTvangsopplosning {
            mainSection.cells.append(
                buildNonInteractiveCell(
                    NSLocalizedString("Detail-ForcedResolution", comment: ""),
                    description: underTvangsavviklingEllerTvangsopplosning.toYesOrNo()
                )
            )
        }

        return mainSection
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.tableFooterView = UIView(frame: .zero)
        
        sections.append(createMainSection())

        if let postadresse = company?.postadresse {
            var postadresseSection = SectionCellData(header: NSLocalizedString("PostalAddress-Section", comment: ""))
            postadresseSection.cells = buildAdressCells(postadresse)
            sections.append(postadresseSection)
        }
        
        if let forretningsadresse = company?.forretningsadresse {
            var forretningsadresseSection = SectionCellData(header: NSLocalizedString("BusinessAddress-Section", comment: ""))
            forretningsadresseSection.cells = buildAdressCells(forretningsadresse)
            sections.append(forretningsadresseSection)
        }
        
        if let beliggenhetsadresse = company?.beliggenhetsadresse {
            var beliggenhetsadresseSection = SectionCellData(header: NSLocalizedString("LocationAddress-Section", comment: ""))
            beliggenhetsadresseSection.cells = buildAdressCells(beliggenhetsadresse)
            sections.append(beliggenhetsadresseSection)
        }
        
        if let institusjonellSektorkode = company?.institusjonellSektorkode {
            var sektorkodeSection = SectionCellData(header: NSLocalizedString("InstitutionalSectorCode-Section", comment: ""))
            
            if let kode = institusjonellSektorkode.kode {
                sektorkodeSection.cells.append(
                    buildNonInteractiveCell(
                        NSLocalizedString("InstitutionalSectorCode-Code", comment: ""), description: String(kode)
                    )
                )
            }
            
            if let beskrivelse = institusjonellSektorkode.beskrivelse {
                sektorkodeSection.cells.append(
                    buildNonInteractiveCell(
                        NSLocalizedString("InstitutionalSectorCode-Description", comment: ""), description: beskrivelse
                    )
                )
            }
            
            sections.append(sektorkodeSection)
        }
        
        if let naeringskode1 = company?.naeringskode1 {
            var naeringskode1Section = SectionCellData(header: NSLocalizedString("Naeringskode1-Section", comment: ""))
            naeringskode1Section.cells = buildNaeringskodeCells(naeringskode1)
            sections.append(naeringskode1Section)
        }
        
        if let naeringskode2 = company?.naeringskode2 {
            var naeringskode2Section = SectionCellData(header: NSLocalizedString("Naeringskode2-Section", comment: ""))
            naeringskode2Section.cells = buildNaeringskodeCells(naeringskode2)
            sections.append(naeringskode2Section)
        }
        
        if let naeringskode3 = company?.naeringskode3 {
            var naeringskode3Section = SectionCellData(header: NSLocalizedString("Naeringskode3-Section", comment: ""))
            naeringskode3Section.cells = buildNaeringskodeCells(naeringskode3)
            sections.append(naeringskode3Section)
        }
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        if company != nil {
            return sections.count
        } else {
            return 0
        }
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sections[section].cells.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return sections[indexPath.section].cells[indexPath.row]
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return sections[section].header
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let cellText = sections[indexPath.section].cells[indexPath.row].textLabel?.text {
            if cellText == NSLocalizedString("Detail-Website", comment: "") {
                self.performSegue(withIdentifier: "showWebView", sender: self)
            } else if cellText == NSLocalizedString("Detail-Parent", comment: "") {
                showParentCompany(company!.overordnetEnhet!)
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showWebView" {
            let webViewController = segue.destination as! WebViewController
            
            let hjemmeside = company!.hjemmeside!
            let range = hjemmeside.startIndex..<hjemmeside.index(hjemmeside.startIndex, offsetBy: 4)
            let substring = hjemmeside[range]
            if substring != "http" {
                webViewController.urlString = "http://" + hjemmeside
            } else {
                webViewController.urlString = hjemmeside
            }
        }
    }
    
    private func showParentCompany(_ organisasjonsnummer: String) {
        guard let encodedURL = "http://data.brreg.no/enhetsregisteret/api/enheter/\(organisasjonsnummer)"
            .addingPercentEncoding(withAllowedCharacters: .urlFragmentAllowed) else {
            print("Couldn't encode URL"); return
        }

        JSONUtil.retrieveCompany(encodedURL) { self.navigateToParentCompany($0) }
    }
    
    private func navigateToParentCompany(_ company: Company?) {
        if let comp = company {
            let firmDetailsTableViewController = self.storyboard?.instantiateViewController(
                withIdentifier: "FirmDetailsController"
            ) as! FirmDetailsTableViewController

            firmDetailsTableViewController.company = comp

            self.navigationController?.pushViewController(firmDetailsTableViewController, animated: true)
        } else {
            let alert = UIAlertController(
                title: NSLocalizedString("ErrorLoadingDataTitle", comment: ""),
                message: NSLocalizedString("ErrorLoadingDataMessage", comment: ""),
                preferredStyle: .alert
            )

            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }
}
