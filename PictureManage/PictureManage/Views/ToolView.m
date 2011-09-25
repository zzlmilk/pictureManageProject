//
//  ToolView.m
//  almondz
//
//  Created by 卞中杰 on 11-6-30.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import "ToolView.h"
#import <QuartzCore/QuartzCore.h>


@implementation ToolView

@synthesize delegate;
@synthesize topButton = _topButton;
@synthesize textView = _textView;
@synthesize bottomView = _bottomView;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
//        self.backgroundColor = [UIColor lightGrayColor];
//        self.alpha = .3f;
//        _baseView = [[UIView alloc] initWithFrame:CGRectMake(5, 5, 200, 70)];
//        _baseView.backgroundColor = [UIColor darkGrayColor];
//        _baseView.alpha = .5f;
//        [self addSubview:_baseView];
//        
//        UIButton *deleteBtn = [UIButton alloc] initWithFrame:CGRectMake(<#CGFloat x#>, <#CGFloat y#>, <#CGFloat width#>, <#CGFloat height#>)
    }
    return self;
}


- (void)awakeFromNib {
    isDetailOpen = NO;
    _topButton.layer.cornerRadius = 5;
    _textView.layer.cornerRadius = 5;
    _textView.alpha = 0.f;
    _bottomView.layer.cornerRadius = 5;
    _topButton.center = CGPointMake(110, 103);
}

- (void)dealloc
{
    [_topButton release];
    [_textView release];
    [_bottomView release];
    [super dealloc];
}


- (IBAction)topButtonPressed:(id)sender {
    isDetailOpen = !isDetailOpen;
    CGContextRef context = UIGraphicsGetCurrentContext();
    [UIView beginAnimations:nil context:context];
    [UIView setAnimationDuration:.3f];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
    [UIView setAnimationTransition:UIViewAnimationTransitionNone forView:self cache:YES];
    if (_textView.alpha == 0.f) {
        _topButton.center = CGPointMake(110, 10);
        _textView.alpha = 0.7f;
    }
    else {
        _topButton.center = CGPointMake(110, 103);
        _textView.alpha = 0.f;
    }
    if (isDetailOpen) {
        [_topButton setTitle:@"点击以收起详细视图" forState:0];
    }
    else
        [_topButton setTitle:@"点击以展开详细视图" forState:0];
    [UIView commitAnimations];
}

- (IBAction)shareButtonPressed:(id)sender {
    [delegate sharePicture];
}

- (IBAction)deleteButtonPressed:(id)sender {
    [delegate deletePicture];
}

- (void)textViewDidBeginEditing:(UITextView *)textView {
    [delegate beginEditing];
}

- (void)textViewDidEndEditing:(UITextView *)textView {
    [delegate endEditingWithString:textView.text];
    [textView resignFirstResponder];
}
@end
