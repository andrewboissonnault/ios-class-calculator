//
//  ProgramDescription.m
//  Calculator
//
//  Created by Andrew Boissonnault on 6/24/13.
//  Copyright (c) 2013 Lexmark. All rights reserved.
//

#import "Program.h"
#import "Operators.h"

#define NOT_ENOUGH_OPERANDS_ERROR @"Not Enough Operands"
#define DIVIDE_BY_ZERO_ERROR @"Divide By Zero";
#define SQUARE_ROOT_OF_NEGATIVE_ERROR @"Square Root of Negative"
#define UNKNOWN_ERROR @"Unknown Error"


@interface Program()
@property (nonatomic) NSMutableArray* programStack;
@end

@implementation Program

@synthesize programStack;

+(Program*)initWithProgram:(id)program
{
    Program* programDescription = [[Program alloc] init];
    programDescription.programStack = program;
    return programDescription;
}

-(NSString*)buildProgramDescription
{
    NSString *descriptionAccumulator = [self buildNextOperandDescription:NO];
    
    while ([self.programStack lastObject]) {
        NSString* nextOperandDescription = [self buildNextOperandDescription:NO];
        descriptionAccumulator = [NSString stringWithFormat:@"%@, %@", descriptionAccumulator, nextOperandDescription];
    }
    return descriptionAccumulator;
}

-(NSString*)buildDescriptionForNumber:(NSNumber*)number
{
    return [number stringValue];
}

-(NSString*)buildDescriptionForTwoOperands:(NSString*)operator wasPreviousOperatorHighPriority:(BOOL)wasPreviousOperatorHighPriority
{
    BOOL isCurrentOperatorHighPriority = ![Operators isLowPriorityOperator:operator];
    NSString* firstOperandDescription = [self buildNextOperandDescription:isCurrentOperatorHighPriority];
    NSString* secondOperandDescription = [self buildNextOperandDescription:isCurrentOperatorHighPriority];
    
    NSString* operatorDescription = [NSString stringWithFormat:@"%@%@%@", secondOperandDescription, operator, firstOperandDescription];
    if(wasPreviousOperatorHighPriority && [Operators isLowPriorityOperator:operator])
    {
        operatorDescription = [NSString stringWithFormat:@"(%@)", operatorDescription];
    }
    return operatorDescription;
}

-(NSString*)buildDescriptionForOneOperand:(NSString*)operator wasPreviousOperatorHighPriority:(BOOL)wasPreviousOperatorHighPriority
{
    NSString* operandDescription = [self buildNextOperandDescription:wasPreviousOperatorHighPriority];
    
    NSString* operationDescription = [NSString stringWithFormat:@"%@(%@)", operator, operandDescription];
    return operationDescription;
}

-(NSString*)buildDescriptionForOperator:(NSString*)operator wasPreviousOperatorHighPriority:(BOOL)wasPreviousOperatorHighPriority
{
    NSString* operatorDescription;
    int numberOfOperands = [Operators numberOfOperandsForOperator:operator];
    if (numberOfOperands==2) {
        operatorDescription = [self buildDescriptionForTwoOperands:operator wasPreviousOperatorHighPriority:wasPreviousOperatorHighPriority];
    } else if (numberOfOperands==1) {
        operatorDescription = [self buildDescriptionForOneOperand:operator wasPreviousOperatorHighPriority:wasPreviousOperatorHighPriority];
    } else if (numberOfOperands==0) {
        operatorDescription = operator;
    } else if (numberOfOperands==IS_VARIABLE) {
        operatorDescription = operator;
    }
    return operatorDescription;
}

//Recursively builds a description of the top most piece of the program stack.
//higherPriorityOperatorUsedYet is used to help determine if paranthesis are required for lower priority operations.
-(NSString *)buildNextOperandDescription:(BOOL)wasPreviousOperatorHighPriority
{
    NSString *nextOperandDescription = @"";
    
    id topOfStack = [self.programStack lastObject];
    if (topOfStack) [self.programStack removeLastObject];
    
    if ([topOfStack isKindOfClass:[NSNumber class]])
    {
        nextOperandDescription = [self buildDescriptionForNumber:topOfStack];
    }
    if ([topOfStack isKindOfClass:[NSString class]])
    {
        nextOperandDescription = [self buildDescriptionForOperator:topOfStack wasPreviousOperatorHighPriority:wasPreviousOperatorHighPriority];
    }
    
    return nextOperandDescription;
}

-(id)calculateResultWithVariableValues:(NSDictionary *)variableValues
{
    if(variableValues)
    {
        [self replaceVariablesWithValues:variableValues];
    }

    return [self calculateResult];
}

-(id)calculateResult
{
    NSString *error = nil;
    double result = [self popOperandOffProgramStack:&error];
    if(error)
    {
        return error;
    }
    return [NSNumber numberWithDouble:result];
}

-(void)replaceVariablesWithValues:(NSDictionary*)variableValues
{
    for(int i=0; i<[self.programStack count]; i++)
    {
        if([variableValues objectForKey:[self.programStack objectAtIndex:i]])
        {
            NSNumber *value = [variableValues objectForKey:[self.programStack objectAtIndex:i]];
            if([value isKindOfClass:[NSNumber class]])
            {
                [self.programStack replaceObjectAtIndex:i
                                             withObject:value];
            }
        }
    }
}


//Method to run the program, returns an error message by reference.
//::Error Conditions::
//Not Enough Operands
//Divide By Zero
//Square Root of a Negative Number
-(double)popOperandOffProgramStack:(NSString **)error
{
    double result = 0;
    
    id topOfStack = [self.programStack lastObject];
    if (topOfStack) [self.programStack removeLastObject];
    else {
        *error = NOT_ENOUGH_OPERANDS_ERROR;
        return 0;
    }
    
    if ([topOfStack isKindOfClass:[NSNumber class]])
    {
        result = [self resultOfNumber:topOfStack];
    }
    else if ([topOfStack isKindOfClass:[NSString class]])
    {
        result = [self resultOfOperator:topOfStack error:error];
    }
    return result;
}

-(double)resultOfNumber:(NSNumber*)number
{
    return [number doubleValue];
}

-(double)resultOfOperator:(NSString*)operator error:(NSString **)error
{
    
    if ([operator isEqualToString:PI]) {
        return M_PI;
    }
    
    if ([Operators isVariable:operator]) {
        return 0;
    }
    
    double firstOperand = [self popOperandOffProgramStack:error];
    
    if ([operator isEqualToString:NEGATE]) {
        return -firstOperand;
    }
    if ([operator isEqualToString:SIN]) {
        return sin(firstOperand);
    }
    if ([operator isEqualToString:COS]) {
        return cos(firstOperand);
    }
    if ([operator isEqualToString:SQRT]) {
        if(firstOperand<0) {
            *error = SQUARE_ROOT_OF_NEGATIVE_ERROR;
            return 0;
        }
        return sqrt(firstOperand);
    }
    
    double secondOperand = [self popOperandOffProgramStack:error];
    
    if ([operator isEqualToString:ADD]) {
        return firstOperand + secondOperand;
    }
    if ([operator isEqualToString:MULTIPLY]) {
        return firstOperand * secondOperand;
    }
    if ([operator isEqualToString:SUBTRACT]) {
        return secondOperand - firstOperand;
    }
    if ([operator isEqualToString:DIVIDE]) {
        if (firstOperand) {
            return secondOperand / firstOperand;
        }
        else {
            *error = DIVIDE_BY_ZERO_ERROR;
            return 0;
        }
    }
    
    *error = UNKNOWN_ERROR;
    return 0;
}

@end
