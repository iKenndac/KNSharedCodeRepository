/*
=========
 LICENSE 
=========
 
 In a nutshell:
 
 1. You can use this code as you wish in your own products, whether they are open source, free or commercial.
 
 2. You may modify the code.
 
 3. If you redistribute the code without modifying it, you must include the original license. 
 
 4. In all cases, you must attribute KennettNet Software Limited as the original author in a reasonable place in your product.
 
 5. We’re not liable for the code, nor can we provide any support for it.
 
 6. If you don’t agree to this license, don’t use our code!
 
 The Agreement
 Copyright (c) 2010 KennettNet Software Limited
 All rights reserved.
 
 Redistribution and use in source and binary forms, with or without
 modification, are permitted provided that the following conditions
 are met:
 1. Redistributions of source code must retain the above copyright
 notice, this list of conditions and the following disclaimer.
 2. Redistributions in binary form must, in all cases, contain attribution of
 KennettNet Software Limited as the original author of the source code
 shall be included in all such resulting software products or distributions.
 3. The name of the author may not be used to endorse or promote products
 derived from this software without specific prior written permission.
 
 THIS SOFTWARE IS PROVIDED BY THE AUTHOR “AS IS” AND ANY EXPRESS OR
 IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES
 OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED.
 IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR ANY DIRECT, INDIRECT,
 INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT
 NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE,
 DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY
 THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
 (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF
 THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
 
====================
 ABOUT THIS CLASS
====================
 
This class manages resources in a document's bundle, although the class isn't 
 actually tied to the document instance. Instead, the document creates an instance 
 of this and tells it where the document's bundle is, and when to save or revert. 
 
 This class is needed as the document may need file-based resources such as images. However, the user may decide 
 that they don't want the resource after all and close without saving. In this case, the document's bundle shouldn't be 
 filled with files that shouldn't be there. Likewise, when adding and removing resources (and undo/redoing these operations)
 the bundle should be kept consistent with the state of the saved model rather than the working model. 
 
Files are kept in the correct location at all times to ensure the integrity of the document's pacakage on disk:
 
 - Newly added resources are kept in -transientResourcesDirectory.
 - When -commit is called, they're moved into the bundle.
 - Files aren't ever moved in or out of the bundle until -commit or is called.
 - Use -revert to revert the internal state of the class to match the state on disk.
 - Files aren't ever deleted until the instance is deallocated. This allows undo past save points.
 - Removing a resource will put it into the removedResources list, to be moved out of the bundle on the next -commit.
 - Use -restoreResourceWithId: to restore a previous resource at any time. The file will be moved into the bundle on the next -commit.
 
 The class supports using resources when the bundle is nil - i.e., before a document is saved for the first time. 
 In this case, everything is kept in the transientResources dictionary until a bundle is set and -commit is called.
 
 The class also supports properties in a manner very similar to NSUserDefaults. These properties are saved 
 independently of the resources - you don't need to call -commit to save them, and -revert has no effect. This 
 allows you to save, for example, the document's window position without the user having to hit save for them
 to be remembered. 
 
 */

#import <Foundation/Foundation.h>

// Using this protocol, classes that need to be self-aware about their location (such as a Core Data
// entity) can have the resource manager set as their delegate without having to know the full
// workings of the class.

@protocol KNBundledResourceDelegate <NSObject>

-(NSString *)pathForResourceWithId:(NSString *)resourceid;

@end

@interface KNBundledDocumentResourceManager : NSObject <KNBundledResourceDelegate> {
	
	NSBundle *documentBundle;
	NSMutableDictionary *transientResources;
	NSMutableDictionary *removedResources;
	NSMutableDictionary *transientRemovedResources;
	// ^ key:id value:full path
	
	NSMutableDictionary *properties;
	
	BOOL propertiesAreWaitingToBeSaved;
}

// Feel free to pass nil and set the bundle later.
-(id)initWithDocumentBundle:(NSBundle *)bundle;

@property (retain, readwrite, nonatomic) NSBundle *documentBundle;

// The directory used for committed resources.
-(NSString *)resourcesDirectory;
  
// Add resources to the bundle. The returned string is the resource ID used to reference the given resource. 
-(NSString *)addResourceFromPath:(NSString *)resourcePath;
-(NSString *)addResourceFromData:(NSData *)data;

// Remove the given resource from the document. File will be removed from the bundle on the next commit. 
-(void)removeResourceWithId:(NSString *)resourceid;

// Restore a resource back to the document after is has been removed, even if the removal has been committed 
// (i.e., for undo). The file will be moved into the bundle on the next commit. 
-(void)restoreResourceWithId:(NSString *)resourceid;

// Get the full path for the given resource. This *will* change on commit/revert, so don't cache it. 
-(NSString *)pathForResourceWithId:(NSString *)resourceid;

// Commit will move all resources to their correct places on the main thread.
-(void)commit;
// Revert does nothing to files on disk, but resets state back to the last commit.
-(void)revert;

// Properties

+(void)setDefaultProperties:(NSDictionary *)props;
+(NSDictionary *)defaultProperties;

-(BOOL)boolForKey:(NSString *)key;
-(void)setBool:(BOOL)b forKey:(NSString *)key;

-(float)floatForKey:(NSString *)key;
-(void)setFloat:(float)f forKey:(NSString *)key;

-(id)propertyForKey:(NSString *)key;
-(void)setProperty:(id)p forKey:(NSString *)key;

@end
