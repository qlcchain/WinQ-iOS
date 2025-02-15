//
//  ResetPWViewController.m
//  Qlink
//
//  Created by Jelly Foo on 2018/10/31.
//  Copyright © 2018 pan. All rights reserved.
//

#import "ResetPWViewController.h"
#import "ResetPWSuccessView.h"
#import "NSString+Valid.h"
#import "LoginPWModel.h"
//#import "GlobalConstants.h"
#import <SwiftTheme/SwiftTheme-Swift.h>
#import "NSString+Trim.h"

@interface ResetPWViewController ()

@property (weak, nonatomic) IBOutlet UIView *currentPWBack;
@property (weak, nonatomic) IBOutlet UIView *setPWBack;
@property (weak, nonatomic) IBOutlet UIView *repeatPWBack;
@property (weak, nonatomic) IBOutlet UIButton *storeBtn;
@property (weak, nonatomic) IBOutlet UITextField *currentPWTF;
@property (weak, nonatomic) IBOutlet UITextField *setPWTF;
@property (weak, nonatomic) IBOutlet UITextField *repeatPWTF;
@property (weak, nonatomic) IBOutlet UILabel *pwWrongLab;


@end

@implementation ResetPWViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.view.backgroundColor = MAIN_WHITE_COLOR;
    
    [self renderView];
    [self configInit];
}

#pragma mark - Operation
- (void)renderView {
    [_storeBtn cornerRadius:6];
    
    UIColor *cornerColor = UIColorFromRGB(0xE8EAEC);
    [_currentPWBack cornerRadius:6 strokeSize:1 color:cornerColor];
    [_setPWBack cornerRadius:6 strokeSize:1 color:cornerColor];
    [_repeatPWBack cornerRadius:6 strokeSize:1 color:cornerColor];
}

- (void)configInit {
    _pwWrongLab.text = nil;
    [_storeBtn setBackgroundColor:UIColorFromRGB(0xD5D8DD)];
    _storeBtn.userInteractionEnabled = NO;
    [_currentPWTF addTarget:self action:@selector(textFieldDidEnd) forControlEvents:UIControlEventEditingDidEnd];
    [_setPWTF addTarget:self action:@selector(textFieldDidEnd) forControlEvents:UIControlEventEditingDidEnd];
    [_setPWTF addTarget:self action:@selector(setPWTFDidEnd) forControlEvents:UIControlEventEditingDidEnd];
    [_repeatPWTF addTarget:self action:@selector(textFieldDidEnd) forControlEvents:UIControlEventEditingDidEnd];
}

- (void)setPWTFDidEnd {
    NSString *pw = _setPWTF.text.trim_whitespace;
    if ([pw containDigital] && [pw containLowercase] && [pw containUppercase]) {
        _pwWrongLab.text = nil;
    } else {
        _pwWrongLab.text = kLang(@"a_mix_of_uppercase_and_lowercase_letters_along_with_at_least_one_symbol");
        [_storeBtn setBackgroundColor:UIColorFromRGB(0xD5D8DD)];
        _storeBtn.userInteractionEnabled = NO;
    }
}

- (void)textFieldDidEnd {
    if (_currentPWTF.text.trim_whitespace && _currentPWTF.text.trim_whitespace.length > 0 && _setPWTF.text.trim_whitespace && _setPWTF.text.trim_whitespace.length > 0 && _repeatPWTF.text.trim_whitespace && _repeatPWTF.text.trim_whitespace.length > 0) {
//        [_storeBtn setBackgroundColor:MAIN_BLUE_COLOR];
        _storeBtn.theme_backgroundColor = globalBackgroundColorPicker;
        _storeBtn.userInteractionEnabled = YES;
    } else {
        [_storeBtn setBackgroundColor:UIColorFromRGB(0xD5D8DD)];
        _storeBtn.userInteractionEnabled = NO;
    }
}

- (void)showStoreSuccess {
    [[ResetPWSuccessView getInstance] show];
    kWeakSelf(self);
    [UIView animateWithDuration:2 animations:^{
        [weakself hideStoreSuccess];
    }];
}

- (void)hideStoreSuccess {
    [[ResetPWSuccessView getInstance] hide];
}

- (void)backToRoot {
    [self.navigationController popToRootViewControllerAnimated:YES];
}

#pragma mark - Action

- (IBAction)backAction:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)storeAction:(id)sender {
    NSString *loginPW = [LoginPWModel getLoginPW];
    if (![_currentPWTF.text.trim_whitespace isEqualToString:loginPW]) {
        [kAppD.window makeToastDisappearWithText:kLang(@"current_password_is_wrong")];
        return;
    }
    
    if (![_setPWTF.text.trim_whitespace isEqualToString:_repeatPWTF.text.trim_whitespace]) {
        [kAppD.window makeToastDisappearWithText:kLang(@"repeat_password_is_different_from_set_password")];
        return;
    }
    
    [LoginPWModel setLoginPW:_setPWTF.text.trim_whitespace];
    [self showStoreSuccess];
    [self performSelector:@selector(backToRoot) withObject:nil afterDelay:2];
}


@end
