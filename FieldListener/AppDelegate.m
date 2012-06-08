//
//  AppDelegate.m
//  FieldListener
//
//  Created by gewara on 12-6-6.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "AppDelegate.h"

@interface AppDelegate () <NSWindowDelegate>

@property(nonatomic, copy)NSString *currentURLString;

- (void)log:(NSString *)log;
- (void)check;
- (void)requestCheck;

@end

@implementation AppDelegate

@synthesize window = _window;

@synthesize currentURLString = _currentURLString;

- (void)dealloc
{
    [_textFieldURLString release];
    [_textViewLog release];
    [_textFieldMatchingString release];
    [_currentURLString release];
    [super dealloc];
}

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
    // Insert code here to initialize your application
    self.window.delegate = self;
    
    [NSThread detachNewThreadSelector:@selector(run) toTarget:self withObject:nil];
}

- (BOOL)applicationShouldTerminateAfterLastWindowClosed:(NSApplication *)sender
{
    return YES;
}

- (void)run
{
    @autoreleasepool {
        while(true){
            [self performSelectorOnMainThread:@selector(check) 
                                   withObject:nil 
                                waitUntilDone:YES];
            double interval = arc4random() % 10;
            [self log:[NSString stringWithFormat:@"sleep %.0fs", interval]];
            [NSThread sleepForTimeInterval:interval];
            [self log:@"sleep over"];
        }
    }
}

- (void)log:(NSString *)log
{
    [_textViewLog performSelectorOnMainThread:@selector(insertText:) 
                                   withObject:[NSString stringWithFormat:@"%@\n", log] 
                                waitUntilDone:YES];
}

- (void)check
{
    [self log:@"start check"];
    self.currentURLString = _textFieldURLString.stringValue;
    if(self.currentURLString){
        self.currentURLString = [self.currentURLString stringByTrimmingCharactersInSet:
                                 [NSCharacterSet whitespaceAndNewlineCharacterSet]];
    }
    BOOL valid = [self.currentURLString hasPrefix:@"http://"];
    if(valid){
        [self log:[NSString stringWithFormat:@"checking:%@", self.currentURLString]];
        if(_textFieldMatchingString.stringValue.length != 0){
            [self requestCheck];
        }else{
            [self log:@"no matching text"];
        }
    }else{
        [self log:[NSString stringWithFormat:@"invalid URL string:%@", self.currentURLString]];
    }
}

- (void)handleResponseString:(NSString *)string
{
    NSString *matchingText = _textFieldMatchingString.stringValue;
    if(matchingText != nil){
        NSRange range = [string rangeOfString:matchingText];
        if(range.location != NSNotFound){
            [self log:[NSString stringWithFormat:@"found:%@", matchingText]];
            [NSApp activateIgnoringOtherApps:YES];
        }
    }
}

- (void)requestCheck
{
    NSURLRequest *req = [NSURLRequest requestWithURL:[NSURL URLWithString:self.currentURLString]];
    [NSURLConnection sendAsynchronousRequest:req 
                                       queue:[[[NSOperationQueue alloc] init] autorelease] 
                           completionHandler:^(NSURLResponse *res, NSData *data, NSError *error) {
                               [self handleResponseString:[[[NSString alloc] initWithData:data 
                                                                                 encoding:NSUTF8StringEncoding] autorelease]];
                           }];
}


@end
