#import "PushUtils.h"
#import "CardViewController.h"

@implementation PushUtils

+(void) pushCard: (CardItem *) item navController: (UINavigationController *) nav {
    UIStoryboard * cardStory = [UIStoryboard storyboardWithName:@"CardStory" bundle:nil];
    CardViewController * cc = [cardStory instantiateViewControllerWithIdentifier:@"cardViewController"];
    [cc setCardId:item.card_id];
    [cc setCardName:item.name];
    [nav pushViewController:cc animated:YES];
}

@end
