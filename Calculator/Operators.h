//
//  Operators.h
//  Calculator
//
//  Created by Andrew Boissonnault on 6/24/13.
//  Copyright (c) 2013 Lexmark. All rights reserved.
//

#import <Foundation/Foundation.h>

#define IS_VARIABLE -1

#define PI @"π"
#define NEGATE @"+/-"
#define SIN @"sin"
#define COS @"cos"
#define SQRT @"sqrt"
#define ADD @"+"
#define SUBTRACT @"-"
#define MULTIPLY @"*"
#define DIVIDE @"/"

@interface Operators : NSObject

+(BOOL)isValidOperation:(NSString *)string;
+(int)numberOfOperandsForOperator:(NSString *)operator;
+(BOOL)isLowPriorityOperator:(NSString *)operator;
+(BOOL)isVariable:(NSString*)string;

@end



