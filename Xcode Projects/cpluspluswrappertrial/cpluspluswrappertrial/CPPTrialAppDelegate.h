//
//  CPPTrialAppDelegate.h
//  cpluspluswrappertrial
//
//  Created by Carl Dong on 7/7/13.
//  Copyright (c) 2013 catswearingbreadhats. All rights reserved.
//

#include <GClasses/GMatrix.h>
#include <GClasses/GHolders.h>
#include <GClasses/GRand.h>
#include <GClasses/GDecisionTree.h>

#import <Cocoa/Cocoa.h>

@interface CPPTrialAppDelegate : NSObject <NSApplicationDelegate>
{
    struct Opaque* opaque;
}

@property (assign) IBOutlet NSWindow *window;

@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;

struct Opaque;

- (IBAction)saveAction:(id)sender;

@end
