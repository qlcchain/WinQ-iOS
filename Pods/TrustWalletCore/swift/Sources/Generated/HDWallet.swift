// Copyright © 2017-2019 Trust Wallet.
//
// This file is part of Trust. The full Trust copyright notice, including
// terms governing use, modification, and redistribution, is contained in the
// file LICENSE at the root of the source code distribution tree.
//
// This is a GENERATED FILE, changes made here WILL BE LOST.
//

import Foundation

public final class HDWallet {

    public static func isValid(mnemonic: String) -> Bool {
        let mnemonicString = TWStringCreateWithNSString(mnemonic)
        defer {
            TWStringDelete(mnemonicString)
        }
        return TWHDWalletIsValid(mnemonicString)
    }

    public static func getPublicKeyFromExtended(extended: String, derivationPath: String) -> PublicKey? {
        let extendedString = TWStringCreateWithNSString(extended)
        defer {
            TWStringDelete(extendedString)
        }
        let derivationPathString = TWStringCreateWithNSString(derivationPath)
        defer {
            TWStringDelete(derivationPathString)
        }
        guard let value = TWHDWalletGetPublicKeyFromExtended(extendedString, derivationPathString) else {
            return nil
        }
        return PublicKey(rawValue: value)
    }

    public var seed: Data {
        return TWDataNSData(TWHDWalletSeed(rawValue))
    }

    public var mnemonic: String {
        return TWStringNSString(TWHDWalletMnemonic(rawValue))
    }

    let rawValue: OpaquePointer

    init(rawValue: OpaquePointer) {
        self.rawValue = rawValue
    }

    public init(strength: Int32, passphrase: String) {
        let passphraseString = TWStringCreateWithNSString(passphrase)
        defer {
            TWStringDelete(passphraseString)
        }
        rawValue = TWHDWalletCreate(Int32(strength), passphraseString)
    }

    public init(mnemonic: String, passphrase: String) {
        let mnemonicString = TWStringCreateWithNSString(mnemonic)
        defer {
            TWStringDelete(mnemonicString)
        }
        let passphraseString = TWStringCreateWithNSString(passphrase)
        defer {
            TWStringDelete(passphraseString)
        }
        rawValue = TWHDWalletCreateWithMnemonic(mnemonicString, passphraseString)
    }

    public init(data: Data, passphrase: String) {
        let dataData = TWDataCreateWithNSData(data)
        defer {
            TWDataDelete(dataData)
        }
        let passphraseString = TWStringCreateWithNSString(passphrase)
        defer {
            TWStringDelete(passphraseString)
        }
        rawValue = TWHDWalletCreateWithData(dataData, passphraseString)
    }

    deinit {
        TWHDWalletDelete(rawValue)
    }

    public func getMasterKey(curve: Curve) -> PrivateKey {
        return PrivateKey(rawValue: TWHDWalletGetMasterKey(rawValue, TWCurve(rawValue: curve.rawValue)))
    }

    public func getKeyForCoin(coin: CoinType) -> PrivateKey {
        return PrivateKey(rawValue: TWHDWalletGetKeyForCoin(rawValue, TWCoinType(rawValue: coin.rawValue)))
    }

    public func getAddressForCoin(coin: CoinType) -> String {
        return TWStringNSString(TWHDWalletGetAddressForCoin(rawValue, TWCoinType(rawValue: coin.rawValue)))
    }

    public func getKey(derivationPath: String) -> PrivateKey {
        let derivationPathString = TWStringCreateWithNSString(derivationPath)
        defer {
            TWStringDelete(derivationPathString)
        }
        return PrivateKey(rawValue: TWHDWalletGetKey(rawValue, derivationPathString))
    }

    public func getKeyBIP44(coin: CoinType, account: UInt32, change: UInt32, address: UInt32) -> PrivateKey {
        return PrivateKey(rawValue: TWHDWalletGetKeyBIP44(rawValue, TWCoinType(rawValue: coin.rawValue), account, change, address))
    }

    public func getExtendedPrivateKey(purpose: Purpose, coin: CoinType, version: HDVersion) -> String {
        return TWStringNSString(TWHDWalletGetExtendedPrivateKey(rawValue, TWPurpose(rawValue: purpose.rawValue), TWCoinType(rawValue: coin.rawValue), TWHDVersion(rawValue: version.rawValue)))
    }

    public func getExtendedPublicKey(purpose: Purpose, coin: CoinType, version: HDVersion) -> String {
        return TWStringNSString(TWHDWalletGetExtendedPublicKey(rawValue, TWPurpose(rawValue: purpose.rawValue), TWCoinType(rawValue: coin.rawValue), TWHDVersion(rawValue: version.rawValue)))
    }

}
