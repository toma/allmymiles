//
//  AMMViewController.m
//  AllMyMiles
//
//  Created by Tom Allen on 8/16/12.
//  Copyright (c) 2012 Tom Allen. All rights reserved.
//

#import "AMMViewController.h"
#import <RestKit/RestKit.h>
#import "AMMActivityType.h"
#import "ActionSheetPicker.h"

@interface AMMViewController () {
    NSArray *activityTypes;
}

@end

@implementation AMMViewController
@synthesize distanceTextField;
@synthesize distanceUnitsButton;
@synthesize selectActivityTypeButton;

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
        
    RKURL *baseURL = [RKURL URLWithBaseURLString:@"http://172.16.1.8:8000/api/v1"];
    RKObjectManager *objectManager = [RKObjectManager objectManagerWithBaseURL:baseURL];
    objectManager.client.baseURL = baseURL;
    
    RKObjectMapping *activityTypeMapping = [RKObjectMapping mappingForClass:[AMMActivityType class]];
    
    [activityTypeMapping mapKeyPath:@"id" toAttribute:@"activityTypeId"];
    [activityTypeMapping mapAttributes:@"name", @"description", nil];
    
    [objectManager.mappingProvider setMapping:activityTypeMapping forKeyPath:@"objects"];
    
    [self sendRequest];
}

- (IBAction)selectDistanceUnits:(UIControl *)sender{
    ActionStringDoneBlock doneSelectingDistanceUnits = ^(ActionSheetStringPicker *picker, NSInteger selectedIndex, id selectedValue) {
        [self performSelector:@selector(setDistanceUnitsText:) withObject:selectedValue];
    };
        
    NSArray *distanceUnits = [NSArray arrayWithObjects:@"Miles", @"Kilometers", nil];
        
    NSInteger initialSelection = [distanceUnits indexOfObject:distanceUnitsButton.titleLabel.text];
    
    [ActionSheetStringPicker showPickerWithTitle:@"Select Distance Unit" rows:distanceUnits initialSelection:initialSelection doneBlock:doneSelectingDistanceUnits cancelBlock:nil origin:sender];
}

- (void) setDistanceUnitsText:(id)sender {
    [self.distanceUnitsButton setTitle:sender forState:UIControlStateNormal];
}

- (IBAction)selectActivityType:(UIControl *)sender {
    
    ActionStringDoneBlock doneSelectingActivityType = ^(ActionSheetStringPicker *picker, NSInteger selectedIndex, id selectedValue) {
            [self performSelector:@selector(setActivityTypeText:) withObject:selectedValue];
    };
    
    NSMutableArray *activityTypeText = [NSMutableArray new];
    for (AMMActivityType *activityType in activityTypes) {
        [activityTypeText addObject:activityType.name];
    }
    
    //if an activity type has changed set the initialSelection
    
    [ActionSheetStringPicker showPickerWithTitle:@"Select Activity Type" rows:activityTypeText initialSelection:0 doneBlock:doneSelectingActivityType cancelBlock:nil origin:sender];
}

- (void)setActivityTypeText:(id)sender {
    [self.selectActivityTypeButton setTitle:sender forState:UIControlStateNormal];
}

- (void)viewDidUnload
{
    [self setSelectActivityTypeButton:nil];
    [self setDistanceTextField:nil];
    [self setDistanceUnitsButton:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (void)sendRequest
{
    RKObjectManager *objectManager = [RKObjectManager sharedManager];
    
    RKURL *URL = [RKURL URLWithBaseURL:[objectManager baseURL] resourcePath:@"/activitytype"];
    [objectManager loadObjectsAtResourcePath:[URL resourcePath] delegate:self];
}

- (void)objectLoader:(RKObjectLoader *)objectLoader didFailWithError:(NSError *)error
{
    NSLog(@"Error: %@", [error localizedDescription]);
}

- (void)request:(RKRequest*)request didLoadResponse:(RKResponse*)response {
    NSLog(@"response code: %d", [response statusCode]);
}

- (void)objectLoader:(RKObjectLoader *)objectLoader didLoadObjects:(NSArray *)objects
{
    NSLog(@"objects[%d]", [objects count]);
    activityTypes = objects;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
    } else {
        return YES;
    }
}

- (IBAction)textFieldReturn:(id)sender
{
    [sender resignFirstResponder];
}

- (IBAction)backgroundTouched:(id)sender
{
    [distanceTextField resignFirstResponder];
}

@end
