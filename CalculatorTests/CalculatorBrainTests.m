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
    double expectedValue = 3-5*(6+7);
    
    [self runTestForProgram:testProgram expectedDescription:expectedDescription expectedValue:expectedValue];
}

-(void)testProgramB
{
    id testProgram = [self buildTestProgramStackFromButtonsPressed:@"3,5,+,sqrt"];
    NSString* expectedDescription = @"sqrt(3+5)";
    double expectedValue = sqrt(3+5);
    
    [self runTestForProgram:testProgram expectedDescription:expectedDescription expectedValue:expectedValue];
}

-(void)testProgramC
{
    id testProgram = [self buildTestProgramStackFromButtonsPressed:@"3,sqrt,sqrt"];
    NSString* expectedDescription = @"sqrt(sqrt(3))";
    double expectedValue = sqrt(sqrt(3));
    
    [self runTestForProgram:testProgram expectedDescription:expectedDescription expectedValue:expectedValue];
}

-(void)testProgramD
{
    id testProgram = [self buildTestProgramStackFromButtonsPressed:@"3,5,sqrt,+"];
    NSString* expectedDescription = @"3+sqrt(5)";
    double expectedValue = 3+sqrt(5);
    
    [self runTestForProgram:testProgram expectedDescription:expectedDescription expectedValue:expectedValue];
}

-(void)testProgramE
{
    id testProgram = [self buildTestProgramStackFromButtonsPressed:@"π,r,r,*,*"];
    NSString* expectedDescription = @"π*r*r";
    NSNumber* r = [NSNumber numberWithDouble:5];
    NSDictionary* variableValues = [NSDictionary dictionaryWithObject:r forKey:@"r"];
    
    double expectedValue = M_PI*r.doubleValue*r.doubleValue;
    
    [self runTestForProgram:testProgram expectedDescription:expectedDescription expectedValue:0];
    [self runTestForResult:testProgram expectedValue:expectedValue usingVariableValues:variableValues];
}

-(void)testProgramF
{
    id testProgram = [self buildTestProgramStackFromButtonsPressed:@"a,a,*,b,b,*,+,sqrt"];
    NSString* expectedDescription = @"sqrt(a*a+b*b)";
    NSNumber* a = [NSNumber numberWithDouble:4];
    NSNumber* b = [NSNumber numberWithDouble:3];
    NSMutableDictionary* variableValues = [NSMutableDictionary dictionaryWithObject:a forKey:@"a"];
    [variableValues setObject:b forKey:@"b"];
    
    double expectedValue = sqrt(a.doubleValue*a.doubleValue+b.doubleValue*b.doubleValue);
    
    [self runTestForProgram:testProgram expectedDescription:expectedDescription expectedValue:0];
    [self runTestForResult:testProgram expectedValue:expectedValue usingVariableValues:variableValues];
}


-(void)runTestForProgram:(id)testProgram expectedDescription:(NSString*)expectedDescription expectedValue:(double)expectedValue
{
    [self runTestForDescription:testProgram expectedDescription:expectedDescription];
    [self runTestForResult:testProgram expectedValue:expectedValue];
}

-(void)runTestForDescription:(id)testProgram expectedDescription:(NSString*)expectedDescription
{
    NSString* description = [CalculatorBrain descriptionOfProgram:testProgram];
    STAssertEqualObjects(description, expectedDescription, nil);
}

-(void)runTestForResult:(id)testProgram expectedValue:(double)expectedValue
{
    NSNumber* expectedResult = [NSNumber numberWithDouble:expectedValue];
    NSNumber* result = [CalculatorBrain runProgram:testProgram];
    STAssertEqualObjects(result, expectedResult, nil);
}

-(void)runTestForResult:(id)testProgram expectedValue:(double)expectedValue usingVariableValues:(NSDictionary *)variableValues
{
    NSNumber* expectedResult = [NSNumber numberWithDouble:expectedValue];
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
