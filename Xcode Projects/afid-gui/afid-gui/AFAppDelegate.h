//
//  AFAppDelegate.h
//  afid-gui
//
//  Created by Carl Dong on 6/28/13.
//  Copyright (c) 2013 catswearingbreadhats. All rights reserved.
//

#import "AFHUDViewController.h"
#import "AFDataset.h"
#import "AFSupervisedLearner.h"
#import "AFActionDefinitionStack.h"
#import <Cocoa/Cocoa.h>

@interface AFAppDelegate : NSObject <NSApplicationDelegate>

@property (assign) IBOutlet NSWindow *window;

@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;

//MINE!!



- (IBAction)saveAction:(id)sender;

@end
