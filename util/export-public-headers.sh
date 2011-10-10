#!/bin/sh

PUBLIC_HEADERS="
SocializeActionBar.h
SocializeActionView.h
SocializeActivity.h
SocializeApplication.h
SocializeBaseViewController.h
SocializeComment.h
SocializeCommentDetailsViewController.h
SocializeCommentsTableViewController.h
SocializeCommonDefinitions.h
SocializeEntity.h
SocializeError.h
SocializeFullUser.h
SocializeLike.h
SocializeObject.h
SocializePostCommentViewController.h
SocializeProfileViewController.h
SocializeShare.h
SocializeUser.h
SocializeView.h
SocializeObjects.h
SocializeServiceDelegate.h
SocializeProfileEditViewController.h
_Socialize.h
Socialize.h
"

HEADERS_OUT="${CONFIGURATION_BUILD_DIR}/${PUBLIC_HEADERS_FOLDER_PATH}"
echo "Wiping headers in $HEADERS_OUT"
rm -rf "$HEADERS_OUT"

echo "Copying public headers to $HEADERS_OUT"
mkdir -p "$HEADERS_OUT"
for f in $PUBLIC_HEADERS; do
  cp "Socialize/Classes/$f" "$HEADERS_OUT"
done
