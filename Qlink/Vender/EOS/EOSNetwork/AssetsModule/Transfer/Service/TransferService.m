//
//  TransferService.m
//  pocketEOS
//
//  Created by oraclechain on 2018/2/9.
//  Copyright © 2018年 oraclechain. All rights reserved.
//

#import "TransferService.h"
#import "EOS_RichListResult.h"
#import "EOS_Follow.h"
#import "EOS_BlockChainInfo.h"
#import "GetBlockChainInfoRequest.h"
#import "Abi_json_to_binRequest.h"
#import "AskQuestion_abi_to_json_request.h"
#import "GetRequiredPublicKeyRequest.h"
#import "PushTransactionRequest.h"
#import <JavaScriptCore/JavaScriptCore.h>
#import <eosFramework/TypeChainId.h>
#import <eosFramework/EosByteWriter.h>
#import <eosFramework/EOS_Key_Encode.h>
#import <eosFramework/Sha256.h>
#import <eosFramework/uECC.h>
#import <eosFramework/NSObject+Extension.h>
#import <eosFramework/NSDate+ExFoundation.h>
#import "EOS_GetRateResult.h"
#import "EOS_Rate.h"
#import "EOS_WalletAccountsResult.h"
#import "EOS_Wallet.h"
#import <eosFramework/rmd160.h>
#import <eosFramework/libbase58.h>
#import <eosFramework/NSData+Hash.h>
#import <eosFramework/AppConstant.h>
#import <eosFramework/AESCrypt.h>
#import <MJExtension/MJExtension.h>
#import "EOS_AccountInfo.h"
#import "EOSWalletInfo.h"
#import "GlobalConstants.h"

@interface TransferService()

@property(nonatomic, strong) GetBlockChainInfoRequest *getBlockChainInfoRequest;
@property(nonatomic, strong) Abi_json_to_binRequest *abi_json_to_binRequest;
@property(nonatomic , strong) AskQuestion_abi_to_json_request *askQuestion_abi_to_json_request;
@property(nonatomic, strong) GetRequiredPublicKeyRequest *getRequiredPublicKeyRequest;
@property(nonatomic, strong) PushTransactionRequest *pushTransactionRequest;

@property(nonatomic, strong) JSContext *context;
@property(nonatomic, copy) NSString *ref_block_prefix;

@property(nonatomic , strong) NSData *chain_Id;
@property(nonatomic, copy) NSString *expiration;
@property(nonatomic, copy) NSString *required_Publickey;

@end


@implementation TransferService
- (RichListRequest *)richListRequest{
    if (!_richListRequest) {
        _richListRequest = [[RichListRequest alloc] init];
    }
    return _richListRequest;
}

- (GetBlockChainInfoRequest *)getBlockChainInfoRequest{
    if (!_getBlockChainInfoRequest) {
        _getBlockChainInfoRequest = [[GetBlockChainInfoRequest alloc] init];
    }
    return _getBlockChainInfoRequest;
}

- (Abi_json_to_binRequest *)abi_json_to_binRequest{
    if (!_abi_json_to_binRequest) {
        _abi_json_to_binRequest = [[Abi_json_to_binRequest alloc] init];
    }
    return _abi_json_to_binRequest;
}

- (AskQuestion_abi_to_json_request *)askQuestion_abi_to_json_request{
    if (!_askQuestion_abi_to_json_request) {
        _askQuestion_abi_to_json_request = [[AskQuestion_abi_to_json_request alloc] init];
    }
    return _askQuestion_abi_to_json_request;
}

- (GetRequiredPublicKeyRequest *)getRequiredPublicKeyRequest{
    if (!_getRequiredPublicKeyRequest) {
        _getRequiredPublicKeyRequest = [[GetRequiredPublicKeyRequest alloc] init];
    }
    return _getRequiredPublicKeyRequest;
}

- (PushTransactionRequest *)pushTransactionRequest{
    if (!_pushTransactionRequest) {
        _pushTransactionRequest = [[PushTransactionRequest alloc] init];
    }
    return _pushTransactionRequest;
}

- (GetRateRequest *)getRateRequest{
    if (!_getRateRequest) {
        _getRateRequest = [[GetRateRequest alloc] init];
    }
    return _getRateRequest;
}

- (NSMutableArray *)richListDataArray{
    if (!_richListDataArray) {
        _richListDataArray = [[NSMutableArray alloc] init];
    }
    return _richListDataArray;
}

- (JSContext *)context{
    if (!_context) {
        _context = [[JSContext alloc] init];
    }
    return _context;
}


// pushTransaction
- (void)pushTransaction{
    [self getBlockChainInfoOperation];
}

- (void)getBlockChainInfoOperation{
    WS(weakSelf);
    [self.getBlockChainInfoRequest getDataSusscess:^(id DAO, id data) {
        if ([data isKindOfClass:[NSDictionary class]]) {
#pragma mark -- [@"data"]
//            EOS_BlockChainInfo *model = [EOS_BlockChainInfo mj_objectWithKeyValues:data[@"data"]];// [@"data"]
            EOS_BlockChainInfo *model = [EOS_BlockChainInfo mj_objectWithKeyValues:data];
            weakSelf.expiration = [[[NSDate dateFromString: model.head_block_time] dateByAddingTimeInterval: 60] formatterToISO8601];
            weakSelf.ref_block_num = [NSString stringWithFormat:@"%@",model.head_block_num];
            
            NSString *js = @"function readUint32( tid, data, offset ){var hexNum= data.substring(2*offset+6,2*offset+8)+data.substring(2*offset+4,2*offset+6)+data.substring(2*offset+2,2*offset+4)+data.substring(2*offset,2*offset+2);var ret = parseInt(hexNum,16).toString(10);return(ret)}";
            [weakSelf.context evaluateScript:js];
            JSValue *n = [weakSelf.context[@"readUint32"] callWithArguments:@[@8,VALIDATE_STRING(model.head_block_id) , @8]];
            
            weakSelf.ref_block_prefix = [n toString];
            
            weakSelf.chain_Id = [NSObject convertHexStrToData:model.chain_id];
            NSLog(@"get_block_info_success:%@, %@---%@-%@", weakSelf.expiration , weakSelf.ref_block_num, weakSelf.ref_block_prefix, weakSelf.chain_Id);
            
            [weakSelf getRequiredPublicKeyRequestOperation];
        }
    } failure:^(id DAO, NSError *error) {
        NSLog(@"error:%@", error);
    }];
}


- (void)getRequiredPublicKeyRequestOperation{
    self.getRequiredPublicKeyRequest.ref_block_prefix = self.ref_block_prefix;
    self.getRequiredPublicKeyRequest.ref_block_num = self.ref_block_num;
    self.getRequiredPublicKeyRequest.expiration = self.expiration;
    self.getRequiredPublicKeyRequest.sender = self.sender;
    self.getRequiredPublicKeyRequest.data = self.binargs;
    self.getRequiredPublicKeyRequest.account = self.code;
    self.getRequiredPublicKeyRequest.name = self.action;
    self.getRequiredPublicKeyRequest.available_keys = self.available_keys;
    self.getRequiredPublicKeyRequest.permission = self.permission;
    
    
    WS(weakSelf);
    self.getRequiredPublicKeyRequest.showActivityIndicator = YES;
    
    [self.getRequiredPublicKeyRequest postOuterDataSuccess:^(id DAO, id data) {
        #pragma mark -- [@"data"]
        NSArray *required_keys = data[@"required_keys"];
        if (!required_keys) {
            return;
        }
//        if ([data[@"code"] isEqualToNumber:@0 ]) {
            weakSelf.required_Publickey = required_keys[0];
            NSLog(@"get_required_keys_success: -- %@",required_keys[0]);//
            [weakSelf pushTransactionRequestOperation];
        
    } failure:^(id DAO, NSError *error) {
        NSLog(@"get_required_keys_error: -- %@",error);
    }];
}

- (void)pushTransactionRequestOperation{
    NSString *wif;
    if ([[EOSWalletInfo getOwnerPublicKey:_sender] isEqualToString:self.required_Publickey]) {
//        wif = [AESCrypt decrypt:accountInfo.account_owner_private_key password:self.password];
        wif = [EOSWalletInfo getOwnerPrivateKey:_sender];
    }else if ([[EOSWalletInfo getActivePublicKey:_sender] isEqualToString:self.required_Publickey]) {
//        wif = [AESCrypt decrypt:accountInfo.account_active_private_key password:self.password];
        wif = [EOSWalletInfo getActivePrivateKey:_sender];;
    }else{
        NSLog(@"未找到账号的私钥!", nil);
        return;
    }
    const int8_t *private_key = [[EOS_Key_Encode getRandomBytesDataWithWif:wif] bytes];
    //     [NSObject out_Int8_t:private_key andLength:32];
    if (!private_key) {
        NSLog(@"private_key can't be nil!");
        return;
    }
    
    Sha256 *sha256 = [[Sha256 alloc] initWithData:[EosByteWriter getBytesForSignature:self.chain_Id andParams: [[self.getRequiredPublicKeyRequest parameters] objectForKey:@"transaction"] andCapacity:255]];
    int8_t signature[uECC_BYTES*2];
    int recId = uECC_sign_forbc(private_key, sha256.mHashBytesData.bytes, signature);
    if (recId == -1 ) {
        printf("could not find recid. Was this data signed with this key?\n");
    }else{
        unsigned char bin[65+4] = { 0 };
        unsigned char *rmdhash = NULL;
        int binlen = 65+4;
        int headerBytes = recId + 27 + 4;
        bin[0] = (unsigned char)headerBytes;
        memcpy(bin + 1, signature, uECC_BYTES * 2);
        
        unsigned char temp[67] = { 0 };
        memcpy(temp, bin, 65);
        memcpy(temp + 65, "K1", 2);
        
        rmdhash = RMD(temp, 67);
        memcpy(bin + 1 +  uECC_BYTES * 2, rmdhash, 4);
        
        char sigbin[100] = { 0 };
        size_t sigbinlen = 100;
        b58enc(sigbin, &sigbinlen, bin, binlen);
        
        NSString *signatureStr = [NSString stringWithFormat:@"SIG_K1_%@", [NSString stringWithUTF8String:sigbin]];
        NSString *packed_trxHexStr = [[EosByteWriter getBytesForSignature:nil andParams: [[self.getRequiredPublicKeyRequest parameters] objectForKey:@"transaction"] andCapacity:512] hexadecimalString];
        
        self.pushTransactionRequest.packed_trx = packed_trxHexStr;
        self.pushTransactionRequest.signatureStr = signatureStr;
        WS(weakSelf);
//        self.pushTransactionRequest.showActivityIndicator = YES;
        NSLog(@"%@", [[self.pushTransactionRequest parameters] mj_JSONObject]);
        dispatch_async(dispatch_get_main_queue(), ^{
            [kAppD.window makeToastInView:kAppD.window];
        });
        [self.pushTransactionRequest postOuterDataSuccess:^(id DAO, id data) {
            NSLog(@"success: -- %@",data );
            dispatch_async(dispatch_get_main_queue(), ^{
                [kAppD.window hideToast];
            });
            
            EOS_TransactionResult *result = [EOS_TransactionResult mj_objectWithKeyValues:data];
            
            if (weakSelf.pushTransactionType == PushTransactionTypeTransfer) {
                if (weakSelf.delegate && [weakSelf.delegate respondsToSelector:@selector(pushTransactionDidFinish:)]) {
                    [weakSelf.delegate pushTransactionDidFinish:result];
                }
                
            }else if (weakSelf.pushTransactionType == PushTransactionTypeApprove){
                if (weakSelf.delegate && [weakSelf.delegate respondsToSelector:@selector(approveDidFinish:)]) {
                    [weakSelf.delegate approveDidFinish:result];
                }
                
            }else if (weakSelf.pushTransactionType == PushTransactionTypeAskQustion){
                if (weakSelf.delegate && [weakSelf.delegate respondsToSelector:@selector(askQuestionDidFinish:)]) {
                    [weakSelf.delegate askQuestionDidFinish:result];
                }
                
            }else if (weakSelf.pushTransactionType == PushTransactionTypeAnswer){
                if (weakSelf.delegate && [weakSelf.delegate respondsToSelector:@selector(answerQuestionDidFinish:)]) {
                    [weakSelf.delegate answerQuestionDidFinish:result];
                }
                
            }else if (weakSelf.pushTransactionType == PushTransactionTypeRegisteVoteSystem){
                if (weakSelf.delegate && [weakSelf.delegate respondsToSelector:@selector(registeToVoteSystemQuestionDidFinish:)]) {
                    [weakSelf.delegate registeToVoteSystemQuestionDidFinish:result];
                }
                
            }
        } failure:^(id DAO, NSError *error) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [kAppD.window hideToast];
                if (error.userInfo != nil && error.userInfo[AFNetworkingOperationFailingURLResponseDataErrorKey] != nil) {
                    NSDictionary *errorDic = [NSJSONSerialization JSONObjectWithData:error.userInfo[AFNetworkingOperationFailingURLResponseDataErrorKey] options:NSJSONReadingMutableContainers error:nil];
                    NSLog(@"responseERROR:%@", errorDic);
                    [kAppD.window makeToastDisappearWithText:errorDic[@"error"][@"what"]];
                }
            });
        }];
    }
}


/**
 get_rate
 */
- (void)get_rate:(CompleteBlock)complete{
    [self.getRateRequest postDataSuccess:^(id DAO, id data) {
        if ([data isKindOfClass:[NSDictionary class]]) {
            EOS_GetRateResult *result = [EOS_GetRateResult mj_objectWithKeyValues:data];
            complete(result , YES);
        }
    } failure:^(id DAO, NSError *error) {
        complete(nil , NO);
    }];
}



- (void)getRichlistAccount:(CompleteBlock)complete{
    WS(weakSelf);
    
    [self.richListRequest postDataSuccess:^(id DAO, id data) {
        [weakSelf.richListDataArray removeAllObjects];
        EOS_RichListResult *result = [EOS_RichListResult mj_objectWithKeyValues:data];
        // 关注的账号或钱包
        NSMutableArray *followsArr = result.data;
        // 获取 key 对应的数据源
        NSMutableArray *itemArray = [NSMutableArray array];
        for (EOS_Follow *model in followsArr) {
            if ([model.followType isEqualToNumber:@2]) {
                [weakSelf.richListDataArray addObject:model];
            }
        }
        complete(weakSelf , YES);
    } failure:^(id DAO, NSError *error) {
        complete(nil , NO);
    }];
}
@end

