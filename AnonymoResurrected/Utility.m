//
//  Utility.m
//  iPi
//
//  Created by Radu Ionescu on 9/3/13.
//  Copyright (c) 2013 Sparktech. All rights reserved.
//

#import "Utility.h"

static char Encode[] = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/"; //64 digit code

@implementation Utility

+ (NSString *)uniqueIdentifier
{
    NSString *uniqueIdentifier = [[NSUserDefaults standardUserDefaults] stringForKey:@"uniqueIdentifier"];
    
    if (uniqueIdentifier == nil || [uniqueIdentifier isEqualToString:@""])
    {
        CFUUIDRef UUID = CFUUIDCreate(kCFAllocatorDefault);
        uniqueIdentifier = (__bridge NSString *)CFUUIDCreateString(kCFAllocatorDefault, UUID);
        CFRelease(UUID);
        // NSLog(@"Generated unique app ID : %@",uniqueIdentifier);
        
        [[NSUserDefaults standardUserDefaults] setObject:uniqueIdentifier forKey:@"uniqueIdentifier"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
    return uniqueIdentifier;
}

/* Crops an UIImage using a predetermined rectangle area. */
+ (UIImage *)cropImage:(UIImage *)image withRect:(CGRect)cropRect
{
    UIImage *outputImage = nil;
    CGSize size = image.size;
    
    UIGraphicsBeginImageContextWithOptions(size, YES, image.scale);
    [image drawInRect:CGRectMake(0.0, 0.0, size.width, size.height)];
    outputImage = UIGraphicsGetImageFromCurrentImageContext();
    
    // Crop the image
    CGImageRef imageRef;
    if ((imageRef = CGImageCreateWithImageInRect(outputImage.CGImage, cropRect)))
    {
        outputImage = [[UIImage alloc] initWithCGImage:imageRef scale:image.scale orientation:image.imageOrientation];
        CGImageRelease(imageRef);
    }
    UIGraphicsEndImageContext();
    return outputImage;
}

+ (UIImage *)cropImage:(UIImage *)image toFitInSize:(CGSize)cropSize
{
    CGFloat aspectRatio = cropSize.width / cropSize.height;
    CGFloat inverseAspectRatio = 1 / aspectRatio;
    CGFloat minHeight = (image.size.height < image.size.width * inverseAspectRatio) ? image.size.height : image.size.width * inverseAspectRatio;
    
    UIImage *croppedImage = [self cropImage:image withRect:CGRectMake((image.size.width - minHeight * aspectRatio) * 0.5 * image.scale, (image.size.height - minHeight) * 0.5 * image.scale, minHeight * aspectRatio * image.scale, minHeight * image.scale)];
    return croppedImage;
}

+ (NSString *)serverDateTimeString:(NSString *)dateString
{
    if (!dateString) return nil;
    
    NSDateFormatter *inputDateFormatter = [[NSDateFormatter alloc] init];
    inputDateFormatter.dateStyle = NSDateFormatterLongStyle;
    // inputDateFormatter.timeStyle = NSDateFormatterShortStyle;
    [inputDateFormatter setTimeZone:[NSTimeZone timeZoneWithName:@"UTC"]];
    
    NSLocale *usLocale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US"];
    [inputDateFormatter setLocale:usLocale];
    
    NSDateFormatter *outputDateFormatter = [[NSDateFormatter alloc] init];
    [outputDateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    [outputDateFormatter setTimeZone:[NSTimeZone timeZoneWithName:@"UTC"]];
    
    [outputDateFormatter setLocale:usLocale];
    
    NSDate *inputDate = [inputDateFormatter dateFromString:dateString];
    NSString *outputDateString = [outputDateFormatter stringFromDate:inputDate];

    /*
    NSLog(@"Input date string: %@",dateString);
    NSLog(@"Input date: %@",inputDate);
    NSLog(@"Output date string: %@",outputDateString);
    */
    
    outputDateString = [outputDateString stringByReplacingOccurrencesOfString:@" " withString:@"T"];
    outputDateString = [outputDateString stringByAppendingString:@"Z"];
    
    return outputDateString;
}

+ (NSString *)formatDateTimeString:(NSString *)dateString
{
    if (!dateString) return nil;
    dateString = [dateString stringByReplacingOccurrencesOfString:@"T" withString:@" "];
    dateString = [dateString stringByReplacingOccurrencesOfString:@"Z" withString:@" "];
    
    NSDateFormatter *inputDateFormatter = [[NSDateFormatter alloc] init];
    [inputDateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    [inputDateFormatter setTimeZone:[NSTimeZone timeZoneWithName:@"UTC"]];
    
    NSDateFormatter *outputDateFormatter = [[NSDateFormatter alloc] init];
    outputDateFormatter.dateStyle = NSDateFormatterLongStyle;
    outputDateFormatter.timeStyle = NSDateFormatterShortStyle;
    [outputDateFormatter setTimeZone:[NSTimeZone localTimeZone]];
    
    NSLocale *usLocale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US"];
    [outputDateFormatter setLocale:usLocale];
    
    NSDate *inputDate = [inputDateFormatter dateFromString:dateString];
    if (!inputDate)
    {
        [inputDateFormatter setDateFormat:@"yyyy-MM-dd"];
        inputDate = [inputDateFormatter dateFromString:dateString];
        
        outputDateFormatter = [[NSDateFormatter alloc] init];
        outputDateFormatter.dateStyle = NSDateFormatterLongStyle;
        [outputDateFormatter setTimeZone:[NSTimeZone localTimeZone]];
        
        NSLocale *usLocale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US"];
        [outputDateFormatter setLocale:usLocale];
    }
    NSString *outputDateString = [outputDateFormatter stringFromDate:inputDate];
    
    return outputDateString;
}

+ (NSString *)formatDateString:(NSString *)dateString
{
    if (!dateString) return nil;
    dateString = [[dateString componentsSeparatedByString:@"."] firstObject];
    dateString = [dateString stringByReplacingOccurrencesOfString:@"T" withString:@" "];
    dateString = [dateString stringByReplacingOccurrencesOfString:@"Z" withString:@" "];
    
    NSDateFormatter *inputDateFormatter = [[NSDateFormatter alloc] init];
    [inputDateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    [inputDateFormatter setTimeZone:[NSTimeZone timeZoneWithName:@"UTC"]];
    
    NSDateFormatter *outputDateFormatter = [[NSDateFormatter alloc] init];
    outputDateFormatter.dateStyle = NSDateFormatterLongStyle;
    [outputDateFormatter setTimeZone:[NSTimeZone localTimeZone]];
    
    NSLocale *usLocale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US"];
    [outputDateFormatter setLocale:usLocale];
    
    NSDate *inputDate = [inputDateFormatter dateFromString:dateString];
    if (!inputDate)
    {
        [inputDateFormatter setDateFormat:@"yyyy-MM-dd"];
        inputDate = [inputDateFormatter dateFromString:dateString];
    }
    NSString *outputDateString = [outputDateFormatter stringFromDate:inputDate];
    
    return outputDateString;
}

+ (NSString *)formatDateWithoutYearString:(NSString *)dateString
{
    if (!dateString) return nil;
    dateString = [[dateString componentsSeparatedByString:@"."] firstObject];
    dateString = [dateString stringByReplacingOccurrencesOfString:@"T" withString:@" "];
    dateString = [dateString stringByReplacingOccurrencesOfString:@"Z" withString:@" "];
    
    NSDateFormatter *inputDateFormatter = [[NSDateFormatter alloc] init];
    [inputDateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    [inputDateFormatter setTimeZone:[NSTimeZone timeZoneWithName:@"UTC"]];
    
    NSDateFormatter *outputDateFormatter = [[NSDateFormatter alloc] init];
    [outputDateFormatter setDateFormat:@"MMMM d"];
    [outputDateFormatter setTimeZone:[NSTimeZone localTimeZone]];
    
    NSLocale *usLocale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US"];
    [outputDateFormatter setLocale:usLocale];
    
    NSDate *inputDate = [inputDateFormatter dateFromString:dateString];
    if (!inputDate)
    {
        [inputDateFormatter setDateFormat:@"yyyy-MM-dd"];
        inputDate = [inputDateFormatter dateFromString:dateString];
    }
    NSString *outputDateString = [outputDateFormatter stringFromDate:inputDate];
    
    return outputDateString;
}

+ (NSString *)stringFromDate:(NSDate *)date
{
    NSDateFormatter *outputDateFormatter = [[NSDateFormatter alloc] init];
    outputDateFormatter.dateStyle = NSDateFormatterLongStyle;
    [outputDateFormatter setTimeZone:[NSTimeZone localTimeZone]];
    
    NSLocale *usLocale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US"];
    [outputDateFormatter setLocale:usLocale];
    
    NSString *outputDateString = [outputDateFormatter stringFromDate:date];
    
    return outputDateString;
}

+ (NSDate *)dateFromString:(NSString *)dateString
{
    NSDateFormatter *inputDateFormatter = [[NSDateFormatter alloc] init];
    inputDateFormatter.dateStyle = NSDateFormatterLongStyle;
    [inputDateFormatter setTimeZone:[NSTimeZone localTimeZone]];
    
    NSDate *outputDate = [inputDateFormatter dateFromString:dateString];
    
    return outputDate;
}

+ (NSString *)extractDateFromDateTimeString:(NSString *)dateTimeString
{
    NSArray *dateComponents = [dateTimeString componentsSeparatedByString:@" "];
    if (dateComponents.count < 4) return dateTimeString;
    
    NSString *dateString = [[dateComponents subarrayWithRange:NSMakeRange(0, 4)] componentsJoinedByString:@" "];
    return dateString;
}

+ (NSString *)timeIntervalSinceDateTimeString:(NSString *)dateString
{
    if (!dateString) return nil;
    dateString = [[dateString componentsSeparatedByString:@"."] firstObject];
    dateString = [dateString stringByReplacingOccurrencesOfString:@"T" withString:@" "];
    dateString = [dateString stringByReplacingOccurrencesOfString:@"Z" withString:@" "];
    
    NSDateFormatter *inputDateFormatter = [[NSDateFormatter alloc] init];
    [inputDateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    [inputDateFormatter setTimeZone:[NSTimeZone timeZoneWithName:@"UTC"]];
    
    NSDate *inputDate = [inputDateFormatter dateFromString:dateString];
    int timeInterval = [[NSDate date] timeIntervalSinceDate:inputDate];

    // int seconds = timeInterval % 60;
    timeInterval = timeInterval / 60;
    int minutes = timeInterval % 60;
    timeInterval = timeInterval / 60;
    int hours = timeInterval % 24;
    timeInterval = timeInterval / 24;
    int days = timeInterval % 7;
    int weeks = timeInterval / 7;
    
	NSString *timeIntervalString;

	if (weeks > 0)
    {
        timeIntervalString = (weeks == 1) ? [NSString stringWithFormat:@"%d week ago", weeks] : [NSString stringWithFormat:@"%d weeks ago", weeks];
    }
	else if (days > 0)
    {
        timeIntervalString = (days == 1) ? [NSString stringWithFormat:@"%d day ago", days] : [NSString stringWithFormat:@"%d days ago", days];
    }
    else if (hours > 0)
    {
        timeIntervalString = (hours == 1) ? [NSString stringWithFormat:@"%d hour ago", hours] : [NSString stringWithFormat:@"%d hours ago", hours];
    }
    else if (minutes > 0)
    {
        timeIntervalString = (minutes == 1) ? [NSString stringWithFormat:@"%d min ago", minutes] : [NSString stringWithFormat:@"%d mins ago", minutes];
    }
	else timeIntervalString = @"just now";
	return timeIntervalString;
}

/* Convert bytes from NSData to a base64 encoded string. */
+ (NSString *)base64StringFromData:(NSData *)data
{
	//Point to start of the data and set buffer sizes
	int inLength = [data length];
	int outLength = ((((inLength * 4) / 3) / 4) * 4) + (((inLength * 4) / 3) % 4 ? 4 : 0);
	const char *inputBuffer = [data bytes];
	char *outputBuffer = malloc(outLength + 1);
	outputBuffer[outLength] = 0;
    
	//Start the count
	int cycle = 0;
	int inpos = 0;
	int outpos = 0;
	char temp;
	
	//Pad the last to bytes, the outbuffer must always be a multiple of 4
	outputBuffer[outLength-1] = '=';
	outputBuffer[outLength-2] = '=';
	
	while (inpos < inLength)
	{
		switch (cycle)
		{
			case 0:
				outputBuffer[outpos++] = Encode[(inputBuffer[inpos]&0xFC)>>2];
				cycle = 1;
				break;
			case 1:
				temp = (inputBuffer[inpos++]&0x03)<<4;
				outputBuffer[outpos] = Encode[temp];
				cycle = 2;
				break;
			case 2:
				outputBuffer[outpos++] = Encode[temp|(inputBuffer[inpos]&0xF0)>>4];
				temp = (inputBuffer[inpos++]&0x0F)<<2;
				outputBuffer[outpos] = Encode[temp];
				cycle = 3;
				break;
			case 3:
				outputBuffer[outpos++] = Encode[temp|(inputBuffer[inpos]&0xC0)>>6];
				cycle = 4;
				break;
			case 4:
				outputBuffer[outpos++] = Encode[inputBuffer[inpos++]&0x3f];
				cycle = 0;
				break;
			default:
				cycle = 0;
				break;
		}
	}
	NSString *stringImage = @(outputBuffer);
	free(outputBuffer);
	return stringImage;
}

+ (NSString *)deviceIP
{
    NSUInteger indexOfAddress;
    NSArray *IPItemsArray;
    NSString *externalIP = @"";
    
    NSURL *requestIPURL = [NSURL URLWithString:@"http://www.dyndns.org/cgi-bin/check_ip.cgi"];
    
    NSError *error = nil;
    NSString *htmlString = [NSString stringWithContentsOfURL:requestIPURL encoding:NSUTF8StringEncoding error:&error];
    if (!error)
    {
        NSScanner *scanner;
        NSString *text = nil;
            
        scanner = [NSScanner scannerWithString:htmlString];
            
        while ([scanner isAtEnd] == NO)
        {
                
            // find start of tag
            [scanner scanUpToString:@"<" intoString:NULL] ;
                
            // find end of tag
            [scanner scanUpToString:@">" intoString:&text] ;
                
            // replace the found tag with a space (you can filter multi-spaces out later if you wish)
            htmlString = [htmlString stringByReplacingOccurrencesOfString:[NSString stringWithFormat:@"%@>", text]
                                                               withString:@" "];
            IPItemsArray = [htmlString componentsSeparatedByString:@" "];
            indexOfAddress = [IPItemsArray indexOfObject:@"Address:"];
            indexOfAddress++;
            externalIP =IPItemsArray[indexOfAddress];
        }
        NSLog(@"IP Address : %@", externalIP);
    }
    else
    {
        NSLog(@"IP Address not found : %d - %@", [error code], [error localizedDescription]);
    }
    return externalIP;
}

+ (void)playAddActionSound
{
    static SystemSoundID sound;
    if (!sound)
    {
        NSURL *soundFileURL = [[NSBundle mainBundle] URLForResource:@"addAction1" withExtension:@"wav"];
        AudioServicesCreateSystemSoundID((__bridge CFURLRef)soundFileURL, &sound);
    }
    
    AudioServicesPlaySystemSound(sound);
}

// This function can be used to remove keys with null values from collection objects
// The function was written because the guys working on the server side don't give a shit on building a good API
+ (id)removeNullObjectsFromObject:(id)rootObject
{
    // Recurse through dictionaries and remove Null objects
    if ([rootObject isKindOfClass:[NSDictionary class]])
    {
        NSMutableDictionary *sanitizedDictionary = [NSMutableDictionary dictionaryWithDictionary:rootObject];
        [rootObject enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop)
        {
            id sanitizedObject = [self removeNullObjectsFromObject:obj];
            
            if (!sanitizedObject) [sanitizedDictionary removeObjectForKey:key];
            else [sanitizedDictionary setObject:sanitizedObject forKey:key];
        }];
        
        if ([rootObject isKindOfClass:[NSMutableDictionary class]]) return sanitizedDictionary;
        else return [NSDictionary dictionaryWithDictionary:sanitizedDictionary];
    }
    
    // Recurse through arrays
    if ([rootObject isKindOfClass:[NSArray class]])
    {
        NSMutableArray *sanitizedArray = [NSMutableArray arrayWithArray:rootObject];
        [rootObject enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop)
        {
            id sanitizedObject = [self removeNullObjectsFromObject:obj];
            if (!sanitizedObject) [sanitizedArray removeObjectIdenticalTo:obj];
            else [sanitizedArray replaceObjectAtIndex:[sanitizedArray indexOfObject:obj] withObject:sanitizedObject];
        }];
        
        if ([rootObject isKindOfClass:[NSMutableArray class]]) return sanitizedArray;
        else return [NSArray arrayWithArray:sanitizedArray];
    }
    
    // Object is not a collection. Should be removed if Null
    if ([rootObject isKindOfClass:[NSNull class]]) return nil;
    else return rootObject;
}

@end
