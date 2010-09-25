//
//  MGMXMLDocument.h
//  MGMXML
//
//  Created by Mr. Gecko on 9/22/10.
//  Copyright (c) 2010 Mr. Gecko's Media (James Coleman). All rights reserved. http://mrgeckosmedia.com/
//

#if TARGET_OS_IPHONE
#import <UIKit/UIKit.h>
#import <MGMXMLNode.h>
#else
#import <Cocoa/Cocoa.h>
#import <VoiceBase/MGMXMLNode.h>
#endif

#define MGMXMLDocPtr (xmlDocPtr)commonXML

@interface MGMXMLDocument : MGMXMLNode {

}
- (id)initWithXMLString:(NSString *)string options:(NSUInteger)mask error:(NSError **)error;
- (id)initWithContentsOfURL:(NSURL *)url options:(NSUInteger)mask error:(NSError **)error;
- (id)initWithData:(NSData *)data options:(NSUInteger)mask error:(NSError **)error; //primitive
//- (id)initWithRootElement:(MGMXMLElement *)element;

//+ (Class)replacementClassForClass:(Class)cls;
//- (void)setCharacterEncoding:(NSString *)encoding; //primitive
//- (NSString *)characterEncoding; //primitive
//- (void)setVersion:(NSString *)version; //primitive
//- (NSString *)version; //primitive
//- (void)setStandalone:(BOOL)standalone; //primitive
//- (BOOL)isStandalone; //primitive
//- (void)setDocumentContentKind:(MGMXMLDocumentContentKind)kind; //primitive
//- (MGMXMLDocumentContentKind)documentContentKind; //primitive
//- (void)setMIMEType:(NSString *)MIMEType; //primitive
//- (NSString *)MIMEType; //primitive
//- (void)setDTD:(MGMXMLDTD *)documentTypeDeclaration; //primitive
//- (MGMXMLDTD *)DTD; //primitive
- (void)setRootElement:(MGMXMLNode *)root;
- (MGMXMLElement *)rootElement; //primitive

//- (void)insertChild:(MGMXMLNode *)child atIndex:(NSUInteger)index; //primitive
//- (void)insertChildren:(NSArray *)children atIndex:(NSUInteger)index;
//- (void)removeChildAtIndex:(NSUInteger)index; //primitive
//- (void)setChildren:(NSArray *)children; //primitive
//- (void)addChild:(MGMXMLNode *)child;
//- (void)replaceChildAtIndex:(NSUInteger)index withNode:(MGMXMLNode *)node;

- (NSData *)XMLData;
- (NSData *)XMLDataWithOptions:(NSUInteger)options;

//- (id)objectByApplyingXSLT:(NSData *)xslt arguments:(NSDictionary *)arguments error:(NSError **)error;
//- (id)objectByApplyingXSLTString:(NSString *)xslt arguments:(NSDictionary *)arguments error:(NSError **)error;
//- (id)objectByApplyingXSLTAtURL:(NSURL *)xsltURL arguments:(NSDictionary *)argument error:(NSError **)error;

//- (BOOL)validateAndReturnError:(NSError **)error;
@end