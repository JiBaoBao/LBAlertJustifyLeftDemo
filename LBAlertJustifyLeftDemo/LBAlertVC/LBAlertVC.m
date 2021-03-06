//
//  LBAlertVC.m
//  LBAlertJustifyLeftDemo
//
//  Created by JiBaoBao on 17/6/8.
//  Copyright © 2017年 JiBaoBao. All rights reserved.
//

#import "LBAlertVC.h"
#import "LBUtil.h"

@interface LBAlertVC ()

@property (nonatomic, strong) UIAlertController *alert;
@property (nonatomic, strong) NSString *titleStr;
@property (nonatomic, strong) NSString *messageStr;
@property (nonatomic, strong) NSString *leftStr;
@property (nonatomic, strong) NSString *rightStr;
@property (nonatomic, assign) UIAlertActionStyle leftStyle;
@property (nonatomic, assign) UIAlertActionStyle rightStyle;
@property (nonatomic, strong) UIColor *leftColor;
@property (nonatomic, strong) UIColor *rightColor;
@property (nonatomic, copy) LeftBlock leftBlock;
@property (nonatomic, copy) RightBlock rightBlock;
@property (nonatomic, weak) __weak id<LBAlertVCDelegate>delegate;

@end

@implementation LBAlertVC

- (void)dealloc{
    NSLog(@"LBAlertVC dealloc");
    _delegate = nil;
}

+ (LBAlertVC *)sharedInstance{
    static LBAlertVC *sharedManager;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedManager = [[LBAlertVC alloc] init];
    });
    return sharedManager;
}


#pragma mark - show alert

- (void)showAlertVC_OneWithTitle:(NSString *)titleStr
                         message:(NSString *)messageStr
                messageAlignment:(NSTextAlignment )messageAlignment
                      leftBtnStr:(NSString *)leftStr
                       leftBlock:(LeftBlock)leftBlock{
    [self showAlertVC_BaseWithTitle:titleStr message:messageStr messageAlignment:messageAlignment leftBtnStr:leftStr rightBtnStr:nil leftBlock:leftBlock rightBlock:nil];
}

- (void)showAlertVC_BaseWithTitle:(NSString *)titleStr
                          message:(NSString *)messageStr
                 messageAlignment:(NSTextAlignment )messageAlignment
                       leftBtnStr:(NSString *)leftStr
                      rightBtnStr:(NSString *)rightStr
                        leftBlock:(LeftBlock)leftBlock
                       rightBlock:(RightBlock)rightBlock{
    [self showAlertVCWithTitle:titleStr message:messageStr messageAlignment:messageAlignment leftBtnStr:leftStr leftBtnStyle:UIAlertActionStyleDefault leftBtnColor:nil rightBtnStr:rightStr leftBtnStyle:UIAlertActionStyleDefault rightBtnColor:nil leftBlock:leftBlock rightBlock:rightBlock delegate:nil];
}

- (void)showAlertVC_WithDelegate_BaseWithTitle:(NSString *)titleStr
                                       message:(NSString *)messageStr
                              messageAlignment:(NSTextAlignment )messageAlignment
                                    leftBtnStr:(NSString *)leftStr
                                   rightBtnStr:(NSString *)rightStr
                                      delegate:(id /**<LBAlertVCDelegate>*/)delegate{
    [self showAlertVCWithTitle:titleStr message:messageStr messageAlignment:messageAlignment leftBtnStr:leftStr leftBtnStyle:UIAlertActionStyleDefault leftBtnColor:nil rightBtnStr:rightStr leftBtnStyle:UIAlertActionStyleDefault rightBtnColor:nil leftBlock:nil rightBlock:nil delegate:delegate];
}


- (void)showAlertVCWithTitle:(NSString *)titleStr
                     message:(NSString *)messageStr
            messageAlignment:(NSTextAlignment )messageAlignment
                  leftBtnStr:(NSString *)leftStr
                leftBtnStyle:(UIAlertActionStyle)leftStyle
                leftBtnColor:(UIColor *)leftColor
                 rightBtnStr:(NSString *)rightStr
                leftBtnStyle:(UIAlertActionStyle)rightStyle
               rightBtnColor:(UIColor *)rightColor
                   leftBlock:(LeftBlock)leftBlock
                  rightBlock:(RightBlock)rightBlock
                    delegate:(id /**<LBAlertVCDelegate>*/)delegate{
    self.leftBlock=leftBlock;
    self.rightBlock=rightBlock;
    self.delegate = delegate;
    
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:titleStr message:messageStr preferredStyle:UIAlertControllerStyleAlert];
    [self lb_setAlertVCConetentAlignmentLeft:alertController messageAlignment:messageAlignment];
    if (leftStr) {
        __weak typeof(self) wSelf = self;
        UIAlertAction *leftBtn = [UIAlertAction actionWithTitle:leftStr style:leftStyle? :UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            if (wSelf.leftBlock) {
                wSelf.leftBlock(wSelf);
            }
            if (wSelf.delegate) {
                [wSelf.delegate lbAlertVC:alertController buttonIndex:0];
            }
        }];
        if (leftColor) [leftBtn setValue:leftColor forKey:@"titleTextColor"];
        [alertController addAction:leftBtn];
    }
    if (rightStr) {
        __weak typeof(self) wSelf = self;
        UIAlertAction *rightBtn = [UIAlertAction actionWithTitle:rightStr style:rightStyle? :UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            if (wSelf.rightBlock) {
                wSelf.rightBlock(wSelf);
            }
            if (wSelf.delegate) {
                [wSelf.delegate lbAlertVC:alertController buttonIndex:1];
            }
        }];
        if (rightColor) [rightBtn setValue:rightColor forKey:@"titleTextColor"];
        [alertController addAction:rightBtn];
    }
    [[LBUtil getCurrentViewController] presentViewController:alertController animated:YES completion:nil];
}


#pragma mark - assist method

// set AlertVC-message TextAlignment
- (void)lb_setAlertVCConetentAlignmentLeft:(UIAlertController *)alertController messageAlignment:(NSTextAlignment )messageAlignment{
    UIView *messageParentView = [self getParentViewOfTitleAndMessageFromView:alertController.view];
    if (messageParentView && messageParentView.subviews.count > 1) {
        UILabel *messageLb = messageParentView.subviews[1];
        messageLb.textAlignment = messageAlignment;
    }
}

// get AlertVC-title/message ParentView
- (UIView *)getParentViewOfTitleAndMessageFromView:(UIView *)view {
    for (UIView *subView in view.subviews) {
        if ([subView isKindOfClass:[UILabel class]]) {
            return view;
        }else{
            UIView *resultV = [self getParentViewOfTitleAndMessageFromView:subView];
            if (resultV) return resultV;
        }
    }
    return nil;
}

@end
