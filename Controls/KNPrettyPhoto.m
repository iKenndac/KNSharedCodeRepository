//
//  KNPrettyPhoto.m
//  iTS Prototype
//
//  Created by Daniel Kennett on 26/09/2007.
//  Copyright 2007 KennettNet Software Limited. All rights reserved.
//

#import "KNPrettyPhoto.h"
#import "Constants.h"
#import <QuartzCore/CIContext.h>

@implementation KNPrettyPhotoCell

-(id) init {
	
	self = [super init];
	
	//_trackingRect = [[self controlView] addTrackingRect:NSMakeRect(0, 0, 0, 0) owner:self userData:nil assumeInside:NO];
	_photo = nil;
	_photoBorder = 0.05;
	_selected = NO;
	_preDragSelected = NO;
	_animation = nil;
	_drawsDragHilight = NO;
	showPushpin = NO;
	showPageCurl = NO;
	
	NSShadow *shadow = [[[NSShadow alloc] init] autorelease];
	[shadow setShadowBlurRadius:4];
	[shadow setShadowOffset:NSMakeSize(4,-4)];
	[shadow setShadowColor:[NSColor darkGrayColor]];
	[self setShadow:shadow];
	
	return self;
}

- (id)initWithCoder:(NSCoder *)coder {
    self = [super initWithCoder:coder];
    if ([coder allowsKeyedCoding]) {
		_photo = [[coder decodeObjectForKey: @"photo"] retain];
    } else {
		_photo = [[coder decodeObject] retain];
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)coder {
    [super encodeWithCoder:coder];
    if ([coder allowsKeyedCoding]) {
		[coder encodeObject: [self photo] forKey: @"time"];
    } else {
		[coder encodeObject: [self photo]];
    }
}



- (id)copyWithZone:(NSZone *)zone {
    KNPrettyPhotoCell *newCopy = [[KNPrettyPhotoCell alloc] init];
    [newCopy setPhoto: [self photo]];
	[newCopy setShadow:[self shadow]];
	[newCopy setPhotoCollection:[self photoCollection]];
	[newCopy setPhotoBorder:[self photoBorder]];
	
    return newCopy;
}

-(void)dealloc {
	[_photo release];
	[photoCollection release];
	[photoShadow release];
	
	[super dealloc];
}	


- (void)sendActionToTarget {
    if ([self target] && [self action]) {
        [(NSControl *)[self controlView] sendAction:[self action] to:[self target]];
    }
}

-(void)setShadow:(NSShadow *)shadow {
	[shadow retain];
	[photoShadow release];
	photoShadow = shadow;
	
	[(NSControl *)[self controlView] updateCell: self];
}

-(NSShadow *)shadow {
	return photoShadow;
}

-(void)setShowPushpin:(BOOL)show {
	showPushpin = show;
	[(NSControl *)[self controlView] updateCell: self];
}

-(BOOL)showPushpin {
	return showPushpin;
}

-(void)setShowPageCurl:(BOOL)show {
	showPageCurl = show;
	[(NSControl *)[self controlView] updateCell: self];
}

-(BOOL)showPageCurl {
	return showPageCurl;
}

-(void)setPhoto:(id <KNPhoto>)photo {
	// Copy the image so we don't have to retain it, etc
	[_photo release];
	_photo = [photo retain]; // Should be copy?
	[(NSControl *)[self controlView] updateCell: self];
}

-(id <KNPhoto>)photo {
	return _photo;	
}

-(id <KNPhoto>)temporaryPhoto {
	return _temporaryPhoto;
}

-(void)setPhotoCollection:(NSSet *)collection {
	[collection retain];
	[photoCollection release];
	photoCollection = collection;
	
	[(NSControl *)[self controlView] updateCell: self];

}
	
-(NSSet *)photoCollection {
	return photoCollection;
}


- (void)setObjectValue:(id <NSCopying>)object {
    // We understand how to convert from NSCalendarDates, and NSStrings anything else is unexpected.
    if (([(NSObject *)object conformsToProtocol:@protocol(KNPhoto)])) {
		[self setPhoto: (id <KNPhoto>)object];
	} else {
        [NSException raise: NSInvalidArgumentException format: @"%@ Invalid object %@", NSStringFromSelector(_cmd), object];
    }
}

- (id)objectValue {
    return [self photo];
}




-(void)setPhotoBorder:(float)width {
	_photoBorder = width;
	[(NSControl *)[self controlView] updateCell: self];
}
	
-(float)photoBorder {
	return _photoBorder;
}

-(void)setSelected:(BOOL)selected {
	if (selected != _selected) {
		_selected = selected;
		
		if ([[[NSUserDefaults standardUserDefaults] objectForKey:kGratuitousAnimationUserDefaultsKey] boolValue] == YES) {
			
			if (_animation) {
				[_animation stopAnimation];
			}
			_animation = [[NSAnimation alloc] initWithDuration:0.15 animationCurve:NSAnimationLinear];
			
			[_animation setDelegate:(id <NSAnimationDelegate>)self];
			[_animation setAnimationBlockingMode:NSAnimationNonblockingThreaded];
			
			float i;
			float step = 0.2;
			
			for (i = 0; i <= 1.0; i += step) {
				[_animation addProgressMark:i];
			}
			
			[_animation startAnimation];	
			
		} else {
			if (_selected) {
				_selectRectOpacity = 1.0;
			} else {
				_selectRectOpacity = 0.0;
			}
		}
		
	}
}

-(BOOL)selected {
	return _selected;
}

-(void)setPreDragSelected:(BOOL)selected {
	_preDragSelected = selected;
}
	
-(BOOL)preDragSelected {
	return _preDragSelected;
}

-(NSRect)photoRect {
	return _borderRect;
}


-(BOOL)drawsDragHilight {

	return _drawsDragHilight;
	
}

-(void)setDrawsDragHilight:(BOOL)draws {

	_drawsDragHilight = draws;
	
}

#pragma mark -
#pragma mark Mouse (Cell)

- (void)mouseMoved:(NSEvent *)theEvent {
	
	if ([[self photoCollection] count] > 1) {
	
		float pixelsPerPhoto = _photoRect.size.width / (float)[photoCollection count];
		float x = [[self controlView] convertPoint:[theEvent locationInWindow] fromView:nil].x;
		
		int photoIndex = 0;
		
		if (pixelsPerPhoto > 0) {
			photoIndex = floor((x - _photoRect.origin.x) / pixelsPerPhoto);
		}
		
		if (x < _photoRect.origin.x || x > NSMaxX(_photoRect)) {
			if (_temporaryPhoto) {
				_temporaryPhoto = nil;
				[(NSControl *)[self controlView] updateCell:self];
			}
		} else {
			
			NSArray *photos = [[self photoCollection] allObjects];
			
			id photo = [photos objectAtIndex:photoIndex];
			
			if (photoIndex < [photos count] && _temporaryPhoto != photo) {
				_temporaryPhoto = photo;
				[(NSControl *)[self controlView] updateCell:self];
			}
		}
	}
	
	
}

- (void)mouseExited:(NSEvent *)theEvent {
	
	if ([self photoCollection]) {
		_temporaryPhoto = nil;
		[(NSControl *)[self controlView] updateCell:self];
	}
	
}


#pragma mark -
#pragma mark Animation

- (void)animationDidEnd:(NSAnimation *)animation
{
    if (_selected) {
		_selectRectOpacity = 1.0;
	} else {
		_selectRectOpacity = 0.0;
	}
	
	[(NSControl *)[self controlView] updateCell: self];
	[_animation release];
	_animation = nil;
	
	
}

- (void)animation:(NSAnimation*)animation didReachProgressMark:(NSAnimationProgress)progress {
	
	if (_selected) {
		_selectRectOpacity = progress;
	} else {
		_selectRectOpacity = 1 - progress;
	}
	
	[(NSControl *)[self controlView] updateCell: self];
}

#define photoPadding 5 // Padding for shadow, etc
//#define photoBorder 3 // Width of white border

//- (void)drawRect:(NSRect)rect {
    // Drawing code here.

#pragma mark -
#pragma mark Drawing

#define clipWidth 27.0
#define clipHeight 19.0

- (void)drawWithFrame:(NSRect)cellFrame inView:(NSView *)controlView {

	NSRect bounds = cellFrame;
	//NSRect borderRect;
	
	
	float boxWidthHeightRatio = bounds.size.height / bounds.size.width;
	float pictureWidthHeightRatio = [[_photo ciImage] extent].size.height / [[_photo ciImage] extent].size.width;

	NSRect imageRect = NSZeroRect;
	//float borderSizeInPixels = 0.0;
	
	if ([_photo ciImage]) {
				
		float width = 0.0;
		float height = 0.0;
		float x = 0.0;
		float y = 0.0;
		
		if (pictureWidthHeightRatio > boxWidthHeightRatio) {
			// Picture should be sized by height (i.e., the box is wider than the picture)
			// This means the vertical (top and bottom [y axis]) edges will touch the edges of the padding
		
			float heightBeforeBorder = bounds.size.height - (photoPadding * 2);
			
			height = floor(heightBeforeBorder - (heightBeforeBorder * (_photoBorder * 2)));
			width = floor (height / pictureWidthHeightRatio);
						
			y = NSMinY(cellFrame) + photoPadding + (heightBeforeBorder * (_photoBorder));
			x = NSMinX(cellFrame) + floor(((bounds.size.width - (photoPadding * 2)) / 2) - (width / 2) + photoPadding);
			
		} else {
			// Picture should be sized by width (the box is higher than the picture)
			
			float widthBeforeBorder = bounds.size.width - (photoPadding * 2);
			
			width = floor(widthBeforeBorder - (widthBeforeBorder * (_photoBorder * 2)));
			height = floor(width * pictureWidthHeightRatio);
			x = NSMinX(cellFrame) + photoPadding + (widthBeforeBorder * (_photoBorder));
			y = NSMinY(cellFrame) + floor(((bounds.size.height - (photoPadding * 2)) / 2) - (height / 2) + photoPadding);
		}
		
		imageRect = NSOffsetRect(NSMakeRect(x,y,width,height), 0.5, 0.5);
		
	} else {
		// No image, so make the border fill our avilable space.
		imageRect = NSOffsetRect(NSMakeRect(NSMinX(cellFrame) + photoPadding + _photoBorder, 
											  NSMinX(cellFrame) + photoPadding + _photoBorder, 
											  floor(bounds.size.width - (photoPadding * 2) - (_photoBorder * 2)), 
											  floor(bounds.size.height - (photoPadding * 2) - (_photoBorder * 2))), 0.5, 0.5);
	}
	
	if (imageRect.size.width < imageRect.size.height) {
		_borderRect = NSInsetRect(imageRect, -(imageRect.size.width * _photoBorder), -(imageRect.size.width * _photoBorder));
	} else { 
		_borderRect = NSInsetRect(imageRect, -(imageRect.size.height * _photoBorder), -(imageRect.size.height * _photoBorder));
	} 
	
	//NSLog(@"%1.0f, %1.0f, %1.0f, %1.0f", _borderRect.origin.x, _borderRect.origin.y, _borderRect.size.width, _borderRect.size.height);

	//NSLog(@"%1.4f", _photoBorder);
		
	
	//[controlView removeTrackingRect:_trackingRect];
	//_trackingRect = [controlView addTrackingRect:_borderRect owner:self userData:nil assumeInside:NO];
	
	//NSRect borderRect = NSOffsetRect(NSMakeRect(photoPadding, photoPadding, floor(bounds.size.width - (photoPadding * 2)), floor(bounds.size.height - (photoPadding * 2))), 0.5, 0.5);
	
	NSGraphicsContext* theContext = [NSGraphicsContext currentContext];
	[theContext saveGraphicsState];

	if ([self shadow]) {
		[[self shadow] set];
	}
	
	if (_drawsDragHilight) {
		[[NSColor selectedControlColor] set];
	} else {
		[[[NSColor whiteColor] colorWithAlphaComponent:1.0] set];
	}
	
	
	
	if ([self showPageCurl]) {
		
		NSImage *pageBackgroundImage = [[NSImage alloc] initWithSize:NSMakeSize(_borderRect.size.width,
																				_borderRect.size.height)];
		
		[pageBackgroundImage lockFocus];
		
		NSImage *pageCurl = [NSImage imageNamed:@"PageCurl"];
		
		NSBezierPath *background = [NSBezierPath bezierPath];
		
		BOOL flipped = [controlView isFlipped];
		
		[background appendBezierPathWithRect:NSMakeRect(0.0, 
														flipped ? 0.0 : [pageCurl size].height - 1, 
														NSWidth(_borderRect),
														NSHeight(_borderRect) - [pageCurl size].height + 1)];
		
		[background appendBezierPathWithRect:NSMakeRect(0.0, 
														flipped ? _borderRect.size.height - [pageCurl size].height : 0.0,
														NSWidth(_borderRect) - [pageCurl size].width + 1, 
														[pageCurl size].height)];
		[[NSColor whiteColor] set]; 
		[background fill];
		
		BOOL curlWasFlipped = [pageCurl isFlipped];
		[pageCurl setFlipped:flipped];
		
		[pageCurl drawAtPoint:NSMakePoint(_borderRect.size.width - [pageCurl size].width, 
										  flipped ? _borderRect.size.height - [pageCurl size].height : 0.0)
					 fromRect:NSZeroRect
					operation:NSCompositeSourceOver
					 fraction:1.0];
		
		[pageCurl setFlipped:curlWasFlipped];
		
		[pageBackgroundImage unlockFocus];
		
		[pageBackgroundImage setFlipped:[controlView isFlipped]];
		
		[pageBackgroundImage drawInRect:_borderRect
							   fromRect:NSZeroRect
							  operation:NSCompositeSourceOver
							   fraction:1.0];
		
		[pageBackgroundImage release];
		pageBackgroundImage = nil;
		
		
		
	} else {
		[NSBezierPath fillRect:_borderRect];
	}
	
	[theContext restoreGraphicsState];
	
	/*float er;
	
	if (_borderRect.size.width < _borderRect.size.height) {
		er = _borderRect.size.width * _photoBorder;
	} else { 
		er = _borderRect.size.height * _photoBorder;
	}
	*/
	//NSRect imageRect = _borderRect; //NSMakeRect(_borderRect.origin.x + er, _borderRect.origin.y + er, 
									//_borderRect.size.width - (er * 2), _borderRect.size.height - (er * 2));
	
	
	[[NSGraphicsContext currentContext] saveGraphicsState];
	
	if ([self showPageCurl]) {
		
		BOOL flipped = [controlView isFlipped];
		
		NSBezierPath *clipPath = [[NSBezierPath alloc] init];
		[clipPath moveToPoint:_borderRect.origin];
		
		if (flipped) {
			[clipPath lineToPoint:NSMakePoint(NSMaxX(_borderRect), _borderRect.origin.y)];
			[clipPath lineToPoint:NSMakePoint(NSMaxX(_borderRect), NSMaxY(_borderRect) - clipHeight)];
			[clipPath lineToPoint:NSMakePoint(NSMaxX(_borderRect) - clipWidth, NSMaxY(_borderRect))];
			[clipPath lineToPoint:NSMakePoint(NSMinX(_borderRect), NSMaxX(_borderRect))];
		} else {
			[clipPath lineToPoint:NSMakePoint(NSMaxX(_borderRect) - clipWidth, _borderRect.origin.y)];
			[clipPath lineToPoint:NSMakePoint(NSMaxX(_borderRect), _borderRect.origin.y + clipHeight)];
			[clipPath lineToPoint:NSMakePoint(NSMaxX(_borderRect), NSMaxY(_borderRect))];
			[clipPath lineToPoint:NSMakePoint(NSMinX(_borderRect), NSMaxY(_borderRect))];
		}
		
		[clipPath closePath];
		[clipPath setClip];
		[clipPath release];
		
	}
	
	if ([_photo ciImage]) {
	
		// Disabling hardware rendering prevents problems with junk pixels when resizing 
		// images on the 9400M GPU (and possibly others).
		
	
		//[[_photo getImage] drawInRect:imageRect fromRect:NSZeroRect operation:NSCompositeCopy fraction:1];
		
		CIImage *photo = nil;
		CGRect actualImageRect;
		
		if (_temporaryPhoto) { 
			photo = [_temporaryPhoto ciImage];
			
			// We need to fit this sensibly inside imageRect
			
			float tempBoxWidthHeightRatio = imageRect.size.height / imageRect.size.width;
			float tempPictureWidthHeightRatio = [photo extent].size.height / [photo extent].size.width;
			float tempWidth = 0;
			float tempHeight = 0;
			float tempX = 0.0;
			float tempY = 0.0;
			
			//NSLog(@"%1.2f, %1.2f", tempBoxWidthHeightRatio, tempPictureWidthHeightRatio);
			
			if (tempPictureWidthHeightRatio > tempBoxWidthHeightRatio) {
				// Picture should be sized by height (i.e., the box is wider than the picture)
				// This means the vertical (top and bottom [y axis]) edges will touch the edges of the padding
				
				tempHeight = floor(imageRect.size.height);
				tempWidth = floor (tempHeight / tempPictureWidthHeightRatio);
				
				tempY = NSMinY(imageRect);
				tempX = NSMinX(imageRect) + floor((imageRect.size.width / 2) - (tempWidth / 2));
				
			} else {
				// Picture should be sized by width (the box is higher than the picture)
				
				tempWidth = floor(imageRect.size.width);
				tempHeight = floor(tempWidth * tempPictureWidthHeightRatio);
				tempX = NSMinX(imageRect);
				tempY = NSMinY(imageRect) + floor((imageRect.size.height / 2) - (tempHeight / 2));
			}
			
			actualImageRect = CGRectOffset(CGRectMake(tempX,tempY,tempWidth,tempHeight), 0.5, 0.5);
			
			
		} else {
			photo = [_photo ciImage];
			actualImageRect = *(CGRect *)&imageRect;
		}
		 
		if ([controlView isFlipped]) {
			CGAffineTransform transform;
			transform = CGAffineTransformMakeTranslation(0.0,[photo extent].size.height);
			transform = CGAffineTransformScale(transform, 1.0, -1.0);
			photo = [photo imageByApplyingTransform:transform];
		}
		
		CGImageRef photoRef = [[[[NSBitmapImageRep alloc] initWithCIImage:photo] autorelease] CGImage];
		
		CGContextDrawImage([[NSGraphicsContext currentContext] graphicsPort], actualImageRect, photoRef);
		
		_photoRect = NSRectFromCGRect(actualImageRect);
		
		[[NSColor colorWithCalibratedWhite:0.9 alpha:1.0] set]; 
		[NSBezierPath strokeRect:imageRect];
		
	} else {
		
		[[NSColor colorWithCalibratedWhite:0.9 alpha:1.0] set]; 
		[NSBezierPath strokeRect:imageRect];

		
		NSAttributedString *theText;
		NSMutableParagraphStyle *paragraph;
		
		paragraph = [[NSParagraphStyle defaultParagraphStyle] mutableCopy];
		[paragraph setAlignment:NSCenterTextAlignment]; 
		
		NSMutableDictionary *dict = 
		[NSMutableDictionary dictionaryWithObjectsAndKeys:
		 [NSFont userFontOfSize:11.0],
		 NSFontAttributeName,
		 [NSColor colorWithCalibratedWhite:0.9 alpha:1.0],
		 NSForegroundColorAttributeName,
		 paragraph,
		 NSParagraphStyleAttributeName,
		 nil]; 
		
		//[dict addEntriesFromDictionary:[_fontDescriptor fontAttributes]];
		
		theText = [[NSAttributedString alloc] initWithString: @"No Image" attributes: dict];
		
		NSSize textSize = [theText size];
		
		[theText drawInRect:NSMakeRect(0, (bounds.size.height / 2) - (textSize.height / 2), bounds.size.width, textSize.height)];
		
		[theText release];
		[paragraph release];
		 
	}
	
	[[NSGraphicsContext currentContext] restoreGraphicsState];
	
	if (_selectRectOpacity > 0.0) {
	
		[theContext saveGraphicsState];
		
		NSShadow *shadow = [[[NSShadow alloc] init] autorelease];
		[shadow setShadowBlurRadius:2];
		[shadow setShadowColor:[[NSColor darkGrayColor] colorWithAlphaComponent:_selectRectOpacity]];
		[shadow setShadowOffset:NSMakeSize(1,-1)];
		[shadow set];
		
		
		[[[NSColor yellowColor] colorWithAlphaComponent:_selectRectOpacity] set];
		
		// We want a border that's 1px from our bounds and 1px from our _borderRect
		
		NSBezierPath *strokePath;
		strokePath = [[NSBezierPath alloc] init];
		
		
		 if (pictureWidthHeightRatio > boxWidthHeightRatio) {
			 // Picture should be sized by height (i.e., the box is wider than the picture)
			 [strokePath setLineWidth: _borderRect.origin.y - 5];
		 } else {
			 [strokePath setLineWidth: _borderRect.origin.x - 5];
		 }
		
		NSRect selectionRect = NSMakeRect(_borderRect.origin.x - [strokePath lineWidth], _borderRect.origin.y - [strokePath lineWidth],
										  _borderRect.size.width + ([strokePath lineWidth] * 2), _borderRect.size.height + ([strokePath lineWidth] * 2));
		
		[strokePath appendBezierPathWithRect:selectionRect];
		[strokePath stroke];
		[strokePath release];	
		
		[theContext restoreGraphicsState];

		
	}
	
	if ([self showPushpin]) {
	
			
		NSImage *pin = [NSImage imageNamed:@"PushPin"];
		BOOL wasFlipped = [pin isFlipped];
		[pin setFlipped:[controlView isFlipped]]; 
		
		[pin drawAtPoint:NSMakePoint(NSMidX(_borderRect) - ([pin size].width / 2) + 16.0,
									 [controlView isFlipped] ? 
									 NSMinY(_borderRect) : 
									 (NSMaxY(_borderRect) - ([pin size].height / 1.25)))
				fromRect:NSZeroRect
			   operation:NSCompositeSourceOver
				fraction:1.0];
		
		
		[pin setFlipped:wasFlipped];
		
	}
	
	if ([self showPageCurl]) {
	
		NSImage *curlCorner = [NSImage imageNamed:@"CurlCorner"];
		
		BOOL wasFlipped = [curlCorner isFlipped];
		[curlCorner setFlipped:[controlView isFlipped]];
		
		[curlCorner drawAtPoint:NSMakePoint(NSMaxX(_borderRect) - [curlCorner size].width, 
											[controlView isFlipped] ? NSMaxY(_borderRect) - [curlCorner size].height : _borderRect.origin.y)
					   fromRect:NSZeroRect
					  operation:NSCompositeSourceOver
					   fraction:1.0];
		
		[curlCorner setFlipped:wasFlipped];
	}
	
	
	
}

@end

#pragma mark -


@implementation KNPrettyPhoto

+ (void)initialize {
    if (self == [KNPrettyPhoto class]) {		// Do it once
        [self setCellClass: [KNPrettyPhotoCell class]];
    }
	
	[self exposeBinding:@"photo"];
	[self exposeBinding:@"photoCollection"];
}

+ (Class)cellClass {
    return [KNPrettyPhotoCell class];
}

- (id)initWithFrame:(NSRect)frame border:(float)border{

    self = [super initWithFrame:frame];
    if (self) {
		
		//[self registerForDraggedTypes:[Entity entityDragTypes]];
		
		_trackingRect = [self addTrackingRect:NSMakeRect(0, 0, frame.size.width, frame.size.height) owner:self userData:nil assumeInside:NO];
		
		[[self cell] setPhotoBorder:border];
		
		[self setRefusesFirstResponder:NO];
		
    }
    return self;
}

-(BOOL)isFlipped {
	return flipped;
}

-(void)setIsFlipped:(BOOL)f {
	flipped = f;
}

- (void)setFrame:(NSRect)frameRect {
	
	[super setFrame:frameRect];
	
	[self removeTrackingRect:_trackingRect];
	_trackingRect = [self  addTrackingRect:NSMakeRect(0, 0, frameRect.size.width, frameRect.size.height) owner:self userData:nil assumeInside:NO];
	
}


- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [super dealloc];
}

-(void)setDraggingDestinationDelegate:(id)del {
	[del retain];
	[draggingDestinationDelegate release];
	draggingDestinationDelegate = del;
	
}

-(id)draggingDestinationDelegate {
	return draggingDestinationDelegate;
}

-(void)setPhoto:(id <KNPhoto>)photo {
	
	[[self cell] setPhoto:photo];
}

-(id <KNPhoto>)photo {
	return [[self cell] photo];
}

-(void)setPhotoCollection:(NSSet *)collection {
	[[self cell] setPhotoCollection:collection];
}

-(NSSet *)photoCollection {
	return [[self cell] photoCollection];
}

-(void)setPhotoBorder:(float)width {
	[[self cell] setPhotoBorder:width];
}

-(float)photoBorder {
	return [[self cell] photoBorder];
}

-(void)setSelected:(BOOL)selected {
	[[self cell] setSelected:selected];
}

-(BOOL)selected  {
	return [[self cell] selected];
}	
	
-(void)setPreDragSelected:(BOOL)selected {
	return [[self cell] setPreDragSelected:selected];
}
	
-(BOOL)preDragSelected {
	return [[self cell] preDragSelected];
}

-(NSRect)photoRect {
	return [[self cell] photoRect];
}

-(void)setShadow:(NSShadow *)shadow {
	[[self cell] setShadow:shadow];
}

-(NSShadow *)shadow {
	return [[self cell] shadow];
}

-(void)setShowPushpin:(BOOL)show {
	[[self cell] setShowPushpin:show];
}

-(BOOL)showPushpin {
	return [[self cell] showPushpin];
}

-(void)setShowPageCurl:(BOOL)show {
	[[self cell] setShowPageCurl:show];
}

-(BOOL)showPageCurl {
	return [[self cell] showPageCurl];
}

- (void)updateCell:(NSCell *)aCell {

	[super updateCell:aCell];
	
	[self removeTrackingRect:_trackingRect];
	_trackingRect = [self addTrackingRect:[[self cell] photoRect] owner:self userData:nil assumeInside:NO];
	
}

- (BOOL)canBecomeKeyView {

	return YES;
	
}

- (BOOL)becomeFirstResponder {
	return YES;
}

- (BOOL)acceptsFirstResponder {
	return YES;
}

- (void)viewDidMoveToWindow {

	[[self window] setAcceptsMouseMovedEvents:YES];
}



-(id <KNPrettyPhotoDelegate>)prettyPhotoDelegate {
	return prettyPhotoDelegate;
}

-(void)setPrettyPhotoDelegate:(id <KNPrettyPhotoDelegate>)del {
	[del retain];
	[prettyPhotoDelegate release];
	prettyPhotoDelegate = del;
}

#pragma mark -
#pragma mark Mouse

-(void)mouseDown:(NSEvent *)theEvent {
	
	
	[[self window] makeFirstResponder:self];
	
}

- (void)mouseMoved:(NSEvent *)theEvent {
	
	if (NSPointInRect([self convertPointFromBase:[theEvent locationInWindow]], [self bounds])) {
		[[self cell] mouseMoved:theEvent];
	}
	
}

- (void)mouseExited:(NSEvent *)theEvent {
	
	[[self cell] mouseExited:theEvent];
}

- (void)keyDown:(NSEvent *)theEvent {

	if ([theEvent keyCode] == 49) {
		if ([[self cell] temporaryPhoto]) {
			[[self prettyPhotoDelegate] prettyPhoto:self didChoosePhoto:[[self cell] temporaryPhoto]];
		}
	}
	
}

#pragma mark -
#pragma mark  draggingDestinationDelegate

- (void)concludeDragOperation:(id < NSDraggingInfo >)sender {
	if ([[self draggingDestinationDelegate] respondsToSelector:@selector(concludeDragOperation:)]) {
		[[self draggingDestinationDelegate] performSelector:@selector(concludeDragOperation:) withObject:sender];
	}
}

- (void)draggingEnded:(id < NSDraggingInfo >)sender {
	if ([[self draggingDestinationDelegate] respondsToSelector:@selector(draggingEnded:)]) {
		[[self draggingDestinationDelegate] performSelector:@selector(draggingEnded:) withObject:sender];
	}
}

- (NSDragOperation)draggingEntered:(id < NSDraggingInfo >)sender {
	if ([[self draggingDestinationDelegate] respondsToSelector:@selector(draggingEntered:)]) {
		return (NSDragOperation) (intptr_t)[[self draggingDestinationDelegate] performSelector:@selector(draggingEntered:) withObject:sender];
	} else {
		return NSDragOperationNone;
	}
}

- (void)draggingExited:(id < NSDraggingInfo >)sender {
	if ([[self draggingDestinationDelegate] respondsToSelector:@selector(draggingExited:)]) {
		[[self draggingDestinationDelegate] performSelector:@selector(draggingExited:) withObject:sender];
	}
}

- (NSDragOperation)draggingUpdated:(id < NSDraggingInfo >)sender {
	if ([[self draggingDestinationDelegate] respondsToSelector:@selector(draggingUpdated:)]) {
		return (NSDragOperation) (intptr_t)[[self draggingDestinationDelegate] performSelector:@selector(draggingUpdated:) withObject:sender];
	} else {
		return NSDragOperationNone;
	}
}

- (BOOL)performDragOperation:(id < NSDraggingInfo >)sender {
	if ([[self draggingDestinationDelegate] respondsToSelector:@selector(performDragOperation:)]) {
		return (BOOL) (intptr_t)[[self draggingDestinationDelegate] performSelector:@selector(performDragOperation:) withObject:sender];
	} else {
		return NO;
	}
}

- (BOOL)prepareForDragOperation:(id < NSDraggingInfo >)sender {
	if ([[self draggingDestinationDelegate] respondsToSelector:@selector(prepareForDragOperation:)]) {
		return (BOOL) (intptr_t)[[self draggingDestinationDelegate] performSelector:@selector(prepareForDragOperation:) withObject:sender];
	} else {
		return NO;
	}
}

- (BOOL)wantsPeriodicDraggingUpdates {
	if ([[self draggingDestinationDelegate] respondsToSelector:@selector(wantsPeriodicDraggingUpdates)]) {
		return (BOOL) (intptr_t)[[self draggingDestinationDelegate] performSelector:@selector(wantsPeriodicDraggingUpdates)];
	} else {
		return YES;
	}
}

@end