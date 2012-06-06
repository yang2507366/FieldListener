//
//  AppDelegate.m
//  FieldListener
//
//  Created by gewara on 12-6-6.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "AppDelegate.h"

@interface AppDelegate ()

@property(nonatomic, copy)NSString *currentURLString;

- (void)updateCurrentURLString;
- (void)log:(NSString *)log;

@end

@implementation AppDelegate

@synthesize window = _window;

@synthesize currentURLString = _currentURLString;

- (void)dealloc
{
    [_textFieldURLString release];
    [_textViewLog release];
    [_currentURLString release];
    [super dealloc];
}

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
    // Insert code here to initialize your application
    [NSThread detachNewThreadSelector:@selector(run) toTarget:self withObject:nil];
}

- (void)run
{
    @autoreleasepool {
        while(true){
            [self performSelectorOnMainThread:@selector(updateCurrentURLString) 
                                   withObject:nil 
                                waitUntilDone:YES];
            [self performSelectorOnMainThread:@selector(check) 
                                   withObject:nil 
                                waitUntilDone:YES];
            double interval = arc4random() % 10;
            [self log:[NSString stringWithFormat:@"sleep %.0fs", interval]];
            [NSThread sleepForTimeInterval:interval];
        }
    }
}

- (void)updateCurrentURLString
{
    self.currentURLString = _textFieldURLString.stringValue;
}

- (void)log:(NSString *)log
{
    [_textViewLog insertText:[NSString stringWithFormat:@"%@\n", log]];
}

- (void)check
{
    if(self.currentURLString){
        self.currentURLString = [self.currentURLString stringByTrimmingCharactersInSet:
                                 [NSCharacterSet whitespaceAndNewlineCharacterSet]];
    }
    BOOL valid = [self.currentURLString hasPrefix:@"http://"];
    if(valid){
        [self log:[NSString stringWithFormat:@"checking:%@", self.currentURLString]];
        
    }else{
        [self log:[NSString stringWithFormat:@"invalid URL string:%@", self.currentURLString]];
    }
}

@end
