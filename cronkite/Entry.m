#import "Entry.h"

@implementation Entry

//@dynamic text1;
//@dynamic date;

@synthesize text1 = _text1;
@synthesize date = _date;

-(id)initWithText:(NSString *)text
{
  return [self initWithText:text andDate:[NSDate date]];
}

-(id) initWithText:(NSString *)text andDate:(NSDate *)date_
{
  if(self != nil) {
    self.text1 = text;
    self.date = date_;
  }
  return self; 
}

@end
