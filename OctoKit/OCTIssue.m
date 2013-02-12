//
//  OCTIssue.m
//  OctoKit
//
//  Created by Justin Spahr-Summers on 2012-10-02.
//  Copyright (c) 2012 GitHub. All rights reserved.
//

#import "OCTIssue.h"
#import "OCTPullRequest.h"
#import "OCTUser.h"

@interface OCTIssue ()

// The webpage URL for any attached pull request.
@property (nonatomic, copy, readonly) NSURL *pullRequestHTMLURL;

@end

@implementation OCTIssue

#pragma mark Properties

- (OCTPullRequest *)pullRequest {
	if (self.pullRequestHTMLURL == nil) return nil;

	// We don't have a "real" pull request model within the issue data, but we
	// have enough information to construct one.
	return [OCTPullRequest modelWithDictionary:@{
		@"objectID": self.objectID,
		@"HTMLURL": self.pullRequestHTMLURL,
		@"title": self.title,
		@"body": self.body,
		@"commentsURL": self.commentsURL,
		@"user": self.user,
	}];
}

#pragma mark MTLModel

+ (NSDictionary *)externalRepresentationKeyPathsByPropertyKey {
	NSMutableDictionary *keys = [super.externalRepresentationKeyPathsByPropertyKey mutableCopy];
	
	[keys addEntriesFromDictionary:@{
		@"HTMLURL": @"html_url",
		@"objectID": @"number",
		@"pullRequestHTMLURL": @"pull_request.html_url",
		@"body": @"body",
		@"commentsURL": @"comments_url",
		@"user": @"user",
	}];

	return keys;
}

+ (NSValueTransformer *)HTMLURLTransformer {
	return [NSValueTransformer valueTransformerForName:MTLURLValueTransformerName];
}

+ (NSValueTransformer *)pullRequestHTMLURLTransformer {
	return [NSValueTransformer valueTransformerForName:MTLURLValueTransformerName];
}

+ (NSValueTransformer *)commentsURLTransformer {
	return [NSValueTransformer valueTransformerForName:MTLURLValueTransformerName];
}

+ (NSValueTransformer *)userTransformer {
	return [MTLValueTransformer mtl_externalRepresentationTransformerWithModelClass:OCTUser.class];
}

@end