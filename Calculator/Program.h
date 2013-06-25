//
//  ProgramDescription.h
//  Calculator
//
//  Created by Andrew Boissonnault on 6/24/13.
//  Copyright (c) 2013 Lexmark. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Program : NSObject

@property (nonatomic, readonly) NSMutableArray* stack;

-(NSString*)buildProgramDescription;
-(id)calculateResult;
-(id)calculateResultWithVariableValues:(NSDictionary*)variableValues;
+(Program*)initWithProgram:(id)program;

@end
