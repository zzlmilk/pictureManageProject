//
//  ToolView.h
//  almondz
//
//  Created by 卞中杰 on 11-6-30.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ToolViewDelegate <NSObject>
- (void)deletePicture;
- (void)sharePicture;
- (void)beginEditing;
- (void)endEditingWithString:(NSString *)string;
@end
@interface ToolView : UIView <UITextViewDelegate> {
    id <ToolViewDelegate> delegate;
    UIButton *_topButton;
    UITextView *_textView;  //详细信息
    UIView *_bottomView;
    BOOL isDetailOpen;
}
@property (nonatomic, assign) id <ToolViewDelegate> delegate;
@property (nonatomic, retain) IBOutlet UIButton *topButton;
@property (nonatomic, retain) IBOutlet UITextView *textView;
@property (nonatomic, retain) IBOutlet UIView *bottomView;

- (IBAction)topButtonPressed:(id)sender;
- (IBAction)deleteButtonPressed:(id)sender;
- (IBAction)shareButtonPressed:(id)sender;

@end
