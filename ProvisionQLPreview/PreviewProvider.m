//
//  PreviewProvider.m
//  ProvisionQLPreview
//
//  Created by Daniel Muhra on 31.10.24.
//  Copyright © 2024 Evgeny Aleksandrov. All rights reserved.
//

#import "PreviewProvider.h"

NSData* generatePreviewDataForURL(NSURL *URL, NSString *dataType);

@implementation PreviewProvider

/*

 Use a QLPreviewProvider to provide data-based previews.
 
 To set up your extension as a data-based preview extension:

 - Modify the extension's Info.plist by setting
   <key>QLIsDataBasedPreview</key>
   <true/>
 
 - Add the supported content types to QLSupportedContentTypes array in the extension's Info.plist.

 - Change the NSExtensionPrincipalClass to this class.
   e.g.
   <key>NSExtensionPrincipalClass</key>
   <string>PreviewProvider</string>
 
 - Implement providePreviewForFileRequest:completionHandler:
 
 */

- (void)providePreviewForFileRequest:(QLFilePreviewRequest *)request completionHandler:(void (^)(QLPreviewReply * _Nullable reply, NSError * _Nullable error))handler
{
    //You can create a QLPreviewReply in several ways, depending on the format of the data you want to return.
    //To return NSData of a supported content type:
    
    UTType* contentType = UTTypeHTML; //replace with your data type
    
    QLPreviewReply* reply = [[QLPreviewReply alloc] initWithDataOfContentType:contentType contentSize:CGSizeMake(800, 800) dataCreationBlock:^NSData * _Nullable(QLPreviewReply * _Nonnull replyToUpdate, NSError *__autoreleasing  _Nullable * _Nullable error) {
        UTType *fileUTI = [UTType typeWithFilenameExtension:request.fileURL.pathExtension];
        if (fileUTI) {
            return generatePreviewDataForURL(request.fileURL, fileUTI.identifier);
        }

        return nil;
    }];
    
    //You can also create a QLPreviewReply with a fileURL of a supported file type, by drawing directly into a bitmap context, or by providing a PDFDocument.
    
    handler(reply, nil);
}

@end

