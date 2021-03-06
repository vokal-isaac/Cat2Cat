//
//  VOKTemplating.m
//  Cat2Cat
//
//  Created by Isaac Greenspan on 10/28/14.
//  Copyright (c) 2014 Vokal. All rights reserved.
//

#import "VOKTemplateModel.h"

#import <GRMustache.h>

@interface VOKTemplateModel ()

@property (nonatomic, strong) NSArray *folders;
@property (nonatomic, strong) NSString *imageClass;
@property (nonatomic, strong) NSString *kitName;
@property (nonatomic, assign) BOOL isMac;

@end

#define FRAMEWORK_PREFIX @"ac_"

#define CONSTANT_STRUCT_NAME @"Cat2CatImageNames"

#define MUSTACHE_FORCE_TEXT_TYPE @"{{% CONTENT_TYPE:TEXT }}"
#define MUSTACHE_GENERATED_AUTOMATICALLY_COMMENT_WITH_FILENAME(f)    @"//\n" \
@"// " f @"\n" \
@"//\n" \
@"// Generated Automatically Using Cat2Cat\n" \
@"// NOTE: This file is wholly regenerated whenever that utility is run, so any changes made manually will be lost.\n" \
@"//\n" \
@"// For more information, go to http://github.com/vokal/Cat2Cat\n" \
@"//\n"


NSString *const VOKTemplatingClassNameIOS = @"UIImage";
NSString *const VOKTemplatingClassNameMac = @"NSImage";

/**
 *  Mustache template for Objective-C .h file
 */
static NSString *const MustacheFileH
= (MUSTACHE_FORCE_TEXT_TYPE
   MUSTACHE_GENERATED_AUTOMATICALLY_COMMENT_WITH_FILENAME(@"{{ imageClass }}+AssetCatalog.h")
   @"\n"
   @"#import <{{ kitName }}/{{ kitName }}.h>\n"
   @"\n"
   @"@interface {{ imageClass }} (AssetCatalog)\n"
   @"\n"
   @"{{# folders }}{{ h_content }}{{/ folders }}"
   @"@end\n"
   @"\n"
   @"FOUNDATION_EXPORT const struct " CONSTANT_STRUCT_NAME @" {\n"
   @"{{# folders }}{{ h_struct_content }}{{/ folders }}"
   @"} " CONSTANT_STRUCT_NAME @";\n"
   );
/// Mustache template for recursing into folders for Objective-C .h file
NSString *const VOKTemplatingFolderContentHMustache
= (MUSTACHE_FORCE_TEXT_TYPE
   @"#pragma mark - {{ name }}\n"
   @"\n"
   @"{{# isMac }}{{# icons }}+ ({{ imageClass }} *)" FRAMEWORK_PREFIX @"{{ method }};\n\n{{/ icons }}{{/ isMac }}"
   @"{{# images }}+ ({{ imageClass }} *)" FRAMEWORK_PREFIX @"{{ method }};\n\n{{/ images }}"
   @"{{# subfolders }}{{ h_content }}{{/ subfolders }}"
   );
/// Mustache template for recursing into folders for Objective-C .h file, struct part
NSString *const VOKTemplatingFolderContentHStructMustache
= (MUSTACHE_FORCE_TEXT_TYPE
   @"    // {{ name }}\n"
   @"{{# isMac }}{{# icons }}    __unsafe_unretained NSString *const {{ method }};\n{{/ icons }}{{/ isMac }}"
   @"{{# images }}    __unsafe_unretained NSString *const {{ method }};\n{{/ images }}"
   @"{{# subfolders }}{{ h_struct_content }}{{/ subfolders }}"
   );

/**
 *  Mustache template for Objective-C .m file
 */
static NSString *const MustacheFileM
= (MUSTACHE_FORCE_TEXT_TYPE
   MUSTACHE_GENERATED_AUTOMATICALLY_COMMENT_WITH_FILENAME(@"{{ imageClass }}+AssetCatalog.m")
   @"\n"
   @"#import \"{{ imageClass }}+AssetCatalog.h\"\n"
   @"\n"
   @"@implementation {{ imageClass }} (AssetCatalog)\n"
   @"\n"
   @"{{# folders }}{{ m_content }}{{/ folders }}"
   @"@end\n"
   @"\n"
   @"const struct " CONSTANT_STRUCT_NAME @" " CONSTANT_STRUCT_NAME @" = {\n"
   @"{{# folders }}{{ m_struct_content }}{{/ folders }}"
   @"};\n"
   );
/// Mustache template for recursing into folders for Objective-C .m file
NSString *const VOKTemplatingFolderContentMMustache
= (MUSTACHE_FORCE_TEXT_TYPE
   @"#pragma mark - {{ name }}\n"
   @"\n"
   @"{{# isMac }}{{# icons }}+ ({{ imageClass }} *)" FRAMEWORK_PREFIX @"{{ method }}\n"
   @"{\n"
   @"    return [{{ imageClass }} imageNamed:" CONSTANT_STRUCT_NAME @".{{ method }}];\n"
   @"}\n"
   @"\n{{/ icons }}{{/ isMac }}"
   @"{{# images }}+ ({{ imageClass }} *)" FRAMEWORK_PREFIX @"{{ method }}\n"
   @"{\n"
   @"    return [{{ imageClass }} imageNamed:" CONSTANT_STRUCT_NAME @".{{ method }}];\n"
   @"}\n"
   @"\n{{/ images }}"
   @"{{# subfolders }}{{ m_content }}{{/ subfolders }}"
   );
/// Mustache template for recursing into folders for Objective-C .m file, struct part
NSString *const VOKTemplatingFolderContentMStructMustache
= (MUSTACHE_FORCE_TEXT_TYPE
   @"    // {{ name }}\n"
   @"{{# isMac }}{{# icons }}    .{{ method }} = @\"{{ name }}\",\n{{/ icons }}{{/ isMac }}"
   @"{{# images }}    .{{ method }} = @\"{{ name }}\",\n{{/ images }}"
   @"{{# subfolders }}{{ m_struct_content }}{{/ subfolders }}"
   );

/**
 *  Mustache template for .swift file
 */
static NSString *const MustacheFileSwift
= (MUSTACHE_FORCE_TEXT_TYPE
   MUSTACHE_GENERATED_AUTOMATICALLY_COMMENT_WITH_FILENAME(@"Cat2Cat{{ imageClass }}.swift")
   @"\n"
   @"import {{ kitName }}\n"
   @"\n"
   @"extension {{ imageClass }} {\n"
   @"\n"
   @"{{# folders }}{{ swift_content }}{{/ folders }}"
   @"}\n"
   @"\n"
   @"struct " CONSTANT_STRUCT_NAME @" {\n"
   @"{{# folders }}{{ swift_struct_content }}{{/ folders }}"
   @"}\n"
   );
/// Mustache template for recursing into folders for .swift file
NSString *const VOKTemplatingFolderContentSwiftMustache
= (MUSTACHE_FORCE_TEXT_TYPE
   @"    // MARK: - {{ name }}\n"
   @"    \n"
   @"{{# isMac }}{{# icons }}    class func " FRAMEWORK_PREFIX @"{{ method }}() -> {{ imageClass }}? {\n"
   @"        return {{ imageClass }}(named:" CONSTANT_STRUCT_NAME @".{{ method }})\n"
   @"    }\n"
   @"    \n{{/ icons }}{{/ isMac }}"
   @"{{# images }}    class func " FRAMEWORK_PREFIX @"{{ method }}() -> {{ imageClass }}? {\n"
   @"        return {{ imageClass }}(named:" CONSTANT_STRUCT_NAME @".{{ method }})\n"
   @"    }\n"
   @"    \n{{/ images }}"
   @"{{# subfolders }}{{ swift_content }}{{/ subfolders }}"
   );
/// Mustache template for recursing into folders for .swift file, struct part
NSString *const VOKTemplatingFolderContentSwiftStructMustache
= (MUSTACHE_FORCE_TEXT_TYPE
   @"    // {{ name }}\n"
   @"{{# isMac }}{{# icons }}    static let {{ method }} = \"{{ name }}\"\n{{/ icons }}{{/ isMac }}"
   @"{{# images }}    static let {{ method }} = \"{{ name }}\"\n{{/ images }}"
   @"{{# subfolders }}{{ swift_struct_content }}{{/ subfolders }}"
   );

static NSString *const KitNameIOS = @"UIKit";
static NSString *const KitNameMac = @"AppKit";

@implementation VOKTemplateModel

+ (instancetype)templateModelWithFolders:(NSArray *)folders
{
    VOKTemplateModel *model = [[self alloc] init];
    model.folders = folders;
    return model;
}

- (NSString *)renderWithClassName:(NSString *)className
                   templateString:(NSString *)templateString
{
    self.imageClass = className;
    if ([className isEqualToString:VOKTemplatingClassNameIOS]) {
        self.kitName = KitNameIOS;
        self.isMac = NO;
    } else if ([className isEqualToString:VOKTemplatingClassNameMac]) {
        self.kitName = KitNameMac;
        self.isMac = YES;
    }
    NSString *result = [GRMustacheTemplate renderObject:self
                                             fromString:templateString
                                                  error:NULL];
    self.imageClass = nil;
    self.kitName = nil;
    self.isMac = NO;
    return result;
}

- (NSString *)renderObjCHWithClassName:(NSString *)className
{
    return [self renderWithClassName:className templateString:MustacheFileH];
}

- (NSString *)renderObjCMWithClassName:(NSString *)className
{
    return [self renderWithClassName:className templateString:MustacheFileM];
}

- (NSString *)renderSwiftWithClassName:(NSString *)className
{
    return [self renderWithClassName:className templateString:MustacheFileSwift];
}

@end
