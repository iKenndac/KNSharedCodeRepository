//
//  KNStatusBarView.m
//  Music Rescue 4
//
//  Created by Daniel Kennett on 30/01/2008.
//  Copyright 2008 KennettNet Software Limited. All rights reserved.
//

#import "KNStatusBarView.h"
#import "KNGradientExtensions.h"

@implementation KNStatusBarView

- (id)initWithFrame:(NSRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code here.
    }
    return self;
}

- (void)viewDidMoveToWindow {
    
    if ([self window]) {
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(windowDidChangeKey:)
                                                     name:NSWindowDidBecomeKeyNotification
                                                   object:[self window]];
        
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(windowDidChangeKey:)
                                                     name:NSWindowDidBecomeMainNotification
                                                   object:[self window]];
        
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(windowDidChangeKey:)
                                                     name:NSWindowDidBecomeKeyNotification
                                                   object:[self window]];
        
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(windowDidChangeKey:)
                                                     name:NSWindowDidResignKeyNotification
                                                   object:[self window]];
        
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(windowDidChangeKey:)
                                                     name:NSWindowDidResignMainNotification
                                                   object:[self window]];
    }
    
}

- (void)viewWillMoveToWindow:(NSWindow *)newWindow {

    if ([self window]) {
        [[NSNotificationCenter defaultCenter] removeObserver:self
                                                        name:NSWindowDidBecomeMainNotification
                                                      object:[self window]];
        
        [[NSNotificationCenter defaultCenter] removeObserver:self
                                                        name:NSWindowDidBecomeKeyNotification
                                                      object:[self window]];

        [[NSNotificationCenter defaultCenter] removeObserver:self
                                                        name:NSWindowDidResignKeyNotification
                                                      object:[self window]];

        [[NSNotificationCenter defaultCenter] removeObserver:self
                                                        name:NSWindowDidResignMainNotification
                                                      object:[self window]];

    }

}

-(void)windowDidChangeKey:(NSNotification *)not {
    [self setNeedsDisplay:YES];
}

- (void)drawRect:(NSRect)rect {
    // Drawing code here.

	NSRect frame = [self bounds];

	if ([[self window] isMainWindow])
		[[NSGradient unifiedPressedGradient] fillRect:frame angle:90];
	else
		[[NSGradient unifiedNormalGradient] fillRect:frame angle:90];

	[[NSColor grayColor] set];

	//NSRect border = NSMakeRect(frame.origin.x, frame.origin.y, frame.size.width - 1, frame.size.height - 1);
	
	[NSBezierPath strokeLineFromPoint:NSMakePoint(-0.5, frame.size.height - 0.5) toPoint:NSMakePoint(frame.size.width + 1, frame.size.height - 0.5)];
	
	[[[NSColor whiteColor] colorWithAlphaComponent:0.4] set];
	
	[NSBezierPath strokeLineFromPoint:NSMakePoint(-0.5, frame.size.height - 1.5) toPoint:NSMakePoint(frame.size.width + 1, frame.size.height - 1.5)];
}

- (BOOL)mouseDownCanMoveWindow {
	return YES;
}

@end
