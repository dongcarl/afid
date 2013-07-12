//
//  WTAppDelegate.h
//  WrappingTrial
//
//  Created by Carl Dong on 7/7/13.
//  Copyright (c) 2013 catswearingbreadhats. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import <GClasses/GMatrix.h>

struct RNWrapOpaque;

@interface WTAppDelegate : NSObject <NSApplicationDelegate>
//{
//    struct RNWrapOpaque *_cpp;
//}

@property (assign) IBOutlet NSWindow *window;

@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;

- (IBAction)saveAction:(id)sender;

@end
