//
//  ViewController.m
//  ButtonClick2
//
//  Created by Ernald on 5/5/16.
//
//

#import "ViewController.h"

typedef enum _CalcOperator
{
    ADDITION = 0,
    SUBTRACTION,
    DIVISION,
    MULTIPLICATION,
    EQUALS,
    PERCENTAGE,
    NONE
} CalcOperator;

typedef enum enumThemeColor
{
    PINK = 0,
    BLUE,
    GRAY,
    BLACK
} ThemeColor;

@interface ViewController ()

@property NSDecimalNumber *displayValue;
@property NSDecimalNumber *value;
@property NSDecimalNumber *repeatOperand;
@property (strong, nonatomic) UIColor *themeColor;

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
    
    self.myPickerView.delegate = self;
    self.myPickerView.dataSource = self;
    
    self.themeNames = @[@"Pink", @"Blue", @"Gray", @"Black"];
    [self.myPickerView selectRow:([self.themeNames count] / 2) inComponent:0 animated:NO];

    [self SetColorFromTheme: GRAY];
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
        NSDecimalNumber* newDec = [[NSDecimalNumber alloc] initWithMantissa:[curDig longLongValue] exponent:(numPlaceAfterDecimal*-1) isNegative:([self.displayValue intValue] < 0)];
        
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
        case '%':
        {
            if(!bCompletedCalculation)
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
            }
            else
            {
                self.value = self.displayValue;
                bCompletedCalculation = NO;
                self.repeatOperand = nil;
            }
            
            op = PERCENTAGE;
            self.value = [self.value decimalNumberByDividingBy:[[NSDecimalNumber alloc] initWithInt:100]];
            
            self.display.text = [[NSString alloc] initWithFormat:@"%@", self.value];
            self.displayValue = self.value;
            
            numPlaceAfterDecimal = -1;
            bNumberPressed = NO;
            bCompletedCalculation = YES;
            break;
        }
        case '=':
        {
            if(op <= EQUALS)
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
            }
            
            numPlaceAfterDecimal = -1;
            bNumberPressed = NO;
            bCompletedCalculation = YES;
            break;
        }
        case '.':
        {
            if(bNumberPressed == NO && [self.value doubleValue] != 0)
            {
                self.displayValue = [[NSDecimalNumber alloc] initWithInt:0];
                numPlaceAfterDecimal = -1;
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
- (IBAction)negateOpClick:(id)sender {

    self.displayValue = [self.displayValue decimalNumberByMultiplyingBy:
                         [NSDecimalNumber decimalNumberWithMantissa: 1
                                            exponent: 0
                                            isNegative: YES]];
    
    if(bCompletedCalculation == YES)
    {
        self.value = [self.displayValue copy];
    }
    
    self.display.text = [[NSString alloc] initWithFormat:@"%@", self.displayValue];
}

- (void) resetDisplayValue
{
    self.displayValue = [[NSDecimalNumber alloc] initWithInt:0];
    bNumberPressed = NO;
}

- (IBAction) clearDisplay:(id) sender
{
    self.displayValue = [[NSDecimalNumber alloc] initWithInt:0];
    self.value = [[NSDecimalNumber alloc] initWithInt:0];
    self.display.text = [[NSString alloc] initWithFormat:@"%@", self.displayValue];
    bNumberPressed = NO;
    op = NONE;
    bFirstOperandEntered = NO;
    numPlaceAfterDecimal = -1;
    bCompletedCalculation = NO;
    self.repeatOperand = nil;
}


- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    return [self.themeNames count];
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    return self.themeNames[row];
}


 -(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row
      inComponent:(NSInteger)component
{
    [self SetColorFromTheme:(ThemeColor)row];
}

-(void) SetColorFromTheme: (ThemeColor) color
{
    switch(color)
    {
        case PINK:
        {
            self.themeColor = [UIColor colorWithRed:224/255.0 green:130/255.0 blue:131/255.0 alpha:0.5];
            break;
        }
        case BLUE:
        {
            self.themeColor = [UIColor colorWithRed:65/255.0 green:131/255.0 blue:215/255.0 alpha:0.5];
            break;
        }
        case GRAY:
        {
            self.themeColor = [UIColor colorWithRed:189/255.0 green:195/255.0 blue:199/255.0 alpha:0.5];
            break;
        }
        case BLACK:
        {
            self.themeColor = [UIColor colorWithRed:44/255.0 green:62/255.0 blue:80/255.0 alpha:0.5];
            break;
        }
    }
    
    for(UIView* subView in self.view.subviews)
    {
        if([subView isKindOfClass:[UIPickerView class]])
        {
            continue;
        }
        
        subView.backgroundColor = self.themeColor;
    }
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
