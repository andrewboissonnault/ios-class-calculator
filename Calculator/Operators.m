//
//  Operators.m
//  Calculator
//
//  Created by Andrew Boissonnault on 6/24/13.
//  Copyright (c) 2013 Lexmark. All rights reserved.
//

#import "Operators.h"

@implementation Operators

//Sets to store the valid operators
+ (NSSet *)zeroArgumentOperators
{
    static NSSet* _zeroArgumentOperators = nil;
    
    if (_zeroArgumentOperators == nil) _zeroArgumentOperators = [[NSSet alloc] initWithObjects:PI, nil];
    
    return _zeroArgumentOperators;
}

+ (NSSet *)oneArgumentOperators
{
    static NSSet* _oneArgumentOperators = nil;
    
    if (_oneArgumentOperators == nil) _oneArgumentOperators = [[NSSet alloc] initWithObjects:NEGATE, SIN, COS, SQRT, nil];
    
    return _oneArgumentOperators;
}

+ (NSSet *)twoArgumentOperators
{
    static NSSet* _twoArgumentOperators = nil;
    
    if (_twoArgumentOperators == nil) _twoArgumentOperators = [[NSSet alloc] initWithObjects:ADD, SUBTRACT, MULTIPLY, DIVIDE, nil];
    
    return _twoArgumentOperators;
}

//Helper methods to return useful information on a given operator.
+ (BOOL)isValidOperation:(NSString *)operator
{
    if([[self zeroArgumentOperators] containsObject:operator] || [[self oneArgumentOperators] containsObject:operator] || [[self twoArgumentOperators] containsObject:operator])
    {
        return YES;
    }
    return NO;
}

+ (BOOL)isVariable:(NSString *)operator
{
    return ![self isValidOperation:operator];
}

+ (int)numberOfOperandsForOperator:(NSString *)operator
{
    if([[self zeroArgumentOperators] containsObject:operator]) return 0;
    if([[self oneArgumentOperators] containsObject:operator]) return 1;
    if([[self twoArgumentOperators] containsObject:operator]) return 2;
    return IS_VARIABLE;
}

+ (BOOL)isLowPriorityOperator:(NSString *)operator
{
    if([operator isEqualToString:@"+"] || [operator isEqualToString:@"-"])
    {
        return YES;
    }
    return NO;
}

@end
