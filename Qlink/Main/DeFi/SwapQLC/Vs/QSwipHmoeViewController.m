//
//  QSwipHmoeViewController.m
//  Qlink
//
//  Created by 旷自辉 on 2020/8/10.
//  Copyright © 2020 pan. All rights reserved.
//

#import "QSwipHmoeViewController.h"
#import "NinaPagerView.h"
#import "QSwipViewController.h"
#import "QRecordViewController.h"
#import "WebViewController.h"

@interface QSwipHmoeViewController ()
@property (weak, nonatomic) IBOutlet UIView *contentBack;
@property (weak, nonatomic) IBOutlet UILabel *navTitle;


@end

@implementation QSwipHmoeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = MAIN_WHITE_COLOR;
    [self setupNinaPage];
}

#pragma mark - Operation
- (void)setupNinaPage {
    
    _navTitle.text = kLang(@"QLC_Cross-chain_Swap");
    QSwipViewController *vc1 = [QSwipViewController new];

    QRecordViewController *vc2 = [QRecordViewController new];

    NSArray *titles = @[kLang(@"swap"),kLang(@"record")];

    NSArray *objs = @[vc1, vc2];
    
    NinaPagerView *_ninaPageView = [[NinaPagerView alloc] initWithFrame:CGRectMake(0, 0, 0, 0) WithTitles:titles WithObjects:objs];
    _ninaPageView.unSelectTitleColor = UIColorFromRGB(0xB3B3B3);
    _ninaPageView.selectTitleColor = MAIN_BLUE_COLOR;
    _ninaPageView.titleFont = 14;
    _ninaPageView.titleScale = 1;
    _ninaPageView.selectBottomLinePer = 0.8;
    _ninaPageView.selectBottomLineHeight = 1;
    _ninaPageView.underlineColor = MAIN_BLUE_COLOR;
    _ninaPageView.underLineHidden = YES;
    _ninaPageView.topTabHeight = 44;
    _ninaPageView.nina_autoBottomLineEnable = YES;
    [_contentBack addSubview:_ninaPageView];
    kWeakSelf(self);
    [_ninaPageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.bottom.right.mas_equalTo(weakself.contentBack).offset(0);
    }];
}

#pragma mark -- Action
- (IBAction)backAction:(id)sender {
    [self leftNavBarItemPressedWithPop:YES];
}
- (IBAction)helpAction:(id)sender {
    WebViewController *vc = [[WebViewController alloc] init];
    NSString *language = [Language currentLanguageCode];
    if ([language isEqualToString:LanguageCode[1]]) { // 中文
        vc.inputUrl = @"http://dapp-t.qlink.mobi/f/swap/faq_cn.html";
    } else {
        vc.inputUrl = @"http://dapp-t.qlink.mobi/f/swap/faq_en.html";
    }
    vc.inputTitle = kLang(@"QLC_Cross-chain_Swap_intro");
    [self.navigationController pushViewController:vc animated:YES];
}

@end
