//
//  CreateAll.m
//  TaiYiToken
//
//  Created by Frued on 2018/8/21.
//  Copyright © 2018年 Frued. All rights reserved.
//
#import <Foundation/Foundation.h>
#import "CreateAll.h"

@implementation CreateAll
/*
 *********************************************钱包生成/导入/恢复********************************************************
 */
/* 1 * 生成种子
 助记词由长度为128到256位的随机序列(熵)匹配词库而来，随后采用PBKDF2(Password-Based Key Derivation Function 2)推导出更长的种子(seed)。
 生成的种子被用来生成构建deterministic Wallet和推导钱包密钥。
 */
+(NSString *)CreateSeedByMnemonic:(NSString *)mnemonic Password:(NSString *)password{
   // mnemonic = @"breeze eternal fiction junior ethics lumber chaos squirrel code jar snack broccoli";
//    NSLog(@"mnemonic = %@",mnemonic);
    NSString *seed = [NYMnemonic deterministicSeedStringFromMnemonicString:mnemonic
                                                                passphrase:@""
                                                                language:@"english"];
    NSLog(@"seed = %@",seed);
    return seed;
}
/*
 根据mnemonic生成keystore,用于恢复账号，备份私钥，导出助记词等
 */
+(void)CreateKeyStoreByMnemonic:(NSString *)mnemonic WalletAddress:(NSString *)walletAddress Password:(NSString *)password  callback: (void (^)(Account *account, NSError *error))callback{
    Account *account = [Account accountWithMnemonicPhrase:mnemonic];
    if (account == nil) {
        callback(nil, nil);
    }
    [account encryptSecretStorageJSON:password callback:^(NSString *json) {
        NSLog(@"\n keystore(json) = %@",json);
        [Account decryptSecretStorageJSON:json password:password callback:^(Account *decryptedAccount, NSError *error) {
            if (![account.address isEqual:decryptedAccount.address]) {
                NSLog(@"keystore生成错误");
            }else{
                NSLog(@"\n\n\n** keystore 恢复 mnemonic ** = \n %@ \n\n\n",decryptedAccount.mnemonicPhrase);
                //按地址保存keystore
                [[NSUserDefaults standardUserDefaults] setObject:json forKey:[NSString stringWithFormat:@"keystore%@",walletAddress]];
            }
            callback(decryptedAccount,error);

        }];
    }];
}


/*
 根据PrivateKey生成keystore,用于恢复账号，备份私钥，导出助记词等
 */
+(void)CreateKeyStoreByPrivateKey:(NSString *)privatekey  WalletAddress:(NSString *)walletAddress Password:(NSString *)password  callback: (void (^)(Account *account, NSError *error))callback{
    Account *account = [Account accountWithPrivateKey:[NSData dataWithHexString:privatekey]];
    [account encryptSecretStorageJSON:password callback:^(NSString *json) {
        NSLog(@"\n keystore(json) = %@",json);
        [Account decryptSecretStorageJSON:json password:password callback:^(Account *decryptedAccount, NSError *error) {
            if (![account.address isEqual:decryptedAccount.address]) {
                NSLog(@"keystore生成错误");
            }else{
                NSLog(@"\n\n\n** keystore 恢复 mnemonic ** = \n %@ \n\n\n",decryptedAccount.mnemonicPhrase);
                //按密码保存keystore
                [[NSUserDefaults standardUserDefaults] setObject:json forKey:[NSString stringWithFormat:@"keystore%@",walletAddress]];
            }
            callback(decryptedAccount,error);
            
        }];
    }];
}


//扩展主公钥生成
+(NSString *)CreateMasterPublicKeyWithSeed:(NSString *)seed{
    BRBIP32Sequence *seq = [BRBIP32Sequence new];
    NSData *mpk = [seq masterPublicKeyFromSeed:seed.hexToData];
    [[NSUserDefaults standardUserDefaults] setObject:mpk forKey:@"masterPublicKey"];
    //mpk前4位为较验位
    NSString *mpkstr = [NSString hexWithData:mpk];
    return  mpkstr;
}

//取主公钥
+(NSData *)GetMasterPublicKey{
    NSData *mpk = [[NSUserDefaults standardUserDefaults] objectForKey:@"masterPublicKey"];
    if (mpk == nil || [mpk isEqual:[NSNull null]]) {
        return nil;
    }
    return mpk;
}


//扩展账号私钥生成  BIP32 Root Key
+(NSString *)CreateExtendPrivateKeyWithSeed:(NSString *)seed{
    BRBIP32Sequence *seq = [BRBIP32Sequence new];
    //**********BIP32SequenceSerializedPrivateMasterFromSeed
    NSString *xprv = [seq serializedPrivateMasterFromSeed:seed.hexToData];
    
    NSLog(@"xprv = %@",xprv);
    return  xprv;
}

//扩展账号公钥生成
+(NSString *)CreateExtendPublicWithSeed:(NSString *)seed{
    BRBIP32Sequence *seq = [BRBIP32Sequence new];
    NSData *mpk = [seq masterPublicKeyFromSeed:seed.hexToData];
  //*********BIP32SequenceSerializedMasterPublicKey 对应的是"m/0'" (hardened child #0 of the root key)
    NSString *xpub = [seq serializedMasterPublicKey:mpk];
    NSLog(@"xpub = %@",xpub);
    return  xpub;
}
//根据扩展公钥生成index索引的子BTCKey，用于增加BTC子地址
+(BTCKey *)CreateBTCAddressAtIndex:(UInt32)index ExtendKey:(NSString *)extendedPublicKey{
    BTCKeychain* pubchain = [[BTCKeychain alloc] initWithExtendedKey:extendedPublicKey];
    BTCKey* key = [pubchain keyAtIndex:index];
    return key;
}

/*
 由扩展私钥生成钱包
 指定钱包索引，币种两个参数
 xprv,index,coinType
 */
+(MissionWallet *)CreateWalletByXprv:(NSString*)xprv index:(UInt32)index CoinType:(CoinType)coinType{
   // BTCKeychain *masterchain = [[BTCKeychain alloc]initWithSeed:seed.hexToData];
    MissionWallet *wallet = [MissionWallet new];
    wallet.coinType = coinType;
    
    BTCKeychain *btckeychainxprv = [[BTCKeychain alloc]initWithExtendedKey:xprv];
    
    //Account Extendedm
    NSString *AccountPath = [NSString stringWithFormat:@"m/44'/%d'/0'",coinType];
    NSLog(@"\n\n path = %@\n\n",AccountPath);
    NSString *AccountExtendedPrivateKey  =  [btckeychainxprv derivedKeychainWithPath:AccountPath].extendedPrivateKey;
    NSString *AccountExtendedPublicKey  = [btckeychainxprv derivedKeychainWithPath:AccountPath].extendedPublicKey;
    NSLog(@"\n *** Account Extended ***\n pri = %@ \n pub = %@",AccountExtendedPrivateKey,AccountExtendedPublicKey);
   // BIP32 Extended
    NSString *BIP32Path = [NSString stringWithFormat:@"m/44'/%d'/0'/0",coinType];
    NSString *BIP32ExtendedPrivateKey = [btckeychainxprv derivedKeychainWithPath:BIP32Path].extendedPrivateKey;
    NSString *BIP32ExtendedPublicKey = [btckeychainxprv derivedKeychainWithPath:BIP32Path].extendedPublicKey;
    NSLog(@"\n *** BIP32 Extended ***\n pri = %@ \n pub = %@",BIP32ExtendedPrivateKey,BIP32ExtendedPublicKey);
    
    wallet.AccountExtendedPrivateKey = AccountExtendedPrivateKey;
    wallet.AccountExtendedPublicKey = AccountExtendedPublicKey;
    wallet.BIP32ExtendedPrivateKey = BIP32ExtendedPrivateKey;
    wallet.BIP32ExtendedPublicKey = BIP32ExtendedPublicKey;
    
    //第一个地址和私钥m/44'/0'/0'/0  m/44'/60'/0'/0
    BTCKey* key = [[btckeychainxprv derivedKeychainWithPath:BIP32Path] keyAtIndex:index];
    if(coinType == BTC){
        NSString *compressedPublicKeyAddress = key.compressedPublicKeyAddress.string;
        NSString *privateKey = key.privateKeyAddress.string;
        NSString *compressedPublicKey = [NSString hexWithData:key.compressedPublicKey];
        wallet.privateKey = privateKey;
        wallet.publicKey = compressedPublicKey;
        wallet.address = compressedPublicKeyAddress;
        wallet.addressarray = [@[compressedPublicKeyAddress] mutableCopy];
        wallet.index = index;
        NSLog(@"\n BTC  privateKey= %@\n Address = %@\n  PublicKey = %@\n",privateKey,compressedPublicKeyAddress, compressedPublicKey);
        
    }else{
        Account *account = [Account accountWithPrivateKey:key.privateKeyAddress.data];
        NSString *privateKey = [NSString hexWithData:key.privateKeyAddress.data];
        NSString *compressedPublicKey = [NSString hexWithData:key.compressedPublicKey];
        wallet.privateKey = privateKey;
        wallet.publicKey = compressedPublicKey;
        wallet.address = account.address.checksumAddress;
        wallet.addressarray = [@[account.address.checksumAddress] mutableCopy];
        wallet.index = index;
        NSLog(@"\n ETH  privateKey= %@\n Address = %@\n  PublicKey = %@\n",privateKey,account.address.checksumAddress, compressedPublicKey);
    }
    wallet.walletName = @"";
    wallet.walletType = LOCAL_WALLET;//类型标记为本地生成
    wallet.importType = LOCAL_CREATED_WALLET;//类型标记为本地生成
    wallet.selectedBTCAddress = wallet.address;
    wallet.passwordHint = @"";
    return wallet;
}


//生成地址二维码
+(UIImage *)CreateQRCodeForAddress:(NSString *)address{
    if (address == nil || [address isEqualToString:@""]) {
        return nil;
    }
    UIImage *QRCodeImage = [BTCQRCode imageForString:address size:CGSizeMake(180, 180) scale:1.0];
    return QRCodeImage;
}

/*
************************************  导入  **************************************************
 BTC -> 助记词，私钥
 ETH -> keyStore,助记词，私钥
*/

//由助记词导入钱包 （存储钱包 生成存储KeyStore）
/*
 return nil; 表示钱包已存在
 */
+(void)ImportWalletByMnemonic:(NSString *)mnemonic CoinType:(CoinType)coinType Password:(NSString *)password PasswordHint:(NSString *)passwordHint callback: (void (^)(MissionWallet *wallet, NSError *error))completionHandler{
    NSString *seed = [CreateAll CreateSeedByMnemonic:mnemonic Password:password];
    NSString *xprv = [CreateAll CreateExtendPrivateKeyWithSeed:seed];
    MissionWallet *wallet = [CreateAll CreateWalletByXprv:xprv index:0 CoinType:coinType];
    [CreateAll CreateKeyStoreByMnemonic:mnemonic  WalletAddress:wallet.address Password:password callback:^(Account *account, NSError *error) {
    }];
    wallet.walletName = [CreateAll GenerateNewWalletNameWithWalletAddress:wallet.address CoinType:coinType];
    if ([wallet.walletName isEqualToString:@"exist"]) {
        NSString *domain = @"";
        NSString *desc = NSLocalizedString(@"wallet already exist!", @"");
        NSDictionary *userInfo = @{ NSLocalizedDescriptionKey : desc };
        NSError *error = [NSError errorWithDomain:domain
                                             code:-101
                                         userInfo:userInfo];
        completionHandler(nil,error);
    }

    wallet.importType = IMPORT_BY_MNEMONIC;
    
    //存KeyStore
    [CreateAll CreateKeyStoreByMnemonic:mnemonic WalletAddress:wallet.address Password:password callback:^(Account *account, NSError *error) {
        if (account == nil) {//说明出错
            completionHandler(nil,nil);
        }else{
            if (!error) {//无错误
                //存钱包
                [CreateAll SaveWallet:wallet Name:wallet.walletName WalletType:IMPORT_WALLET];
                completionHandler(wallet,nil);
            }
        }
    }];
   
}

//由私钥导入钱包 （存储钱包 生成存储KeyStore）
/*
return nil; 表示钱包已存在
 */
+(MissionWallet *)ImportWalletByPrivateKey:(NSString *)privateKey CoinType:(CoinType)coinType Password:(NSString *)password PasswordHint:(NSString *)passwordHint{
    BTCKey *key = [[BTCKey alloc]initWithPrivateKey:[NSData dataWithHexString:privateKey]];
    if ([key.privateKey isEqual:[NSNull null]] || [key.publicKey isEqual:[NSNull null]]) {
        return nil;
    }
    if (key.privateKey == nil || key.publicKey == nil) {
        return nil;
    }
    MissionWallet *wallet = [MissionWallet new];
    wallet.coinType = coinType;
    wallet.AccountExtendedPrivateKey = @"";
    wallet.AccountExtendedPublicKey = @"";
    wallet.BIP32ExtendedPrivateKey = @"";
    wallet.BIP32ExtendedPublicKey = @"";
    wallet.privateKey = [NSString hexWithData:key.privateKeyAddress.data];
    wallet.publicKey = [NSString hexWithData:key.compressedPublicKey];
    if (coinType == BTC) {
        wallet.address = key.compressedPublicKeyAddress.string;
    }else{
        Account *account = [Account accountWithPrivateKey:key.privateKeyAddress.data];
        wallet.address = account.address.checksumAddress;
    }
    wallet.addressarray = [@[wallet.address] mutableCopy];
    wallet.index = 0;
    wallet.walletType = IMPORT_WALLET;
    wallet.selectedBTCAddress = wallet.address;
    wallet.passwordHint = passwordHint;
    wallet.index = [CreateAll GetCurrentImportWalletIndexWithWalletAddress:wallet.address CoinType:coinType];
    wallet.walletName = [CreateAll GenerateNewWalletNameWithWalletAddress:wallet.address CoinType:coinType];
    if ([wallet.walletName isEqualToString:@"exist"]) {
        return nil;
    }
    wallet.importType = IMPORT_BY_PRIVATEKEY;
    [CreateAll SaveWallet:wallet Name:wallet.walletName WalletType:IMPORT_WALLET];
    [CreateAll CreateKeyStoreByPrivateKey:wallet.privateKey WalletAddress:wallet.address Password:password callback:^(Account *account, NSError *error) {
    }];
    return wallet;
}

//由KeyStore导入钱包 （存储钱包 生成存储KeyStore）
/*
 callback(wallet,error); wallet == nil; 表示钱包已存在
 */
+(void)ImportWalletByKeyStore:(NSString *)keystore  CoinType:(CoinType)coinType Password:(NSString *)password PasswordHint:(NSString *)passwordHint callback: (void (^)(MissionWallet *wallet, NSError *error))callback{
    [Account decryptSecretStorageJSON:keystore password:password callback:^(Account *decryptedAccount, NSError *error) {
        NSString *privateKey = [NSString hexWithData:decryptedAccount.privateKey];
        MissionWallet *wallet = [CreateAll ImportWalletByPrivateKey:privateKey CoinType:coinType Password:(NSString *)password PasswordHint:passwordHint];
        if (wallet == nil) {
            callback(nil,error);
        }else{
            wallet.importType = IMPORT_BY_KEYSTORE;
            [CreateAll SaveWallet:wallet Name:wallet.walletName WalletType:IMPORT_WALLET];
            callback(wallet,error);
        }
       
    }];
}
//移除导入的钱包
/*
 return @"WalletType is LOCAL_WALLET !";
 return @"Delete WalletName Failed!";
 return @"Delete Wallet Failed!";
 return @"Delete Successed!"; 成功
 */
+(NSString *)RemoveImportedWallet:(MissionWallet *)wallet{
    //只能移除导入的钱包
    if (wallet.walletType == LOCAL_WALLET) {
        return @"WalletType is LOCAL_WALLET !";
    }
    NSString *walletname = @"";
    if (wallet.coinType == BTC) {
        walletname = [NSString stringWithFormat:@"BTCWalletImported%d",wallet.index];
    }else{
        walletname = [NSString stringWithFormat:@"ETHWalletImported%d",wallet.index];
    }
    //移除钱包名
    BOOL deleteName = [CreateAll DeleteWalletFromImportWalletNameArray:walletname];
    //移除钱包
    BOOL deleteWallet = [CreateAll DeleteWallet:wallet.address WalletName:walletname];
    if (deleteName == NO) {
        return @"Delete WalletName Failed!";
    }
    if (deleteWallet == NO) {
        return @"Delete Wallet Failed!";
    }
    return @"Delete Successed!";
}
//获取当前导入钱包的index
/*
return -1;表示已存在
 */
+(int)GetCurrentImportWalletIndexWithWalletAddress:(NSString *)address CoinType:(CoinType)coinType{
    //查询本地导入数组中是否已经存在
    int importindex = 0;
    NSArray *importnamearray = [CreateAll GetImportWalletNameArray];
    for (NSString *name in importnamearray) {
        MissionWallet *miswallet = [CreateAll GetMissionWalletByName:name];
        if ([address isEqualToString:miswallet.address]) {
            return -1;
        }else{
            if (miswallet.coinType == coinType) {
                importindex ++;//标记是第几个BTC/ETH钱包
            }
        }
    }
    return importindex;
}
//生成新导入钱包的名称
/*
 return @"exist";表示已存在
 */
+(NSString *)GenerateNewWalletNameWithWalletAddress:(NSString *)address CoinType:(CoinType)coinType{
    //查询本地生成数组中是否已经存在
    NSArray *namearray = [CreateAll GetWalletNameArray];
    for (NSString *name in namearray) {
        MissionWallet *miswallet = [CreateAll GetMissionWalletByName:name];
        if ([address isEqualToString:miswallet.address]) {
            return @"exist";
        }
    }
    //查询本地导入数组中是否已经存在
    NSInteger importindex = 0;
    NSArray *importnamearray = [CreateAll GetImportWalletNameArray];
    for (NSString *name in importnamearray) {
        MissionWallet *miswallet = [CreateAll GetMissionWalletByName:name];
        if ([address isEqualToString:miswallet.address]) {
            return @"exist";
        }else{
            if (miswallet.coinType == coinType) {
                importindex ++;//标记是第几个BTC/ETH钱包
            }
        }
    }
    //本地不存在，存储
    NSString *savewalletname = @"";
    if (coinType == BTC) {
        savewalletname = [NSString stringWithFormat:@"BTCWalletImported%ld",importindex];
    }else{
        savewalletname = [NSString stringWithFormat:@"ETHWalletImported%ld",importindex];
    }
    return savewalletname;
}


/*
 ************************************************ 钱包导出 *********************************************************************
 */
//导出keystore
+(void)ExportKeyStoreByPassword:(NSString *)password  WalletAddress:(NSString *)walletAddress callback: (void (^)(NSString *address, NSError *error))callback{
    NSString *json = [[NSUserDefaults standardUserDefaults]  objectForKey:[NSString stringWithFormat:@"keystore%@",walletAddress]];
    NSLog(@"json = %@",json);
    if (json == nil || [json isEqual:[NSNull null]]) {
        callback(@"wrong password！",nil);
        return;
    }
    [Account decryptSecretStorageJSON:json password:password callback:^(Account *decryptedAccount, NSError *error) {
        callback(decryptedAccount.address.checksumAddress,error);
    }];
}
//导出助记词
+(void)ExportMnemonicByPassword:(NSString *)password WalletAddress:(NSString *)walletAddress callback: (void (^)(NSString *mnemonic, NSError *error))callback{
    NSString *json = [[NSUserDefaults standardUserDefaults]  objectForKey:[NSString stringWithFormat:@"keystore%@",walletAddress]];
    if (json == nil || [json isEqual:[NSNull null]]) {
        callback(@"wrong password！",nil);
        return;
    }
    [Account decryptSecretStorageJSON:json password:password callback:^(Account *decryptedAccount, NSError *error) {
        callback(decryptedAccount.mnemonicPhrase,error);
    }];
}
//导出私钥
+(void)ExportPrivateKeyByPassword:(NSString *)password CoinType:(CoinType)coinType WalletAddress:(NSString *)walletAddress  index:(UInt32)index  callback: (void (^)(NSString *privateKey, NSError *error))callback{
    NSString *json = [[NSUserDefaults standardUserDefaults]  objectForKey:[NSString stringWithFormat:@"keystore%@",walletAddress]];
    if (json == nil || [json isEqual:[NSNull null]]) {
        callback(@"wrong password！",nil);
        return;
    }
    [Account decryptSecretStorageJSON:json password:password callback:^(Account *decryptedAccount, NSError *error) {
        NSString *hexprivatekey = [NSString hexWithData:decryptedAccount.privateKey];
        callback(hexprivatekey,error);
    }];
}

/*
 ********************************************** 钱包账号存取管理 *******************************************************************
 */
//清空所有钱包，退出账号
+(void)RemoveAllWallet{
    [CreateAll clearAllUserDefaultsData];
}

/**
 *  清除所有的存储本地的数据
 */
+ (void)clearAllUserDefaultsData
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    
    NSDictionary *dic = [userDefaults dictionaryRepresentation];
    for (id  key in dic) {
        [userDefaults removeObjectForKey:key];
    }
    [userDefaults synchronize];
}

//取得所有钱包名称（不包含导入）
+(NSArray *)GetWalletNameArray{
   NSArray *walletarray = [[NSUserDefaults standardUserDefaults]  objectForKey:@"walletArray"];
   return walletarray;
}

//取得所有导入的钱包名称
+(NSArray *)GetImportWalletNameArray{
    NSArray *walletarray = [[NSUserDefaults standardUserDefaults]  objectForKey:@"importwalletArray"];
    return walletarray;
}


//根据钱包名称取钱包
+(MissionWallet *)GetMissionWalletByName:(NSString *)walletname{
    NSData *walletdata =  [[NSUserDefaults standardUserDefaults] objectForKey:walletname];
    if (walletdata == nil || [walletdata isEqual:@""]) {
        return nil;
    }
    MissionWallet *wallet =  [NSKeyedUnarchiver unarchiveObjectWithData:walletdata];
    return wallet;
}

//存储钱包
+(void)SaveWallet:(MissionWallet *)wallet Name:(NSString *)walletname WalletType:(WALLET_TYPE)walletType{
    wallet.walletName = walletname;
    wallet.walletType = walletType;
    //1.存钱包
    NSData *walletdata = [NSKeyedArchiver archivedDataWithRootObject:wallet];
    [[NSUserDefaults standardUserDefaults] setObject:walletdata forKey:walletname];
    //2.存钱包名
    //如果是本地创建类型 存储到本地钱包名数组
    if (walletType == LOCAL_WALLET) {
        NSMutableArray *oldwalletarray = [[[NSUserDefaults standardUserDefaults]  objectForKey:@"walletArray"] mutableCopy];
        if (oldwalletarray == nil || ![oldwalletarray containsObject:walletname]) {
            if (oldwalletarray == nil) {
                oldwalletarray = [NSMutableArray array];
            }
            [oldwalletarray addObject:walletname];
            NSMutableArray *newwalletarray = [oldwalletarray mutableCopy];
            [[NSUserDefaults standardUserDefaults]  setObject:newwalletarray forKey:@"walletArray"];
        }
    }
    //如果是导入类型 存储到导入钱包名数组
    if (walletType == IMPORT_WALLET) {
       
        NSMutableArray *oldimportwalletarray = [[[NSUserDefaults standardUserDefaults]  objectForKey:@"importwalletArray"] mutableCopy];
        if (oldimportwalletarray == nil || ![oldimportwalletarray containsObject:walletname]) {
            if (oldimportwalletarray == nil) {
                oldimportwalletarray = [NSMutableArray array];
            }
            [oldimportwalletarray addObject:walletname];
            NSMutableArray *newimportwalletarray = [oldimportwalletarray mutableCopy];
            [[NSUserDefaults standardUserDefaults]  setObject:newimportwalletarray forKey:@"importwalletArray"];
        }
    }
}
//移除钱包名
+(BOOL)DeleteWalletFromImportWalletNameArray:(NSString *)walletname{
    NSMutableArray *oldimportwalletarray = [[[NSUserDefaults standardUserDefaults]  objectForKey:@"importwalletArray"] mutableCopy];
    if ([oldimportwalletarray containsObject:walletname]) {
        [oldimportwalletarray removeObject:walletname];
        NSMutableArray *newimportwalletarray = [oldimportwalletarray mutableCopy];
        [[NSUserDefaults standardUserDefaults]  setObject:newimportwalletarray forKey:@"importwalletArray"];
        return YES;
    }else{
        return NO;
    }
}
//移除钱包
+(BOOL)DeleteWallet:(NSString *)walletaddress WalletName:(NSString *)walletname{
    MissionWallet *miswallet = [CreateAll GetMissionWalletByName:walletname];
    if ([walletaddress isEqualToString:miswallet.address]) {
        [[NSUserDefaults standardUserDefaults] setObject:@"" forKey:walletname];
        return YES;
    }else{
        return NO;
    }
}


@end
