//
//  RSDependencyOperation.m
//  RSColorPicker
//
//  Created by Ryan Sullivan on 7/22/13.
//  Copyright (c) 2013 Freelance Web Developer. All rights reserved.
//

#import "RSDependencyOperation.h"

@implementation RSDependencyOperation

-(NSOperation*)dependency {
    if (self.dependencies.count < 1) return nil;
    return [self.dependencies objectAtIndex:0];
}

-(void)main {
    return;
}

-(BOOL)isFinished {
    return self.dependency.isFinished;
}

-(BOOL)isExecuting {
    return self.dependency.isExecuting;
}

-(BOOL)isConcurrent {
    return self.dependency.isConcurrent;
}

@end
