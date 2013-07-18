//
//  AMMViewController.h
//  AllMyMiles
//
//  Created by Tom Allen on 8/16/12.
//  Copyright (c) 2012 Tom Allen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <RestKit/RKObjectLoader.h>
#import "ActionSheetPicker.h"

@interface AMMViewController : UIViewController <RKObjectLoaderDelegate, UITextFieldDelegate>
@property (strong, nonatomic) AbstractActionSheetPicker *actionSheetPicker;
- (IBAction)selectActivityType:(UIControl *)sender;
@property (weak, nonatomic) IBOutlet UIButton *selectActivityTypeButton;
- (IBAction)textFieldReturn:(id)sender;
- (IBAction)backgroundTouched:(id)sender;
@property (weak, nonatomic) IBOutlet UITextField *distanceTextField;
@property (weak, nonatomic) IBOutlet UIButton *distanceUnitsButton;

@end
