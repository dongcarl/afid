//
//  WFAppDelegate.h
//  waffles
//
//  Created by Carl Dong on 7/7/13.
//  Copyright (c) 2013 catswearingbreadhats. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface WFAppDelegate : NSObject <NSApplicationDelegate>

@property (assign) IBOutlet NSWindow *window;

@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (weak) IBOutlet NSScrollView *textField;

- (IBAction)saveAction:(id)sender;


@end
