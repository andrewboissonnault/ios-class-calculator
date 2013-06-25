//
//  CalculatorBrain.m
//  Calculator
//
//  Created by CS193p Instructor.
//  Copyright (c) 2011 Stanford University.
//  All rights reserved.
//

#import "CalculatorBrain.h"
#import "Operators.h"
#import "Program.h"

@interface CalculatorBrain()
@property (nonatomic, strong) NSMutableArray *programStack;
@end

@implementation CalculatorBrain

+ (id)runProgram:(id)inputProgram
{
    return [self runProgram:inputProgram usingVariableValues:nil];
}

+ (id)runProgram:(id)inputProgram
usingVariableValues:(NSDictionary *)variableValues
{
    if ([inputProgram isKindOfClass:[NSArray class]]) {
        if([inputProgram lastObject])
        {
            Program* program = [Program initWithProgram:[inputProgram mutableCopy]];
            return [program calculateResultWithVariableValues:variableValues];
        }
    }
    return @"";
}

//Returns a string description of the program currently stored in the stack.
+ (NSString *)descriptionOfProgram:(id)inputProgram
{
    if ([inputProgram isKindOfClass:[NSArray class]]) {
        Program* program = [Program initWithProgram:[inputProgram mutableCopy]];
        return [program buildProgramDescription];
    }
    return @"";
}

@synthesize programStack = _programStack;

- (NSMutableArray *)programStack
{
    if (_programStack == nil) _programStack = [[NSMutableArray alloc] init];
    return _programStack;
}

//Searches through the programStack for variables and puts their names into an array.
-(NSArray *)variablesUsedInProgram
{
    NSMutableArray *variables = [NSMutableArray arrayWithCapacity:3];
    for(int i=0; i<[self.programStack count]; i++)
    {
        if([[self.programStack objectAtIndex:i] isKindOfClass:[NSString class]])
        {
            if(![Operators isValidOperation:[self.programStack objectAtIndex:i]])
            {
                [variables addObject:[self.programStack objectAtIndex:i]];
            }
        }
    }
    return variables; 
}

- (id)program
{
    return [self.programStack copy];
}

- (void)pushOperand:(double)operand
{
    [self.programStack addObject:[NSNumber numberWithDouble:operand]];
}

- (void)pushVariable:(NSString *)variable
{
    if(![Operators isValidOperation:variable])
    {
        [self.programStack addObject:variable];
    }
}

- (id)performOperation:(NSString *)operation
{
    if([Operators isValidOperation:operation])
    {
        [self pushOperation:operation];
        return [[self class] runProgram:self.program];
    }
    return @"Not An Operation";
}

- (void)pushOperation:(NSString*)operation
{
    [self.programStack addObject:operation];
}

- (void)clearStack
{
    [self.programStack removeAllObjects];
}

- (void)removeLastObjectFromProgramStack
{
    [self.programStack removeLastObject];
}


@end
