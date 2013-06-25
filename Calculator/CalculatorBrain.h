//
//  CalculatorBrain.h
//  Calculator
//
//  Created by CS193p Instructor.
//  Copyright (c) 2011 Stanford University.
//  All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CalculatorBrain : NSObject

- (void)pushOperand:(double)operand;
- (id)performOperation:(NSString *)op;
- (void)clearStack;
- (void)pushVariable:(NSString *)variable;
- (void)removeLastObjectFromProgramStack;

@property (nonatomic, readonly) NSArray *variablesUsedInProgram;
@property (nonatomic, readonly) id program;

+ (NSString *)descriptionOfProgram:(id)program;
+ (id)runProgram:(id)program;
+ (id)runProgram:(id)program 
 usingVariableValues:(NSDictionary *)variables;
@end
