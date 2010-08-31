//
//  OtoolDisassemblyParser.m
//  SimpleFileParser
//
//  Created by Steven Hooley on 04/08/2010.
//  Copyright 2010 Tinsal Parks. All rights reserved.
//

#import "OtoolDisassemblyParser.h"
#import "CodeBlockFactory.h"
#import "CodeBlockStore.h"
#import "SourceLineCategorizer.h"
#import "LinesInStringIterator.h"
#import "StringCounter.h"
#import "CodeLine.h"
#import "HexConversions.h"
#import "TokenArray.h"
#import "ArgumentScanner.h"
#import "InstructionHash.h"
#import "Instruction.h"
#import "StringCounter.h"
#import "BasicToken.h"
#import "HexToken.h"
#import "HexValueHash.h"
#import "HexLookup.h"
#import "Argument.h"

@interface OtoolDisassemblyParser ()

- (CodeLine *)_tokeniseLine:(NSString *)aLine;
@end

#pragma mark -
@implementation OtoolDisassemblyParser

@synthesize codeBlockStore = _codeBlockStore;

+ (CodeBlockStore *)constructInternalRepresentation:(NSString *)fileString {

	OtoolDisassemblyParser *parser = [self OtoolDisassemblyParserWithSrcString:fileString];
	return parser.codeBlockStore;
}

+ (id)OtoolDisassemblyParserWithSrcString:(NSString *)fileString {
	
	return [[[self alloc] initWithSrcString:fileString] autorelease];
}

- (id)initWithSrcString:(NSString *)fileString {

	self = [super init];
	if(self) {
		
		_instructionHash = [instHash retain];
		
		_codeBlockStore = [[CodeBlockStore store] retain];
		_codeBlockfactory = [[CodeBlockFactory factoryWithStore:_codeBlockStore] retain];

		SourceLineCategorizer *groker = [SourceLineCategorizer grokerWithDelegate:self];
		[LinesInStringIterator feedLines:fileString to:groker];
	}
	return self;
}

- (void)dealloc {

	[_codeBlockStore release];
	[_codeBlockfactory release];
	[_instructionHash release];

	[super dealloc];
}

- (void)noMoreLinesComing {

	[self constructBlock];
}

- (void)newTitle:(NSString *)lineText {
	
	if(_title){
		[self constructBlock];
	}
	_title = [lineText retain];
	_blockLines = [[NSMutableArray alloc] init];
}

- (void)newLine:(NSString *)lineText {

	NSAssert(_blockLines, @"fuck off");
	//[self constructLine:lineText];
	[_blockLines addObject:lineText];
}

typedef void(^BasicBlock)(void); 

- (void)constructBlock {

	NSArray *tempArray = [_blockLines copy];
	dispatch_queue_t q_default = dispatch_get_global_queue(0, 0);
	BasicBlock block = ^{
		
		NSMutableArray *lines = [[NSMutableArray alloc] initWithCapacity:[tempArray count]];
		for( NSString *eachStr in tempArray ) {
			// TODO: wy is this an instance method?
			CodeLine *line = [self _tokeniseLine:eachStr];
			if(line)
				[lines addObject:line];
		}
		// TODO: how to do this?
		[_codeBlockfactory newCodeBlockWithName:_title lines:lines];
		[lines release];
		[tempArray release];
	}; 

	dispatch_async( q_default, block );
	
	[_title release];
	_title = nil;
	[_blockLines release];
	_blockLines = nil;
}

//- (void)constructLine:(NSString *)lineText {
	
//	CodeLine *line = [self _tokeniseLine:lineText];
//	[_codeBlockfactory addCodeLine:line];
//}

- (void)processSrcLine:(NSString *)lineText type:(enum srcLineType)lineType {

	switch (lineType) {
		case BLOCK_TITLE:
			[self newTitle:lineText];
			break;
		case BLOCK_LINE:
			[self newLine:lineText];
			break;
		default:
			[NSException raise:@"Unknown Src Line type" format:@"%i", lineType];
			break;
	}	
}

// -- exactly how much should we do here?
- (CodeLine *)_tokeniseLine:(NSString *)aLine {
		
	NSArray *components = worderize( aLine );

	// not optional
	// NSString *lineOffset = [components objectAtIndex:0];
	NSString *address = [components objectAtIndex:1];
	// NSString *code = [components objectAtIndex:2];
	NSString *opcode = [components objectAtIndex:3];

	// Instructions are cached - ie you should always get the same Instruction back for the same opcode
	Instruction *instr = [_instructionHash instructionForOpcode:opcode];
	
	NSString *arguments=nil, *functionHint=nil;
	NSArray *allArgs = nil;

	// optional
	if([components count]>=5)
	{
		arguments = [components objectAtIndex:4];
		TokenArray *tkns1 = [TokenArray tokensWithString:arguments];
		[tkns1 secondPass];
		ArgumentScanner *scanner = [ArgumentScanner scannerWithTokens:tkns1];
		
		allArgs = [scanner.allArguments copy];
		NSAssert([allArgs count]<=3, @"we should formalise this - there is never more than 2 - we dont need an array");
	}
	if([components count]>=6)
		functionHint = [components objectAtIndex:5];

	NSUInteger addressInt = hexStringToInt(address);
	CodeLine *newLine = [CodeLine lineWithAddress:addressInt instruction:instr args:allArgs];
	return newLine;
}



@end

