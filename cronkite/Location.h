#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "Item.h"

@interface Location : Item

@property (nonatomic, retain) NSString * lat;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSString * lon;

@end
