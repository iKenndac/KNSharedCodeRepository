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
 */
 
#import "KNBundledDocumentResourceManager.h"

@interface KNBundledDocumentResourceManager (Private)

-(NSString *)createUUID;
-(void)migrateTransientResourcesToBundle;
-(void)migrateRemovedResourcesToTransientRemovedResources;
-(void)removeTransientRemovedResources;
-(NSString *)transientResourcesDirectory;
-(void)saveProperties;
-(NSString *)getUniqueNameForFile:(NSString *)fileName atPath:(NSString *)path secondPath:(NSString *)otherPath;

@end

@implementation KNBundledDocumentResourceManager

static NSDictionary *defaultProperties;
static NSString * const kPropertiesFileName = @"properties.plist";

+(void)setDefaultProperties:(NSDictionary *)props {
	
	[defaultProperties release];
	defaultProperties = [props copy];
	
}

+(NSDictionary *)defaultProperties {
	return defaultProperties;
}

-(id)init {
	
	// Designated initialser 
	
	if ((self = [super init])) {
		transientResources = [[NSMutableDictionary alloc] init];
		removedResources = [[NSMutableDictionary alloc] init];
		properties = [[NSMutableDictionary alloc] init];
		transientRemovedResources = [[NSMutableDictionary alloc] init];
	}
	
	return self;
}


-(id)initWithDocumentBundle:(NSBundle *)bundle {
	
	if ((self = [self init])) {
		[self setDocumentBundle:bundle];
	}
	return self;
}

-(NSString *)getUniqueNameForFile:(NSString *)fileName atPath:(NSString *)path secondPath:(NSString *)otherPath {
	
	// This method passes back a unique file name for the passed file and path(s). 
	// So, for example, if the caller wants to put a file called "Hello.txt" in ~/Desktop
	// and that file already exists, it'll give back ~/Desktop/Hello 2.txt".
	// The method respects extensions and will keep incrementing the number until it finds a 
	// name that's unique in both of the given directories. 
	
	NSFileManager *manager = [NSFileManager defaultManager];
	int uNum = 2;
	
	BOOL fileNameAvailable = NO;
	
	if (otherPath) {
		fileNameAvailable = ((![manager fileExistsAtPath:[path stringByAppendingPathComponent:fileName]]) &&
							 (![manager fileExistsAtPath:[otherPath stringByAppendingPathComponent:fileName]]));
	} else {
		fileNameAvailable = (![manager fileExistsAtPath:[path stringByAppendingPathComponent:fileName]]);
	}
		
	if (fileNameAvailable) {
		return [path stringByAppendingPathComponent:fileName];
	} else {
		
		while ((!fileNameAvailable)) {
			
			NSString *newName = [NSString stringWithFormat:@"%@ %d.%@", [fileName stringByDeletingPathExtension], uNum, [fileName pathExtension]];
			
			if (otherPath) {
				fileNameAvailable = ((![manager fileExistsAtPath:[path stringByAppendingPathComponent:newName]]) &&
									 (![manager fileExistsAtPath:[otherPath stringByAppendingPathComponent:newName]]));
			} else {
				fileNameAvailable = (![manager fileExistsAtPath:[path stringByAppendingPathComponent:newName]]);
			}
			
			if (!fileNameAvailable) { 
				uNum++;
			} else {
				return [path stringByAppendingPathComponent:newName];
			}
		}
	}
	
	return [path stringByAppendingPathComponent:fileName];
	
}

@synthesize documentBundle;

-(void)setDocumentBundle:(NSBundle *)bundle {
	
	if (bundle != documentBundle) {
		
		[bundle retain];
		[documentBundle release];
		documentBundle = bundle;
		
		// Read Properties 
		
		NSData *propertiesData = [NSData dataWithContentsOfFile:[[self resourcesDirectory] stringByAppendingPathComponent:kPropertiesFileName]];
		
		NSDictionary *props = [NSPropertyListSerialization propertyListFromData:propertiesData 
															   mutabilityOption:NSPropertyListImmutable 
																		 format:nil 
															   errorDescription:nil];
		if (props) {
			[properties addEntriesFromDictionary:props];
			[self saveProperties];
		}
	}
}

-(NSString *)resourcesDirectory {
	
	if ([self documentBundle]) {
		return [[self documentBundle] resourcePath];
	} else {
		return NSTemporaryDirectory();
	}
	
}

#pragma mark -
#pragma mark Resources

-(NSString *)addResourceFromPath:(NSString *)resourcePath {
	
	if ([[NSFileManager defaultManager] fileExistsAtPath:resourcePath]) {
		
		NSString *destinationPath = [self getUniqueNameForFile:[resourcePath lastPathComponent] 
														atPath:[self transientResourcesDirectory]
													secondPath:[self resourcesDirectory]];
				
		[[NSFileManager defaultManager] copyItemAtPath:resourcePath 
												toPath:destinationPath
												 error:nil];
		
		// The fact that the resource id is the filename is an implementation detail, and subject to change.
		NSString *resourceId = [destinationPath lastPathComponent];
		
		[transientResources setValue:destinationPath 
							  forKey:resourceId];
		
		return resourceId;
	}
	
	return nil;
}

-(NSString *)addResourceFromData:(NSData *)data {
	
	NSString *uuid = [self createUUID];
	
	NSString *destinationPath = [[self transientResourcesDirectory] stringByAppendingPathComponent:uuid];
	
	[data writeToFile:destinationPath atomically:NO];
	
	[transientResources setValue:destinationPath forKey:uuid];
	
	return uuid;
	
}

-(void)removeResourceWithId:(NSString *)resourceid {
	
	// Remove transient resource and bundle resource. Remember, we don't actually move any files yet.
	
	if ([transientResources valueForKey:resourceid]) {
		
		NSString *resourcePath = [transientResources valueForKey:resourceid];
		
		[transientResources removeObjectForKey:resourceid];
		[transientRemovedResources setValue:resourcePath forKey:resourceid];
		
	} else if ([self documentBundle]) {
		
		NSString *bundlePath = [[[self documentBundle] resourcePath] stringByAppendingPathComponent:resourceid];
		
		if ([[NSFileManager defaultManager] fileExistsAtPath:bundlePath]) {
			[removedResources setValue:bundlePath forKey:resourceid];
			
		}
		
	}
	
}

-(void)restoreResourceWithId:(NSString *)resourceid {
	
	if ([transientRemovedResources valueForKey:resourceid]) {
		// A transient removed resource becomes a transient resource 
		
		[transientResources setValue:[transientRemovedResources valueForKey:resourceid]
							  forKey:resourceid];
		
		[transientRemovedResources removeObjectForKey:resourceid];
	}
	
	if ([removedResources valueForKey:resourceid]) {
		[removedResources removeObjectForKey:resourceid];
	}
	
	
}

-(NSString *)pathForResourceWithId:(NSString *)resourceid {
	
	if ([transientResources valueForKey:resourceid]) {
		
		return [transientResources valueForKey:resourceid];
		
	} else {
		
		if ((![removedResources valueForKey:resourceid]) && (![transientRemovedResources valueForKey:resourceid])) {
			
			NSString *path = [[[self documentBundle] resourcePath] stringByAppendingPathComponent:resourceid];
			
			if ([[NSFileManager defaultManager] fileExistsAtPath:path]) {
				return path;
			}
		}
		
		return nil;	
	}
}

#pragma mark -

-(void)commit {
	
	if ([self documentBundle]) {
		
		[self migrateTransientResourcesToBundle];
		[self migrateRemovedResourcesToTransientRemovedResources];
		
		if (propertiesAreWaitingToBeSaved) {
			[self saveProperties];
		}
	}
}

-(void)revert {
	
	for (NSString *resourcePath in [transientResources allValues]) {
		// Transients have been added but never commited. Since reverting clears the undo queue, 
		// there's no need to keep these around.
		[[NSFileManager defaultManager] removeItemAtPath:resourcePath error:nil];
	}
	
	[transientResources removeAllObjects];
	
	// If we revert, removed resources become normal ones again.
	[removedResources removeAllObjects];
		
}

#pragma mark -
#pragma mark Properties

-(BOOL)boolForKey:(NSString *)key {
	return [[self propertyForKey:key] boolValue];
}

-(void)setBool:(BOOL)b forKey:(NSString *)key {
	[self setProperty:[NSNumber numberWithBool:b] forKey:key];
}

-(float)floatForKey:(NSString *)key {
	return [[self propertyForKey:key] floatValue];
}

-(void)setFloat:(float)f forKey:(NSString *)key {
	[self setProperty:[NSNumber numberWithFloat:f] forKey:key];
}

-(id)propertyForKey:(NSString *)key {
	id prop = [properties valueForKey:key];
	
	if (!prop) {
		
		prop = [[KNBundledDocumentResourceManager defaultProperties] valueForKey:key];
	}
	
	return prop;
}

-(void)setProperty:(id)p forKey:(NSString *)key {
	[properties setValue:p forKey:key];
	
	if (!propertiesAreWaitingToBeSaved) {
		propertiesAreWaitingToBeSaved = YES;
		[self performSelector:@selector(saveProperties) withObject:nil afterDelay:1.0];
	}
	
}

-(void)saveProperties {
	
	if ([self documentBundle]) {
	
		NSData *data = [NSPropertyListSerialization dataFromPropertyList:properties format:NSPropertyListXMLFormat_v1_0 errorDescription:nil];
		
		if (data) {
			[data writeToFile:[[self resourcesDirectory] stringByAppendingPathComponent:@"properties.plist"] atomically:YES];
			propertiesAreWaitingToBeSaved = NO;
		}
	}
}

#pragma mark -
#pragma mark Private 

-(void)migrateTransientResourcesToBundle {

	NSMutableArray *successfulMoves = [NSMutableArray array];
	
	for (NSString *resourceId in [transientResources allKeys]) {
	
		NSString *resourcePath = [transientResources valueForKey:resourceId];
		
		if ([[NSFileManager defaultManager] fileExistsAtPath:resourcePath]) {
			
			NSString *destinationPath = [[self resourcesDirectory] stringByAppendingPathComponent:[resourcePath lastPathComponent]];
			
			NSError *error = nil;
			[[NSFileManager defaultManager] moveItemAtPath:resourcePath 
													toPath:destinationPath 
													 error:&error];
			
			if (!error) {
				[successfulMoves addObject:resourceId];
			} else {
				NSLog(@"Couldn't move: %@", [error localizedDescription]);
			}
		}
	}
	
	[transientResources removeObjectsForKeys:successfulMoves];
}

-(void)migrateRemovedResourcesToTransientRemovedResources {
	
	NSMutableArray *successfulMoves = [NSMutableArray array];
	
	for (NSString *resourceId in [removedResources allKeys]) {
		
		NSString *resourcePath = [removedResources valueForKey:resourceId];
		
		if ([[NSFileManager defaultManager] fileExistsAtPath:resourcePath]) {
			
			NSString *destinationPath = [[self transientResourcesDirectory] stringByAppendingPathComponent:[resourcePath lastPathComponent]];
			
			NSError *error = nil;
			[[NSFileManager defaultManager] moveItemAtPath:resourcePath toPath:destinationPath error:&error];
			
			if (!error) {
				[successfulMoves addObject:resourceId];
				[transientRemovedResources setValue:destinationPath forKey:resourceId];
			} else {
				NSLog(@"Couldn't move: %@", [error localizedDescription]);
			}
		}
	}
	
	[removedResources removeObjectsForKeys:successfulMoves];
}

-(void)removeTransientRemovedResources {
	
	NSMutableArray *successfulRemoves = [NSMutableArray array];
	
	for (NSString *resourceId in [transientRemovedResources allKeys]) {
		
		NSString *resourcePath = [transientRemovedResources valueForKey:resourceId];
		
		NSError *error = nil;
		[[NSFileManager defaultManager] removeItemAtPath:resourcePath
												   error:&error];
		if (!error) {
			[successfulRemoves addObject:resourceId];
		} else {
			NSLog(@"Couldn't remove: %@", [error localizedDescription]);
		}
	}
	
	[transientRemovedResources removeObjectsForKeys:successfulRemoves];
	
}

-(NSString *)transientResourcesDirectory {
	// The fact that this is the user's temporary directory is an implemenation detail, 
	// and is subject to change.
	return NSTemporaryDirectory();
}

-(NSString *)createUUID {
	//create a new UUID
	CFUUIDRef	uuidObj = CFUUIDCreate(nil);
	//get the string representation of the UUID
	NSString	*newUUID = (NSString*)CFUUIDCreateString(nil, uuidObj);
	CFRelease(uuidObj);
	return [newUUID autorelease];
}


-(void)dealloc {
	
	[self revert]; // Delete the transients so we're not cluttering up the drive
	[self removeTransientRemovedResources]; 
	
	if (propertiesAreWaitingToBeSaved) {
		[self saveProperties];
	}
	
	[self setDocumentBundle:nil];
	
	[removedResources release];
	[transientResources release];
	[transientRemovedResources release];
	[properties release];
	
	[super dealloc];
}

@end
