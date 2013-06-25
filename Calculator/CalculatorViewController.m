//
//  CalculatorViewController.m
//  Calculator
//
//  Created by Andrew Boissonnault on 6/4/12.
//  Copyright (c) 2012 Lexmark. All rights reserved.
//

#import "CalculatorViewController.h"
#import "CalculatorBrain.h"

@interface CalculatorViewController ()

@property (nonatomic) BOOL userIsInTheMiddleOfEnteringANumber;
@property (nonatomic, strong) CalculatorBrain *brain;  //Model

@property (nonatomic, strong) NSDictionary *testVariableValues;

@end

@implementation CalculatorViewController

@synthesize display = _display;  //Results Display
@synthesize historyDisplay = _historyDisplay;  //History of Numbers/Operations
@synthesize variableDisplay = _variableDisplay; //Display for variable values

@synthesize userIsInTheMiddleOfEnteringANumber = _userIsInTheMiddleOfEnteringANumber;
@synthesize brain = _brain;

@synthesize testVariableValues = _testVariableValues;


- (CalculatorBrain *)brain
{
    if (!_brain) _brain = [[CalculatorBrain alloc] init];
    return _brain;
}


//Adds digits and decimal point to the display as the user enters them.
- (void)appendToDisplay:(NSString *)digit {
    if(self.userIsInTheMiddleOfEnteringANumber) {  //User is currently entering something so we append the new digit
        self.display.text = [self.display.text stringByAppendingString:digit];
    }
    else {  //User is entering the first digit of a new number so we start over with the first digit
        self.display.text = digit;
        self.userIsInTheMiddleOfEnteringANumber = YES;
    }
}

- (void)updateHistoryDisplay
{
    self.historyDisplay.text = [CalculatorBrain descriptionOfProgram:self.brain.program];
}


//Update variable display with the variable values.
- (void)updateVariableDisplay
{
    NSString *update = @"";
    for(int i=0; i<[self.brain.variablesUsedInProgram count]; i++) {   //Iterates over all currently used variables.
        NSString *variable = [self.brain.variablesUsedInProgram objectAtIndex:i];
        NSString *value;
        NSNumber *num = [self.testVariableValues objectForKey:variable];
        if(num) {  //If the variable has been set
            value = [num stringValue];
        }
        else {
            value = @"0";
        }
        update = [[[[update stringByAppendingString:variable] stringByAppendingString:@" = "] stringByAppendingString:value] stringByAppendingString:@"    "];
    }
    self.variableDisplay.text = update;
}


//Updates the history display, then the main display.
- (void)updateDisplay:(id)result {
    [self updateHistoryDisplay];
    
    if([result isKindOfClass:[NSNumber class]]) {
        self.display.text = [result stringValue];
    } else if([result isKindOfClass:[NSString class]]) {
        self.display.text = result;
    } else {
        self.display.text = @"UNKNOWN ERROR";
    }
}


//Clears the main display.
- (void)clearDisplay
{
    self.display.text = @"";
}


//Handles an operation by accessing the model API, displaying the result, and updating the history.
- (void)handleOperation:(NSString *)operation {
    [self updateDisplay:[self.brain performOperation:operation]];
}


//When a digit is pressed, have it appended to the display.
- (IBAction)digitPressed:(UIButton *)sender {
    NSString *digit = [[NSNumber numberWithInt:[sender tag]] stringValue];
    [self appendToDisplay:digit];
}


//When the enter button is pressed, push the current operand onto the stack, get ready for a new number, and update the history.
- (IBAction)enterPressed {
    [self.brain pushOperand:[self.display.text doubleValue]];
    self.userIsInTheMiddleOfEnteringANumber = NO;
    [self updateHistoryDisplay];
}


//When an operation is pressed, check if a number is currently being entered, if so pseudo press the enter button first, then handle the operations.
- (IBAction)operationPressed:(id)sender {
    if (self.userIsInTheMiddleOfEnteringANumber) {
        [self enterPressed];
    }
    NSString *operation = [sender currentTitle];
    [self handleOperation:operation];
}


//When the sign change button is pressed, check if a number is currently being entered, if so change the current number, else treat the button press as an operation.
- (IBAction)signChangePressed {
    if (self.userIsInTheMiddleOfEnteringANumber) {
        [self updateDisplay:[NSNumber numberWithDouble:-[self.display.text doubleValue]]];
    }
    else {
        [self handleOperation:@"+/-"];
        }
    }


//When the decimal button is pressed, check if a decimal point already exists, if so do nothing, else add the decimal point to the display.
- (IBAction)decimalPressed {
    NSLog(@"DecimalPressed");
    if([self.display.text rangeOfString:@"."].location == NSNotFound) {
        [self appendToDisplay:@"."];
    }
}


//When the clear button is pressed, clear the program stack, and update all displays.
- (IBAction)clearPressed {
    NSLog(@"ClearPressed");
    [self.brain clearStack];
    [self updateDisplay:[NSNumber numberWithDouble:0]];
    [self updateVariableDisplay];
    self.userIsInTheMiddleOfEnteringANumber = YES;
}


//When the undo button is pressed, check if the user is currently entering a number, then either backspace a digit, or remove something from the program stack.  If they aren't enteirng a number then just remove something from the program stack.
//The assignment mentioned not leaving a blank display when there are no digits left, but I actually find that more user friendly than defaulting to 0 or something else.  It assures me as a user that I didn't clear anything off the operand stack.
- (IBAction)undoPressed {
    if(self.userIsInTheMiddleOfEnteringANumber)
    {
        if([self.display.text length]>0) {
            int newLength = [self.display.text length] - 1;
            self.display.text = [self.display.text substringToIndex:newLength];
            }
        else {
            self.userIsInTheMiddleOfEnteringANumber = NO;
            [self.brain removeLastObjectFromProgramStack];
            [self updateDisplay:[CalculatorBrain runProgram:self.brain.program]];
        }
    }
    else {
        [self.brain removeLastObjectFromProgramStack];
        [self updateDisplay:[CalculatorBrain runProgram:self.brain.program]];
    }
}


//When a variable button is pressed, push that variable onto the stack and update all the displays.
- (IBAction)variablePressed:(id)sender {
    NSString *variable = [sender currentTitle];
    [self.brain pushVariable:variable];
    
    [self updateHistoryDisplay];
    [self updateDisplay:[CalculatorBrain runProgram:self.brain.program
            usingVariableValues:self.testVariableValues]];
    [self updateVariableDisplay];
}


//When a test variables button is pressed, create some test values for all existing variables, run the program with variables, then update the displays.
- (IBAction)testPressed:(id)sender
{
    NSString *test = [sender currentTitle];
    if([test isEqualToString:@"nil"])
    {
        self.testVariableValues = nil;
    } else if([test isEqualToString:@"basic"])
    {
        NSMutableArray *variableValues = [NSMutableArray arrayWithCapacity:[self.brain.variablesUsedInProgram count]];
        for(int i=0; i<[self.brain.variablesUsedInProgram count]; i++)
        {
            [variableValues addObject:[NSNumber numberWithDouble:i]];
        }
        self.testVariableValues = [NSDictionary dictionaryWithObjects:variableValues 
                                                              forKeys:self.brain.variablesUsedInProgram];
    }    
    [self updateDisplay:[CalculatorBrain runProgram:self.brain.program
                                usingVariableValues:self.testVariableValues]];
    [self updateVariableDisplay];
}

- (void)viewDidUnload {
    [self setHistoryDisplay:nil];
    [self setVariableDisplay:nil];
    [super viewDidUnload];
}
@end	
