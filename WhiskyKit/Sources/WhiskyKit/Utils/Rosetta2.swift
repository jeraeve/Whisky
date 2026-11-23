//
//  Rosetta2.swift
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
import os.log

public class Rosetta2 {
    /// Probe actual x86_64 execution instead of depending on Apple's private runtime path.
    /// Re-evaluate after installation; a cached result stays false until the app restarts.
    public static var isRosettaInstalled: Bool {
        canRunIntelCode()
    }

    static func canRunIntelCode(
        executableURL: URL = URL(fileURLWithPath: "/usr/bin/arch"),
        arguments: [String] = ["-x86_64", "/usr/bin/true"]
    ) -> Bool {
        let process = Process()
        process.executableURL = executableURL
        process.arguments = arguments
        process.standardOutput = FileHandle.nullDevice
        process.standardError = FileHandle.nullDevice
        do {
            try process.run()
            process.waitUntilExit()
            return process.terminationReason == .exit && process.terminationStatus == 0
        } catch {
            return false
        }
    }

    public static func installRosetta() async throws -> Bool {
        let process = Process()
        let fileHandle = try Wine.makeFileHandle()

        process.executableURL = URL(fileURLWithPath: "/usr/sbin/softwareupdate")
        process.arguments = ["--install-rosetta", "--agree-to-license"]
        process.standardOutput = fileHandle
        process.standardError = fileHandle
        fileHandle.writeApplicaitonInfo()
        fileHandle.writeInfo(for: process)

        return try await withCheckedThrowingContinuation { continuation in
            process.terminationHandler = { (process: Process) in
                do {
                    try fileHandle.close()
                    continuation.resume(returning: process.terminationStatus == 0 && isRosettaInstalled)
                } catch {
                    Logger.wineKit.error("Error while closing file handle: \(error)")
                    continuation.resume(throwing: error)
                }
            }

            do {
                try process.run()
            } catch {
                try? fileHandle.close()
                continuation.resume(throwing: error)
            }
        }
    }
}
