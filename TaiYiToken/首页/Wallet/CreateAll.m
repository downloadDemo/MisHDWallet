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
    mnemonic = @"breeze eternal fiction junior ethics lumber chaos squirrel code jar snack broccoli";
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
+(void)CreateKeyStoreByMnemonic:(NSString *)mnemonic Password:(NSString *)password  callback: (void (^)(Account *account, NSError *error))callback{
    Account *account = [Account accountWithMnemonicPhrase:mnemonic];
    [account encryptSecretStorageJSON:password callback:^(NSString *json) {
        NSLog(@"\n keystore(json) = %@",json);
        [Account decryptSecretStorageJSON:json password:password callback:^(Account *decryptedAccount, NSError *error) {
            if (![account.address isEqual:decryptedAccount.address]) {
                NSLog(@"keystore生成错误");
            }else{
                NSLog(@"\n\n\n** keystore 恢复 mnemonic ** = \n %@ \n\n\n",decryptedAccount.mnemonicPhrase);
                //按密码保存keystore
                [[NSUserDefaults standardUserDefaults] setObject:json forKey:[NSString stringWithFormat:@"keystore%@",password]];
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
    if (mpk == nil || mpk == [NSNull null]) {
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
//根据扩展公钥生成index索引的子BTCKey
+(BTCKey *)CreateBTCAddressAtIndex:(UInt32)index ExtendKey:(NSString *)extendedPublicKey{
    BTCKeychain* pubchain = [[BTCKeychain alloc] initWithExtendedKey:extendedPublicKey];
    BTCKey* key = [pubchain keyAtIndex:index];
    return key;
}





/*
 由扩展私钥生成钱包，指定钱包索引，币种两个参数
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
    wallet.selectedBTCAddress = wallet.address;
    return wallet;
}

//从keystore恢复账号
+(void)RecoverAccountByPassword:(NSString *)password callback: (void (^)(Account *account, NSError *error))callback{
    NSString *json = [[NSUserDefaults standardUserDefaults]  objectForKey:[NSString stringWithFormat:@"keystore%@",password]];
    if (json == nil || json == [NSNull null]) {
        callback(@"wrong password！",nil);
        return;
    }
    [Account decryptSecretStorageJSON:json password:password callback:^(Account *decryptedAccount, NSError *error) {
        callback(decryptedAccount,error);
    }];
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
*/
//由私钥导入钱包
+(MissionWallet *)ImportWalletByPrivateKey:(NSString *)privateKey CoinType:(CoinType)coinType{
    BTCKey *key = [[BTCKey alloc]initWithPrivateKey:privateKey.dataValue];
    
    MissionWallet *wallet = [MissionWallet new];
    wallet.coinType = coinType;
    wallet.AccountExtendedPrivateKey = @"";
    wallet.AccountExtendedPublicKey = @"";
    wallet.BIP32ExtendedPrivateKey = @"";
    wallet.BIP32ExtendedPublicKey = @"";
    
    wallet.privateKey = key.privateKeyAddress.string;;
    wallet.publicKey = [NSString hexWithData:key.compressedPublicKey];
    if (coinType == BTC) {
        wallet.address = key.compressedPublicKeyAddress.string;
    }else{
        Account *account = [Account accountWithPrivateKey:key.privateKeyAddress.data];
        wallet.address = account.address.checksumAddress;
    }
    wallet.addressarray = [@[wallet.address] mutableCopy];
    wallet.index = 0;
    
    
    wallet.walletType = IMPORT_WALLET;//类型标记为本地生成
    wallet.selectedBTCAddress = wallet.address;
    
    //查询本地生成数组中是否已经存在
    NSArray *namearray = [CreateAll GetWalletNameArray];
    for (NSString *name in namearray) {
        MissionWallet *miswallet = [CreateAll GetMissionWalletByName:name];
        if ([wallet.address isEqualToString:miswallet.address]) {
            return nil;
        }
    }
    //查询本地导入数组中是否已经存在
    NSInteger importindex = 0;
    NSArray *importnamearray = [CreateAll GetImportWalletNameArray];
    for (NSString *name in importnamearray) {
        MissionWallet *miswallet = [CreateAll GetMissionWalletByName:name];
        if ([wallet.address isEqualToString:miswallet.address]) {
            return nil;
        }else{
            if (miswallet.coinType == wallet.coinType) {
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
    wallet.walletName = savewalletname;
    return wallet;
}

/*
 ************************************************ 钱包导出 *********************************************************************
 */
//导出keystore
+(void)ExportKeyStoreByPassword:(NSString *)password  callback: (void (^)(NSString *address, NSError *error))callback{
    NSString *json = [[NSUserDefaults standardUserDefaults]  objectForKey:[NSString stringWithFormat:@"keystore%@",password]];
    NSLog(@"json = %@",json);
    if (json == nil || json == [NSNull null]) {
        callback(@"wrong password！",nil);
        return;
    }
    [Account decryptSecretStorageJSON:json password:password callback:^(Account *decryptedAccount, NSError *error) {
        callback(decryptedAccount.address.checksumAddress,error);
    }];
}
//导出助记词
+(void)ExportMnemonicByPassword:(NSString *)password  callback: (void (^)(NSString *mnemonic, NSError *error))callback{
    NSString *json = [[NSUserDefaults standardUserDefaults]  objectForKey:[NSString stringWithFormat:@"keystore%@",password]];
    if (json == nil || json == [NSNull null]) {
        callback(@"wrong password！",nil);
        return;
    }
    [Account decryptSecretStorageJSON:json password:password callback:^(Account *decryptedAccount, NSError *error) {
        callback(decryptedAccount.mnemonicPhrase,error);
    }];
}
//导出私钥
+(void)ExportPrivateKeyByPassword:(NSString *)password CoinType:(CoinType)coinType index:(UInt32)index  callback: (void (^)(NSString *privateKey, NSError *error))callback{
    NSString *json = [[NSUserDefaults standardUserDefaults]  objectForKey:[NSString stringWithFormat:@"keystore%@",password]];
    if (json == nil || json == [NSNull null]) {
        callback(@"wrong password！",nil);
        return;
    }
    [Account decryptSecretStorageJSON:json password:password callback:^(Account *decryptedAccount, NSError *error) {
        NSString *seed = [CreateAll CreateSeedByMnemonic:decryptedAccount.mnemonicPhrase Password:password];
        NSString *xprv = [CreateAll CreateExtendPrivateKeyWithSeed:seed];
        MissionWallet *wallet = [CreateAll CreateWalletByXprv:xprv index:index CoinType:coinType];
        callback(wallet.privateKey,error);
    }];
}

/*
 ********************************************** 钱包账号存取管理 *******************************************************************
 */
//清空所有钱包，退出账号
+(void)RemoveAllWallet{
    [[NSUserDefaults standardUserDefaults]  setBool:NO forKey:@"ifHasAccount"];
    NSArray *walletnamearray = [CreateAll GetWalletNameArray];
    for (NSString *walletname in walletnamearray) {
        [[NSUserDefaults standardUserDefaults] setObject:@"" forKey:walletname];
    }
    NSArray *array = @[];
    [[NSUserDefaults standardUserDefaults]  setObject:array forKey:@"walletArray"];
    [[NSUserDefaults standardUserDefaults]  setObject:array forKey:@"importwalletArray"];
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
    if (walletdata == nil) {
        return nil;
    }
    MissionWallet *wallet =  [NSKeyedUnarchiver unarchiveObjectWithData:walletdata];
    return wallet;
}

//存储钱包
+(void)SaveWallet:(MissionWallet *)wallet Name:(NSString *)walletname WalletType:(WALLET_TYPE)walletType{
    wallet.walletName = walletname;
    //存钱包
    NSData *walletdata = [NSKeyedArchiver archivedDataWithRootObject:wallet];
    [[NSUserDefaults standardUserDefaults] setObject:walletdata forKey:walletname];
    //存钱包名到钱包名数组
    //如果是本地创建类型 存储到本地钱包名数组
    if (walletType == LOCAL_WALLET) {
        NSMutableArray *oldwalletarray = [[[NSUserDefaults standardUserDefaults]  objectForKey:@"walletArray"] mutableCopy];
        if (![oldwalletarray containsObject:walletname]) {
            [oldwalletarray addObject:walletname];
            NSMutableArray *newwalletarray = [oldwalletarray mutableCopy];
            [[NSUserDefaults standardUserDefaults]  setObject:newwalletarray forKey:@"walletArray"];
        }
    }
    //如果是导入类型 存储到导入钱包名数组
    if (walletType == IMPORT_WALLET) {
        NSMutableArray *oldimportwalletarray = [[[NSUserDefaults standardUserDefaults]  objectForKey:@"importwalletArray"] mutableCopy];
        if (![oldimportwalletarray containsObject:walletname]) {
            [oldimportwalletarray addObject:walletname];
            NSMutableArray *newimportwalletarray = [oldimportwalletarray mutableCopy];
            [[NSUserDefaults standardUserDefaults]  setObject:newimportwalletarray forKey:@"importwalletArray"];
        }
    }
}


/***********************************************************/

/***********************************************************/

/***********************************************************/

/***********************************************************/

/***********************************************************/
+(void)GetBitcoinWalletBalanceForAddress:(NSString *)address{
    
}
//Bitcoin转账
+(void)TransitionBitcoinToAddress:(NSString *)address Password:(NSString *)password  amount:(BTCAmount)amount
                              fee:(BTCAmount)fee
                              api:(BTCAPI)btcApi{
    
    [CreateAll RecoverAccountByPassword:password callback:^(Account *account, NSError *error) {
       
       
        BTCKey* key = [[BTCKey alloc] initWithPrivateKey:account.privateKey];
        
        NSLog(@"Address: %@", key.compressedPublicKeyAddress);
        
        if (![@"1TipsuQ7CSqfQsjA9KU5jarSB1AnrVLLo" isEqualToString:key.compressedPublicKeyAddress.string]) {
            NSLog(@"WARNING: incorrect private key is supplied");
            return;
        }
        
        NSError* trerror = nil;
        BTCTransaction* transaction = [self transactionSpendingFromPrivateKey:account.privateKey
                                                                           to:[BTCPublicKeyAddress addressWithString:address]
                                                                       change:key.compressedPublicKeyAddress
                                                                       amount:amount
                                                                          fee:fee
                                                                          api:btcApi
                                                                        error:&trerror];
        
        if (!transaction) {
            NSLog(@"Can't make a transaction: %@", error);
        }
        
        NSLog(@"transaction = %@", transaction.dictionary);
        NSLog(@"transaction in hex:\n------------------\n%@\n------------------\n", BTCHexFromData([transaction data]));
        
        NSLog(@"Sending in 5 sec...");
        sleep(5);
        NSLog(@"Sending...");
        sleep(1);
        NSURLRequest* req = [[[BTCChainCom alloc] initWithToken:@"Free API Token form chain.com"] requestForTransactionBroadcastWithData:[transaction data]];
        NSData* data = [NSURLConnection sendSynchronousRequest:req returningResponse:nil error:nil];
        NSLog(@"Broadcast result: data = %@", data);
        NSLog(@"string = %@", [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding]);
        
    }];
    
}

+ (BTCTransaction*) transactionSpendingFromPrivateKey:(NSData*)privateKey
                                                   to:(BTCPublicKeyAddress*)destinationAddress
                                               change:(BTCPublicKeyAddress*)changeAddress
                                               amount:(BTCAmount)amount
                                                  fee:(BTCAmount)fee
                                                  api:(BTCAPI)btcApi
                                                error:(NSError**)errorOut
{
    // 1. Get a private key, destination address, change address and amount
    // 2. Get unspent outputs for that key (using both compressed and non-compressed pubkey)
    // 3. Take the smallest available outputs to combine into the inputs of new transaction
    // 4. Prepare the scripts with proper signatures for the inputs
    // 5. Broadcast the transaction
    
    BTCKey* key = [[BTCKey alloc] initWithPrivateKey:privateKey];
    
    NSError* error = nil;
    NSArray* utxos = nil;
    
    switch (btcApi) {
        case BTCAPIBlockchain: {
            BTCBlockchainInfo* bci = [[BTCBlockchainInfo alloc] init];
            utxos = [bci unspentOutputsWithAddresses:@[ key.compressedPublicKeyAddress ] error:&error];
            break;
        }
        case BTCAPIChain: {
            BTCChainCom* chain = [[BTCChainCom alloc] initWithToken:@"Free API Token form chain.com"];
            utxos = [chain unspentOutputsWithAddress:key.compressedPublicKeyAddress error:&error];
            break;
        }
        default:
            break;
    }
    
    NSLog(@"UTXOs for %@: %@ %@", key.compressedPublicKeyAddress, utxos, error);
    
    // Can't download unspent outputs - return with error.
    if (!utxos) {
        *errorOut = error;
        return nil;
    }
    
    
    // Find enough outputs to spend the total amount.
    BTCAmount totalAmount = amount + fee;
    BTCAmount dustThreshold = 100000; // don't want less than 1mBTC in the change.
    
    // We need to avoid situation when change is very small. In such case we should leave smallest coin alone and add some bigger one.
    // Ideally, we need to maintain more-or-less binary distribution of coins: having 0.001, 0.002, 0.004, 0.008, 0.016, 0.032, 0.064, 0.128, 0.256, 0.512, 1.024 etc.
    // Another option is to spend a coin which is 2x bigger than amount to be spent.
    // Desire to maintain a certain distribution of change to closely match the spending pattern is the best strategy.
    // Yet another strategy is to minimize both current and future spending fees. Thus, keeping number of outputs low and change sum above "dust" threshold.
    
    // For this test we'll just choose the smallest output.
    
    // 1. Sort outputs by amount
    // 2. Find the output that is bigger than what we need and closer to 2x the amount.
    // 3. If not, find a bigger one which covers the amount + reasonably big change (to avoid dust), but as small as possible.
    // 4. If not, find a combination of two outputs closer to 2x amount from the top.
    // 5. If not, find a combination of two outputs closer to 1x amount with enough change.
    // 6. If not, find a combination of three outputs.
    // Maybe Monte Carlo method is a way to go.
    
    
    // Another way:
    // Find the minimum number of txouts by scanning from the biggest one.
    // Find the maximum number of txouts by scanning from the lowest one.
    // Scan with a minimum window increasing it if needed if no good enough change can be found.
    // Yet another option: finding combinations so the below-the-dust change can go to miners.
    
    
    // Sort utxo in order of
    utxos = [utxos sortedArrayUsingComparator:^(BTCTransactionOutput* obj1, BTCTransactionOutput* obj2) {
        if ((obj1.value - obj2.value) < 0) return NSOrderedAscending;
        else return NSOrderedDescending;
    }];
    
    NSArray* txouts = nil;
    
    for (BTCTransactionOutput* txout in utxos) {
        if (txout.value > (totalAmount + dustThreshold) && txout.script.isPayToPublicKeyHashScript) {
            txouts = @[ txout ];
            break;
        }
    }
    
    // We support spending just one output for now.
    if (!txouts) return nil;
    
    // Create a new transaction
    BTCTransaction* tx = [[BTCTransaction alloc] init];
    
    BTCAmount spentCoins = 0;
    
    // Add all outputs as inputs
    for (BTCTransactionOutput* txout in txouts) {
        BTCTransactionInput* txin = [[BTCTransactionInput alloc] init];
        txin.previousHash = txout.transactionHash;
        txin.previousIndex = txout.index;
        [tx addInput:txin];
        
        NSLog(@"txhash: http://blockchain.info/rawtx/%@", BTCHexFromData(txout.transactionHash));
        NSLog(@"txhash: http://blockchain.info/rawtx/%@ (reversed)", BTCHexFromData(BTCReversedData(txout.transactionHash)));
        
        spentCoins += txout.value;
    }
    
    NSLog(@"Total satoshis to spend:       %lld", spentCoins);
    NSLog(@"Total satoshis to destination: %lld", amount);
    NSLog(@"Total satoshis to fee:         %lld", fee);
    NSLog(@"Total satoshis to change:      %lld", (spentCoins - (amount + fee)));
    
    // Add required outputs - payment and change
    BTCTransactionOutput* paymentOutput = [[BTCTransactionOutput alloc] initWithValue:amount address:destinationAddress];
    BTCTransactionOutput* changeOutput = [[BTCTransactionOutput alloc] initWithValue:(spentCoins - (amount + fee)) address:changeAddress];
    
    // Idea: deterministically-randomly choose which output goes first to improve privacy.
    [tx addOutput:paymentOutput];
    [tx addOutput:changeOutput];
    
    
    // Sign all inputs. We now have both inputs and outputs defined, so we can sign the transaction.
    for (int i = 0; i < txouts.count; i++) {
        // Normally, we have to find proper keys to sign this txin, but in this
        // example we already know that we use a single private key.
        
        BTCTransactionOutput* txout = txouts[i]; // output from a previous tx which is referenced by this txin.
        BTCTransactionInput* txin = tx.inputs[i];
        
        BTCScript* sigScript = [[BTCScript alloc] init];
        
        NSData* d1 = tx.data;
        
        BTCSignatureHashType hashtype = BTCSignatureHashTypeAll;
        
        NSData* hash = [tx signatureHashForScript:txout.script inputIndex:i hashType:hashtype error:errorOut];
        
        NSData* d2 = tx.data;
        
        NSAssert([d1 isEqual:d2], @"Transaction must not change within signatureHashForScript!");
        
        // 134675e153a5df1b8e0e0f0c45db0822f8f681a2eb83a0f3492ea8f220d4d3e4
        NSLog(@"Hash for input %d: %@", i, BTCHexFromData(hash));
        if (!hash) {
            return nil;
        }
        
        NSData* signatureForScript = [key signatureForHash:hash hashType:hashtype];
        [sigScript appendData:signatureForScript];
        [sigScript appendData:key.publicKey];
        
        NSData* sig = [signatureForScript subdataWithRange:NSMakeRange(0, signatureForScript.length - 1)]; // trim hashtype byte to check the signature.
        NSAssert([key isValidSignature:sig hash:hash], @"Signature must be valid");
        
        txin.signatureScript = sigScript;
    }
    
    // Validate the signatures before returning for extra measure.
    
    {
        BTCScriptMachine* sm = [[BTCScriptMachine alloc] initWithTransaction:tx inputIndex:0];
        NSError* error = nil;
        BOOL r = [sm verifyWithOutputScript:[[(BTCTransactionOutput*)txouts[0] script] copy] error:&error];
        NSLog(@"Error: %@", error);
        NSAssert(r, @"should verify first output");
    }
    
    // Transaction is signed now, return it.

    return tx;
}

@end
