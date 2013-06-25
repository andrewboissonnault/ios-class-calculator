//
//  CalculatorBrainTests.m
//  Calculator
//
//  Created by Andrew Boissonnault on 6/24/13.
//  Copyright (c) 2013 Lexmark. All rights reserved.
//

#import "CalculatorBrainTests.h"
#import "CalculatorBrain.h"

@interface CalculatorBrainTests()

@property (nonatomic, readonly) NSNumberFormatter *numberFormatter;

@end

@implementation CalculatorBrainTests

@synthesize numberFormatter = _numberFormatter;

-(void)testProgramA
{
    id testProgram = [self buildTestProgramStackFromButtonsPressed:@"3,5,6,7,+,*,-"];
    NSString* expectedDescription = @"3-5*(6+7)";
    double calculation = 3-5*(6+7);
    
    [self runTestForProgram:testProgram expectedDescription:expectedDescription calculation:calculation];
}

-(void)testProgramB
{
    id testProgram = [self buildTestProgramStackFromButtonsPressed:@"3,5,+,sqrt"];
    NSString* expectedDescription = @"sqrt(3+5)";
    double calculation = sqrt(3+5);
    
    [self runTestForProgram:testProgram expectedDescription:expectedDescription calculation:calculation];
}

-(void)testProgramC
{
    id testProgram = [self buildTestProgramStackFromButtonsPressed:@"3,sqrt,sqrt"];
    NSString* expectedDescription = @"sqrt(sqrt(3))";
    double calculation = sqrt(sqrt(3));
    
    [self runTestForProgram:testProgram expectedDescription:expectedDescription calculation:calculation];
}

-(void)testProgramD
{
    id testProgram = [self buildTestProgramStackFromButtonsPressed:@"3,5,sqrt,+"];
    NSString* expectedDescription = @"3+sqrt(5)";
    double calculation = 3+sqrt(5);
    
    [self runTestForProgram:testProgram expectedDescription:expectedDescription calculation:calculation];
}

-(void)testProgramE
{
    id testProgram = [self buildTestProgramStackFromButtonsPressed:@"π,r,r,*,*"];
    NSString* expectedDescription = @"π*r*r";
    NSNumber* r = [NSNumber numberWithDouble:5];
    NSDictionary* variableValues = [NSDictionary dictionaryWithObject:r forKey:@"r"];
    
    double calculation = M_PI*r.doubleValue*r.doubleValue;
    
    [self runTestForProgram:testProgram expectedDescription:expectedDescription calculation:0];
    [self runTestForResult:testProgram calculation:calculation usingVariableValues:variableValues];
}

-(void)testProgramF
{
    id testProgram = [self buildTestProgramStackFromButtonsPressed:@"a,a,*,b,b,*,+,sqrt"];
    NSString* expectedDescription = @"sqrt(a*a+b*b)";
    NSNumber* a = [NSNumber numberWithDouble:4];
    NSNumber* b = [NSNumber numberWithDouble:3];
    NSMutableDictionary* variableValues = [NSMutableDictionary dictionaryWithObject:a forKey:@"a"];
    [variableValues setObject:b forKey:@"b"];
    
    double calculation = sqrt(a.doubleValue*a.doubleValue+b.doubleValue*b.doubleValue);
    
    [self runTestForProgram:testProgram expectedDescription:expectedDescription calculation:0];
    [self runTestForResult:testProgram calculation:calculation usingVariableValues:variableValues];
}


-(void)runTestForProgram:(id)testProgram expectedDescription:(NSString*)expectedDescription calculation:(double)calculation
{
    [self runTestForDescription:testProgram expectedDescription:expectedDescription];
    [self runTestForResult:testProgram calculation:calculation];
}

-(void)runTestForDescription:(id)testProgram expectedDescription:(NSString*)expectedDescription
{
    NSString* description = [CalculatorBrain descriptionOfProgram:testProgram];
    STAssertEqualObjects(description, expectedDescription, nil);
}

-(void)runTestForResult:(id)testProgram calculation:(double)calculation
{
    NSNumber* expectedResult = [NSNumber numberWithDouble:calculation];
    NSNumber* result = [CalculatorBrain runProgram:testProgram];
    STAssertEqualObjects(result, expectedResult, nil);
}

-(void)runTestForResult:(id)testProgram calculation:(double)calculation usingVariableValues:(NSDictionary *)variableValues
{
    NSNumber* expectedResult = [NSNumber numberWithDouble:calculation];
    NSNumber* result = [CalculatorBrain runProgram:testProgram usingVariableValues:variableValues];
    STAssertEqualObjects(result, expectedResult, nil);
}

-(NSNumberFormatter*)numberFormatter
{
    if(!_numberFormatter)
    {
        _numberFormatter = [NSNumberFormatter new];
    }
    return _numberFormatter;
}

-(id)buildTestProgramStackFromButtonsPressed:(NSString*)buttonsPressedString
{
    CalculatorBrain* calculatorBrain = [[CalculatorBrain alloc] init];
    NSArray* buttonsPressed = [buttonsPressedString componentsSeparatedByString:@","];
    for (NSString* buttonPressed in buttonsPressed) {
        NSNumber* number = [self.numberFormatter numberFromString:buttonPressed];
        if(number)
        {
            [calculatorBrain pushOperand:[number doubleValue]];
        }
        else
        {
            [calculatorBrain pushOperation:buttonPressed];
        }
    }
    return calculatorBrain.program;
}


@end
