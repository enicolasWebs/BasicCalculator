//
//  ViewController.h
//  ButtonClick2
//
//  Created by Ernald on 5/5/16.
//
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController<UIPickerViewDataSource, UIPickerViewDelegate>

@property (strong, nonatomic) IBOutlet UILabel *display;

-(IBAction) numericalClick: (id) sender;

-(IBAction) symbolClick: (id) sender;

-(IBAction) negateOpClick: (id) sender;

-(IBAction) clearDisplay:(id)sender;

@property (nonatomic, strong) IBOutlet UIPickerView *myPickerView;
@property (nonatomic, strong) NSArray *themeNames;

@end
