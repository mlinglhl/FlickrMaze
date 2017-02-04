//
//  HomeViewController.m
//  FlickrMaze
//
//  Created by Minhung Ling on 2017-02-03.
//  Copyright © 2017 Minhung Ling. All rights reserved.
//

#import "HomeViewController.h"
#import "GameManager.h"
#import "MazeTile+CoreDataClass.h"
#import "MazeViewController.h"

@interface HomeViewController ()
@property GameManager *manager;
@property (weak, nonatomic) IBOutlet UITextField *tagTextField;
@property (weak, nonatomic) IBOutlet UITableView *themeTableView;

@end

@implementation HomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.manager = [GameManager new];
}
- (IBAction)startButton:(id)sender {
    NSURL *url = [self.manager generateURL:@"cat"];
    //self.tagTextField.text];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    NSURLSessionConfiguration *config = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:config];
    NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if (error) {
            NSLog (@"error:%@", error.localizedDescription);
            return;
        }
        NSError *jsonError = nil;
        NSDictionary *results = [NSJSONSerialization JSONObjectWithData:data options:0 error:&jsonError];
        if (jsonError) {
            NSLog (@"jsonerror:%@", jsonError.localizedDescription);
            return;
        }
        NSDictionary *photoDictionary = [results objectForKey:@"photos"];
        NSArray *photoArray = [photoDictionary objectForKey:@"photo"];
        for (NSDictionary *photo in photoArray) {
            [self.manager createMazeTileWithDictionary: photo];
        }
        [[NSOperationQueue mainQueue] addOperationWithBlock: ^{
            [self.manager saveContext];
            [self performSegueWithIdentifier:@"MazeViewController" sender:self];
        }];
    }];
    [dataTask resume];
}



#pragma mark Segue Methods

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"MazeViewController"]) {
        MazeViewController *mvc = segue.destinationViewController;
        mvc.manager = self.manager;
    }
}

@end
