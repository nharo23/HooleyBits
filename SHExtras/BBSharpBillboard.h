//
//  BBRenderer.h
//  BBExtras
//
//  Created by Jonathan del Strother on 06/02/2006.
//  Copyright 2006 Best Before Media Ltd. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "QCClasses.h"
// These are possible input/output types.  You don't need these if you
// don't have inputs/outputs, but it doesn't hurt to leave them.
//
// TODO: I need to post the headers to each of these so you can
// see the methods available.
	
@class QCIndexPort, QCNumberPort, QCStringPort,
        QCBooleanPort, QCVirtualPort, QCColorPort,
        QCGLImagePort, QCStructurePort;
	
@interface BBSharpBillboard : QCBillboard {
}
	
- (id)setup:(id)fp8;

@end