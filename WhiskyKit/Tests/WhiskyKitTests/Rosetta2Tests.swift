//
//  Rosetta2Tests.swift
//  Whisky
//
//  This file is part of Whisky.
//
//  Whisky is free software: you can redistribute it and/or modify it under the terms
//  of the GNU General Public License as published by the Free Software Foundation,
//  either version 3 of the License, or (at your option) any later version.
//
//  Whisky is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY;
//  without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
//  See the GNU General Public License for more details.
//
//  You should have received a copy of the GNU General Public License along with Whisky.
//  If not, see https://www.gnu.org/licenses/.
//

import Foundation
import Testing
@testable import WhiskyKit

struct Rosetta2Tests {
    @Test func successfulProbe() {
        #expect(Rosetta2.canRunIntelCode(
            executableURL: URL(fileURLWithPath: "/usr/bin/true"), arguments: []
        ))
    }

    @Test func failedProbe() {
        #expect(!Rosetta2.canRunIntelCode(
            executableURL: URL(fileURLWithPath: "/usr/bin/false"), arguments: []
        ))
    }

    @Test func missingExecutable() {
        #expect(!Rosetta2.canRunIntelCode(
            executableURL: URL(fileURLWithPath: "/nonexistent/whisky-rosetta-probe"), arguments: []
        ))
    }

    @Test func probeIsNotCached() {
        #expect(Rosetta2.canRunIntelCode(
            executableURL: URL(fileURLWithPath: "/usr/bin/true"), arguments: []
        ))
        #expect(!Rosetta2.canRunIntelCode(
            executableURL: URL(fileURLWithPath: "/usr/bin/false"), arguments: []
        ))
    }
}
