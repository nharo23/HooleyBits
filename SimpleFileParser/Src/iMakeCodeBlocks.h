//
//  iMakeCodeBlocks.h
//  SimpleFileParser
//
//  Created by Steven Hooley on 30/06/2010.
//  Copyright 2010 Tinsal Parks. All rights reserved.
//

@class CodeLine;

@protocol iMakeCodeBlocks

- (void)newCodeBlockWithName:(NSString *)funcName;

//-- this will change
- (void)addCodeLine:(CodeLine *)codeLine;

@end