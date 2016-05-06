//
//  ViewController.m
//  ButtonClick2
//
//  Created by Ernald on 5/5/16.
//
//

#import "ViewController.h"

typedef enum enumCalcOperator
{
    ADDITION = 0,
    SUBTRACTION,
    DIVISION,
    MULTIPLICATION,
    NONE
} CalcOperator;

@interface ViewController ()

@property NSDecimalNumber* displayValue;
@property NSDecimalNumber* value;
@property NSDecimalNumber* repeatOperand;

@end

@implementation ViewController
{
    BOOL bNumberPressed, bCompletedCalculation, bFirstOperandEntered;
    short numPlaceAfterDecimal;
    CalcOperator op;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.displayValue = [[NSDecimalNumber alloc] initWithInt:0];
    self.value = [[NSDecimalNumber alloc] initWithInt:0];
    self.display.text = [[NSString alloc] initWithFormat:@"0."];
    
    bNumberPressed = NO;
    bCompletedCalculation = NO;
    bFirstOperandEntered = NO;
    numPlaceAfterDecimal = -1;
    op = NONE;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction) numericalClick: (id) sender {
    
    if (![sender isKindOfClass:[UIButton class]])
        return;
    
    if(bCompletedCalculation == YES)
    {
        self.value = [[NSDecimalNumber alloc] initWithInt:0];
        op = NONE;
        bFirstOperandEntered = NO;
        bCompletedCalculation = NO;
    }
    
    if(bNumberPressed == NO)
    {
        self.displayValue = [[NSDecimalNumber alloc] initWithInt:0];
    }
    
    bNumberPressed = YES;
    self.repeatOperand = nil;
    
    NSString *digit = [(UIButton *)sender currentTitle];
    
    NSDecimalNumber* curDig = [[NSDecimalNumber alloc] initWithString:digit];
    
    if(numPlaceAfterDecimal == -1)
    {
        self.displayValue = [self.displayValue decimalNumberByMultiplyingBy:[[NSDecimalNumber alloc] initWithString:@"10"]];
        self.displayValue = [self.displayValue decimalNumberByAdding:curDig];
    }
    else
    {
        numPlaceAfterDecimal++;
        NSDecimalNumber* newDec = [[NSDecimalNumber alloc] initWithMantissa:[curDig longLongValue] exponent:(numPlaceAfterDecimal*-1) isNegative:false];
        
        self.displayValue = [self.displayValue decimalNumberByAdding:newDec];
    }
    
    self.display.text = [[NSString alloc] initWithFormat:@"%@", self.displayValue];
}

-(IBAction) symbolClick: (id) sender
{
    if (![sender isKindOfClass:[UIButton class]])
        return;
    
    NSString *digit = [(UIButton *)sender currentTitle];

    switch([digit characterAtIndex:0])
    {
        case 'x':
        {
            op = MULTIPLICATION;
            
            if(bFirstOperandEntered == NO)
            {
                self.value = [self.displayValue copy];
                bFirstOperandEntered = YES;
            }
            else
            {
                if(bNumberPressed == NO)
                {
                    self.displayValue = [self.value copy];
                    return;
                }
                else
                {
                    [self performCalculation];
                }
            }
            
            self.repeatOperand = self.displayValue;
            [self resetDisplayValue];
            numPlaceAfterDecimal = -1;
            bCompletedCalculation = NO;
            break;
        }
        case L'÷':
        {
            op = DIVISION;
            
            if(bFirstOperandEntered == NO)
            {
                self.value = [self.displayValue copy];
                bFirstOperandEntered = YES;
            }
            else
            {
                if(bNumberPressed == NO)
                {
                    self.displayValue = [self.value copy];
                }
                else
                {
                    [self performCalculation];
                }
            }
            
            self.repeatOperand = self.displayValue;
            [self resetDisplayValue];
            numPlaceAfterDecimal = -1;
            bCompletedCalculation = NO;
            break;
        }
        case '+':
        {
            op = ADDITION;
            
            if(bFirstOperandEntered == NO)
            {
                self.value = [self.displayValue copy];
                bFirstOperandEntered = YES;
            }
            else
            {
                if(bNumberPressed == NO)
                {
                    self.displayValue = [self.value copy];
                }
                else
                {
                    [self performCalculation];
                }
            }
            
            self.repeatOperand = self.displayValue;
            [self resetDisplayValue];
            numPlaceAfterDecimal = -1;
            bCompletedCalculation = NO;
            break;
        }
        case '-':
        {
            op = SUBTRACTION;
            
            if(bFirstOperandEntered == NO)
            {
                self.value = [self.displayValue copy];
                bFirstOperandEntered = YES;
            }
            else
            {
                if(bNumberPressed == NO)
                {
                    self.displayValue = [self.value copy];
                }
                else
                {
                    [self performCalculation];
                }
            }
            
            self.repeatOperand = self.displayValue;
            [self resetDisplayValue];
            numPlaceAfterDecimal = -1;
            bCompletedCalculation = NO;
            break;
        }
        case '=':
        {
            if(bNumberPressed == NO)
            {
                if(self.repeatOperand == nil)
                {
                    self.displayValue = [self.value copy];
                }
                else
                {
                    self.displayValue = self.repeatOperand;
                }
            }
            
            [self performCalculation];
            self.repeatOperand = self.displayValue;
            self.displayValue = self.value;
            numPlaceAfterDecimal = -1;
            bNumberPressed = NO;
            bCompletedCalculation = YES;
            break;
        }
        case '.':
        {
            if([self.value doubleValue] != 0)
            {
                self.displayValue = [[NSDecimalNumber alloc] initWithInt:0];
            }
            
            if(numPlaceAfterDecimal == -1)
            {
                self.display.text = [[NSString alloc] initWithFormat:@"%@.", self.displayValue];
                
                numPlaceAfterDecimal = 0;
            }
        }
    }
}

- (void) performCalculation
{
    switch(op)
    {
        case ADDITION:
        {
            self.value = [self.value decimalNumberByAdding:self.displayValue];
            break;
        }
        case SUBTRACTION:
        {
            self.value = [self.value decimalNumberBySubtracting:self.displayValue];
            
            break;
        }
        case DIVISION:
        {
            self.value = [self.value decimalNumberByDividingBy:self.displayValue];
            break;
        }
        case MULTIPLICATION:
        {
            self.value = [self.value decimalNumberByMultiplyingBy:self.displayValue];
            break;
        }
        case NONE:
        default:
        {
            break;
        }
    }
    
    self.display.text = [[NSString alloc] initWithFormat:@"%@", self.value];
}

- (void) resetDisplayValue
{
    self.displayValue = [[NSDecimalNumber alloc] initWithInt:0];
    bNumberPressed = NO;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
