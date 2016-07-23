

#import "MKStoreManager.h"
#import "AppDelegate.h"
//#import "Global.h"

@implementation MKStoreManager

@synthesize purchasableObjects;
@synthesize storeObserver;

// all your features should be managed one and only by StoreManager
static NSString *feature100  = IAP;
//static NSString *feature500  = IAP_500_COINS;
//static NSString *feature1200 = IAP_1200_COINS;
static MKStoreManager* _sharedStoreManager; // self

- (void)dealloc
{
	[_sharedStoreManager release];
	[storeObserver release];
	[super dealloc];
}

+ (MKStoreManager*)sharedManager
{
	NSLog(@"pass sharedManager");
	@synchronized(self) {
		
        if (_sharedStoreManager == nil) {
			
            [[self alloc] init]; // assignment not done here
			_sharedStoreManager.purchasableObjects = [[NSMutableArray alloc] init];			
			//[_sharedStoreManager requestProductData];
			
			[MKStoreManager loadPurchases];
			_sharedStoreManager.storeObserver = [[MKStoreObserver alloc] init];
			[[SKPaymentQueue defaultQueue] addTransactionObserver:_sharedStoreManager.storeObserver];
        }
    }
    
    return _sharedStoreManager;
}

#pragma mark Singleton Methods

+ (id)allocWithZone:(NSZone *)zone
{
    @synchronized(self)
    {
        if (_sharedStoreManager == nil)
        {
            _sharedStoreManager = [super allocWithZone:zone];
            return _sharedStoreManager;  // assignment and return on first allocation
        }
    }

    return nil; //on subsequent allocation attempts return nil
}


- (id)copyWithZone:(NSZone *)zone
{
    return self;	
}

- (id)retain
{
    return self;	
}

- (unsigned)retainCount
{
    return UINT_MAX;  //denotes an object that cannot be released
}

- (oneway void)release
{
    //do nothing
}

- (id)autorelease
{
    return self;	
}


- (void) requestProductData
{
	//SKProductsRequest *request= [[SKProductsRequest alloc] initWithProductIdentifiers:[NSSet setWithObjects: featureLivesId, nil]]; // add any other product here
	//request.delegate = self;
	//[request start];
}


- (void)productsRequest:(SKProductsRequest *)request didReceiveResponse:(SKProductsResponse *)response
{
	[purchasableObjects addObjectsFromArray:response.products];
	// populate your UI Controls here
	for(int i=0;i<[purchasableObjects count];i++)
	{
		
		SKProduct *product = [purchasableObjects objectAtIndex:i];
		NSLog(@"Feature: %@, Cost: %f, ID: %@",[product localizedTitle],
			  [[product price] doubleValue], [product productIdentifier]);
	}
	
	[request autorelease];
}

- (void) buyFeature: (int) featureNumber
{
	if ([SKPaymentQueue canMakePayments])
	{
        NSString *featureId = @"";
        featureId = feature100;
        
        
		SKPayment *payment = [SKPayment paymentWithProductIdentifier:featureId];
		[[SKPaymentQueue defaultQueue] addPayment:payment];
	}
	else
	{
		UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"PicStatic" message:@"You are not authorized to purchase from AppStore"
													   delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
		[alert show];
		[alert release];
	}
}


- (void)paymentQueueRestoreCompletedTransactionsFinished:(SKPaymentQueue *)queue
{
    
    NSLog(@"%@",queue );
    NSLog(@"Restored Transactions are once again in Queue for purchasing %@",[queue transactions]);
    
    NSMutableArray *purchasedItemIDs = [[NSMutableArray alloc] init];
    NSLog(@"received restored transactions: %i", queue.transactions.count);
    
    for (SKPaymentTransaction *transaction in queue.transactions)
    {
        NSString *productID = transaction.payment.productIdentifier;
        [purchasedItemIDs addObject:productID];
        
//        if ([productID isEqualToString:featureRemoveAds])
//        {
//            g_bRemoveAds = YES;
//            updateGameInfo();
//        }
        // here put an if/then statement to write files based on previously purchased items
        // example if ([productID isequaltostring: @"youruniqueproductidentifier]){write files} else { nslog sorry}
    }
    
    if([purchasedItemIDs count]>0)
    {
        NSLog(@"RESOTRE SUCCESS!");
    }
    else
    {
        NSLog(@"RESTORE FAILED!");
    }
    
}


- (void) failedTransaction: (SKPaymentTransaction *)transaction
{
	NSString *messageToBeShown = [NSString stringWithFormat:@"Reason: %@, You can try: %@", [transaction.error localizedFailureReason], [transaction.error localizedRecoverySuggestion]];
	UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Unable to complete your purchase" message:messageToBeShown
												   delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
	[alert show];
	[alert release];
    
}

-(void) provideContent: (NSString*) productIdentifier
{
    if([productIdentifier isEqualToString:feature100])
    {
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"ISPURCHASED"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
    
  
    
   if (self.mainviewcontroller != nil)
       [self.mainviewcontroller updateIAPP];
    
    UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"In-App Upgrade" message:@"Successfully Purchased" delegate:self cancelButtonTitle:@"ok" otherButtonTitles:nil, nil];
    [alert show];
    [alert release];
}



+(void) loadPurchases 
{
//	NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];	
//	featureAPurchased = [userDefaults boolForKey:featureAId]; 
    
//    for(int i=0; i<PEOPLE_CNT-PEOPLE_UNLOCK; i++) {
//        NSString *string = [NSString stringWithFormat:@"%@%d", featurePId, i+PEOPLE_UNLOCK+1];
//        featurePPurchased[i] = [userDefaults boolForKey:string];
//    }
}

+(void) updatePurchases
{
//	NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
//
//	[userDefaults setBool:featureAPurchased forKey:featureAId];
//    for(int i=0; i<PEOPLE_CNT-PEOPLE_UNLOCK; i++) {
//        NSString *string = [NSString stringWithFormat:@"%@%d", featurePId, i+PEOPLE_UNLOCK+1];
//        [userDefaults setBool:featurePPurchased[i] forKey:string];
//    }

}

-(void)restoreFunc
{
    [[SKPaymentQueue defaultQueue] restoreCompletedTransactions];
}

- (void)paymentQueue:(SKPaymentQueue *)queue updatedTransactions:(NSArray *)transactions
{
    
}

@end
