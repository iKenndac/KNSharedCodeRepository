//
//  KNPrettyPhoto.h
//  iTS Prototype
//
//  Created by Daniel Kennett on 26/09/2007.
//  Copyright 2007 KennettNet Software Limited. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import <KNClarusQuickDocumentParser/KNPhoto.h>

@class KNPrettyPhoto;

@protocol KNPrettyPhotoDelegate <NSObject>

-(void)prettyPhoto:(KNPrettyPhoto *)view didChoosePhoto:(id <KNPhoto>)photo;

@end


@interface KNPrettyPhotoCell : NSActionCell {

	id <KNPhoto> _photo;
	id <KNPhoto> _temporaryPhoto;
	NSSet *photoCollection;
	float _photoBorder;
	BOOL _selected;
	BOOL _preDragSelected;
	BOOL _drawsDragHilight;
	
	BOOL showPushpin;
	BOOL showPageCurl;
	
	NSRect _borderRect;
	NSRect _photoRect;
	
	NSAnimation *_animation;
	float _selectRectOpacity;
	NSShadow *photoShadow;
}


//- (id)initWithFrame:(NSRect)frame border:(float)border;

-(void)setPhoto:(id <KNPhoto>)photo;
-(id <KNPhoto>)photo;

-(void)setPhotoBorder:(float)width;
-(float)photoBorder;

-(void)setSelected:(BOOL)selected;
-(BOOL)selected;

-(void)setShowPushpin:(BOOL)show;
-(BOOL)showPushpin;

-(void)setShowPageCurl:(BOOL)show;
-(BOOL)showPageCurl;

-(void)setPreDragSelected:(BOOL)selected;
-(BOOL)preDragSelected;

-(NSRect)photoRect;

-(void)setShadow:(NSShadow *)shadow;
-(NSShadow *)shadow;

-(void)setPhotoCollection:(NSSet *)collection;
-(NSSet *)photoCollection;

-(id <KNPhoto>)temporaryPhoto;

@end



@interface KNPrettyPhoto : NSControl  {
	
	NSTrackingRectTag _trackingRect;
	id draggingDestinationDelegate;
	id <KNPrettyPhotoDelegate> prettyPhotoDelegate;
	BOOL flipped;
}

- (id)initWithFrame:(NSRect)frame border:(float)border;

-(void)setPhoto:(id <KNPhoto>)photo;
-(id <KNPhoto>)photo;

-(id <KNPrettyPhotoDelegate>)prettyPhotoDelegate;
-(void)setPrettyPhotoDelegate:(id <KNPrettyPhotoDelegate>)del;


-(void)setPhotoCollection:(NSSet *)collection;
-(NSSet *)photoCollection;

-(void)setPhotoBorder:(float)width;
-(float)photoBorder;
-(void)setSelected:(BOOL)selected;
-(BOOL)selected;
-(void)setPreDragSelected:(BOOL)selected;
-(BOOL)preDragSelected;
-(NSRect)photoRect;

-(void)setShowPushpin:(BOOL)show;
-(BOOL)showPushpin;

-(void)setShowPageCurl:(BOOL)show;
-(BOOL)showPageCurl;

-(BOOL)isFlipped;
-(void)setIsFlipped:(BOOL)f;

-(void)setShadow:(NSShadow *)shadow;
-(NSShadow *)shadow;

-(void)setDraggingDestinationDelegate:(id)del;
-(id)draggingDestinationDelegate;

@end