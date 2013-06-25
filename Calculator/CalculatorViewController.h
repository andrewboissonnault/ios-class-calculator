//
//  CalculatorViewController.h
//  Calculator
//
//  Created by Andrew Boissonnault on 6/4/12.
//  Copyright (c) 2012 Lexmark. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CalculatorViewController : UIViewController

@property (weak, nonatomic) IBOutlet UILabel *display;
@property (weak, nonatomic) IBOutlet UILabel *historyDisplay;
@property (weak, nonatomic) IBOutlet UILabel *variableDisplay;

@end
